function [binary] = file2bin(filename)
%FILE2BIN Summary of this function goes here
%   Detailed explanation goes here
step1 = fileread(filename);
step2 = dec2bin(step1);
step3 = reshape(step2, 1, []);
binary = step3 - '0';
end

