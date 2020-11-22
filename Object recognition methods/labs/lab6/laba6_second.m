%clc
%clear
%close all

%линейно-разделимые
NumberOfPoints = 100;
mu1 = [0, 0];
sigma1 = [0.1, 0.2; 0.2, 1.3];
r1 = mvnrnd(mu1, sigma1, NumberOfPoints);
mu2 = [4, 2];
sigma2 = [0.9, 0.3; 0.3, 0.5];
r2 = mvnrnd(mu2, sigma2, NumberOfPoints);

svm_classify(r1, r2, 'linear', NumberOfPoints);



%линейно-неразделимые
mu1 = [-1, -1];
sigma1 = [0.1, 0.2; 0.2, 1.3];
r3 = mvnrnd(mu1, sigma1, NumberOfPoints);
mu2 = [1, 1];
sigma2 = [0.9, 0.3; 0.3, 0.5];
r4 = mvnrnd(mu2, sigma2, NumberOfPoints);


svm_classify(r3, r4, 'linear', NumberOfPoints);
svm_classify(r3, r4, 'rbf', NumberOfPoints);

