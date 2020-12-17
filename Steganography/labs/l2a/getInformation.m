clear;
clc;

rng(125);

binaryImageName = "lena_embed.tif";
Cw = imread(binaryImageName) / 255;

windowSize = 5;
indecies = indexSequenceGenerator(Cw, windowSize);
indecies = indecies(randperm(numel(indecies)));
[~, s] = size(indecies);
r = indecies(1: s - rem(s, 7));

bits = Cw(r);
disp(bin2string(bits));