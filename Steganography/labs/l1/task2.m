%http://www.computeroptics.smr.ru/KO/PDF/KO42-1/420115.pdf
clear;

containerName = "goldhill.tif"; %��� �����������, ���� ����� ���������� ����������
informationName = "mickey.tif"; %��� �����������, � ������� ���������� ����������
d = 10;
d2 = d * 2;

container = imread(containerName); % ��������� ���������
information = imread(informationName); %��������� ����������

% ����� ������ ������� ������� �� 255, ����� ��� �������� ������ �� 0 � 1
information = information / 255; 

containerAsDouble = double(container); % ������ ��� ������� �� double
quantizedContainer = uint8(floor(containerAsDouble / d2) * d2); % �������� �������

% ���������� ������� (3.10) � (3.13)
encryptedInformation = quantizedContainer + d * information + mod(container, d);

%������� �� ������
I = uint8(floor(double(encryptedInformation) / d2) * d2);
I0 = I; %+ mod(container, d);
I1 = I + d; %+ mod(container, d);

W1 = abs(encryptedInformation - I0);
W2 = abs(encryptedInformation - I1);

e1 = sum(W1, 'all');
e2 = sum(W2, 'all');

fprintf("e1 = %d, e2 = %d\n", e1 , e2);

subplot(2, 2, 1); imshow(container); impixelinfo; title('���������');
subplot(2, 2, 2); imshow(encryptedInformation); impixelinfo; title('������������� ���������');
subplot(2, 2, 3); imshow(255 * W1); impixelinfo; title('����������� ���������� W1');
subplot(2, 2, 4); imshow(255 * W2); impixelinfo; title('����������� ���������� W2');