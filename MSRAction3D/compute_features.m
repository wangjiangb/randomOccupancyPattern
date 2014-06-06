 step = 500;
 parfor ind = 1:60000/step
     sample_one_video_weight((ind-1)*step+1, ind*step,1);
 end
 
 parfor ind = 1:step:10000/step
     sample_one_video_weight((ind-1)*step+1, ind*step,0);
 end
  