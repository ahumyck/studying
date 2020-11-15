function centroids = computeCentroids(X, idx, K)
[~, n] = size(X);
centroids = zeros(K, n);
for k=1:K
    Xk = X(idx==k,:);
    S = sum(Xk);
    colv = length(Xk);
    centroids(k,:)=S./colv;
end

