function [output] = discriminant(X, PX)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
s1 = 0; s2 = 0;
    for i = 1:size(PX, 2)
        s1 = s1 + log (1 - PX(i));
        s2 = s2 + X(i)*log (PX(i)/(1 - PX(i))); 
    end
    output = log (1/2) + s1 + s2;
end

