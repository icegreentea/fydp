function [ lane_map_out,s ] = lane_verify( gray_image, original_gray_image, lane_mask, window_ratios, fisher_threshold, minimum_pixel_count, intensity_threshold)
%LANE_CLUSTER_VERIFY Summary of this function goes here
%   Detailed explanation goes here

%Initialize Output
[number_of_rows, number_of_cols] = size(lane_mask);
lane_map = zeros(number_of_rows, number_of_cols);
lane_map_out = zeros(number_of_rows, number_of_cols);

window_ratio_h = window_ratios(1);
window_ratio_v = window_ratios(2);

nominal_win_size_v = round(number_of_rows / window_ratio_v);
nominal_win_size_h = round(number_of_cols / window_ratio_h);

%resize image to support ratios
gray_image = imresize(gray_image, [nominal_win_size_v * window_ratio_v, nominal_win_size_h * window_ratio_h]);

%Iterate Through All Subwindows
for i_windows_h = 1:window_ratio_h
    for i_windows_v = 1:window_ratio_v
        %Set indices
        top = 1+(i_windows_v-1)*nominal_win_size_v;
        bottom = min(i_windows_v*nominal_win_size_v, number_of_rows);
        left = 1+(i_windows_h-1)*nominal_win_size_h;
        right = min(i_windows_h*nominal_win_size_h, number_of_cols);
        
        %Select subwindows
        subwindow = gray_image(top:bottom,left:right);
        submap = lane_mask(top:bottom,left:right);
        
        %Check clusters for verification
        submap_out = cluster_check(subwindow,submap,fisher_threshold, minimum_pixel_count);
        
        %Add to output map
        lane_map(top:bottom,left:right) = submap_out;
    end
end

%Remove insufficiently large clusters
%Perform Connected component Analysis
[cluster_map, cluster_num] = bwlabel(lane_map,4);
s = regionprops(cluster_map, 'Area', 'SubarrayIdx');

for i = 1:length(s)
   if s(i).Area > minimum_pixel_count
       idx = find(cluster_map == i);
       if sum(original_gray_image(idx))/s(i).Area > intensity_threshold
           lane_map_out(idx) = 1;
       end
   end
end

%For All Candidate Clusters
% for i_cluster = 1:cluster_num    
%     %get indices of cluster
%     indices_cluster = find(cluster_map == i_cluster);
%     
%     if max(size(indices_cluster)) > minimum_pixel_count
%         lane_map_out(indices_cluster) = 1;
%     else
%         lane_map_out(indices_cluster) = 0;
%     end
%     
% end



end

