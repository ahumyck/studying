%K-MEANS
close all;
clc;
K = 5;% number of clusters

M1=[  -1.5  ;  -1.5 ];
M2=[  -1.5  ;  1.5 ];
M3=[ 0  ;  0 ];
M4=[  1.5  ;  -1.5 ];
M5=[  1.5  ; 1.5 ];

R1=[0.1 0.0;0.0 0.075];
R2=[0.1 0.0;0.0 0.075];
R3=[0.05 0.0;0.0 0.05];
R4=[0.1 0.0;0.0 0.075];
R5=[0.05 0.0;0.0 0.05];

n = 2;
N = 200;

if K==3 
    X = cat(2, gennormvec(M1, R1, n,N), gennormvec(M2, R2, n,N), gennormvec(M3, R3, n,N));
    X = X';
    initial_centroids = [X(1,:); X(2,:); X(3,:)];
    %initial_centroids = [X(1,:); X(201,:);X(401,:)];
elseif K==5
    X = cat(2, gennormvec(M1, R1, n,N), gennormvec(M2, R2, n,N), gennormvec(M3, R3, n,N), gennormvec(M4, R4, n,N), gennormvec(M5, R5, n,N));
    X = X';
    %initial_centroids = [X(1,:);X(2,:);X(3,:);X(4,:);X(5,:)];
    initial_centroids = [X(25,:);X(225,:);X(425,:);X(625,:);X(825,:)];
elseif K==2
    X = cat(2, gennormvec(M1, R1, n,N), gennormvec(M2, R2, n,N));
    X = X';
    %initial_centroids = [X(1,:);X(2,:)];  
    initial_centroids = [X(1,:);X(201,:)]; 
end

[centroids, idx,graf] = runkMeans(X, initial_centroids);

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
xlim([-4 4]);
ylim([-4 4]);
hold off;

%graf=graf(2:end,:);
figure;
plot(graf(:,2),graf(:,1));title('Зависимость числа векторов, сменивших номер, от итерации');