clear;
load data_config;
 info_path = '../MSR-Action3D/';
 num_train = 60000;
 num_test = 10000;
 step =100
 sampled_patches_training=single(zeros( num_train,num_samples));
 for f=1:step:num_train
     f
     file_name_out = sprintf('features/sampled_patch_train_%02d',f);
     load(file_name_out);
     sampled_patches_training(f:f+step-1,:) = single(sampled_patches);
 end
 
 
 %% train extreme learning machine
 load train_data;
 load test_data;
damping_ratio = 50;
NumberofTrainingData = size(sampled_patches_training, 1);
NumberofHiddenNeurons=size(sampled_patches_training,2);
BiasofHiddenNeurons=single(rand(NumberofHiddenNeurons,1));
ind=single(ones(1,NumberofTrainingData));
BiasMatrix=BiasofHiddenNeurons(:,ind); 
tempH=sampled_patches_training'+BiasMatrix;
%H = 1./(1+ exp(-tempH/damping_ratio)); %% hidden layer output
H = min(sampled_patches_training, damping_ratio)'/damping_ratio;
clear sampled_patches_training;
T = labels_train';
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
%lambda = 0;
%pinv_H = inv(H'*H+lambda \eye(size(H,2)))*H'
%OutputWeight=pinv_H * T';
save('OutputWeight','OutputWeight');
%%%%%%%%%%% Calculate the training accuracy
Y=(H' * OutputWeight)';  
clear H;
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
    
%% read test data
sampled_patches_test=single(zeros(num_test, num_samples));
 for f=1:step:num_test
     file_name_out = sprintf('features/sampled_patch_test_%02d',f);
     load(file_name_out);
     sampled_patches_test(f:f+step-1,:) = single(sampled_patches);
 end

%% test extreme learning machine
P = sampled_patches_test';
NumberofTestingData=size(sampled_patches_test,1);
ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);  
tempH= P+BiasMatrix;
%H_test = 1./(1+ exp(-tempH)); %% hidden layer output
H_test = min(P, damping_ratio)/damping_ratio;
TY=(H_test' * OutputWeight)';  
TV.T= labels_test';
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
     [x, label_index_expected]=max(TV.T(:,i));
     [x, label_index_actual]=max(TY(:,i));
     if label_index_actual~=label_index_expected
         MissClassificationRate_Testing=MissClassificationRate_Testing+1;
     end
 end
 TestingAccuracy=1-MissClassificationRate_Testing/NumberofTestingData  