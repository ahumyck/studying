clear;
M1 = [-1; -1];
R1 = [0.01 0; 0 0.0625];
M2 = [1; 1];

n = 2;
N = 200;
X1 = gennormvec(M1, R1, n, N);
X2 = gennormvec(M2, R1, n, N);

syms x y;
baes = (M1-M2).'*R1^(-1)*[x; y] - (1/2* (M1-M2).'*R1^(-1)*(M1+M2));

u = zeros (3, 2*N);
g = zeros (2*N, 1);
for i=1:N
    u(1, i) = X1(1, i);
    u(2, i) = X1(2, i);
    u(3, i) = 1;
    g(i, 1) = 1;
end

for k=(N+1):2*N
    u(1, k) = -X2(1, k-N);
    u(2, k) = -X2(2, k-N);
    u(3, k) = -1;
    g(k, 1) = 1;
end

W = (u*u.')^(-1)*u*g;
sko = SKO(u, g, X1, X2);
disp(sko);
disp(baes);

figure;
hold on; 
scatter(X1(1, :), X1(2, :), 5, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 5, 'b', 'fill');
xlim([-3 3])
ylim([-3 3])
d1 = ezplot(sko, [-3, 3]);
d2 = ezplot(baes, [-3, 3]);
set(d2, 'LineColor', 'g');
set(d1, 'LineColor', 'm');
hold off;

R11 = [0.36 0.48; 0.48 0.68];
R2 = [0.04 0.14; 0.14 0.5];

X1 = gennormvec(M1, R11, n, N);
X2 = gennormvec(M2, R2, n, N);


syms x y;
baes = [x,y]*((R2)^-1 - (R11)^-1)* [x;y] + 2* (M1.' * R11^(-1) - M2.' * R2^(-1))* [x; y] + log (det(R11)/det(R2))- M1.'*R11^(-1)*M1 + M2.'*R2^(-1)*M2;

u= zeros (3, 2*N);
g = zeros (2*N, 1);
for i=1:N
    u(1, i) = X1(1, i);
    u(2, i) = X1(2, i);
    u(3, i) = 1;
    g(i, 1) = 1;
end

for k=(N+1):2*N
    u(1, k) = -X2(1, k-N);
    u(2, k) = -X2(2, k-N);
    u(3, k) = -1;
    g(k, 1) = 1;
end

sko = SKO(u, g, X1, X2);
disp(sko);
disp(baes);

figure;
hold on; 
scatter(X1(1, :), X1(2, :), 5, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 5, 'b', 'fill');
xlim([-3 3])
ylim([-3 3])
d1 = ezplot(sko, [-3, 3]);
d2 = ezplot(baes, [-3, 3]);
set(d2, 'LineColor', 'g');
set(d1, 'LineColor', 'm');
hold off;