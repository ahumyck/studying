clear;
clc;

binaryImageName = "lena_bin.tif";
dataFilename = "data.txt";

C = imread(binaryImageName);
Cw = imread(binaryImageName) / 255;

bits = file2bin(dataFilename);
[~, s] = size(bits);
disp(s);

windowSize = 5;
w = weightMatrixGenerator(windowSize);

indecies = indexSequenceGenerator(C, windowSize, s); %s = 140


for i = 1:s
    index = indecies(i);
    bit = bits(i);
    Cw(index) = bit;
    toggleIndex = getToggleIndex(index, Cw, w, bit);
    if toggleIndex ~= -1
        Cw(toggleIndex) = not(Cw(toggleIndex));
    end
    
end

img = 255 * Cw;

imwrite(img, 'lena_embed.tif');

subplot(1, 2, 1); imshow(C); impixelinfo; title('Original image');
subplot(1, 2, 2); imshow(img); impixelinfo; title('Image');