function [centroids, idx,graf] = runkMeans(X, initial_centroids)
%k-Means algorithm
[m , ~] = size(X); % n - dimension of features (2 in this case)
K = size(initial_centroids, 1);
centroids = initial_centroids;
idx = zeros(m, 1);
lastCent = initial_centroids;
lastIdx = idx;
out = 0;
graf = zeros(0, 2);
i=1;
    while out==0    
        %Step 1
        idx = findClosestCentroids(X, centroids);  
        %Step 2
        centroids = computeCentroids(X, idx, K);
        if centroids==lastCent
            out=1;
        end

        graf=cat(1,graf,[length(find(idx~=lastIdx)),i]);
        
        lastCent=centroids;
        lastIdx=idx;
        i=i+1;
    end
    disp(i);
end

