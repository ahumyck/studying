function [weightMatrix] = weightMatrixGenerator(n)
%WEIGTHMATRIXGENERATOR Summary of this function goes here
%   Detailed explanation goes here

weightMatrix = zeros(n);
offset = ceil(n / 2);


for i = 1:n
    i_offset = i - offset;
    for j = 1:n
        j_offset = j - offset;
        if i_offset == 0 && j_offset == 0
            weightMatrix(i, j) = 0;
        else
            weightMatrix(i, j) = 1 / sqrt(power(i_offset, 2) + power(j_offset, 2));
        end
    end
end



end

