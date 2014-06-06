load data_all;
addpath ../lightspeed/;
damping_ratio  =20;
%% use the training data and random sampled grids to get the
%% exterme learning machine
sampled_patches = zeros(size(training_data_all,5),num_samples);
for sample = 1:num_samples
    sample
    lower_x = grids(1, sample);
    higher_x = grids(2, sample);
    lower_y = grids(3, sample);
    higher_y = grids(4, sample);
    lower_z  = grids(5, sample);
    higher_z = grids(6, sample);
    lower_t = grids(7,sample);
    higher_t = grids(8, sample);    
    blocks = training_data_all(lower_y:higher_y,lower_x:higher_x, ...
                               lower_z:higher_z,lower_t:higher_t,: ...
                               );
    block_size = size(blocks);
    blocks_temp = reshape(blocks,[prod(block_size(1:4)),size(blocks,5)]);
    blocks_sum = reshape(sum(blocks_temp,1),[1, ...
                        size(blocks,5)]);
    sampled_patches(:,sample) =  blocks_sum;
end
save ('sampled_patches','sampled_patches');
%% test the exterme learning machine one the test data
sampled_patches_test = zeros(size(test_data_all,5),num_samples);
for sample = 1:num_samples
    sample
    lower_x = grids(1, sample);
    higher_x = grids(2, sample);
    lower_y = grids(3, sample);
    higher_y = grids(4, sample);
    lower_z  = grids(5, sample);
    higher_z = grids(6, sample);
    lower_t = grids(7,sample);
    higher_t = grids(8, sample);    
    blocks = test_data_all(lower_y:higher_y,lower_x:higher_x, ...
                               lower_z:higher_z,lower_t:higher_t,: ...
                               );
    block_size = size(blocks);
    blocks_temp = reshape(blocks,[prod(block_size(1:4)),size(blocks,5)]);
    blocks_sum = reshape(sum(blocks_temp,1),[1, ...
                        size(blocks,5)]);
    sampled_patches_test(:,sample) =  blocks_sum;
end
save ('sampled_patches_test','sampled_patches_test');
%% train extreme learning machine
NumberofTrainingData = size(sampled_patches, 1);
NumberofHiddenNeurons=size(sampled_patches,2);
BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind); 
tempH=sampled_patches'+BiasMatrix;
%H = 1./(1+ exp(-tempH)); %% hidden layer output
H = min(sampled_patches, damping_ratio)'/damping_ratio;
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
H_test = min(P, damping_ratio)/damping_ratio;
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