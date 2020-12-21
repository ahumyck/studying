clear;
clc;

rng(125);

binaryImageName = "lena_embed.tif";
Cw = imread(binaryImageName) / 255;

windowSize = 5;
coordinates = coordinatesGenerator(Cw, windowSize);
coordinates = coordinates(randperm(numel(coordinates)));
[~, s] = size(coordinates);
coordinates = coordinates(1: s - rem(s, 7));

bits = Cw(coordinates);
disp(bin2string(bits));