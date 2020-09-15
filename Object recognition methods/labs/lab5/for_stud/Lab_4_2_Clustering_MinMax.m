M1 = [2; 2];
R1 = [1 0; 0 1];

M1 = [1; -2];
R1 = [2 0; 0 0.1];

M1 = [-2; 1];
R1 = [0.2 0; 0 0.1];

%Generating features
%%%%%%%.........%%%%%%%%
%Generating features

clusters_num = 3;
X_initial = X;
[m n] = size(X);
MX = mean(X, 1);
dist = zeros(m, clusters_num);
ClassNum = zeros(m, 1);
M = zeros(2, clusters_num);

%Step 1
L = 1;
for i=1:m
    dist(i, L) = sqrt(sum((MX - X(i,:)).^2));
end
[maxValue, maxIndex] = max(dist(:, 1));
ClassNum(maxIndex) = L;
M(:, L) = maxValue;
X = X([1:maxIndex-1, maxIndex+1:end], :);

%Step 2
L = L + 1;
for i=1:m
    dist(i, L) = sqrt(sum((M(:, 1) - X(i,:)).^2));
end
[maxValue, maxIndex] = max(dist(:, L));
ClassNum(maxIndex) = L;
M(:, L) = maxValue;
X = X([1:maxIndex-1, maxIndex+1:end], :);

%Step 3
min_d = zeros(m, 1);
for i=1:m % for each feature vector
    for k=1:L % for each centroid
        dist(i, k) = sqrt(sum((M(:, k) - X(i, :)).^2));
    end
    [minValue, minIndex] = min(dist(i, :)); %min distance for each feature vector
    min_d(i) = minValue;
end
[max_d, maxIndex] = max(min_d);

centroid_dist = zeros(L, 1);
for k=1:L % for each centroid
    centroid_dist(k) = sqrt(sum((M(:, k) - X(maxIndex, :)).^2)); %ì X(maxIndex, :) - potential centroid
end
[minCentroidDist, minCentroidDistIndex] = min(centroid_dist);

%typicalDist
%%%%%%%......%%%%%%%
%typicalDist

if(minCentroidDist > typicalDist)
    L = L + 1;
    M(:, L) = X(maxIndex, :);
end

%Step 4 - to do or not to do?


