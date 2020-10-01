clear;
clc;

containerName = "goldhill.tif";
informationName = "mickey.tif";
p = 3;

C = imread(containerName);
W = imread(informationName);

% делим каждый элемент матрицы на 255, чтобы она состояла только из 0 и 1
W = W / 255; 

% достаём биты из p плоски изображения в контейнере
Cp = bitget(C, p); 

% применяем формулу (3.5)
C = not(xor(W, Cp));

% встраиваем зашифрованные биты обратно в контейнер
Cw = bitset(C, p, Cwb); 

% применяем формулу (3.5) чтобы из зашифрованного контейнера получить
% изображение
d = not(bitxor(Cw, C));

subplot(1, 3, 1); imshow(C); impixelinfo; title('C');
subplot(1, 3, 2); imshow(Cw); impixelinfo; title('Cw');
subplot(1, 3, 3); imshow(decryptedInformation); impixelinfo; title('NOT XOR');