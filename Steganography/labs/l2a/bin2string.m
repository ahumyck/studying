function [string] = bin2string(binary)
%BIN2STRING Summary of this function goes here
%   Detailed explanation goes here
[~, L] = size(binary);
m = 7;
n = L / m;

step1 = zeros(n, m);
cnt = 1;
for i = 1:n
    for j = 1:m
        step1(i, j) = binary(cnt);
        cnt = cnt + 1;
    end
end


step1 = char(step1 + '0');
step2 = bin2dec(step1);
step3 = char(step2);
string = reshape(step3, 1, []);
end

