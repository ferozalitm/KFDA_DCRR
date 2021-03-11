function [ Sb ] = Sb_Between_Class_Scattar(X,id)

    noSamples = size(X,1);
    [ H ] = H_matrix(id);
    Sb = (1/noSamples)*X*H*H'*X;
    Sb = (Sb+Sb')/2;

end