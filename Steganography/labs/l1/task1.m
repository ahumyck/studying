clear;
containerName = "goldhill.tif"; %имя изображения, куда будем встраивать информацию
informationName = "mickey.tif"; %имя изображения, в котором содержится информация
p = 3;

container = imread(containerName); % загружаем контейнер
information = imread(informationName); %загружаем информацию

% делим каждый элемент матрицы на 255, чтобы она состояла только из 0 и 1
information = information / 255; 

% достаём биты из p плоски изображения в контейнере
bits = bitget(container, p); 

% применяем формулу (3.5)
secretBits = not(xor(information, bits));

% встраиваем зашифрованные биты обратно в контейнер
encryptedInformation = bitset(container, p, secretBits); 

% применяем формулу (3.5) чтобы из зашифрованного контейнера получить
% изображение
decryptedInformation = not(bitxor(encryptedInformation, container));

subplot(1, 3, 1); imshow(container); impixelinfo; title('Контейнер');
subplot(1, 3, 2); imshow(encryptedInformation); impixelinfo; title('Зашифрованный контейнер');
subplot(1, 3, 3); imshow(decryptedInformation); impixelinfo; title('NOT XOR');