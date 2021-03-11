function [K_train, varargout] = RBF_single_kernel(X, sigma, options, varargin)

    % options.sigma = 1 -----> with mu  (sigma= sigma*mu)
    % options.sigma = 0 -----> without mu (sigma= sigma)

    No_arg = length(varargin);
    varargout = cell(1,No_arg);

    norm1 = sum(X.^2,2);
    norm2 = sum(X.^2,2);
    dist = (repmat(norm1 ,1,size(X,1)) + repmat(norm2',size(X,1),1) - 2*X*X');
    mu=sqrt(mean(dist(:))/2);
    if (options.sigma == 1)
        sigma = sigma*mu;
    end;
    
    K_train =  exp(-0.5/sigma^2 * dist);

    for ia = 1:No_arg   
        Y = varargin{ia};
        norm2 = sum(Y.^2,2);
        dist = (repmat(norm1 ,1,size(Y,1)) + repmat(norm2',size(X,1),1) - 2*X*Y');
        varargout{ia}=exp(-0.5/sigma^2 * dist);
    end;   
end