function lane_detection(raw_image, output)
%% Perform lane detection on the given test image

%% Initialization

%Load Parameters
parameters

%Load Test Image
gray_image = rgb2gray(raw_image);

%Crop Image
[n_im_rows,n_im_cols,~] = size(raw_image);
raw_image_cropped = raw_image;

%Create Grayscale Image
raw_image_cropped = imfilter(raw_image_cropped, fspecial('disk', 3), 'symmetric', 'conv');
%figure; imshow(raw_image_cropped, []); title('image blurred');
gray_image_cropped = rgb2gray(raw_image_cropped);
%figure; imshow(gray_image_cropped, []); title('grayscale image');

%% Initial Lane Mapping

%Saliency - Static Thresholds
[saliency_map_static, saliency_initial_lane_map_static] = saliency_lanes_static(raw_image_cropped, saliency_threshold_static, saliency_subwindows_static);
%figure; imshow(saliency_map_static, []); title('Static Saliency Map');
%figure; imshow(saliency_initial_lane_map_static, []); title('Static Threshold Saliency Mask');

%% Verify Mapping Using Clustering Check

%Saliency - Static Threshold
[saliency_verified_lane_map_static, s] = lane_verify(gray_image_cropped, gray_image, saliency_initial_lane_map_static, saliency_subwindows_static, fisher_threshold_saliency_static, minimum_pixel_count, intensity_threshold);
imwrite(saliency_verified_lane_map_static, strcat(output, '_.jpg'));
%figure; imshow(saliency_verified_lane_map_static, []); title('Static Threshold Saliency - Verified Lane Map');

lanes_out = raw_image;
[i, j] = find(saliency_verified_lane_map_static==1);
for x = 1:size(i)
    lanes_out(i(x),j(x),1) = 255;
    lanes_out(i(x),j(x),2) = 255;
    lanes_out(i(x),j(x),3) = 0;
end
imwrite(lanes_out, strcat(output, '__.jpg'));
%figure; imshow(lanes_out, []); title('Static Threshold Saliency - Verified Lanes');

%line_detect(lanes_out);