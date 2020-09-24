clear;
clc;

containerName = "goldhill.tif";
informationName = "mickey.tif";
p = 3;

C = imread(containerName);
W = imread(informationName);

% ����� ������ ������� ������� �� 255, ����� ��� �������� ������ �� 0 � 1
W = W / 255; 

% ������ ���� �� p ������ ����������� � ����������
Cp = bitget(C, p); 

% ��������� ������� (3.5)
C = not(xor(W, Cp));

% ���������� ������������� ���� ������� � ���������
Cw = bitset(C, p, Cwb); 

% ��������� ������� (3.5) ����� �� �������������� ���������� ��������
% �����������
d = not(bitxor(Cw, C));

subplot(1, 3, 1); imshow(C); impixelinfo; title('C');
subplot(1, 3, 2); imshow(Cw); impixelinfo; title('Cw');
subplot(1, 3, 3); imshow(decryptedInformation); impixelinfo; title('NOT XOR');