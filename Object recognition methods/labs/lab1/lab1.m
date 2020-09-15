%Initialization
M1 = [0; 0];
R1 = [0.1 0; 0 0.1];

A1 = zeros(2, 2);
A1(1, 1) = sqrt(R1(1, 1));
A1(1, 2) = 0;
A1(2, 1) = R1(1, 2) / sqrt(R1(1, 1));
A1(2, 2) = sqrt(R1(2, 2) - R1(1, 2)^2/R1(1, 1));

%Simulation
n = 2;
N = 200;
y1 = zeros(n, N);
X1 = zeros(n, N);

for l=1:n
    for i=1:N
        for j=1:12
            y1(l, i) = y1(l, i) + (rand() - 0.5);
        end
    end
end

for k=1:n
    for i=1:N
        Sum = 0;
        for l=1:2
            Sum = Sum + A1(k, l) * y1(l, i);
        end
        X1(k, i) = Sum + M1(k);
    end
end

%Draw X1 data
figure
scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');
xlim([-1 1])
ylim([-1 1])

%Save X1 data to file
save('data_1.mat', 'X1');

%X11 = load('data_1.mat');
