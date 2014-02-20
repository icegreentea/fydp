%Normalize histogram 
%Get rid of crap

clc;	% Clear command window.
clear;	% Delete all variables.
close all;	% Close all figure windows except those created by imtool.
imtool close all;	% Close all figure windows created by imtool.

% Read in image into an array.

[rgbImage storedColorMap] = imread('red-test.jpg'); 
[rows columns numberOfColorBands] = size(rgbImage); 

s = rows / 2;

rgbImage = rgbImage(s:rows, :, :);

% Display the original image.
figure; imshow(rgbImage);

% Convert RGB image to HSV
hsvImage = rgb2hsv(rgbImage);
% Extract out the H, S, and V images individually
hImage = hsvImage(:,:,1);
sImage = hsvImage(:,:,2);
vImage = hsvImage(:,:,3);
    
%Take a guess at the values that might work for Flag Image.
hueThresholdLow = 0.95;
hueThresholdHigh = 0.05;

%Apply each band's particular thresholds to the color band, producing
%thresholded binary images.
hueMask = (hImage >= hueThresholdLow) | (hImage <= hueThresholdHigh);

% Mask that will be applied to images
redObjectsMask = uint8(hueMask);
figure, imshow(redObjectsMask*255);

%Size Validation: Get rid of small objects.
%redObjectsMask is a logical array = output of bwareaopen
smallestAcceptableArea = 1000;
redObjectsMask = uint8(bwareaopen(redObjectsMask, smallestAcceptableArea));
    
%Smooth the border using a morphological closing operation, imclose()
structuringElement = strel('disk', 4);
redObjectsMask = imclose(redObjectsMask, structuringElement);

%Convert type of redObjectsMask to the same data type as hImage.
redObjectsMask = cast(redObjectsMask, class(rgbImage)); 

%Use the red object mask to mask out the red-only portions of the rgb image.
	maskedImageR = redObjectsMask .* rgbImage(:,:,1);
	maskedImageG = redObjectsMask .* rgbImage(:,:,2);
 	maskedImageB = redObjectsMask .* rgbImage(:,:,3);
	
%Concatenate the masked color bands to form the rgb image.
maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);

HSV2 = rgb2hsv(maskedRGBImage);
sImage =  HSV2(:,:,2);
vImage = HSV2(:,:,3);

satThresholdLow = 0.277;
satThresholdHigh = 0.3;
valThresholdLow = 0.277;
valThresholdHigh = 0.3;

satMask = (sImage >= 0.3) & (sImage <= 1.0);
valMask = (vImage >= 0.5) & (vImage <= 1.0);

finalMask = (satMask & valMask);
maskedRGBImage(:,:,1) = maskedRGBImage(:,:,1) .* uint8(finalMask);
maskedRGBImage(:,:,2) = maskedRGBImage(:,:,2) .* uint8(finalMask);
maskedRGBImage(:,:,3) = maskedRGBImage(:,:,3) .* uint8(finalMask);

% Show the masked off image.
figure, imshow(maskedRGBImage);
imwrite(maskedRGBImage, 'maskedRGBImage.png');
fontSize = 13;
caption = sprintf('Masked Original Image\nShowing Only the Red Objects');
title(caption, 'FontSize', fontSize);

