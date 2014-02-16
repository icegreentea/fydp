function [] = annotate(min, max, picture_path)
    for i=min:max
        for j=0:1
            output_postfix = 'red';
            
            if(j == 1)
                output_postfix = 'blue';
            end
            
            img_str = strcat('0', num2str(i));

            im = imread(strcat(picture_path, 'IMG_', img_str, '.JPG')); 
            figure
            clf;
            h = imagesc(im);
            axis image
            
            title(output_postfix);
            [x, y] = ginput();
            m = [x, y];
            close all;
            
            if(isempty(x) == false)
                fileID = fopen(strcat(picture_path, 'IMG_', img_str, '_', output_postfix, '.txt'),'w');
                fprintf(fileID,'%6s %12s\n','x','y');
                fprintf(fileID,'%6.2f %12.8f\n',m);
                fclose(fileID);
            end            
        end
    end
end