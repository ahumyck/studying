clc;
clear;

n = 2;
N = 200;

M1 = [0; 0];
B1 = [0.1 0; 0 0.1];

M2 = [-0.5; 0.5];
B2 = [0.2 0; 0 0.2];

M3 = [0; 0];
B3 = [0.1 0.1; 0.1 0.1];

A1 = recurrentMatrix(B1);
A2 = recurrentMatrix(B2);
A3 = recurrentMatrix(B3);
y = zeros(n, N);


for i = 1:n
    for j = 1:N
        for k = 1:12
            y(i, j) = y(i, j) + (rand() - 0.5);
        end
    end
end

X1 = A1 * y + M1;
X2 = A2 * y + M2;
X3 = A3 * y + M3;

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
save('data_1.mat', 'X1');
save('data_2.mat', 'X2');
save('data_2.mat', 'X3');

%X11 = load('data_1.mat');



