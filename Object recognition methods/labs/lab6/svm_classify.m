function [] = svm_classify(data1, data2, type, NumberOfPoints)

data3 = [data1; data2];
theclass = ones(2*NumberOfPoints, 1);
theclass(101:end) = -1;
%обучалка
cl = fitcsvm(data3, theclass, 'KernelFunction', type);
d = 0.02;
%создаем матрицу
[x1Grid, x2Grid] = meshgrid(min(data3(:, 1)):d:max(data3(:, 1)),min(data3(:,2)):d:max(data3(:,2)));
xGrid = [x1Grid(:), x2Grid(:)];
%Прогнозирование меток с помощью дерева классификации
[~, scores] = predict(cl, xGrid);

figure;
h(1:2) = gscatter(data3(:, 1),data3(:, 2), theclass, 'br','.');
hold on
h(3) = plot(data3(cl.IsSupportVector, 1), data3(cl.IsSupportVector, 2), 'ko');
title(strcat('SVM classificator ',type));
contour(x1Grid, x2Grid, reshape(scores(:, 2), size(x1Grid)), [0 0], 'k');
legend(h,{'-1', '+1', 'Support Vectors'});

end