clear;
clc;

feature('DefaultCharacterSet', 'UTF8');

binaryImageName = "lena_bin.tif";
dataFilename = "data.txt";

C = imread(binaryImageName);
Cw = imread(binaryImageName) / 255;

bits = file2bin(dataFilename);
[~, s] = size(bits);
disp(s);

windowSize = 5;
w = weightMatrixGenerator(windowSize);

indecies = indexSequenceGenerator(C, windowSize);
imageSize = size(C);

[~, m] = size(indecies);

for i = 1:s
    index = indecies(i);
    bit = bits(i);
    Cw(index) = bit;
    toggleIndex = getToggleIndex(index, Cw, w, bit);
    [row, col] = ind2sub(imageSize, index); %ind2sub(size(toggleArea), candidatesIndecies)
    fprintf("[%d; %d]\n", row, col);
    [row, col] = ind2sub(imageSize, toggleIndex); %ind2sub(size(toggleArea), candidatesIndecies)
    fprintf("[%d; %d]\n\n", row, col);
    if toggleIndex ~= -1
        Cw(toggleIndex) = not(Cw(toggleIndex));
    end
    
end

img = 255 * Cw;

imwrite(img, 'lena_embed.tif');

subplot(1, 2, 1); imshow(C); impixelinfo; title('Original image');
subplot(1, 2, 2); imshow(img); impixelinfo; title('Image');