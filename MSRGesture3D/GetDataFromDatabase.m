person_list = {'01_Me-All','02_Shujie','03_Julia','05_Qin','06_Flavio','07_Douglas', ...
                '08_Marat','09_Akansel','10_AlexG','12_Artem'};  
 gesture_list = {'Asl-z_1', 'Asl-z_2','Asl-z_3','Asl-j_1','Asl-j_2','Asl-j_3','ASL-Where_1','ASL-Where_2','ASL-Where_3','ASL-Store_1' ...
      'ASL-Store_2','ASL-Store_3','ASL-Pig_1','ASL-Pig_2', 'ASL-Pig_3','ASL-Past_1','ASL-Past_2','ASL-Past_3','ASL-Hungry_1',...
      'ASL-Hungry_2','ASL-Hungry_3','ASL-Green_1','ASL-Green_2','ASL-Green_3','ASL-Finish_1','ASL-Finish_2','ASL-Finish_3','ASL-Blue_1',...
      'ASL-Blue_2','ASL-Blue_3','ASL-Bathroom_1','ASL-Bathroom_2','ASL-Bathroom_3','ASL-Milk_1','ASL-Milk_2','ASL-Milk_3'};
 labels=[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9,10,10,10,11,11,11,12,12,12];
 for per_id= 1:length(person_list)
     for ges_id= 1:length(gesture_list)
         outfile = sprintf('gestureData/sub_depth_%02d_%02d.mat',per_id,ges_id);
         if (~exist(outfile,'file'))         
             depth_dir = fullfile('../GesturesDB-Shared',person_list{per_id}, ...
                                  gesture_list{ges_id},'camdz');
             if (~exist(depth_dir,'dir'))
                 continue;
             end             
             depth=ReadDepthDir(depth_dir);
             seg_dir = fullfile('../GesturesDB-Shared/SegmentedImages/Melee' ...
                                 ,person_list{per_id}, gesture_list{ges_id});
             seg = ReadDepthDir(seg_dir);
             valid_indexes = find(seg);
             [y,x,t] = ind2sub(size(seg), valid_indexes);
             depth = depth.*(seg>0);
             x_max = max(x);
             y_max = max(y);
             x_min = min(x);
             y_min = min(y);
             %segment out the image
             depth_part = depth(y_min:y_max, x_min:x_max,:);             
             save(outfile,'depth_part');
         end
     end
 end