%http://www.computeroptics.smr.ru/KO/PDF/KO42-1/420115.pdf
clear;
clc;

containerName = "goldhill.tif"; %имя изображения, куда будем встраивать информацию
informationName = "mickey.tif"; %имя изображения, в котором содержится информация
d = 10;
d2 = d * 2;

C = imread(containerName); % загружаем контейнер
W = imread(informationName); %загружаем информацию

% делим каждый элемент матрицы на 255, чтобы она состояла только из 0 и 1
W = W / 255; 

Cw = uint8(floor(double(C) / d2) * d2) + d * W + mod(C, d);

%формулы из статьи
I = uint8(floor(double(Cw) / d2) * d2) + mod(Cw, d);
W1 = abs(Cw - I);

subplot(1, 3, 1); imshow(C); impixelinfo; title('Контейнер');
subplot(1, 3, 2); imshow(Cw); impixelinfo; title('Зашифрованный контейнер');
subplot(1, 3, 3); imshow(255 * W1); impixelinfo; title('Извлеченная информация W1');