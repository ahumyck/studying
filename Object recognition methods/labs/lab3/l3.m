clear
clc
close all

p = 0.3;
N = 200;

letter_K = [0 1 0 0 0 0 1 0 0;
            0 1 0 0 0 1 0 0 0;
            0 1 0 0 1 0 0 0 0;
            0 1 0 1 0 0 0 0 0;
            0 1 1 0 0 0 0 0 0;
            0 1 0 1 0 0 0 0 0;
            0 1 0 0 1 0 0 0 0;
            0 1 0 0 0 1 0 0 0;
            0 1 0 0 0 0 1 0 0];
        
 
letter_G = [0 1 1 1 1 1 1 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0];
        
letter_G = convertImage(letter_G, p);
letter_K = convertImage(letter_K, p);

data_G = bin_vectors(letter_G, N);
data_K = bin_vectors(letter_K, N);  
figure; 
subplot(1,2,1); imagesc(reshape(sum(data_G), [9 9]));
subplot(1,2,2); imagesc(reshape(sum(data_K), [9 9]));

%дискриминантная функция
dEE = zeros(1, N); dUE = zeros(1, N);
dEU = zeros(1, N); dUU = zeros(1, N);

for i=1:N
  dEE(i) = discriminant(data_G(i, :), letter_G);
  dEU(i) = discriminant(data_G(i, :), letter_K);
  
  dUU(i) = discriminant(data_K(i, :), letter_K);
  dUE(i) = discriminant(data_K(i, :), letter_G);
end

figure; 
subplot(1, 2, 1); hold on; plot(1:N, dEE, 'g'); plot(1:N, dEU, 'r');
hold off;
subplot(1, 2, 2); hold on; plot(1:N, dUU, 'y'); plot(1:N, dUE, 'b');
hold off;

mean_G = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_K)./(letter_K))).*letter_G));
mean_K = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_K)./(letter_K))).*letter_K));
disp_G = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_K)./(letter_K))).^2.*letter_G.*(1-letter_G)));
disp_K = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_K)./(letter_K))).^2.*letter_K.*(1-letter_K)));

fprintf("Среднее G = %.4f\n", mean_G);
fprintf("Среднее K = %.4f\n", mean_K);
fprintf("Отклонение G = %.4f\n", disp_G);
fprintf("Отклонение K = %.4f\n", disp_K);

%вероятность ошибочной классификации
pG = 1 - (1/2)*(1 + erf((-1)*mean_K/sqrt(disp_K*2)));
pK = (1/2)*(1 + erf((-1)*mean_G/sqrt(disp_G*2)));

fprintf("Вероятность ошибочной классификации:\n");
fprintf("G = %.4f\n", pG);
fprintf("K = %.4f\n", pK);

pG_exp = 0;
pK_exp = 0;
for i=1:N
    if  dEE(i) <= dEU(i)
        pG_exp = pG_exp+1;
    end
    if  dUU(i) <= dUE(i)
        pK_exp = pK_exp+1;
    end
end
pG_exp = pG_exp / N;
pK_exp = pK_exp / N;
pG_exp = sqrt((1 - pG_exp)/(N*pG_exp));
pK_exp = sqrt((1 - pK_exp)/(N*pK_exp));

fprintf("Вероятность ошибоной классификации(экспериментально):\n");
fprintf("G = %.4f\n", pG_exp);
fprintf("K = %.4f\n", pK_exp);