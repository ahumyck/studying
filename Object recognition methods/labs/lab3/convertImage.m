function [array] = convertImage(letter, p)
%CONVERT Summary of this function goes here
%   Detailed explanation goes here
    C = double(letter);
    C(C > 0) = p;
    C(C == 0) = 1 - p;
    array = reshape(C, 1, []);
end

