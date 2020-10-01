clear;
clc;

binaryImageName = "lena_embed.tif";
Cw = imread(binaryImageName) / 255;

windowSize = 5;
s = 4270; %secret
indecies = indexSequenceGenerator(Cw, windowSize, s);

bits = Cw(indecies);
disp(bin2string(bits));