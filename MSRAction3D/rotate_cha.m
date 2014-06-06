function new_img = rotate_cha(img_current)
valid_indexes = find(img_current);
[y,x] = ind2sub(size(img_current),valid_indexes);
data = [y x]';
mn = mean(data,2);
data = data-repmat(mn,1,size(data,2));
covariance = data*data';
[PC,V] = eig(covariance);
theta = atan(PC(1,2)/PC(2,2));
if (theta<0)
    theta = theta+ pi;
end
theta = pi/2 - theta;

size_y = 28;
size_x = 28;
mid_y = size_y/2;
mid_x = size_x/2;
theta_degree = theta*180/pi;
new_img = imrotate(img_current,-theta_degree,'bilinear');
valid_indexes = find(new_img);
[y,x] = ind2sub(size(new_img),valid_indexes);

% data = [y x]';
% mn = mean(data,2);
% data = data-repmat(mn,1,size(data,2));
% covariance = data*data';
% [PC,V] = eig(covariance);
% theta = atan(PC(1,2)/PC(2,2));
% if (theta<0)
%     theta = theta+ pi;
% end
% theta = pi/2 - theta;

mean_y = round(mean(y));
mean_x = round(mean(x));
ty = mid_y - mean_y;
tx =  mid_x - mean_x;
t = maketform('affine',[1 0 ; 0 1; tx ty]);
bounds = findbounds(t,[1 1; size(new_img)]);
bounds(1,:) = [1 1];
bounds(2,:) = [28 28];
new_img = imtransform(new_img,t,'XData',bounds(:,1)','YData',bounds(:,2)');
valid_indexes = find(new_img);
[y,x] = ind2sub(size(new_img),valid_indexes);
mean_y = round(mean(y));
mean_x = round(mean(x));
end