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


Xred = [];
Xgreen = [];
Xblue = [];
Yred = [];
Ygreen = [];
Yblue = [];
%K=1;
%K=3;
K=5;
r1 = 0;
r2 = 0;
r3 = 0;
for i = 1:size(X1,2)
    res1 = countK(X1, X1tr(:,i), K);
    res2 = countK(X2, X1tr(:,i), K);
    res3 = countK(X3, X1tr(:,i), K);
    k = ceil(K/2);
    if(res1(1,k)<=res2(1,1))&&(res1(1,k)<=res3(1,1))
        Xred = [Xred, X1tr(1,i)];
        Yred = [Yred, X1tr(2,i)];
    elseif (res2(1,k)<=res1(1,1))&&(res2(1,k)<=res3(1,1))
        Xblue = [Xblue, X1tr(1,i)];
        Yblue = [Yblue, X1tr(2,i)];        
        r1 = r1 + 1;
    else
        Xgreen = [Xgreen, X1tr(1,i)];
        Ygreen = [Ygreen, X1tr(2,i)];        
        r1 = r1 + 1;
    end
end
for i = 1:size(X2,2)
    res1 = countK(X1, X2tr(:,i), K);
    res2 = countK(X2, X2tr(:,i), K);
    res3 = countK(X3, X2tr(:,i), K);
    if(res1(1,k)<=res2(1,1))&&(res1(1,k)<=res3(1,1))
        Xred = [Xred, X2tr(1,i)];
        Yred = [Yred, X2tr(2,i)];
        r2 = r2 + 1;
    elseif (res2(1,k)<=res1(1,1))&&(res2(1,k)<=res3(1,1))
        Xblue = [Xblue, X2tr(1,i)];
        Yblue = [Yblue, X2tr(2,i)];
    else
        Xgreen = [Xgreen, X2tr(1,i)];
        Ygreen = [Ygreen, X2tr(2,i)];        
        r2 = r2 + 1;
    end
end
for i = 1:size(X3,2)
    res1 = countK(X1, X3tr(:,i), K);
    res2 = countK(X2, X3tr(:,i), K);
    res3 = countK(X3, X3tr(:,i), K);
    if(res1(1,k)<=res2(1,1))&&(res1(1,k)<=res3(1,1))
        Xred = [Xred, X3tr(1,i)];
        Yred = [Yred, X3tr(2,i)];        
        r3 = r3 + 1;
    elseif (res2(1,k)<=res1(1,1))&&(res2(1,k)<=res3(1,1))
        Xblue = [Xblue, X3tr(1,i)];
        Yblue = [Yblue, X3tr(2,i)];        
        r3 = r3 + 1;
    else
        Xgreen = [Xgreen, X3tr(1,i)];
        Ygreen = [Ygreen, X3tr(2,i)];
    end
end

figure
title ('Классификатор К ближайших соседей');
hold on;
scatter(Xred(:),Yred(:), 5, 'red', 'fill');
hold on;
scatter(Xblue(:),Yblue(:), 5, 'blue', 'fill');
hold on;
scatter(Xgreen(:),Ygreen(:), 5, 'green', 'fill');
hold on;

r = r1+r2+r3;


function res = countK(X, x, K)
    res = 500*ones(1,K);
    for i = 1:size(X,2)
        dest = sqrt((X(1, i)-x(1))^2+(X(2, i)-x(2))^2);
        res = writeToArr(res, dest);
    end
end

function arr = writeToArr(X, x)
    arr = X;
    if(X(1,size(X,2)) > x)
        for i = 1:size(X,2)
            if(X(1,i) > x)
                arr(1, i) = x;
                arr(1, i+1:end) = X(1, i:end-1);
                break;
            end
        end
    end
end