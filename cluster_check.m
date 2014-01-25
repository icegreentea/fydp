function [ verified_map_out ] = cluster_check(subwindow,submap,fisher_threshold,minimum_pixel_size)
%CLUSTER_CHECK Summary of this function goes here
%   Detailed explanation goes here

%Initialize Output
verified_map_out = zeros(size(subwindow));
dsubwindow = double(subwindow);

%Perform Connected component Analysis
[cluster_map, cluster_num] = bwlabel(submap,4);

%For All Candidate Clusters
for i_cluster = 1:cluster_num
    
    %get indices of clusters
    indices_cluster = find(cluster_map == i_cluster);
    if max(size(indices_cluster)) > minimum_pixel_size/10
        indices_else = find(cluster_map ~= i_cluster);

        %determine stats of cluster vs non-cluster
        mean_cluster = mean(dsubwindow(indices_cluster));
        mean_else = mean(dsubwindow(indices_else));

        %check that cluster mean >> non-cluster mean
        if mean_cluster > mean_else; %cluster mean is higher
            var_cluster = var(dsubwindow(indices_cluster));
            var_else = var(dsubwindow(indices_else));
            %determine fisher value
            fisher_value = ((mean_cluster - mean_else)^2)/(var_cluster + var_else);
            if  fisher_value > fisher_threshold %cluster mean is suffciently higher
               verified_map_out(indices_cluster) = 1; 
            end
        end    
    end
end

end

