%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Demo code for KFDA and Multiple Kernel Metric Learning (NP_MFML) + DCRR re-ranking 
%% Author: T M Feroz Ali
%
% Dataset: VIPeR; 
% Feature: GoG
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all;
seed = 0;
rng(seed);
addpath('./lib');

%% Parameters
numFolds=10;
% Kernel parameters
Nk = 20;      % No. of kernels
sigma_NPMFML = logspace(-1,1,Nk);
sigma_KFDA = 1;
weight =  zeros(Nk,1);
options.sigma = 1;     % with mu  (sigma= sigma*mu) 
options.regularization = 10^(-7);

%% Output variables
numRanks = 100;
CMCs_GoG = zeros( numFolds, numRanks );
CMCs_KFDA = zeros( numFolds, numRanks );
CMCs_NPMFML = zeros( numFolds, numRanks );
CMCs_DCRR = zeros( numFolds, numRanks );

%% Load VIPeR dataset
Load_VIPeR_GoG;        
galFea = double(galFea_GOG);
probFea = double(probFea_GOG);
numclass_half = floor(0.5*numClass);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
for nf = 1:numFolds
    
    %% Load train-test split
    labels_train = Train_labels_all{nf,1}'; 
    labels_test = Test_labels_all{nf,1}'; 
    % Train- Test spiliting of data
    gal_Train = galFea( labels_train, : );
    prob_Train = probFea( labels_train, : );
    gal_Test = galFea( labels_test, : );
    prob_Test = probFea( labels_test, : );
    prob_Train_Labels =  labels_train;
    gal_Train_Labels =  labels_train;
    prob_Test_Labels = labels_test;
    gal_Test_Labels = labels_test;   
    % Data Normalization
    [gal_Train, prob_Train, MeanT] = apply_normalization(gal_Train, prob_Train);
    [gal_Test, prob_Test] = apply_normalization(gal_Test, prob_Test, MeanT);
    X = [prob_Train;gal_Train];
    X_labels = [prob_Train_Labels,gal_Train_Labels];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Evaluate using GoG feature alone 
    labelsGa =  1:numclass_half; labelsPr = 1:numclass_half;    % Re-indexing test data labels
    dist_GoG = pdist2(prob_Test, gal_Test, 'euclidean');
    CMCs_GoG(nf,:) = EvalCMC( -dist_GoG', labelsGa, labelsPr, numRanks);
    fprintf('\n ******************** Fold %d *****************************\n',nf);
    fprintf(' GoG\n');
    fprintf(' Rank1 = %5.2f%% \n\n', CMCs_GoG(nf,1) * 100);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% KFDA
    [K_train, K_test_g, K_test_p] = RBF_single_kernel(X, sigma_KFDA, options, gal_Test, prob_Test);
    KFDA_training;
    calcTestDist;
    dist_KFDA = dist;
    CMCs_KFDA(nf,:) = EvalCMC( -dist_KFDA', labelsGa, labelsPr, numRanks);
    fprintf(' KFDA\n');
    fprintf(' Rank1 = %5.2f%% \n\n', CMCs_KFDA(nf,1) * 100);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% NP-MFML
    weight([13,15,16],:) = 1/3;     % Actually weights to be found using cross-validation (Fixed here for demo)
    [K_train, K_test_g, K_test_p] = RBF_multiple_kernel(X, sigma_NPMFML, options, weight, gal_Test, prob_Test);
    KFDA_training;
    calcTestDist;
    dist_NPMFML = dist;
    CMCs_NPMFML(nf,:) = EvalCMC( -dist_NPMFML', labelsGa, labelsPr, numRanks);
    fprintf(' NP-MFML\n');
    fprintf(' Rank1 = %5.2f%% \n\n', CMCs_NPMFML(nf,1) * 100);    
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% DCRR re-ranking
    k=20;
    scores = dist_NPMFML;
    final_index = Re_ranking_DCRR( scores', numel(labelsPr), k);
    CMC = zeros( numRanks, 1);
    for labels=1:numel(labelsPr)               
        correctind = find( labelsGa(final_index(labels, :)) == labelsPr(labels));
        CMC(correctind:end) = CMC(correctind:end) + 1;
    end
    CMCs_DCRR(nf, :) = CMC/numel(labelsPr);
    fprintf(' DCRR\n');
    fprintf(' Rank1 = %5.2f%% \n\n', CMCs_DCRR(nf,1) * 100); 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('*******************Average performance:**************************\n'); 

CMC_GoG = mean( squeeze(CMCs_GoG(1:numFolds , :)), 1);
fprintf(' Mean Result GoG\n');
fprintf(' Rank1 = %5.2f%% \n\n', CMC_GoG(1) * 100);

CMC_KFDA = mean( squeeze(CMCs_KFDA(1:numFolds , :)), 1);
fprintf(' Mean Result KFDA\n');
fprintf(' Rank1 = %5.2f%% \n\n', CMC_KFDA(1) * 100);

CMC_NPMFML = mean( squeeze(CMCs_NPMFML(1:numFolds , :)), 1);
fprintf(' Mean Result NPMFML\n');
fprintf(' Rank1 = %5.2f%% \n\n', CMC_NPMFML(1) * 100);

CMC_DCRR = mean( squeeze(CMCs_DCRR(1:numFolds , :)), 1);
fprintf(' Mean Result DCRR\n');
fprintf(' Rank1 = %5.2f%% \n\n', CMC_DCRR(1) * 100);








