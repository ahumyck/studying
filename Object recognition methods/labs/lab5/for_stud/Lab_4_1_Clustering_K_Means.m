m = 300;
N=1000;
K = 3;           % number of clusters
max_iters = 10;

%generate 2D features
mu1 = [2, 3];
sigma1 = [1, 0; 0, 3];
r1 = mvnrnd(mu1,sigma1,N/2);

mu2 = [-2, 5];
sigma2 = [3, 0; 0, 4];
r2 = mvnrnd(mu2,sigma2,N/2);

X = [r1; r2];
initial_centroids = [X(1, :); X(510, :)];
%generate 2D features


%K-MEANS
[centroids, idx] = runkMeans(X, initial_centroids, max_iters);


