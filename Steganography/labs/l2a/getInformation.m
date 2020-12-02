clear;
clc;

feature('DefaultCharacterSet', 'UTF8');

binaryImageName = "lena_embed.tif";
Cw = imread(binaryImageName) / 255;

windowSize = 5;
indecies = indexSequenceGenerator(Cw, windowSize);
[~, s] = size(indecies);
disp(s);
s = s - rem(s, 7);
r = indecies(1: 84);
w = indecies(1: 84 + 7);

bits = Cw(r);
r_bit = Cw;
test(bits);
test(Cw(w));

fprintf("\n");
disp(bin2string(bits));