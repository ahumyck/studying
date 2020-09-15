function [A] = recurrentMatrix(B)
%NORMALVECTOR Summary of this function goes here
%   Detailed explanation goes here
[rows, cols] = size(B);
A = zeros(rows, cols);


for j = 1:cols
    for i = 1:rows
        if i < j
            summ = 0;
            for k = 1:i
                summ = summ + A(i, k) * A(j, k);
            end
            A(i, j) = (B(j, i) - summ) / A(i, i);
        elseif i == j  
            summ = 0;
            for k = 1:i
                summ = summ + power(A(i, k), 2);
            end
            A(i, i) = sqrt(B(i, i) - summ);
        end
    end
end

end

