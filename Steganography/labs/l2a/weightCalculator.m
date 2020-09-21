function [w] = weightCalculator(weightMatrix, window)
%WEIGHT Summary of this function goes here
%   Detailed explanation goes here
[a, b] = size(weightMatrix);
linearSize = a * b;
center = ceil(linearSize / 2);

v = weightMatrix(window ~= window(center));
w = sum(v);

end

