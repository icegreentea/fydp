function [ means, variances ] = K_means_2( sub_image )
%K_MEANS_2 Summary of this function goes here
%   Detailed explanation goes here

means = [0, 0];
variances = [0, 0];

ownership = zeros(size(sub_image));

[rows,cols] = size(sub_image);

init_centroids = [min(min(sub_image)),max(max(sub_image))];
init_delta = 10;

centroid_1 = init_centroids(1);
centroid_2 = init_centroids(2);
delta = init_delta;

cluster_populations = [0, 0];
cluster_sums = [0, 0];

figure
imshow(sub_image,[min(min(sub_image)),max(max(sub_image))]);

%while delta > 0
    %Assignment Step
    for i_rows = 1:rows
        for i_cols = 1:cols
            x = sub_image(i_rows,i_cols)
            q1 = double(x) - double(centroid_1)
            q2 = double(x) - double(centroid_2)
            distance_cluster_1 = abs(q1);
            distance_cluster_2 = abs(q2);
            if distance_cluster_1 < distance_cluster_2
                %closer to 1 than 2
                cluster_sums(1) = cluster_sums(1) + sub_image(i_rows,i_cols);
                cluster_populations(1) = cluster_populations(1) + 1;
                ownership(i_rows,i_cols) = 1;
            elseif distance_cluster_2 < distance_cluster_1
                %closer to 2 than 1
                cluster_sums(2) = cluster_sums(2) + sub_image(i_rows,i_cols);
                cluster_populations(2) = cluster_populations(2) + 1;
                ownership(i_rows,i_cols) = 2;
            end
        end
    end
    figure
imshow(ownership,[1 2])
    
    %Update
    new_centroids = [cluster_sums(1)/cluster_populations(1), cluster_sums(2)/cluster_populations(2)];
    delta = new_centroids - centroids;
    
    centroids = new_centroids;    
%end


means = centroids;
variances = [1 1];
