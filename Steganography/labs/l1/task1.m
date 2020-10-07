clear;
containerName = "goldhill.tif"; 
informationName = "mickey.tif"; 
p = 3;

C = imread(containerName); 
W = imread(informationName);

W = W / 255; 

Cp = bitget(C, p); 
Cwp = not(xor(W, Cp));

Cw = bitset(C, p, Cwp); 
Ww = not(bitxor(Cw, C));

subplot(1, 3, 1); imshow(C); impixelinfo; title('C');
subplot(1, 3, 2); imshow(Cw); impixelinfo; title('Cw');
subplot(1, 3, 3); imshow(Ww); impixelinfo; title('W');