function [p] = mah(M0, M1, B)
%MAH Summary of this function goes here
%   Detailed explanation goes here
dM = (M1 - M0);
p = (dM'/B) * dM; 
end

