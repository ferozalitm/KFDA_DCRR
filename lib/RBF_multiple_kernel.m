function [K_train, varargout] = RBF_multiple_kernel(X, sigma, options, weight, varargin)

    % options.sigma = 1 -----> with mu  (sigma= sigma*mu)
    % options.sigma = 0 -----> without mu (sigma= sigma)

    Nk = length(sigma);
    No_arg = length(varargin);
    varargout = cell(1,No_arg);

    norm1 = sum(X.^2,2);
    norm2 = sum(X.^2,2);
    dist = (repmat(norm1 ,1,size(X,1)) + repmat(norm2',size(X,1),1) - 2*X*X');
    mu=sqrt(mean(dist(:))/2);
    if (options.sigma == 1)
        sigma = sigma*mu;
    end;    
    
    K_train = (weight(1)* exp(-0.5/sigma(1)^2 * dist));
    for id= 2:Nk
        K_train = K_train + (weight(id)* exp(-0.5/sigma(id)^2 * dist));
    end;

    for ia = 1:No_arg   
        Y = varargin{ia};
        norm2 = sum(Y.^2,2);
        dist = (repmat(norm1 ,1,size(Y,1)) + repmat(norm2',size(X,1),1) - 2*X*Y');
        varargout{ia}=(weight(1)*exp(-0.5/sigma(1)^2 * dist));
        for j = 2: Nk
            varargout{ia}=varargout{ia}+(weight(j)*exp(-0.5/sigma(j)^2 * dist));
        end;
    end;  
end