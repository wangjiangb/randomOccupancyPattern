predicted_labels_all = [];
real_labels_all = [];
for per_id = 1:10
    [predicted_label, real_labels] = test_svm(per_id);
    predicted_labels_all  = [predicted_labels_all predicted_label];
    real_labels_all = [real_labels_all real_labels];
end
save('result_svm','predicted_labels_all','real_labels_all');
for i=1:20
    num_train(i) = length(find(real_labels_all==i));
end

[C,order] = confusionmat(real_labels_all,predicted_labels_all);
num_classes =12;
for i=1:num_classes
    C(i,:) =  C(i, :)/num_train(i);
end
C = C * 100;
h = imagesc(C);
image_labels = {'bathroom','blue','finish','green','hungry','milk','past','pia','store','where','j','z'};
xticklabel_rotate([1:num_classes],90,image_labels,'interpreter','none');
set(gca,'Ytick',1:20,'YTickLabel', image_labels);
for i=1:num_classes
    for j=1:num_classes
        if C(i,j)>0.1
            text_C = sprintf('%.2f',C(i,j))
            text(j-0.4, i, text_C);
        end
        
    end
end

