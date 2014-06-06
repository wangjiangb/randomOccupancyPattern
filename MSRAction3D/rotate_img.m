load test_data;
bound = 4;
img_test_new = zeros(20,20,size(img_test,3));
for ind = 1:size(img_test,3)
   img_current = img_test(:,:,ind);
   new_img = rotate_cha(img_current);
   new_img = new_img(bound+1:28-bound,bound+1:28-bound);
   img_test_new(:,:,ind) = new_img;
end
save('test_data_new', 'img_test_new');
load train_data;
img_train_new = zeros(20,20,size(img_train,3));
for ind = 1:size(img_train,3)
   img_current = img_train(:,:,ind);
   new_img = rotate_cha(img_current);
   new_img = new_img(bound+1:28-bound,bound+1:28-bound);
   img_train_new(:,:,ind) = new_img;
end
save('train_data_new', 'img_train_new');
