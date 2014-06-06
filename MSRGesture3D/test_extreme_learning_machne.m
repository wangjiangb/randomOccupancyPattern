function [predicted_labels, real_labels]  = test_extreme_learning_machne(person_index)
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
%H = min(sampled_patches_training, damping_ratio)'/damping_ratio;
H = sampled_patches_training';
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
    

%% test extreme learning machine
P = sampled_patches_test';
NumberofTestingData=size(sampled_patches_test,1);
ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);  
tempH= P+BiasMatrix;
%H_test = 1./(1+ exp(-tempH)); %% hidden layer output
%H_test = min(P, damping_ratio)/damping_ratio;
H_test = tempH;
TY=(H_test' * OutputWeight)';  
TV.T= all_test_labels;
 temp_TV_T=zeros(NumberofOutputNeurons, NumberofTestingData);
    for i = 1:NumberofTestingData
        for j = 1:number_class
            if label(1,j) == TV.T(1,i)
                break; 
            end
        end
        temp_TV_T(j,i)=1;
    end
    TV.T=temp_TV_T*2-1;
    
 MissClassificationRate_Testing=0;
for i = 1 : size(TV.T, 2)
     [x, label_index_expected(i)]=max(TV.T(:,i));
     [x, label_index_actual(i)]=max(TY(:,i));
     if label_index_actual(i)~=label_index_expected(i)
         MissClassificationRate_Testing=MissClassificationRate_Testing+1;
     end
end
predicted_labels = label_index_actual;
real_labels = label_index_expected;
 TestingAccuracy=1-MissClassificationRate_Testing/NumberofTestingData  
end
