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

%Bayesovskaya discriminantnaya function
d = 0.5*(M2+M1)'*(inv(B1))*(M2-M1);
v = (M2-M1)'*(inv(B1));

syms x y
d12(x, y) = v(1)*x + v(2)*y - d;
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
%Veroyatnost Bayesovskoy classifikatsii
lambda = 0;

%formulas on p.19
t = (0.5*p + lambda)/sqrt(p);
p1 = 1 - (1 + erf(t/sqrt(2)))/2;
t = (-0.5*p + lambda)/sqrt(p);
p2 = (1 + erf(t/sqrt(2)))/2;
pp = (p1 + p2)/2;

fprintf("Veroyatnost oshibki 1 roda = %d \n ",p1);
fprintf("Veroyatnost oshibki 2 roda = %d \n",p2);
fprintf("Summarnaya veroyatnost oshibki = %d \n",pp);

