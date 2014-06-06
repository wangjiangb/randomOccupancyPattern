function compute_integral_image(video_index_begin, video_index_end, training)    
    if (ischar(video_index_begin)), video_index_begin = ...
            str2num(video_index_begin), end;
        if (ischar(video_index_end)), video_index_end = ...
                str2num(video_index_end), end;        
    if (ischar(training)), training = str2num(training), end;
    load data_config
    if (training==1)
        load('train_data');        
        img = img_train;
        file_name_out = sprintf('features/sampled_patch_train_%02d',video_index_begin);
        file_name_integral = sprintf('features/integral_train_%02d', ...
                                    video_index_begin);    
    else        
        load('test_data');
        img  = img_test;
        file_name_out = sprintf('features/sampled_patch_test_%02d',video_index_begin);
        file_name_integral = sprintf('features/integral_test_%02d', ...
                                     video_index_begin);

    end 
    %file_name_full = strcat('../MSR-Action3D/',file_name)
    %depth = ReadDepthBinOld(file_name_full);
    %sub_depth = subsample_depth_video(depth, params.max_y, params.max_x, ...
    %                                  params.max_z, params.max_t);
    file_name_integral
    if (exist(file_name_integral,'file'))
        return;
    end
    integral_all = zeros(video_index_end - video_index_begin+1, ...
                         size(img, 1), size(img,2));
    for video_index= video_index_begin:video_index_end        
        img_current = img(:,:,video_index);
        integral = integral_from_image(img_current);
        integral_all(video_index-video_index_begin+1,:,:)  = integral;
    end    
    save(file_name_integral, 'integral_all');    
end
