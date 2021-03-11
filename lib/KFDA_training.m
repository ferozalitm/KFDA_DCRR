% Calculation of scattar matrices
[ Sw ] = Sw_Within_Class_Scattar(K_train,X_labels);
[ Sb ] = Sb_Between_Class_Scattar(K_train,X_labels);

% Regularization
Sw = Sw + ((options.regularization)*K_train);
Sw = ((Sw+Sw')/2);

% Finding alpha projection matrix
noClass = length(unique(X_labels));
noSamples = 2*noClass;                  % 2 samples per class in VIPeR dataset
[V,D1] = eig(Sw\Sb);
for s=1:(noSamples)
    if(isreal(D1(:,s))==0)
        D1(:,s)=0;
    end;
end;
[D2,I2] = sort(diag(D1),'descend');
alpha2 = V(:,I2);
alpha = alpha2(:,1:noClass-1);
for s = 1:noClass-1
    norm_factor = alpha(:,s)'*K_train*alpha(:,s);
    alpha(:,s) = alpha(:,s)/sqrt(norm_factor);
end