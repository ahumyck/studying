function [array] = bin_vectors(letter, N)
%BIN_VECTORS Summary of this function goes here
%   Detailed explanation goes here
    array = zeros(N, length(letter));
    for i=1:N
        for j=1:length(letter)
            array(i, j) = floor(rand/letter(j));
            %array(i,j) = (rand-Letter(j))>0;
        end
    end
end

