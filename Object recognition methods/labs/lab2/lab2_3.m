clc;
clear;

M1 = [0;0];
M2 = [-1;-1];
M3 = [1;1];

B1 = [0.0100    0.0200;0.0200    0.1300];
B2 = [0.0400    0.0600;0.0600    0.1000];
B3 = [0.0900    0.0300;0.0300    0.0500];
N = 79600;
n = 2;

X1 = gennormvec(M1,B1,n,N);
X2 = gennormvec(M2,B2,n,N);
X3 = gennormvec(M3,B3,n,N);

syms y0 y1;
d12(y0, y1) = [y0 y1]*((B2)^(-1) - (B1)^(-1))* [y0;y1] + 2* (M1.' * B1^(-1) - M2.' * B2^(-1))* [y0; y1] + log (det(B1)/det(B2))- M1.'*B1^(-1)*M1 + M2.'*B2^(-1)*M2;
d13(y0, y1) = [y0 y1]*((B3)^(-1) - (B1)^(-1))* [y0;y1] + 2* (M1.' * B1^(-1) - M3.' * B3^(-1))* [y0; y1] + log (det(B1)/det(B3))- M1.'*B1^(-1)*M1 + M3.'*B3^(-1)*M3; 
d23(y0, y1) = [y0 y1]*((B3)^(-1) - (B2)^(-1))* [y0;y1] + 2* (M2.' * B2^(-1) - M3.' * B3^(-1))* [y0; y1] + log (det(B2)/det(B3))- M2.'*B2^(-1)*M2 + M3.'*B3^(-1)*M3; 

figure
hold on
scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');
scatter(X2(1, :),X2(2, :), 5, 'blue', 'fill');
scatter(X3(1, :),X3(2, :), 5, 'green', 'fill');
xlim([-5 5])
ylim([-5 5])
g12 = ezplot(d12);
g13 = ezplot(d13);
g23 = ezplot(d23);
set(g12, 'LineColor', 'g');
set(g13, 'LineColor', 'b');
set(g23, 'LineColor', 'r');
title('B1 != B2 != B3');
hold on
xlim([-5 5])
ylim([-5 5])
hold off

%%%%%ќценка веро€тностей
p1est = 0;
for i=1:N
   p1est = p1est + 1 - heaviside(d12(X1(1,i), X1(2,i))); 
end
p1est = p1est / N;
fprintf('Ёкспериментальна€ веро€тность ошибки дл€ первого класса =  %.4f \n',p1est);

p2est = 0;
for i=1:N
   p2est = p2est + heaviside(d12(X2(1,i), X2(2,i))); 
end
p2est = p2est / N;
fprintf('Ёкспериментальна€ веро€тность ошибки дл€ второго класса =  %.4f \n',p2est);

%%%%погрешность
pogr1=sqrt((1-p1est)/(N*p1est));
fprintf('погрешность 1 =  %.4f \n',double(pogr1));
pogr2=sqrt((1-p2est)/(N*p2est));
fprintf('погрешность 2 =  %.4f \n',double(pogr2));

%%%%“еоретический размер выборки
eps = 0.05;
Neps = (1-p2est)/(p2est*eps^2);  
Neps = round(Neps);
disp('ќбъем выборки при погрешности не более 0,05 ')
disp(Neps);