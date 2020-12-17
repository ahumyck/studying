I = rgb2gray(imread('peppers.png'));


J = imnoise(I, 'salt & pepper', 0.3);
K = medfilt2(J);
M = meanfilt2(J);

figure(1);
subplot(2, 2, 1);
imshow(I);
title("Peppers");

subplot(2, 2, 2);
imshow(J);
title("salt & pepper");

subplot(2, 2, 3);
imshow(K);
title("median filter");

subplot(2, 2, 4);
imshow(M);
title("mean filter");



figure(2);
subplot(2, 2, 1);
imhist(I);
title("Peppers");

subplot(2, 2, 2);
imhist(J);
title("salt & pepper");

subplot(2, 2, 3);
imhist(K);
title("median filter");

subplot(2, 2, 4);
imhist(M);
title("mean filter");