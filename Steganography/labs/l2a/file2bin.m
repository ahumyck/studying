function [binary] = file2bin(filename)
%PHRASE2BIN Summary of this function goes here
%   Detailed explanation goes here
step1 = dec2bin(fileread(filename));
step2 = step1 - '0';
[n, m] = size(step2);
binary = zeros(n * m);

cnt = 1;
for i = 1:n
    for j = 1:m
        binary(cnt) = step2(i, j);
        cnt = cnt + 1;
    end
end
end

