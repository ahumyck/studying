clear;
clc;

%125 - key
rng(125);

binaryImageName = "lena_bin.tif";

C = imread(binaryImageName) / 255;
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
        coordinate = coordinates(i);
        bit = bits(i);
        Cw(coordinate) = bit;
        if C(coordinate) ~= bit
            toggleIndex = getToggleIndex(coordinate, C, w, bit);
            if toggleIndex ~= -1
                Cw(toggleIndex) = not(Cw(toggleIndex));
            end
        end

    end

    img = 255 * Cw;

    imwrite(img, 'lena_embed.tif');

    figure(1);
    subplot(1, 2, 1); imshow(255 * C); impixelinfo; title('Original image');
    subplot(1, 2, 2); imshow(img); impixelinfo; title('Image');

    
%     for i = 1:s
%         coordinate = coordinates(i);
%         bit = bits(i);
%         Cw(coordinate) = bit;
%         [x0, y0] = ind2sub(imageSize, coordinate);
%         fprintf("[x0, y0] = %d %d\n", x0, y0);
%         if C(coordinate) ~= bit
%             tg = getToggleIndex(coordinate, C, w, bit);
%             [xt, yt] = ind2sub(imageSize, tg);
%             fprintf("[xt, yt] = %d %d\n", xt, yt);
%         end
%         fprintf("\n");
%         Cc = 255 * C(x0 - r: x0 + r, y0 - r: y0 + r);
%         Ccw = img(x0 - r: x0 + r, y0 - r: y0 + r);
%         diff = (Cc - Ccw) + (Ccw - Cc);
%         figure;
%         subplot(1, 3, 1); imshow(Cc); impixelinfo; title('Original image');
%         subplot(1, 3, 2); imshow(Ccw); impixelinfo; title('Image');
%         subplot(1, 3, 3); imshow(diff); impixelinfo; title('diff');
%         pause;
%     end
    
    tg = getToggleIndex(coordinates(3), C, w, bits(3));
    [x0, y0] = ind2sub(imageSize, coordinates(3));
    fprintf("%d %d\n", x0, y0);
    [x0, y0] = ind2sub(imageSize, tg);
    fprintf("%d %d\n", x0, y0);
    r = 12;
    Cc = 255 * C(x0 - r: x0 + r, y0 - r: y0 + r);
    Ccw = img(x0 - r: x0 + r, y0 - r: y0 + r);
    figure(2);
    subplot(1, 3, 1); imshow(Cc); impixelinfo; title('Original image');
    subplot(1, 3, 2); imshow(Ccw); impixelinfo; title('Image');
    diff = (Cc - Ccw) + (Ccw - Cc);
    disp(size(find(diff == 255)));
    subplot(1, 3, 3); imshow(diff); impixelinfo; title('diff');
    
    
    
    
end