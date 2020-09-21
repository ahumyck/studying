clear;
clc;

%binaryImageName = "lena_bin.tif";
%binaryImage = imread(binaryImageName);


windowSize = 5;
matrix = weightMatrixGenerator(windowSize);
disp(matrix);

r = weightCalculator(matrix, matrix);
disp(r);

%subplot(1, 3, 1); imshow(binaryImage); impixelinfo; title('Контейнер');
%subplot(1, 3, 2); imshow(encryptedInformation); impixelinfo; title('Зашифрованный контейнер');
%subplot(1, 3, 3); imshow(decryptedInformation); impixelinfo; title('NOT XOR');