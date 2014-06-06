clear;
%% generate random grids
num_samples = 10000;
params.min_x = 1;
params.max_x =120;
params.var_x = 120;
params.min_y = 1;
params.max_y =120;
params.var_y = 120;
params.min_z = 1;
params.max_z =3;
params.var_z = 3;
params.min_t = 1;
params.max_t =10;
params.var_t = 10;
grids = random_sample_grids(num_samples,params);

%% list the trainining data
person_list = {'01_Me-All','02_Shujie','03_Julia','05_Qin','06_Flavio','07_Douglas', ...
                '08_Marat','09_Akansel','10_AlexG','12_Artem'};  
 gesture_list = {'Asl-z_1', 'Asl-z_2','Asl-z_3','Asl-j_1','Asl-j_2','Asl-j_3','ASL-Where_1','ASL-Where_2','ASL-Where_3','ASL-Store_1' ...
      'ASL-Store_2','ASL-Store_3','ASL-Pig_1','ASL-Pig_2', 'ASL-Pig_3','ASL-Past_1','ASL-Past_2','ASL-Past_3','ASL-Hungry_1',...
      'ASL-Hungry_2','ASL-Hungry_3','ASL-Green_1','ASL-Green_2','ASL-Green_3','ASL-Finish_1','ASL-Finish_2','ASL-Finish_3','ASL-Blue_1',...
      'ASL-Blue_2','ASL-Blue_3','ASL-Bathroom_1','ASL-Bathroom_2','ASL-Bathroom_3','ASL-Milk_1','ASL-Milk_2','ASL-Milk_3'};
 labels=[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9,10,10,10,11,11,11,12,12,12];
training_id = ones(length(person_list),length(gesture_list));
test_id = zeros(length(person_list),length(gesture_list));
training_id([8],:) = 0;
training_count = 1;
test_count = 1;
test_id([8],:) = 1;
 for per_id= 1:length(person_list)
     for ges_id= 1:length(gesture_list)
         outfile = sprintf('gestureData/sub_depth_%02d_%02d.mat',per_id,ges_id);
         if (~exist(outfile,'file'))  
             continue;
         end         
         if (training_id(per_id, ges_id)>0)             
             all_train_files{training_count} = outfile;
             all_train_labels(training_count)  = labels(ges_id);
             all_train_person(training_count) = per_id;
             training_count = training_count+1;
         end
         if (test_id(per_id, ges_id)>0)                      
             all_test_files{test_count} = outfile;
             all_test_labels(test_count)  = labels(ges_id);
             all_test_person(test_count) = per_id;
             test_count = test_count+1;
         end
     end
 end
save('data_config','all_train_files','all_test_files','grids','num_samples','params','all_test_labels','all_train_labels','all_train_person','all_test_person');
%% use the training data and random sampled grids to get the
%% exterme learning machine

%% test the exterme learning machine for the 
