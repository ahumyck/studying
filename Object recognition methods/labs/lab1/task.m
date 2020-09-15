clc;
clear;

M0 = [0.5; 0.5];
B0 = [0.1 0; 0 0.1];

M1 = [0.51; 0.51];
B1 = [0.11 0; 0 0.11];

p1 = bha(M0, B0, M1, B1);
p2 = mah(M0, M1, B0);

%A = recurrentMatrix(B0);
%disp(A);
fprintf("bha = %f\n", p1);
fprintf("mah = %f\n", p2);