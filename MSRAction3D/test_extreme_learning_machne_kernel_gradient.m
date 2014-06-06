clear
addpath ../lightspeed;
load data_config;
 info_path = '../MSR-Action3D/';
 num_train_samples = length(all_train_files);
 %num_train_samples = 10;
 sampled_patches_training=zeros( 1, 16, num_samples, num_train_samples);
 for f=1:num_train_samples
     file_name_out = sprintf('features/sampled_patch_train_weighted_%02d',f);
     load(file_name_out);
     sampled_patches_training(1, : , :,f) = sampled_patches;
 end
num_kernels = 10; 
w  = randn(num_kernels,16) -0.5; % initial w 
%w(1,:) = [1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1]/2;
%w(2,:) = [1  1 1  1 1  1 1  1 -1 -1 -1 -1 -1 -1 -1 -1]/2;
w_full = repmat(w,[1, 1, num_samples, num_train_samples]);
                
sampled_patches_training_new = repmat(sampled_patches_training, [num_kernels 1 1 1 ]);

prod_train = w_full.*sampled_patches_training_new;
sum_train = reshape(sum(prod_train,2),[num_kernels*num_samples, num_train_samples]);
sampled_patches_training = sum_train';

 %% train extreme learning machine8
damping_ratio = 10;
NumberofTrainingData = size(sampled_patches_training, 1);
NumberofHiddenNeurons=size(sampled_patches_training,2);
BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind); 
tempH=sampled_patches_training'+BiasMatrix;
H = 1./(1+ exp(-tempH/damping_ratio))-0.5; %% hidden layer output
%H = min(sampled_patches_training, damping_ratio)'/damping_ratio;
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
    
%OutputWeight=pinv(H') * T';
%Hd = H';
%delta = 0;
%pinv_H =  Hd'*inv(Hd*Hd'+ delta*eye(size(Hd,1)));
pinv_H = pinv(H');
OutputWeight=pinv_H * T';
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
save ('parameters', 'BiasofHiddenNeurons','label','number_class','NumberofOutputNeurons','OutputWeight','w','num_kernels');

%% test extreme learning machine
clear;
addpath ../lightspeed;
load data_config;
load parameters;
damping_ratio = 10;
num_test_samples = length(all_test_files);
sampled_patches_test=zeros(1, 16, num_samples, num_test_samples);
for f=1:num_test_samples
    file_name_out = sprintf('features/sampled_patch_test_weighted_%02d',f);
    load(file_name_out);
    sampled_patches_test(1,:,:,f) = sampled_patches;
end

w_full = repmat(w,[1, 1, num_samples, num_test_samples]);
                
sampled_patches_test_new = repmat(sampled_patches_test, [num_kernels 1 1 1 ]);

prod_test = w_full.*sampled_patches_test_new;
sum_test= reshape(sum(prod_test,2),[num_kernels*num_samples, num_test_samples]);
sampled_patches_test = sum_test';

P = sampled_patches_test';
NumberofTestingData=size(sampled_patches_test,1);
ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);  
tempH= P+BiasMatrix;
H_test = 1./(1+ exp(-tempH/damping_ratio))-0.5; %% hidden layer output
%H_test = min(P, damping_ratio)/damping_ratio;
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
     [x, label_index_expected]=max(TV.T(:,i));
     [x, label_index_actual]=max(TY(:,i));
     if label_index_actual~=label_index_expected
         MissClassificationRate_Testing=MissClassificationRate_Testing+1;
     end
 end
 TestingAccuracy=1-MissClassificationRate_Testing/NumberofTestingData  