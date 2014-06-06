function sample_one_video(video_index_begin, video_index_end, training)    
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
    else        
        load('test_data');
        img  = img_test;
        file_name_out = sprintf('features/sampled_patch_test_%02d',video_index_begin);
    end 
    sampled_patches = zeros(video_index_end- video_index_begin +1, num_samples);
    for video_index= video_index_begin:video_index_end        
        img_current = img(:,:,video_index);
        %img_current = double(img_current>0.2);
        for sample = 1:num_samples
            lower_x = grids(1, sample);
            higher_x = grids(2, sample);
            lower_y = grids(3, sample);
            higher_y = grids(4, sample);
            blocks = img_current(lower_y:higher_y,lower_x:higher_x);        
            blocks_temp = blocks(1:end);
            blocks_sum = sum(blocks_temp);                            
            sampled_patches(video_index-video_index_begin+1,sample) =  blocks_sum;
        end    
    end
    save(file_name_out, 'sampled_patches');
end
