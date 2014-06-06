function [predicted_labels, real_labels]  = test_svm(person_index)
addpath ../lightspeed/
load data_config;
 info_path = '../MSR-Action3D/';
 sampled_patches_training=zeros( length(all_train_files),num_samples);
 for f=1:length(all_train_files)
     file_name_out = sprintf('features/sampled_patch_train_%02d',f);
     load(file_name_out);
     sampled_patches_training(f,:) = sampled_patches;
 end
sampled_patches_test=zeros(length(all_test_files), num_samples);
 for f=1:length(all_test_files)
     file_name_out = sprintf('features/sampled_patch_test_%02d',f);
     load(file_name_out);
     sampled_patches_test(f,:) = sampled_patches;
 end
sampled_patches_all = [ sampled_patches_training;sampled_patches_test];
labels_all = [all_train_labels all_test_labels];
person_id_all = [all_train_person all_test_person];
train_id = find(person_id_all ~= person_index);
test_id = find(person_id_all  == person_index);
sampled_patches_training = sampled_patches_all(train_id, :);
sampled_patches_test = sampled_patches_all(test_id, :);
all_test_labels = labels_all(test_id);
all_train_labels = labels_all(train_id);
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
predicted_labels = predicted_label;
real_labels = all_test_labels;
