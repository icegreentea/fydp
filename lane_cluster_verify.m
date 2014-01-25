function [ lane_map_out ] = lane_cluster_verify( gray_image, init_lane_map, cluster_window_size)
%LANE_CLUSTER_VERIFY Summary of this function goes here
%   Detailed explanation goes here

%Initialize Output
[number_of_rows, number_of_cols] = size(init_lane_map);
lane_map_out = zeros(number_of_rows, number_of_cols);

%Iterate Through All Candidate Points
for i_row_number = 1:number_of_rows
    for i_col_number = 1:number_of_cols
        %for every candidate point -> could become 1
        if init_lane_map(i_row_number,i_col_number) == 1 %if candidate
            %create window image
            [image_window_rows, image_window_cols] = window_indexer([i_row_number, i_col_number], ...
                [number_of_rows,number_of_cols], cluster_window_size);
            sub_image = gray_image(image_window_rows, image_window_cols);
            
            %cluster sub_image
            K_means_2(sub_image);
            
            
            lane_map_out(i_row_number,i_col_number) = gray_image(i_row_number,i_col_number);
        else %not a candidate -> 0
            lane_map_out(i_row_number,i_col_number) = 0;
        end
    end
end

end

