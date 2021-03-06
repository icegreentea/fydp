clear all
close all
clc

folder = 'Test Images\';

files = dir(strcat(folder,'*.jpg'));
file_list = {files.name};

num = size(file_list, 2);
for i = 1:num
    name = file_list{i};
    idx = strfind(name,'.') - 1;
    image = imread(strcat(folder,name));
    lane_detection(image, strcat('Results\',name(1:idx)));
end