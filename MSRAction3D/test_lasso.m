addpath ./imm3897/;
T = randn(10,100);
 y = ones(10,1);
b1 = lars(T, y, 'lasso', 0, 0, [], 0);