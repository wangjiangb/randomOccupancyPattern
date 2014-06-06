function [grids,weights] = random_sample_grids(num_samples, params)
   max_x = params.max_x;
   max_y = params.max_y;
   max_z = params.max_z;
   min_x = params.min_x;
   min_y = params.min_y;
   min_z = params.min_z;   
   min_t = params.min_t;
   max_t = params.max_t;
   var_t = params.var_t;
   var_x = params.var_x;
   var_y = params.var_y;
   var_z = params.var_z;
   center_x = randi(max_x - min_x, 1, num_samples) + min_x -1;
   size_x = randi(var_x, 1, num_samples)-1;
   lower_x = max(min_x, int32(center_x-size_x/2));
   higher_x = min(max_x, int32(center_x+size_x/2));
   center_y = randi(max_y - min_y, 1, num_samples) + min_y - 1;
   size_y = randi(var_y, 1, num_samples)-1;
   lower_y = max(min_y, int32(center_y-size_y/2));
   higher_y = min(max_y, int32(center_y+size_y/2));
   if (max_z ==min_z)
       center_z = min_z* size(1, num_samples);
   else
    center_z = randi(max_z - min_z, 1, num_samples) + min_z -1;
   end
   size_z = randi(var_z, 1, num_samples)-1;
   lower_z = max(min_z, int32(center_z-size_z/2));
   higher_z = min(max_z, int32(center_z+size_z/2));   
   center_t = randi(max_t - min_t, 1, num_samples) + min_t -1;
   size_t = randi(var_t, 1, num_samples)-1;
   lower_t = max(min_t, int32(center_t-size_t/2));
   higher_t = min(max_t, int32(center_t+size_t/2));     
   grids  = [lower_x; higher_x; lower_y; higher_y; lower_z; higher_z; ...
             lower_t; higher_t];
end
