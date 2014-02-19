function [ mask ] = hsv_verify(original_image, v_threshold, s_threshold)
% Convert RGB image to HSV
hsvImage = rgb2hsv(original_image);
% Extract out the S and V images individually
sImage = hsvImage(:,:,2);
vImage = hsvImage(:,:,3);

valueMask = (vImage >= v_threshold);
saturationMask = (sImage <= s_threshold);
mask = valueMask .* saturationMask;
end