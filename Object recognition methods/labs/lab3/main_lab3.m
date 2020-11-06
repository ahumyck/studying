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
        
letter_K(letter_K == 1) = p;
letter_K(letter_K == 0) = 1 - p;
letter_K = reshape(letter_K, 1, []);
        
letter_G = [0 1 1 1 1 1 1 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0;
            0 1 0 0 0 0 0 0 0];

letter_G(letter_G == 1) = p;
letter_G(letter_G == 0) = 1 - p;
letter_G = reshape(letter_G, 1, []);
        
        
data_G = generate_binary_vectors(letter_G, N);
data_K = generate_binary_vectors(letter_K, N);

figure; 
subplot(1,2,1); imagesc(reshape(sum(data_G), [9 9]));
subplot(1,2,2); imagesc(reshape(sum(data_K), [9 9]));

%дискриминантная функция
dEE = zeros(1, N); dUE = zeros(1, N);
dEU = zeros(1, N); dUU = zeros(1, N);

for i=1:N
  dEE(i) = descriminant_function(data_G(i, :), letter_G);
  dEU(i) = descriminant_function(data_G(i, :), letter_K);
  
  dUU(i) = descriminant_function(data_K(i, :), letter_K);
  dUE(i) = descriminant_function(data_K(i, :), letter_G);
end

figure; 
subplot(1, 2, 1); hold on; plot(1:N, dEE, 'g'); plot(1:N, dEU, 'r');
hold off;
subplot(1, 2, 2); hold on; plot(1:N, dUU, 'y'); plot(1:N, dUE, 'b');
hold off;


%formula p20
mean_G = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_K)./(letter_K))).*letter_G));
mean_H = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_K)./(letter_K))).*letter_K));

fprintf("mean_G = %.4f\n", mean_G);
fprintf("mean_H = %.4f\n", mean_H);

%formula p20
disp_G = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_K)./(letter_K))).^2.*letter_G.*(1-letter_G)));
disp_H = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_K)./(letter_K))).^2.*letter_K.*(1-letter_K)));

fprintf("disp_G = %.4f\n", disp_G);
fprintf("disp_H = %.4f\n", disp_H);

%вероятность ошибочной классификации
%veroyatnost oshibochnoy klassifikatsii
pG = 1 - (1/2)*(1 + erf((-1)*mean_H/sqrt(disp_H*2)));
pH = (1/2)*(1 + erf((-1)*mean_G/sqrt(disp_G*2)));

fprintf("вероятность ошибочной классификации pG = %.4f\n", pG);
fprintf("вероятность ошибочной классификации pH = %.4f\n", pH);

%experementalno
pG_exp = 0;
pH_exp = 0;
for i=1:N
    if  dEE(i) <= dEU(i)
        pG_exp = pG_exp+1;
    end
    if  dUU(i) <= dUE(i)
        pH_exp = pH_exp+1;
    end
end
pG_exp = pG_exp / N;
pH_exp = pH_exp / N;
pG_exp = sqrt((1 - pG_exp)/(N*pG_exp));
pH_exp = sqrt((1 - pH_exp)/(N*pH_exp));
fprintf("вероятность ошибочной классификации эксперементально pG = %.4f\n", pG_exp);
fprintf("вероятность ошибочной классификации эксперементально pH = %.4f\n", pH_exp);