%http://www.computeroptics.smr.ru/KO/PDF/KO42-1/420115.pdf
clear;
clc;

containerName = "goldhill.tif"; %��� �����������, ���� ����� ���������� ����������
informationName = "mickey.tif"; %��� �����������, � ������� ���������� ����������
d = 10;
d2 = d * 2;

C = imread(containerName); % ��������� ���������
W = imread(informationName); %��������� ����������

% ����� ������ ������� ������� �� 255, ����� ��� �������� ������ �� 0 � 1
W = W / 255; 

% ���������� ������� (3.10) � (3.13)
Cw = uint8(floor(double(C) / d2) * d2) + d * W + mod(C, d);

%������� �� ������
I = uint8(floor(double(Cw) / d2) * d2);
I0 = I + mod(Cw, d);
I1 = I0 + d;

W1 = abs(Cw - I0);
W2 = abs(Cw - I1);

e1 = sum(W1, 'all');
e2 = sum(W2, 'all');

fprintf("e1 = %d, e2 = %d\n", e1 , e2);

subplot(2, 2, 1); imshow(C); impixelinfo; title('���������');
subplot(2, 2, 2); imshow(Cw); impixelinfo; title('������������� ���������');
subplot(2, 2, 3); imshow(255 * W1); impixelinfo; title('����������� ���������� W1');
subplot(2, 2, 4); imshow(255 * W2); impixelinfo; title('����������� ���������� W2');