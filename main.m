clear all
close all
clc

folder = 'C:\Users\Cat\Documents\School\SYDE 4A\SYDE 461 - Systems Design Workshop\Test Images\';

files = dir(strcat(folder,'*.tif'));
file_list = {files.name};

num = size(file_list, 2);
for i = 1:num
    name = file_list{i};
    idx = strfind(name,'.') - 1;
    image = imread(strcat(folder,name));
    lane_detection(image, name(1:idx));
end