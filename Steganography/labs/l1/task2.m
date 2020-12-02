%http://www.computeroptics.smr.ru/KO/PDF/KO42-1/420115.pdf
clear;
clc;

containerName = "goldhill.tif"; %��� �����������, ���� ����� ���������� ����������
informationName = "mickey.tif"; %��� �����������, � ������� ���������� ����������
d = 8;
d2 = d * 2;

C = imread(containerName);
W = imread(informationName);

W = W / 255; 

Cw = uint8(floor(double(C) / d2) * d2) + d * W + mod(C, d);

I = uint8(floor(double(Cw) / d2) * d2) + mod(Cw, d);

Ww = abs(Cw - I);
disp(max(max(Cw - C)));

subplot(1, 3, 1); imshow(C); impixelinfo; title('���������');
subplot(1, 3, 2); imshow(Cw); impixelinfo; title('������������� ���������');
subplot(1, 3, 3); imshow(255 * Ww); impixelinfo; title('����������� ���������� W');