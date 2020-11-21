clear; clc; close all;
N = 100;
M1 = [0; 0]; R1 = [0.02 0.005; 0.005 0.02];
M2 = [1; 1]; R2 = [0.01,0; 0,0.04];
M3 = [-1; -1]; R3 = [0.1, 0.2; 0.2, 1.3];
M4 = [1; 1]; R4 = [0.9, 0.3; 0.3, 0.5];

X1 = mvnrnd(M1,R1,N);
X2 = mvnrnd(M2,R2,N);
X3 = mvnrnd(M3,R3,N);
X4 = mvnrnd(M4,R4,N);

N1 = 20;

svmClassifier1(X1,X2,N1,N,[-2, 3],[-1, 3]);
svmClassifier2(X3,X4,N1,N,[-5, 5],[-5, 5]);
svmClassifier3(X3,X4,N1,N,[-5, 5],[-5, 5]);

function [] = svmClassifier1(X1, X2,N1,N,limX,limY)
    Xtrain = [X1(1:N1,:); X2(1:N1,:)];
    Ytrain = [ones(N1,1); 2*ones(N1,1)];
    mdl = fitcsvm(Xtrain,Ytrain,'Solver','L1QP');
    Xtest = [X1(N1+1:N,:); X2(N1+1:N,:)];
    Ytest = predict(mdl, Xtest);
    
    figure;
    xlim(limX);
    ylim(limY);
    hold on;
    scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
    scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
    svm7(Xtrain, Ytrain, limX, limY,'blue');
    hold off;
end

function [] = svmClassifier2(X1, X2,N1,N,limX,limY)
    Xtrain = [X1(1:N1,:); X2(1:N1,:)];
    Ytrain = [ones(N1,1); 2*ones(N1,1)];
    
    Xtest = [X1(N1+1:N,:); X2(N1+1:N,:)];
    
%     figure;
%     xlim(limX);
%     ylim(limY);
%     hold on;
%     scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
%     scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
%     
%     svm12(Xtrain, Ytrain, limX, limY,0.1,'magenta','--');
%     svm12(Xtrain, Ytrain, limX, limY,1,'yellow','-.');
%     svm12(Xtrain, Ytrain, limX, limY,10,'blue',":");
%     hold off;
    
    figure;
    xlim(limX);    ylim(limY);
    hold on;
    scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
    scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
    svm12(Xtrain, Ytrain, limX, limY,0.1,'magenta','--');
    hold off;
    
    figure;
    xlim(limX);    ylim(limY);
    hold on;
    scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
    scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
    svm12(Xtrain, Ytrain, limX, limY,1,'yellow','-.');
    hold off;
    
    figure;
    xlim(limX);    ylim(limY);
    hold on;
    scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
    scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
    svm12(Xtrain, Ytrain, limX, limY,10,'blue',":");
    hold off;
end

function [] = svmClassifier3(X1, X2,N1,N,limX,limY)
    Xtrain = [X1(1:N1,:); X2(1:N1,:)];
    Ytrain = [ones(N1,1); 2*ones(N1,1)];
    mdl = fitcsvm(Xtrain,Ytrain);
    Xtest = [X1(N1+1:N,:); X2(N1+1:N,:)];
    Ytest = predict(mdl, Xtest);
    
%     figure;
%     xlim(limX);
%     ylim(limY);
%     hold on;
%     scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
%     scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
%     
%     svm14(Xtrain, Ytrain, limX, limY,0.1,'magenta','--');
%     svm14(Xtrain, Ytrain, limX, limY,1,'yellow','-.');
%     svm14(Xtrain, Ytrain, limX, limY,10,'blue',":");
%     hold off;
    
    figure;
    xlim(limX);    ylim(limY);
    hold on;
    scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
    scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
    svm14(Xtrain, Ytrain, limX, limY,0.1,'magenta','--');
    hold off;
    
    figure;
    xlim(limX);    ylim(limY);
    hold on;
    scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
    scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
    svm14(Xtrain, Ytrain, limX, limY,1,'yellow','-.');
    hold off;
    
    figure;
    xlim(limX);    ylim(limY);
    hold on;
    scatter(X1(:,1), X1(:,2), 10, 'red',"filled");
    scatter(X2(:,1), X2(:,2), 10, 'green',"filled");
    svm14(Xtrain, Ytrain, limX, limY,10,'blue',":");
    hold off;
end