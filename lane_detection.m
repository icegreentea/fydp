%% Perform lane detection on the given test image

clear all;
close all;
clc;

%% Initialization

%Load Parameters
parameters

%Load Test Image
raw_image = imread('C:\Users\Cat\Documents\School\SYDE 4B\SYDE 462 - Systems Design Workshop\Test Images\FFS1NH.tif');
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
figure; imshow(saliency_map_static, []); title('Static Saliency Map');
figure; imshow(saliency_initial_lane_map_static, []); title('Static Threshold Saliency Mask');

%% Verify Mapping Using Clustering Check

%Saliency - Static Threshold
[saliency_verified_lane_map_static, s] = lane_verify(gray_image_cropped, gray_image, saliency_initial_lane_map_static, saliency_subwindows_static, fisher_threshold_saliency_static, minimum_pixel_count, intensity_threshold);
figure; imshow(saliency_verified_lane_map_static, []); title('Static Threshold Saliency - Verified Lane Map');

colour_mask = uint8(zeros(n_im_rows,n_im_cols,3));
colour_mask(:,:,1) = uint8(saliency_verified_lane_map_static);
lanes_out = raw_image.* colour_mask + raw_image;
figure; imshow(lanes_out, []); title('Static Threshold Saliency - Verified Lanes');
%imwrite(lanes_out, strcat('C:\Users\Cat\Documents\School\SYDE 4A\SYDE 461 - Systems Design Workshop\Mike Smart Code\Results\',imout, '.tif'));

%line_detect(lanes_out);