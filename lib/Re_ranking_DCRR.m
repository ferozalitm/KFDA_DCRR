function [ final_index ] = Re_ranking_DCRR( Dist, n, k)    % 
    % Dual Cross-View Reciprocal Re-ranking (DCRR)
    % Authors: T M Feroz Ali and Kalpesh K Patel
    %
    % probe >> d-by-n, d is feature size, n is number of samples
    % gallary >>  d-by-m, d is feature size, m is number of samples
    % Dist >> m by n matrix

    [~, index_A] = sort(Dist);      % sort column-wise Dist (probe)
    [~, index_B] = sort(Dist, 2);   % sort row-wise Dist (gallary)
    index_A = index_A';
   
    i = 1;
    E = zeros(n,k);
    final_index = zeros(n,k);
    l = k;
    while(i<=n)
        clear C D;
        C = index_B(index_A(i,1:l),1:l);
        [D, ~, ~] = find(C==i);     % sorting based on position of query done here implicitly by find(C==i)
        if length(D)<k 
            l = l+1;
        else
            E(i,:) = D(1:k)';     
            final_index(i,:) = index_A(i,E(i,:));
            i = i+1;
        end;
    end;
end


