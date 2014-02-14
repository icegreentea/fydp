
im = imread('IMG_0243.JPG'); 
figure
clf;
h = imagesc(im);
axis image

[x, y] = ginput(12);
m = [x, y];

 fileID = fopen('IMG_0243.txt','w');
 fprintf(fileID,'%6s %12s\n','x','y');
 fprintf(fileID,'%6.2f %12.8f\n',m);
 fclose(fileID);
