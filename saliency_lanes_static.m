function [ saliency_map_out, saliency_bin_out ] = saliency_lanes_static( raw_image, saliency_threshold, window_ratios )
%SALIENCY_LANES_SUBWINDOWS Summary of this function goes here
%   Detailed explanation goes here

%Initialize Output
[number_of_rows, number_of_cols,~] = size(raw_image);
saliency_map_out = zeros(number_of_rows, number_of_cols);
saliency_bin_out = zeros(number_of_rows, number_of_cols);

window_ratio_h = window_ratios(1);
window_ratio_v = window_ratios(2);

nominal_win_size_v = round(number_of_rows / window_ratio_v);
nominal_win_size_h = round(number_of_cols / window_ratio_h);


%Create a Matrix of subwindow indices
%smoothed_image = imfilter(raw_image, fspecial('gaussian', 3, 3), 'symmetric', 'conv');
%color_transform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('D65'));
%lab_image = applycform(smoothed_image,color_transform);
lab_image = RGB2Lab(raw_image);

%Iterate Through All Subwindows
for i_windows_h = 1:window_ratio_h
    for i_windows_v = 1:window_ratio_v
        %Set indices
        top = 1+(i_windows_v-1)*nominal_win_size_v;
        bottom = min(i_windows_v*nominal_win_size_v, number_of_rows);
        left = 1+(i_windows_h-1)*nominal_win_size_h;
        right = min(i_windows_h*nominal_win_size_h, number_of_cols);
        
        %Select subwindows
        subimage = lab_image(top:bottom,left:right,:);
        
        %Compute Saliency
        % this is the initial hotspot
        submap_out = compute_saliency(subimage);
        
        %Apply Threshold
        sub_bin_out = static_threshold(submap_out, saliency_threshold);
        
        %Add to output map
        saliency_map_out(top:bottom,left:right) = submap_out;
        saliency_bin_out(top:bottom,left:right) = sub_bin_out;
        
    end
end

end


