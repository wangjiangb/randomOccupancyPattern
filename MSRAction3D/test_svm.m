 load data_config;
 info_path = '../MSR-Action3D/';
 sampled_patches_training=[];
 for f=1:length(all_train_files)
     file_name_out = sprintf('features/subdepth_train_%02d',f);
     load(file_name_out);
     sampled_patches_training(f,:) = min(sub_depth(1:end),20);
 end
sampled_patches_test=[];
 for f=1:length(all_test_files)
     file_name_out = sprintf('features/subdepth_test_%02d',f);
     load(file_name_out);
     sampled_patches_test(f,:) = min(sub_depth(1:end),20);
 end
%[mappedX, mapping] = pca(data_training',500);
%mappedTest =  data_test'*mapping.M;
%features_histogram_training = mappedX';
%features_histogram_test = mappedTest';
features_histogram_training  = sampled_patches_training';
features_histogram_test = sampled_patches_test';
train_label = all_train_labels;
test_label = all_test_labels;
c =.05;
%' -s 0 -t 2 -d 1 -g 0.08' 
options = ['-c ' num2str(c) ];
model = train(double(train_label'), sparse(features_histogram_training'), options);
[predicted_label, accuracy2, decision_values] = predict(double(test_label'), sparse(features_histogram_test'), model);

