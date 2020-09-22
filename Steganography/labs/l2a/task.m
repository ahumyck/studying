clear;
clc;

binaryImageName = "lena_bin.tif";
C = imread(binaryImageName);
Cw = imread(binaryImageName) / 255;


windowSize = 5;
w = weightMatrixGenerator(windowSize);
indecies = indexSequenceGenerator(C, windowSize);
[~, s] = size(indecies);
bit = 1;


for k = 1:s
    index = indecies(k);
    toggleIndex = getToggleIndex(index, Cw, w, bit);
    Cw(index) = bit;
    if toggleIndex ~= -1
        Cw(toggleIndex) = not(Cw(toggleIndex));
    end
end


subplot(1, 2, 1); imshow(C); impixelinfo; title('Only eng');
subplot(1, 2, 2); imshow(255 * Cw); impixelinfo; title('Only eng');
%subplot(1, 3, 3); imshow(decryptedInformation); impixelinfo; title('NOT XOR');