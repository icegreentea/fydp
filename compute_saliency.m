function [ saliency_map_out, saliency_bin_out ] = compute_saliency( lab_image )
%SALIENCY_LANES Summary of this function goes here
%   Detailed explanation goes here

% Compute Lab average values
dimage = double(lab_image);
m = mean(mean(dimage));

% Finally compute the saliency map
saliency = sum(dimage,3) - sum(m);
saliency(saliency<0) = 0;

% Output
saliency_map_out = saliency / max(max(saliency));
end

