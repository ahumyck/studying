function [p] = bha(M0, B0, M1, B1)
%BHA Summary of this function goes here
%   Detailed explanation goes here


%rasstoyanie Bhatchariya
dM = M1 - M0;
B2 = (B1 + B0) / 2;

p1 = (dM'/B2) * dM; 
p2 = log(det(B2) / sqrt(det(B1) * det(B0)));
p = p1 / 4 + p2 / 2;

end

