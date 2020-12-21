clear;
clc;

%125 - key
rng(125);

binaryImageName = "lena_bin.tif";

C = imread(binaryImageName);
Cw = imread(binaryImageName) / 255;

bits = file2bin("data.txt");
[~, s] = size(bits);

windowSize = 5;
w = weightMatrixGenerator(windowSize);

coordinates = coordinatesGenerator(C, windowSize);
coordinates = coordinates(randperm(numel(coordinates)));
imageSize = size(C);
r = floor(windowSize / 2); %radius of window

if validation(coordinates(1: s), imageSize, r)
    fprintf("validation suc\n");
    
    [~, m] = size(coordinates);

    for i = 1:s
        index = coordinates(i);
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
end
fprintf("valid fail");