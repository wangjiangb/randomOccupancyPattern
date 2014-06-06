addpath ../spams/build/; 
load sampled_patches;
load sampled_patches_test;
load data_all;
damping_ratio = 10;
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
param.lambda=0.0000001; % not more than 20 non-zeros coefficients
param.lambda2=0;
param.numThreads=-1; % number of processors/cores to use; the default choice is -1
                     % and uses all the cores of the machine
param.mode=2;        % penalized formulation
D = H';                    
D=D./repmat(sqrt(sum(D.^2)+0.000001),[size(D,1) 1]);                    
 alpha=mexLasso(T',D,param);
 OutputWeight = alpha;
%%%%%%%%%%% Calculate the training accuracy
Y=(D * OutputWeight)';  
MissClassificationRate_Training=0;

parfor i = 1 : size(T, 2)
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
D = H_test';                    
D=D./repmat(sqrt(sum(D.^2)+0.000001),[size(D,1) 1]);     
TY=(D * OutputWeight)';  
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
 
 
 