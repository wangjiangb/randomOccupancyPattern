function sample_one_video_weight_fixed(video_index, training)    
    if (ischar(video_index)), video_index = str2num(video_index), end;
    if (ischar(training)), training = str2num(training), end;
    load data_config
    if (training==1)
        file_name = all_train_files{video_index};
        file_name_out = sprintf('features/sampled_patch_train_%02d',video_index);
        file_name_out_fea = sprintf('features/subdepth_train_%02d',video_index);
    else
        file_name = all_test_files{video_index};
        file_name_out = sprintf('features/sampled_patch_test_%02d',video_index);
        file_name_out_fea = sprintf('features/subdepth_test_%02d',video_index);    
    end
    %file_name_full = strcat('../MSR-Action3D/',file_name)
    %depth = ReadDepthBinOld(file_name_full);
    %sub_depth = subsample_depth_video(depth, params.max_y, params.max_x, ...
    %                                  params.max_z, params.max_t);
    file_name_out_fea
    load(file_name_out_fea);
    sampled_patches = zeros(1, num_samples);                                  
    for sample = 1:num_samples
        lower_x = grids(1, sample);
        higher_x = grids(2, sample);
        lower_y = grids(3, sample);
        higher_y = grids(4, sample);
        lower_z  = grids(5, sample);
        higher_z = grids(6, sample);
        lower_t = grids(7,sample);
        higher_t = grids(8, sample);   
        size_x = higher_x -  lower_x +1;
        size_y = higher_y - lower_y +1;
        size_z = higher_z - lower_z +1;
        size_t = higher_t - lower_t +1;
        blocks = sub_depth(lower_y:higher_y,lower_x:higher_x, ...
                               lower_z:higher_z,lower_t:higher_t);        
        blocks_temp = blocks(1:end);
        blocks_sum = sum(blocks_temp); 
        %block_size = (higher_y-lower_y+1)*(higher_x-lower_x+1)*(higher_z-lower_z+1)*(higher_t-lower_t+1);
        sampled_patches(sample) =  blocks_sum;
    end    
    save(file_name_out, 'sampled_patches');    
end
