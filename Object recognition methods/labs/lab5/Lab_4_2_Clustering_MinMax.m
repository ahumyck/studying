close all;
clear;
clc;
K = 5;% number of clusters

M1 = [ 0; 0];
M2 = [-1; 1];
M3 = [-1;-1];
M4 = [ 1;-1];
M5 = [ 1; 1];

R1=[0.1 0.0;0.0 0.075];
R2=[0.1 0.0;0.0 0.1];
R3=[0.05 0.0;0.1 0.05];
R4=[0.1 0.05;0.0 0.075];
R5=[0.05 0;0.05 0.05];

n = 2;
N = 50;

if K==3 
    X = cat(2, gennormvec(M1, R1, n,N), gennormvec(M2, R2, n,N), gennormvec(M3, R3, n,N));
elseif K==5
    X = cat(2, gennormvec(M1, R1, n,N), gennormvec(M2, R2, n,N), gennormvec(M3, R3, n,N), gennormvec(M4, R4, n,N), gennormvec(M5, R5, n,N));
elseif K==2
    X = cat(2, gennormvec(M1, R1, n,N), gennormvec(M2, R2, n,N));
end
X=X';

clusters_num = K;
X_initial = X;
[m, n] = size(X);
disp(size(X));
MX = mean(X, 1);
distToCent = zeros(m, clusters_num);
idx = zeros(m, 1);
centroids = zeros(clusters_num, 2);
grMax=zeros(K-2,2);
grTyp=zeros(K-2,2);

%Step 1 M0
L = 1;
for i=1:m
    distToCent(i, L) = sqrt(sum((MX - X(i,:)).^2));
end
[~, maxIndex] = max(distToCent(:, 1));
centroids(L, :) = X(maxIndex,:);

%Step 2 M1
L = L + 1;
for i=1:m
    distToCent(i, L) = sqrt(sum((centroids(1,:) - X(i,:)).^2));
end
[maxValue, maxIndex] = max(distToCent(:, L));
centroids(L,:) = X(maxIndex,:);


while 1==1%L<clusters_num
    %Step 3 Pererachet
    min_d = zeros(m, 1);
    for i=1:m % for each feature vector
        for k=1:L % for each centroid
            distToCent(i, k) = sqrt(sum((centroids(k,:) - X(i, :)).^2));
        end
        [minValue, minIndex] = min(distToCent(i, 1:L)); %min distance for each feature vector
        min_d(i) = minValue;
    end
    [max_d, maxIndex] = max(min_d);

    centroid_dist = zeros(L, 1);
    for k=1:L % for each centroid
        centroid_dist(k) = sqrt(sum((centroids(k,:) - X(maxIndex, :)).^2)); %м X(maxIndex, :) - potential centroid
    end
    [minCentroidDist, minCentroidDistIndex] = min(centroid_dist);

    %typicalDist
    centroidsDist=zeros(L, L);
    for i=1:L
       for j=i+1:L
           centroidsDist(i,j)=sqrt( sum((centroids(i,:) - centroids(j,:)).^2));
       end
    end
    centroidsDist=centroidsDist(:);
    typSum=sum(centroidsDist);
    colvo=length(find(centroidsDist));
    typicalDist=typSum/colvo*0.579;
    
    if(minCentroidDist > typicalDist)
        L = L + 1;
        centroids(L, :) = X(maxIndex, :);
    else
        break;
    end          
    grMax(L-2,:)=[max_d,L];
    grTyp(L-2,:)=[typicalDist,L];
end

for i=1:m % for each feature vector
     for k=1:L % for each centroid
         distFromXToCent(i, k) = sqrt(sum((centroids(k,:) - X(i, :)).^2));
     end
     [blizhValue, blizhIndex] = min(distFromXToCent(i, :)); %min distance for each feature vector
     idx(i,1)=blizhIndex;
end


X1=X(idx(:)==1,:);
X2=X(idx(:)==2,:);
if K>2
    X3=X(idx(:)==3,:);
    if K==5
        X4=X(idx(:)==4,:);
        X5=X(idx(:)==5,:);
    end
end
figure;
hold on;
scatter(X1(:, 1),X1(:, 2), 7, 'red', 'fill');
scatter(X2(:, 1),X2(:, 2), 7, 'blue', 'fill');
if K>2
    scatter(X3(:, 1),X3(:, 2), 7, 'green', 'fill');
    if K==5
        scatter(X4(:, 1),X4(:, 2), 7, 'y', 'fill');
        scatter(X5(:, 1),X5(:, 2), 7, 'black', 'fill');
    end
end
scatter(centroids(:, 1),centroids(:, 2), 25, 'm', 'o');
xlim([-3 3]);
ylim([-3 3]);
hold off;

figure;
hold on;
plot(grMax(:,2),grMax(:,1));
plot(grTyp(:,2),grTyp(:,1));
legend('«ависимость макс из мин от числа кластеров','«ависимость типичного рассто€ни€ от числа кластеров');
hold off;
