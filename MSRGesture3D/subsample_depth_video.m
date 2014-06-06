function depth_sub = subsample_depth_video(depth, bins_y, bins_x, bins_z, ...
                                           bins_t)
    % determine the bounding box according to the first frame
    depth_sub = zeros(bins_y, bins_x, bins_z, bins_t);
    depth1 = depth(:,:,3);
    max_z = max(max(depth1)) +10;
    depth_pos = depth1>0;
    min_z = min(min(depth1(depth_pos))) - 10;
    center_z = mean(mean(depth1(depth_pos)));
    valid_indexes = find(depth_pos);
    [y,x] = ind2sub(size(depth1),valid_indexes);
    center_y = int32(mean(y));
    center_x = int32(mean(x));
    max_z = 255;
    min_z = 0;
    size_z = int32((max_z-min_z+1)/bins_z);
    max_t  = size(depth,3);
    min_t = 1;
    size_t = int32(max_t/bins_t);
    % for x and y axis, we assume there must be some non-zero pixels
    min_y = 1;
    max_y = size(depth, 1);
    min_x = 1;
    max_x = size(depth, 2);
    for y=1:size(depth,1)
        if (~isempty(find(depth(y,:,1), 1)))
            min_y = y;
            break;
        end
    end
    min_y = max(min_y -10 ,1);
    for y=size(depth,1):-1:1
        if (~isempty(find(depth(y,:,1), 1)))
            max_y = y;
            break;
        end
    end
    max_y = min(max_y + 10 ,size(depth,1));    
    max_y =150;
    min_y =1;
    size_y = int32((max_y - min_y+1)/bins_y);
    for x=1:size(depth,2)
        if (~isempty(find(depth(:,x,1), 1)))
            min_x = x;
            break;
        end    
    end
    min_x = max(min_x - 10, 1);
    for x=size(depth,2):-1:1
        if (~isempty(find(depth(:,x,1), 1)))
            max_x = x;
            break;
        end    
    end    
    max_x =  min(max_x +10 , size(depth,2));
     max_x = 150;
     min_x = 1;
    size_x = int32((max_x - min_x+1)/bins_x);
    box_med_x = (min_x + max_x)/2;
    box_med_y = (min_y + max_y)/2;
    box_med_z = (min_z + max_z)/2;
    for ind_y = 1:bins_x
        lower_y = min_y + (ind_y - 1) * size_y - box_med_y + ...
                  center_y;
        lower_y = max(1, lower_y);
        higer_y = min(size(depth,1), min_y +  ind_y * size_y-box_med_y+center_y);
        for ind_x = 1:bins_y
            lower_x =max(1, min_x + (ind_x - 1) * size_x -box_med_x+center_x);
            higer_x = min(size(depth,2), min_x +  ind_x * size_x-1-box_med_x+center_x);
            for ind_z = 1:bins_z
                lower_z = max(1, min_z + (ind_z - 1) * size_z-box_med_z+center_z);
                higer_z = min(max_z, min_z +  ind_z * size_z-1-box_med_z+center_z);
                for ind_t = 1:bins_t
                    lower_t = min_t + (ind_t - 1) * size_t;
                    higer_t = min(max_t, min_t +  ind_t * size_t-1);
                    depth_part = depth(lower_y:higer_y, lower_x: ...
                                       higer_x,lower_t:higer_t);
                    num_pixels = length(find((depth_part<=higer_z)&(depth_part>=lower_z)));
                    depth_sub(ind_y, ind_x, ind_z, ind_t)  = num_pixels;
                end
            end
        end
    end   
end