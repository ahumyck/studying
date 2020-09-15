function [centroids, idx] = runkMeans(X, initial_centroids, max_iters)

%k-Means algorithm
[m n] = size(X); % n - dimension of features (2 in this case)
K = size(initial_centroids, 1);
centroids = initial_centroids;
idx = zeros(m, 1);

for i=1:max_iters
    
    %Step 1
    idx = findClosestCentroids(X, centroids);
    
    %Step 2
    centroids = computeCentroids(X, idx, K);
end


end

