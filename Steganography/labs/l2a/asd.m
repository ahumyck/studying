clc;
clear;

s = 'ab';
binary = dec2bin(s);
str = bin2dec(binary);

disp(num2str(str));