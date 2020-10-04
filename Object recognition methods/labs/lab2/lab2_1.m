clc;
clear;

M1 = [-1;-1];
M2 = [ 1; 1];
B1 = [0.0100    0.0200;0.0200    0.1300];
N = 200;
n = 2;

X1 = gennormvec(M1, B1, n, N);
X2 = gennormvec(M2, B1, n, N);

p = mah(M1, M2, B1);

%Байесовская дискриминантная функция
d = 0.5*(M2+M1)'*(inv(B1))*(M2-M1);
v = (M2-M1)'*(inv(B1));

syms y0 y1
d12(y0, y1) = v(1)*y0 + v(2)*y1 - d;

figure
scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');
hold on
scatter(X2(1, :),X2(2, :), 5, 'blue', 'fill');
hold on
ezplot (d12);
hold on
xlim([-3 3])
ylim([-3 3])
hold off

%Вероятность Байесовской классификации
lambda = 0;

%formulas on p.19
t = (0.5*p + lambda)/sqrt(p);
p1 = 1 - (1 + erf(t/sqrt(2)))/2;
t = (-0.5*p + lambda)/sqrt(p);
p2 = (1 + erf(t/sqrt(2)))/2;
pp = (p1 + p2)/2;

fprintf("Вероятность ошибки первого рода = %d \n ",p1);
fprintf("Вероятность ошибки второго рода = %d \n",p2);
fprintf("Суммарная вероятность ошибки = %d \n",pp);

