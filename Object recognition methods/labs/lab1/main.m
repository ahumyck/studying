%clear all; close all;
%15 вариант
%M1 = [0; 1];
%M2 = [-1; -1];
%M3 = [1; 0];

M1 = [0;0];
M2 = [1;-1];
M3 = [1;1];


B1=[0.0100    0.0200;0.0200    0.1300]
B2=[0.0400    0.0600;0.0600    0.1000]
B3=[0.0900    0.0300;0.0300    0.0500]

%A1 = [0.1 0; 0.2 0.3];
%A2 = [0.4 0; 0.5 0.6];
%A3 = [0.7 0; 0.8 0.9];

%B1 = A1'*A1;
%B2 = A2'*A2;
%B3 = A3'*A3;

n = 2;
N = 200;

%2 point
figure 
hold on
Y1 = gennormvec(M1, B1, n, N);
scatter(Y1(1, :),Y1(2, :), 5, 'red', 'fill');

Y2 = gennormvec(M2, B1, n, N);
scatter(Y2(1, :),Y2(2, :), 5, 'blue', 'fill');
hold off

%3 point
figure 
hold on
X1 = gennormvec(M1, B1, n, N);
scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');

X2 = gennormvec(M2, B2, n, N);
scatter(X2(1, :),X2(2, :), 5, 'green', 'fill');

X3 = gennormvec(M3, B3, n, N);
scatter(X3(1, :),X3(2, :), 5, 'blue', 'fill');
hold off

bha12 = (1/4)*(M2 - M1)'*inv((B2+B1)/2)*(M2 - M1)+(1/2)*log(det((B2+B1)/2)/sqrt(det(B2)*det(B1)));
bha23 = (1/4)*(M3 - M2)'*inv((B3+B2)/2)*(M3 - M2)+(1/2)*log(det((B3+B2)/2)/sqrt(det(B3)*det(B2)));
bha13 = (1/4)*(M3 - M1)'*inv((B3+B1)/2)*(M3 - M1)+(1/2)*log(det((B3+B1)/2)/sqrt(det(B3)*det(B1)));
mah12 = (M2 - M1)'*inv(B1)*(M2 - M1);

mu1 = mean(X1,2);
mu2 = mean(X2,2);
mu3 = mean(X3,2);
sigma1 = var(X1,0,2);
sigma2 = var(X2,0,2);
sigma3 = var(X3,0,2);

disp(B1);
disp(B2);
disp(B3);

disp(mu1);
disp(mu2);
disp(mu3);

disp(sigma1);
disp(sigma2);
disp(sigma3);

disp(bha12);
disp(bha23);
disp(bha13);
disp(mah12);

Sum = [0 0; 0 0];
for i=1:N
     Sum = Sum + X1(:,i) * X1(:,i)';
end
tmp=Sum./N-mu1*mu1';
disp(tmp);

Sum = [0 0; 0 0];
for i=1:N
     Sum = Sum + X2(:,i) * X2(:,i)';
end
tmp=Sum./N-mu2*mu2';
disp(tmp);

Sum = [0 0; 0 0];
for i=1:N
     Sum = Sum + X3(:,i) * X3(:,i)';
end
tmp=Sum./N-mu3*mu3';
disp(tmp);

save('data1.mat', 'X1');
save('data2.mat', 'X2');
save('data3.mat', 'X3');
save('data4.mat', 'Y1');
save('data5.mat', 'Y2');