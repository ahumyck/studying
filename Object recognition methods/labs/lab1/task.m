clc;
clear;

n = 2;
N = 200;

%params for normal distributions
M1 = [0;0];
M2 = [1;-1];
M3 = [1;1];

B1 = [0.0100    0.0200;0.0200    0.1300];
B2 = [0.0400    0.0600;0.0600    0.1000];
B3 = [0.0900    0.0300;0.0300    0.0500];

%---

X1 = gennormvec(M1, B1, n, N);
X2 = gennormvec(M2, B2, n, N);
X3 = gennormvec(M3, B3, n, N);

tiledlayout(2, 2);

ax1 = nexttile;
scatter(ax1, X1(1, :),X1(2, :), 5, 'red', 'fill');

xlim([-2 2])
ylim([-2 2])

ax2 = nexttile;
scatter(ax2, X2(1, :),X2(2, :), 5, 'blue', 'fill');

xlim([-2 2])
ylim([-2 2])

ax3 = nexttile;
scatter(ax3, X3(1, :),X3(2, :), 5, 'green', 'fill');

xlim([-2 2])
ylim([-2 2])

%Save X1 data to file
save('X1.mat', 'X1');
save('X2.mat', 'X2');
save('X3.mat', 'X3');

[M1o, B1o] = estimation(X1);
[M2o, B2o] = estimation(X2);
[M3o, B3o] = estimation(X3);

custom_disp(M1, M1o, B1, B1o, 1);
custom_disp(M2, M2o, B2, B2o, 2);
custom_disp(M3, M3o, B3, B3o, 3);

fprintf("bha12 = %f\n", bha(M1, B1, M2, B2));
fprintf("bha13 = %f\n", bha(M1, B1, M3, B3));
fprintf("bha23 = %f\n", bha(M2, B2, M3, B3)); 
fprintf("mah with B(%d)and M(%d, %d) = %f\n", 1, 1, 2, mah(M1, M2, B1));

