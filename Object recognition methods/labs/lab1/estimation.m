function [M,B] = estimation(X)
% estimation Summary of this function goes here
%   Detailed explanation goes here

[n, N] = size(X);
M = zeros(n, 1);

for i = 1:n
    M(i) = sum(X(i, :)) / N;
end

B = zeros(n, n);

for i = 1:n
    for j = 1:n
        B(i, j) = (X(i, :) * (X(j, :)')) / N - M(i) * (M(j)');        
    end
end

end

