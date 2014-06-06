function [predicted_labels, real_labels]  = test_extreme_learning_machne_dict(person_index)
%person_index = 1;
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
 
 %% train extreme learning machine
damping_ratio = 1;
NumberofTrainingData = size(sampled_patches_training, 1);
NumberofHiddenNeurons=size(sampled_patches_training,2);
BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind); 
tempH=sampled_patches_training'+BiasMatrix;
%H = 1./(1+ exp(-tempH/damping_ratio)); %% hidden layer output
H = min(sampled_patches_training, damping_ratio)'/damping_ratio;
%H = sampled_patches_training';
T = all_train_labels;

sorted_target=sort(T,2);
label=zeros(1,1);                               %   Find and save in 'label' class label from training and testing data sets
label(1,1)=sorted_target(1,1);
j=1;
for i = 2:NumberofTrainingData
    if sorted_target(1,i) ~= label(1,j)
        j=j+1;
        label(1,j) = sorted_target(1,i);
    end
end 
number_class=j;
NumberofOutputNeurons=number_class;

temp_T=zeros(NumberofOutputNeurons, NumberofTrainingData);
for i = 1:NumberofTrainingData
    for j = 1:number_class
        if label(1,j) == T(1,i)
            break; 
        end
    end
    temp_T(j,i)=1;
end
T=temp_T*2-1;
    
OutputWeight=pinv(H') * T';
%%%%%%%%%%% Calculate the training accuracy
Y=(H' * OutputWeight)';  
MissClassificationRate_Training=0;

for i = 1 : size(T, 2)
    [x, label_index_expected]=max(T(:,i));
    [x, label_index_actual]=max(Y(:,i));
    output(i)=label(label_index_actual);
    if label_index_actual~=label_index_expected
        MissClassificationRate_Training=MissClassificationRate_Training+1;
    end
end
TrainingAccuracy=1-MissClassificationRate_Training/NumberofTrainingData
    
%% dictionary learning
weight_data = sum(abs(OutputWeight), 2)';
sampled_patches_training  = min(sampled_patches_training,damping_ratio);
num_train_samples = size(sampled_patches_training,1);
X = (sampled_patches_training.*repmat(weight_data,[num_train_samples, 1]));
D = X;
W_train = []
for i= 1:num_train_samples
    W_train(:,i) = Solve_L1LS(D',X(i,:)',0.1);
end
%% tesint the data
sampled_patches_test = min(sampled_patches_test, damping_ratio);
num_test_samples = size(sampled_patches_test,1);
X = (sampled_patches_test.*repmat(weight_data,[num_test_samples, 1]));
%X = X + randn(size(X));
W_test = [];
W_test_e1 = [];
for i= 1:num_test_samples
    i
    W_test(:,i) = Solve_L1LS(D',X(i,:)',0.01);
%     residue = zeros(size(W_test,1),1);
%     for j= 1:size(W_test,1)
%         residue(j,1) = norm(sampled_patches_test(i,:)' - W_test(j,i)*D(j,:)');
%         
%     end
    %i
    %W_test_e1(:,i) = SolvePALM(D',sampled_patches_test(1,:)');    
end


%% train SVM model
addpath ../gesture_sampling/
features_histogram_training  = W_train;
features_histogram_test = W_test;
train_label = all_train_labels;
test_label = all_test_labels;
c =50;
%' -s 0 -t 2 -d 1 -g 0.08' 
options = ['-c ' num2str(c) ];
model = train(double(train_label'), sparse(features_histogram_training'), options);
[predicted_labels, accuracy2, decision_values] = predict(double(test_label'), sparse(features_histogram_test'), model);
predicted_labels =  predicted_labels';
real_labels = test_label;
%save ('spase_result','predicted_label','test_label');
