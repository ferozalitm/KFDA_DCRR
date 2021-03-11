%% VIPER Dataset 
% GOG feature

numClass = 632;

disp(' *** loading GOG features of VIPER dataset ***');
addpath './VIPeR'
load('Train_labels_VIPeR.mat');
load('Test_labels_VIPeR.mat');

% Loading Camera A data
load 'GOG_YHOGRGB_feature_all_A.mat';
probFea_GOG_RGB  = feature_all_A;   
load 'GOG_YHOGHSV_feature_all_A.mat';
probFea_GOG_HSV  = feature_all_A;
probFea = [probFea_GOG_RGB,feature_all_A]; 
load 'GOG_YHOGLAB_feature_all_A.mat';
probFea_GOG_LAB  = feature_all_A;
probFea = [probFea,feature_all_A]; 
load 'GOG_YHOGnRnG_feature_all_A.mat';
probFea_GOG_nRnG  = feature_all_A;
probFea_GOG = [probFea,feature_all_A]; 

% Loading Camera B data
load 'GOG_YHOGRGB_feature_all_B.mat';
galFea_GOG_RGB = feature_all_B;
load 'GOG_YHOGHSV_feature_all_B.mat';
galFea_GOG_HSV = feature_all_B;
galFea = [galFea_GOG_RGB,feature_all_B];
load 'GOG_YHOGLAB_feature_all_B.mat';
galFea_GOG_LAB = feature_all_B;
galFea = [galFea,feature_all_B];
load 'GOG_YHOGnRnG_feature_all_B.mat';
galFea_GOG_nRnG = feature_all_B;
galFea_GOG = [galFea,feature_all_B];

clear feature_all_A feature_all_B galFea probFea;