clear
clc
close all

p = 0.3;
N = 200;
letter_G = read_letter_as_vector('g.tif', p);
letter_H = read_letter_as_vector('h.tif', p);

data_G = generate_binary_vectors(letter_G, N);
data_H = generate_binary_vectors(letter_H, N);  
figure; 
subplot(1,2,1); imagesc(reshape(sum(data_G), [9 9]));
subplot(1,2,2); imagesc(reshape(sum(data_H), [9 9]));

%дискриминантная функция
dEE = zeros(1, N); dUE = zeros(1, N);
dEU = zeros(1, N); dUU = zeros(1, N);

for i=1:N
  dEE(i) = dscmFunc(data_G(i, :), letter_G);
  dEU(i) = dscmFunc(data_G(i, :), letter_H);
  
  dUU(i) = dscmFunc(data_H(i, :), letter_H);
  dUE(i) = dscmFunc(data_H(i, :), letter_G);
end

figure; 
subplot(1, 2, 1); hold on; plot(1:N, dEE, 'g'); plot(1:N, dEU, 'r');
hold off;
subplot(1, 2, 2); hold on; plot(1:N, dUU, 'y'); plot(1:N, dUE, 'b');
hold off;

mean_G = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_H)./(letter_H))).*letter_G));
mean_H = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_H)./(letter_H))).*letter_H));
disp_G = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_H)./(letter_H))).^2.*letter_G.*(1-letter_G)));
disp_H = sum(sum(log((letter_G./(1-letter_G)).*((1-letter_H)./(letter_H))).^2.*letter_H.*(1-letter_H)));

%вероятность ошибочной классификации
pG = 1 - (1/2)*(1 + erf((-1)*mean_H/sqrt(disp_H*2)));
pH = (1/2)*(1 + erf((-1)*mean_G/sqrt(disp_G*2)));

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

figure;
subplot(1,2,1); imagesc(reshape(sum(data_G), [9 9]));
subplot(1,2,2); imagesc(reshape(sum(data_H), [9 9]));

function array = read_letter_as_vector(path_to_img, p)
    C = double(imread(path_to_img));
    C(C>0) = 1-p;
    C(C==0) = p;
    array = reshape(C, 1, []);
end

function [array] = generate_binary_vectors(Letter, N)

    array = zeros(N, length(Letter));
    for i=1:N
        for j=1:length(Letter)
            array(i,j) = (rand-Letter(j))>0;
        end
    end
end

function output  = dscmFunc(X, PX)
    s1 = 0; s2 = 0;
    for i = 1:size(PX, 2)
        s1 = s1 + log (1 - PX(i));
        s2 = s2 + X(i)*log (PX(i)/(1 - PX(i))); 
    end
    output = log (1/2) + s1 + s2;
end