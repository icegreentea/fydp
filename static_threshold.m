function [ output_image ] = static_threshold( image, threshold )
%STATIC_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here

%Apply Threshold
output_image = image > threshold;

end

