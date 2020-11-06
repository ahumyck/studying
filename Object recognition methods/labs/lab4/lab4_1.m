clear;
M1 = [0; 0];
R1 = [0.01 0; 0 0.0625];
M2 = [1; 1];

n = 2;
N = 200;
X1 = gennormvec(M1, R1, n, N);
X2 = gennormvec(M2, R1, n, N);

fprintf("Equal R Matricies\n");
fishera = Fisher (M1, M2, R1, R1, X1, X2);

syms x y;
baes = (M1-M2).'*R1^(-1)*[x; y] - (1/2* (M1-M2).'*R1^(-1)*(M1+M2));
disp(fishera);
disp(baes);

figure;
hold on; 
scatter(X1(1, :), X1(2, :), 5, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 5, 'b', 'fill');
xlim([-3 3])
ylim([-3 3])
d1 = ezplot(fishera, [-3, 3]);
d2 = ezplot(baes, [-3, 3]);
set(d1, 'LineColor', 'g');
set(d2, 'LineColor', 'm');
hold off;

R11 = [0.36 0.48; 0.48 0.68];
R2 = [0.04 0.14; 0.14 0.5];


X1 = gennormvec(M1, R11, n, N);
X2 = gennormvec(M2, R2, n, N);

fprintf("Not equal R Matricies\n");
fishera = Fisher (M1, M2, R11, R2, X1, X2);

syms x y;
baes = [x,y]*((R2)^-1 - (R11)^-1)* [x;y] + 2* (M1.' * R11^(-1) - M2.' * R2^(-1))* [x; y] + log (det(R11)/det(R2))- M1.'*R11^(-1)*M1 + M2.'*R2^(-1)*M2;
disp(fishera);
disp(baes);

figure;
hold on; 
scatter(X1(1, :), X1(2, :), 5, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 5, 'b', 'fill');
xlim([-3 3])
ylim([-3 3])
d1 = ezplot(fishera, [-3, 3]);
d2 = ezplot(baes, [-3, 3]);
set(d2, 'LineColor', 'g');
set(d1, 'LineColor', 'm');
hold off;