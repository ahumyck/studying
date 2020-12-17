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
for i = 1:size(X1,2)
    result = K_closest(X1tr, X2tr, X3tr, X1tr(:,i), K);
    if(result == 1)
        Xred = [Xred, X1tr(1,i)];
        Yred = [Yred, X1tr(2,i)];        
    elseif (result == 2)
        Xblue = [Xblue, X1tr(1,i)];
        Yblue = [Yblue, X1tr(2,i)];        
    else
        Xgreen = [Xgreen, X1tr(1,i)];
        Ygreen = [Ygreen, X1tr(2,i)];
    end
end

for i = 1:size(X2,2)
    result = K_closest(X1tr, X2tr, X3tr, X2tr(:,i), K);
    if(result == 1)
        Xred = [Xred, X2tr(1,i)];
        Yred = [Yred, X2tr(2,i)];        
    elseif (result == 2)
        Xblue = [Xblue, X2tr(1,i)];
        Yblue = [Yblue, X2tr(2,i)];        
    else
        Xgreen = [Xgreen, X2tr(1,i)];
        Ygreen = [Ygreen, X2tr(2,i)];
    end
end

for i = 1:size(X3,2)
    result = K_closest(X1tr, X2tr, X3tr, X3tr(:,i), K);
    if result == 1
        Xred = [Xred, X3tr(1,i)];
        Yred = [Yred, X3tr(2,i)];        
    elseif result == 2
        Xblue = [Xblue, X3tr(1,i)];
        Yblue = [Yblue, X3tr(2,i)];        
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


function dist = generate_class_distance(X, x)
    dist = zeros(1, size(X, 2));
    
    for i = 1:size(dist, 2)
        dist(i) = sqrt( (x(1) - X(1, i)) * (x(1) - X(1, i)) + (x(2) - X(2, i)) * (x(2) - X(2, i)) );
    end
    
    
end

function detect_class = K_closest(X1, X2, X3, x, K)
    dist1 = (generate_class_distance(X1, x));    
    dist2 = (generate_class_distance(X2, x));
    dist3 = (generate_class_distance(X3, x));
    
    joined = [dist1, dist2, dist3];
    K_closest = sort(joined);
    K_closest = K_closest(1: K);
    
    k1 = 0;
    k2 = 0;
    k3 = 0;
    
    for k = 1:size(K_closest, 2)
        if ismember(K_closest(k), dist1)
            k1 = k1 + 1;
        end
        if ismember(K_closest(k), dist2)
            k2 = k2 + 1;
        end
        if ismember(K_closest(k), dist3)
            k3 = k3 + 1;
        end
    end  
    [~, detect_class] = max([k1, k2, k3]);
    
end