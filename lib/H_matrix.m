function [ H ] = H_matrix( Labels )
    
    [class_label,~, ~] = unique(Labels,'stable');
    Sort_Labels = sort(Labels);
    [~, index, ~] = unique(Sort_Labels);
    N_class = length(class_label);
    N_sample = length(Labels);
    index1 = [index(2:end); N_sample+1];
    N_per_class = index1-index;
    H = zeros(N_sample, N_class);
    a=repmat(Labels', 1, N_class);
    for i=1:N_class
        H(:,i)=-sqrt(N_per_class(i)/N_sample);
        [I]=find(a(:,i)==class_label(i));
        H(I,i) = H(I,i)+sqrt(N_sample/N_per_class(i));
    end;



end

