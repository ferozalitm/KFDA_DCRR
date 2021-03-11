function [ Sw ] = Sw_Within_Class_Scattar(X,id)

    
    if isrow(id)==1
        id = id';
    end;
    temp = repmat(id.^2, 1, length(id));
    temp = temp + temp' - 2*id*id';
    A = zeros(size(temp));
    A(temp ==0) =1;
    nc = sum(A);
    A = bsxfun(@times, A, 1./nc);
    B = eye(size(A)) - A;
    Sw = X*B*X';
    Sw = (Sw+Sw')/2;

end

