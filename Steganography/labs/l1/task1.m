clear;
containerName = "goldhill.tif"; %��� �����������, ���� ����� ���������� ����������
informationName = "mickey.tif"; %��� �����������, � ������� ���������� ����������
p = 3;

container = imread(containerName); % ��������� ���������
information = imread(informationName); %��������� ����������

% ����� ������ ������� ������� �� 255, ����� ��� �������� ������ �� 0 � 1
information = information / 255; 

% ������ ���� �� p ������ ����������� � ����������
bits = bitget(container, p); 

% ��������� ������� (3.5)
secretBits = not(xor(information, bits));

% ���������� ������������� ���� ������� � ���������
encryptedInformation = bitset(container, p, secretBits); 

% ��������� ������� (3.5) ����� �� �������������� ���������� ��������
% �����������
decryptedInformation = not(bitxor(encryptedInformation, container));

subplot(1, 3, 1); imshow(container); impixelinfo; title('���������');
subplot(1, 3, 2); imshow(encryptedInformation); impixelinfo; title('������������� ���������');
subplot(1, 3, 3); imshow(decryptedInformation); impixelinfo; title('NOT XOR');