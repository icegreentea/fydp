clc;	% Clear command window.
clear;	% Delete all variables.
close all;	% Close all figure windows except those created by imtool.
imtool close all;	% Close all figure windows created by imtool.

% Read in image into an array.

[rgbImage storedColorMap] = imread('red-test2.jpg'); 
[rows columns numberOfColorBands] = size(rgbImage); 

% Display the original image.
% Display the original image.
%subplot(3, 4, 1);
figure; imshow(rgbImage);

% Convert RGB image to HSV
hsvImage = rgb2hsv(rgbImage);
% Extract out the H, S, and V images individually
hImage = hsvImage(:,:,1);
sImage = hsvImage(:,:,2);
vImage = hsvImage(:,:,3);

fontSize = 16;
	
% Display them.
%subplot(3, 4, 2);
figure, imshow(hImage);
imwrite(hImage, 'hImage.png');
title('Hue Image', 'FontSize', fontSize);
%subplot(3, 4, 3);
figure, imshow(sImage);
imwrite(sImage, 'sImage.png');
title('Saturation Image', 'FontSize', fontSize);
%subplot(3, 4, 4);
figure, imshow(vImage);
imwrite(vImage, 'vImage.png');
title('Value Image', 'FontSize', fontSize);
    
%Take a guess at the values that might work for Flag Image.
hueThresholdLow = 0.05;
hueThresholdHigh = 0.95;
saturationThresholdLow = 0.277;
saturationThresholdHigh = 0.3;
valueThresholdLow = 0.277;
valueThresholdHigh = 0.3;


% Now apply each color band's particular thresholds to the color band
	hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
	%saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
	%valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);

% Display the thresholded binary images.
	fontSize = 16;
	
	figure, imshow(hueMask, []);
    imwrite(hueMask, 'hueMask.png');
	title('=   Hue Mask', 'FontSize', fontSize);

redObjectsMask = uint8(hueMask);

figure, imshow(redObjectsMask, []);
imwrite(redObjectsMask, 'redObjectsMask.png');

    % Get rid of small objects.  Note: bwareaopen returns a logical.
    smallestAcceptableArea = 100;
	redObjectsMask = uint8(bwareaopen(redObjectsMask, smallestAcceptableArea));
	
	figure, imshow(redObjectsMask, []);
    imwrite(redObjectsMask, 'redObjectsMasksmall.png');
    
   % Smooth the border using a morphological closing operation, imclose().
	structuringElement = strel('disk', 4);
	redObjectsMask = imclose(redObjectsMask, structuringElement);
	
	figure, imshow(redObjectsMask, []);
    imwrite(redObjectsMask, 'redObjectsMaskSmoothed.png');
	title('Border smoothed', 'FontSize', fontSize);

% You can only multiply integers if they are of the same type.
	% (redObjectsMask is a logical array.)
	% We need to convert the type of redObjectsMask to the same data type as hImage.
	redObjectsMask = cast(redObjectsMask, class(rgbImage)); 

    % Use the red object mask to mask out the red-only portions of the rgb image.
	maskedImageR = redObjectsMask .* rgbImage(:,:,1);
	maskedImageG = redObjectsMask .* rgbImage(:,:,2);
	maskedImageB = redObjectsMask .* rgbImage(:,:,3);
	
    % Show the masked off red image.
	
	figure, imshow(maskedImageR);
	title('Masked Red Image', 'FontSize', fontSize);
    imwrite(maskedImageR, 'maskedImageR.png');

    figure, imshow(maskedImageG);
	title('Masked Green Image', 'FontSize', fontSize);
    imwrite(maskedImageG, 'maskedImageG.png');
	
	figure, imshow(maskedImageB);
	title('Masked Blue Image', 'FontSize', fontSize);
    imwrite(maskedImageB, 'maskedImageB.png');
    
	% Concatenate the masked color bands to form the rgb image.
	maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);
	% Show the masked off, original image.
	
	figure, imshow(maskedRGBImage);
	imwrite(maskedRGBImage, 'maskedRGBImage.png');
    fontSize = 13;
	caption = sprintf('Masked Original Image\nShowing Only the Red Objects');
	title(caption, 'FontSize', fontSize);
	% Show the original image next to it.
	%subplot(3, 3, 7);
	figure, imshow(rgbImage);
	title('The Original Image (Again)', 'FontSize', fontSize);


%Instead of doing mask, only show pixels with hue values 
    
%http://www.mathworks.com/matlabcentral/fileexchange/25157-image-segmentation-tutorial-blobsdemo
%http://www.mathworks.com/matlabcentral/fileexchange/?term=authorid%3A31862
%http://www.mathworks.com/matlabcentral/answers/29982-detecting-colours
%http://www.mathworks.com/help/images/examples/color-based-segmentation-using-the-l-a-b-color-space.html
