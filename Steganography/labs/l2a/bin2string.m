function [string] = bin2string(binary)
%BIN2STRING Summary of this function goes here
%   Detailed explanation goes here
step1 = char(reshape(binary + '0', [], 7));
step2 = bin2dec(step1);
step3 = char(step2);
string = reshape(step3, 1, []);
end

