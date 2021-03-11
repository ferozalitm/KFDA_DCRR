function [ Z1, Z2, meanX ] = apply_normalization(X, Y, meanX)
% input X
[m,~] = size(X);
X = [X;Y];

if nargin<3
    meanX = mean( X, 1); % meanX -- mean vector of features % meanX -- mean vector of features
end;

Z1 = ( X - repmat(meanX, size(X,1), 1)); % Mean removal
for dnum = 1:size(X, 1)
    Z1(dnum,:) = Z1(dnum, :)./norm(Z1(dnum, :), 2); % L2 norm normalization
end;

Z2=Z1(m+1:end,:);
Z1=Z1(1:m,:);

end

