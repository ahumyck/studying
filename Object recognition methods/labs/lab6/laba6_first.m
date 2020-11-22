clc
clear
close all

%линейно-разделимые
NumberOfPoints = 100;
mu1 = [0, 0];
sigma1 = [0.1, 0.2; 0.2, 1.3];
r1 = mvnrnd(mu1,sigma1,NumberOfPoints);
mu2 = [4, 2];
sigma2 = [0.9, 0.3; 0.3, 0.5];
r2 = mvnrnd(mu2,sigma2,NumberOfPoints);
%figure; title ('линейно-разделимые'); hold on;scatter(r1(:, 1),r1(:, 2), 5, 'red', 'fill');scatter(r2(:, 1),r2(:, 2), 5, 'blue', 'fill');hold off;
x_left1 = min([min(r1(:,1)), min(r2(:,1))]);y_left1 = min([min(r1(:,2)), min(r2(2))]);
x_right1 = max([max(r1(:,1)), max(r2(:,1))]);y_right1 = max([max(r1(:,2)), max(r2(:,2))]);
borders1 = [min(x_left1,y_left1), max(x_right1, y_right1)];
%----------------------------------

%линейно-неразделимые
mu3 = [0, 0];
sigma3 = [0.1, 0.2; 0.2, 1.3];
r3 = mvnrnd(mu3, sigma3, NumberOfPoints);
mu4 = [1, 1];
sigma4 = [0.9, 0.3; 0.3, 0.5];
r4 = mvnrnd(mu4, sigma4,  NumberOfPoints);
%figure; title ('линейно-неразделимые'); hold on;scatter(r3(:, 1),r3(:, 2), 5, 'red', 'fill');scatter(r4(:, 1),r4(:, 2), 5, 'blue', 'fill');hold off;
x_left2 = min([min(r3(:,1)), min(r4(:,1))]);y_left2 = min([min(r3(:,2)), min(r4(:,2))]);
x_right2 = max([max(r3(:,1)), max(r4(:,1))]);y_right2 = max([max(r3(:,2)), max(r4(:,2))]);
borders2 = [min(x_left2,y_left2), max(x_right2, y_right2)];
%----------------------------------

% ѕостроить линейный классификатор по SVM, раздел€ющий лин разделимые
% использовать  дл€ этого: задачу (7) и SVM 
train_vyb = [r1(1:50, :); r2(1:50, :)];
test_vyb = [r1(51:end, :); r2(51:end, :)];
labels = [ones(50,1); -1 * ones(50,1)];
%svmtrain
svmStruct1 = fitcsvm(train_vyb,labels,'Solver','L1QP');
%svmclassify
predict(svmStruct1,test_vyb);

figure; hold on;
scatter(r1(:, 1),r1(:, 2), 5, 'red', 'fill'); scatter(r2(:, 1),r2(:, 2), 5, 'blue', 'fill');
svm_f7(train_vyb, labels, borders1, 'по формуле 7');
hold off;
%----------------------------------

% ѕостроить линейный классификатор по SVM, раздел€ющий лин Ќ≈разделимые
% использовать  дл€ этого: задачу (12) и SVM
% ”казать решени€ дл€ C = 0.1, 1, 10 
train_vyb = [r3(1:50, :); r4(1:50, :)];
test_vyb = [r3(51:end, :); r4(51:end, :)];
labels = [ones(50,1); -1 * ones(50,1)];
%svmtrain
svmStruct1 = fitcsvm(train_vyb,labels,'Solver','L1QP');
%svmclassify
predict(svmStruct1,test_vyb);

figure; hold on;
scatter(r3(:, 1),r3(:, 2), 5, 'red', 'fill'); scatter(r4(:, 1),r4(:, 2), 5, 'blue', 'fill');
svm_f12(train_vyb, labels, borders2, 0.1, 'по формуле 12, C = 0.1');
hold off;

figure; hold on;
scatter(r3(:, 1),r3(:, 2), 5, 'red', 'fill'); scatter(r4(:, 1),r4(:, 2), 5, 'blue', 'fill');
svm_f12(train_vyb, labels, borders2, 1, 'по формуле 12, C = 1');
hold off;

figure; hold on;
scatter(r3(:, 1),r3(:, 2), 5, 'red', 'fill'); scatter(r4(:, 1),r4(:, 2), 5, 'blue', 'fill');
svm_f12(train_vyb, labels, borders2, 10, 'по формуле 12, C = 10');
hold off;
%----------------------------------

% ѕостроить Ќ≈линейный классификатор по SVM, раздел€ющий лин Ќ≈разделимые 
% использовать  дл€ этого: задачу (14) и SVM 
% ”казать решени€ дл€ C = 0.1, 1, 10 
train_vyb = [r3(1:50, :); r4(1:50, :)];
test_vyb = [r3(51:end, :); r4(51:end, :)];
labels = [ones(50,1); -1 * ones(50,1)];
%svmtrain
svmStruct1 = fitcsvm(train_vyb,labels,'Solver','L1QP');
%svmclassify
predict(svmStruct1,test_vyb);

figure; hold on;
scatter(r3(:, 1),r3(:, 2), 5, 'red', 'fill'); scatter(r4(:, 1),r4(:, 2), 5, 'blue', 'fill');
svm_f14(train_vyb, labels, borders2, 0.1, 'по формуле 14, C = 0.1');
hold off;

figure; hold on;
scatter(r3(:, 1),r3(:, 2), 5, 'red', 'fill'); scatter(r4(:, 1),r4(:, 2), 5, 'blue', 'fill');
svm_f14(train_vyb, labels, borders2, 1, 'по формуле 14, C = 1');
hold off;

figure; hold on;
scatter(r3(:, 1),r3(:, 2), 5, 'red', 'fill'); scatter(r4(:, 1),r4(:, 2), 5, 'blue', 'fill');
svm_f14(train_vyb, labels, borders2, 10, 'по формуле 14, C = 10');
hold off;
%----------------------------------
