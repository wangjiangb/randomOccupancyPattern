load data_config
num_train_files = length(all_train_files);
size_data  = [params.max_y, params.max_x, params.max_z, params.max_t];
scores = zeros(size_data);
data  = zeros([size_data num_train_files]);
for video_index=1:num_train_files
    video_index
    file_name_data = sprintf('features/subdepth_train_%02d', ...
                                    video_index);
    load(file_name_data)
    data(:,:,:,:,video_index) = sub_depth;
end

for c= 1:12
    index_positive = find(all_train_labels==c);
    index_negative = find(all_train_labels~=c);
    mean_positive = mean(data(:,:,:,:,index_positive),  5);
    mean_negative = mean(data(:,:,:,:,index_negative),  5);
    var_positive = var(data(:,:,:,:,index_positive),  0, 5);
    var_negatieve = var(data(:,:,:,:,index_positive),  0, 5);
    scores = scores + (mean_positive - mean_negative).^2 ./ (var_positive + var_negatieve+0.0001);
end
scores_sigmoid = 1./(1+exp(-scores/100));
scores_vis  = sum(sum(scores_sigmoid, 3 ), 4);
save('scores','scores','scores_sigmoid');
scores_bigger = repmat(scores_sigmoid, [2 2 2 2]);
score_integral = integral_from_image(scores_bigger);
save('score_integral','score_integral');
