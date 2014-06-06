addpath ../lightspeed
parfor i=1:270
    compute_integral_image(i,1);
end

parfor i=1:297
    compute_integral_image(i,0);
end
