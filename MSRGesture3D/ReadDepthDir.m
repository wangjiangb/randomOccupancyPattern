function depth = ReadDepthDir(target_dir)
    frames = dir(fullfile(target_dir,'*.bmp'));
    num_frames = length(frames);
    img = imread(fullfile(target_dir, frames(1).name));
    depth = zeros(size(img,1),size(img,2), num_frames);
    for fr = 1:num_frames
        img = imread(fullfile(target_dir, frames(fr).name));
        depth(:,:,fr) = img;
    end    
end
