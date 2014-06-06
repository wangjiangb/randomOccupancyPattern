clear;
%% generate random grids
num_samples = 10000;
params.min_x = 1;
params.max_x =20;
params.var_x = 20;
params.min_y = 1;
params.max_y =20;
params.var_y = 20;
params.min_z = 1;
params.max_z =1;
params.var_z = 1;
params.min_t = 1;
params.max_t =10;
params.var_t = 10;
grids = random_sample_grids(num_samples,params);

%% list the trainining data
save('data_config','grids','num_samples','params');
%% use the training data and random sampled grids to get the
%% exterme learning machine

%% test the exterme learning machine for the 
