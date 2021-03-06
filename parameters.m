%MAJOR PARAMETERS
bottom_crop = 0.50; % Percentage of bottom image kept

minimum_pixel_count = 4000;

%Saliency Parameters
saliency_threshold_static = 0.4;
saliency_subwindows_static = [4, 4]; % [x,y] x windows across, y down
fisher_threshold_saliency_static = 0.001;

intensity_threshold = 100;

%HSV Parameters
v_threshold = 0.7;
s_threshold = 0.1;