clc;
clear;

n = 2;
N = 200;

%params for normal distributions
M1 = [ 0;  0];
M2 = [-1;  1];
M3 = [-1; -1];

B1 = [0.0100    0.0200;0.0200    0.1300];
B2 = [0.0400    0.0600;0.0600    0.1000];
B3 = [0.0900    0.0300;0.0300    0.0500];

%---

X1 = gennormvec(M1, B1, n, N);
X2 = gennormvec(M2, B2, n, N);
X3 = gennormvec(M3, B3, n, N);

Y1 = gennormvec(M1, B2, n, N);
Y2 = gennormvec(M3, B2, n, N);

figure 
hold on
scatter(Y1(1, :),Y1(2, :), 5, 'red', 'fill');
scatter(Y2(1, :),Y2(2, :), 5, 'blue', 'fill');
xlim([-2 2])
ylim([-2 2])
hold off

figure 
hold on
scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');
scatter(X2(1, :),X2(2, :), 5, 'green', 'fill');
scatter(X3(1, :),X3(2, :), 5, 'blue', 'fill');
xlim([-2 2])
ylim([-2 2])
hold off

[M1o, B1o] = estimation(X1);
[M2o, B2o] = estimation(X2);
[M3o, B3o] = estimation(X3);

custom_disp(M1, M1o, B1, B1o, 1);
custom_disp(M2, M2o, B2, B2o, 2);
custom_disp(M3, M3o, B3, B3o, 3);

fprintf("bha12 = %f\n", bha(M1, B1, M2, B2));
fprintf("bha13 = %f\n", bha(M1, B1, M3, B3));
fprintf("bha23 = %f\n", bha(M2, B2, M3, B3)); 
fprintf("mah with B(%d) and M(%d, %d) = %f\n", 2, 1, 3, mah(M1, M3, B2));
fprintf("bha with B(%d) and M(%d, %d) = %f\n", 2, 1, 3, bha(M1, B2, M3, B2));

%Save X1 data to file
save('X1.mat', 'X1');
save('X2.mat', 'X2');
save('X3.mat', 'X3');

save('Y1.mat', 'Y1');
save('Y2.mat', 'Y2');

