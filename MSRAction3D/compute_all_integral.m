 step = 500;
 parfor ind = 1:60000/step
     compute_integral_image((ind-1)*step+1, ind*step,1);
 end
 
 parfor ind = 1:step:10000/step
     compute_integral_image((ind-1)*step+1, ind*step,0);
 end
 