function [w] = weightCalculator(weightMatrix, window)
%weightCalculator Summary of this function goes here
%   Detailed explanation goes here
[a, b] = size(weightMatrix);
linearSize = a * b;
center = ceil(linearSize / 2);

w = sum(weightMatrix(window ~= window(center)));
end

