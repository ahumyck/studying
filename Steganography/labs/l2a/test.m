function [zero] = test(bits)
%TEST Summary of this function goes here
%   Detailed explanation goes here

[~, l] = size(bits);
for i = 1:l
    fprintf("%d", bits(i));
    if rem(i, 8) == 0
        fprintf(" ");
    end
end
fprintf("\n");

zero = 0;
end

