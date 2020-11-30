fileData = load('data_2-x1.mat');
X1 = fileData.X1;
fileData = load('data_2-x2.mat');
X2 = fileData.X2;
fileData = load('data_2-x3.mat');
X3 = fileData.X3;
fileData = load('data_2-x1tr.mat');
X1tr = fileData.X1;
fileData = load('data_2-x2tr.mat');
X2tr = fileData.X2;
fileData = load('data_2-x3tr.mat');
X3tr = fileData.X3;

showData(X1,X2,X3,X1tr,X2tr,X3tr);
parzenClassify(X1tr,X2tr,X3tr,X1,X2,X3);

function parzenClassify(X1,X2,X3,X1tr,X2tr,X3tr)
A6=[0.25 0; 0.7 0.5];
A7=[0.2 0; 0.7 0.45];
A8=[0.25 0; 0.2 0.85];
B1=A6*A6';
B2=A7*A7';
B3=A8*A8';
n = 2;
Xred = [];
Xgreen = [];
Xblue = [];
Yred = [];
Ygreen = [];
Yblue = [];
r1 = 0;
r2 = 0;
r3 = 0;
for i = 1:size(X1,2)
    res1 = parzenDensity(B1, X1tr, X1(:,i));
    res2 = parzenDensity(B2, X2tr, X1(:,i));
    res3 = parzenDensity(B3, X3tr, X1(:,i));
    if(res1>=res2)&&(res1>=res3)
        Xred = [Xred, X1(1,i)];
        Yred = [Yred, X1(2,i)];
    elseif (res2>=res1)&&(res2>=res3)
        Xblue = [Xblue, X1(1,i)];
        Yblue = [Yblue, X1(2,i)];
        r1 = r1 + 1;
    else
        Xgreen = [Xgreen, X1(1,i)];
        Ygreen = [Ygreen, X1(2,i)];
        r1 = r1 + 1;
    end
end
for i = 1:size(X2,2)
    res1 = parzenDensity(B1, X1tr, X2(:,i));
    res2 = parzenDensity(B2, X2tr, X2(:,i));
    res3 = parzenDensity(B3, X3tr, X2(:,i));
    if(res1>=res2)&&(res1>=res3)
        Xred = [Xred, X2(1,i)];
        Yred = [Yred, X2(2,i)];
        r2 = r2 + 1;
    elseif (res2>=res1)&&(res2>=res3)
        Xblue = [Xblue, X2(1,i)];
        Yblue = [Yblue, X2(2,i)];
    else
        Xgreen = [Xgreen, X2(1,i)];
        Ygreen = [Ygreen, X2(2,i)];
        r2 = r2 + 1;
    end
end
for i = 1:size(X3,2)
    res1 = parzenDensity(B1, X1tr, X3(:,i));
    res2 = parzenDensity(B2, X2tr, X3(:,i));
    res3 = parzenDensity(B3, X3tr, X3(:,i));
    if(res1>=res2)&&(res1>=res3)
        Xred = [Xred, X3(1,i)];
        Yred = [Yred, X3(2,i)];
        r3 = r3 + 1;
    elseif (res2>=res1)&&(res2>=res3)
        Xblue = [Xblue, X3(1,i)];
        Yblue = [Yblue, X3(2,i)];        
        r3 = r3 + 1;
    else
        Xgreen = [Xgreen, X3(1,i)];
        Ygreen = [Ygreen, X3(2,i)];
    end
end

figure
title ('Классификатор Парзена');
hold on;
scatter(Xred(:),Yred(:), 5, 'red', 'fill');
hold on;
scatter(Xblue(:),Yblue(:), 5, 'blue', 'fill');
hold on;
scatter(Xgreen(:),Ygreen(:), 5, 'green', 'fill');
hold on;
r = r1+r2+r3;
end


function res = parzenDensity(B,X,x)
res = 0;
n = 2;
N = size(X,2);
k = 0.25;
h = N^(-k/n);
B = (1 + h^2)*B;
for i = 1:N
    l=(x-X(:, i))'*inv(B)*(x-X(:, i));
    res = res + 1/((2*pi)^(n/2)*sqrt(det(B)*h^(2*n)))*exp(-l/(2*h^2));
end
res = res/N;

end

function showData(X1,X2,X3,X1tr,X2tr,X3tr)
    figure
    title ('Обучающая выборка');
    hold on;
    scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');
    hold on;
    scatter(X2(1, :),X2(2, :), 5, 'blue', 'fill');
    hold on;
    scatter(X3(1, :),X3(2, :), 5, 'green', 'fill');
    hold on;

    figure
    title ('Тренировочная выборка');
    hold on;
    scatter(X1tr(1, :),X1tr(2, :), 5, 'red', 'fill');
    hold on;
    scatter(X2tr(1, :),X2tr(2, :), 5, 'blue', 'fill');
    hold on;
    scatter(X3tr(1, :),X3tr(2, :), 5, 'green', 'fill');
    hold on;
end