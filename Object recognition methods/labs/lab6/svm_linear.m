%Генерация линейно-разделимых классов
NumberOfPoints = 100;

mu1 = [2, 3];
sigma1 = [1, 1.5; 1.5, 3];
r1 = mvnrnd(mu1,sigma1,NumberOfPoints);

mu2 = [-2, 5];
sigma2 = [3, 3.2; 3.2, 4];
r2 = mvnrnd(mu2,sigma2,NumberOfPoints);

%TODO - prepare train and test sets

%TODO - svm
%svmtrain, svmclassify






