[img_test, labels_test] = readMNIST('t10k-images-idx3-ubyte','t10k-labels-idx1-ubyte',10000,0);
[img_train, labels_train] = readMNIST('train-images-idx3-ubyte','train-labels-idx1-ubyte',60000,0);
save('train_data', 'img_train','labels_train');
save('test_data', 'img_test','labels_test');