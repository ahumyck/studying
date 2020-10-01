function [M,B] = estimation(matrix)
% estimation Summary of this function goes here
%   Detailed explanation goes here

[N1, N2] = size(matrix);
M = zeros(1, N1);

for i = 1:N1
    M(i) = mean(matrix(i, :));
end

B = zeros(N1, N2);

for i = 1:N1
    for j = 1:N2       
        Ei = matrix(i, :) - M(i);
        Ej = (matrix(j, :) - M(j))';
        B(i, j) = mean(Ei * Ej);
        
    end
end

end

