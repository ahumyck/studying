clc;
clear;

M1 = [-1;-1];
M2 = [ 1; 1];
B1 = [0.04    0.02;0.02  0.9];
B2 = B1;
N = 200;
n = 2;

X1 = gennormvec(M1, B1, n, N);
X2 = gennormvec(M2, B2, n, N);

%MinMax
d = 0.5*(M2+M1)'*inv(B1)*(M2-M1);
v = (M2-M1)'*inv(B1);

syms y0 y1
d12(y0, y1) = v(1)*y0 + v(2)*y1 - d;

figure
scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');
hold on
scatter(X2(1, :),X2(2, :), 5, 'blue', 'fill');
hold on
ezplot (d12);
title('MinMax');
hold on
xlim([-3 3])
ylim([-3 3])
hold off

%Neiman Pirson
c = 1.645;
p1 = 0.05;
p = mah(M1,M2,B1);

lambda = -0.5*p + sqrt(p)*c;

syms y0 y1
d12NP(y0, y1) = v(1)*y0 + v(2)*y1 - d + lambda;

figure
scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');
hold on
scatter(X2(1, :),X2(2, :), 5, 'blue', 'fill');
hold on;
ezplot(d12NP);
title('Neiman-Pirson');
hold on
xlim([-3 3])
ylim([-3 3])
hold off