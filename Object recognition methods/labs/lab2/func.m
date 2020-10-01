function [f] = func(X, M, B)
%F Summary of this function goes here
%   Detailed explanation goes here

e = -0.5 * (X - M)' / B * (X - M);
k = 2 * 3.14 * sqrt(det(B));
f = exp(e) / k;
end

