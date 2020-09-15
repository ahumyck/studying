%http://www.computeroptics.smr.ru/KO/PDF/KO42-1/420115.pdf
clear;

containerName = "goldhill.tif"; %имя изображения, куда будем встраивать информацию
informationName = "mickey.tif"; %имя изображения, в котором содержится информация
d = 10;
d2 = d * 2;

container = imread(containerName); % загружаем контейнер
information = imread(informationName); %загружаем информацию

% делим каждый элемент матрицы на 255, чтобы она состояла только из 0 и 1
information = information / 255; 

containerAsDouble = double(container); % меняем тип матрицы на double
quantizedContainer = uint8(floor(containerAsDouble / d2) * d2); % квантуем матрицу

% используем формулы (3.10) и (3.13)
encryptedInformation = quantizedContainer + d * information + mod(container, d);

%формулы из статьи
I = uint8(floor(double(encryptedInformation) / d2) * d2);
I0 = I; %+ mod(container, d);
I1 = I + d; %+ mod(container, d);

W1 = abs(encryptedInformation - I0);
W2 = abs(encryptedInformation - I1);

e1 = sum(W1, 'all');
e2 = sum(W2, 'all');

fprintf("e1 = %d, e2 = %d\n", e1 , e2);

subplot(2, 2, 1); imshow(container); impixelinfo; title('Контейнер');
subplot(2, 2, 2); imshow(encryptedInformation); impixelinfo; title('Зашифрованный контейнер');
subplot(2, 2, 3); imshow(255 * W1); impixelinfo; title('Извлеченная информация W1');
subplot(2, 2, 4); imshow(255 * W2); impixelinfo; title('Извлеченная информация W2');