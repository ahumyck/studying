close all;
% clear;
NumberOfPoints = 100;
[r1, r2] = generateLinearSeparatedData(NumberOfPoints);
svmclassify(r1, r2, 'linear', NumberOfPoints);
[data1, data2] = generateNotLinearSeparatedData(NumberOfPoints);
svmclassify(data1, data2, 'linear', NumberOfPoints);
svmclassify(data1, data2, 'rbf', NumberOfPoints);

function [r1, r2] = generateLinearSeparatedData(NumberOfPoints)
    mu1 = [0, 0];
    sigma1 = [0.02 0.005; 0.005 0.02];
    r1 = mvnrnd(mu1, sigma1, NumberOfPoints);
    mu2 = [1, 1];
    sigma2 = [0.01,0; 0,0.04];
    r2 = mvnrnd(mu2, sigma2, NumberOfPoints);
end


function [data1, data2] = generateNotLinearSeparatedData(NumberOfPoints)
    mu1 = [-1, -1];
    sigma1 = [0.1, 0.2; 0.2, 1.3];
    data1 = mvnrnd(mu1, sigma1, NumberOfPoints);
    mu2 = [1, 1];
    sigma2 = [0.9, 0.3; 0.3, 0.5];
    data2 = mvnrnd(mu2, sigma2, NumberOfPoints);
end

function svmclassify(data1, data2, type, NumberOfPoints)
    data3 = [data1; data2];
    theclass = ones(2*NumberOfPoints, 1);
    theclass(1:100) = -1;
    cl = fitcsvm(data3, theclass, 'KernelFunction', type);
    d = 0.02;
    [x1Grid, x2Grid] = meshgrid(min(data3(:, 1)):d:max(data3(:, 1)),...
                                min(data3(:,2)):d:max(data3(:,2)));
    xGrid = [x1Grid(:), x2Grid(:)];
    [~, scores] = predict(cl, xGrid);
    figure;
    h(1:2) = gscatter(data3(:, 1),data3(:, 2), theclass, 'br','.');
    hold on
    h(3) = plot(data3(cl.IsSupportVector, 1), data3(cl.IsSupportVector, 2), 'ko');
    title(strcat('SVM classificator ',type));
    contour(x1Grid, x2Grid, reshape(scores(:, 2), size(x1Grid)), [0 0], 'k');
    legend(h,{'-1', '+1', 'Support Vectors'});
end


