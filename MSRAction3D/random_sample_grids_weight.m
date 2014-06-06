function random_sample_grids_weight(begin_index, full_index)
    load data_config
    if (ischar(begin_index)), begin_index = str2num(begin_index), end;
    if (ischar(full_index)), full_index = str2num(full_index), end;
    num_samples = size(grids, 2);
    begin_sample= begin_index * num_samples/full_index+1;
    end_sample = (begin_index +1) *num_samples/full_index;    
    for sample = begin_sample:end_sample
        lower_x = grids(1, sample);
        higher_x = grids(2, sample);
        lower_y = grids(3, sample);
        higher_y = grids(4, sample);
        lower_z  = grids(5, sample);
        higher_z = grids(6, sample);
        lower_t = grids(7,sample);
        higher_t = grids(8, sample);   
        weight  = rand([higher_y-lower_y+1, higher_x-lower_x+1])*2 -1;
        outfilename = sprintf('features/weights_%09d',sample);
        save(outfilename, 'weight');
    end     
end
