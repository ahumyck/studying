function [p] = mah(M2, M1, B)
%MAH Summary of this function goes here
%   Detailed explanation goes here
dM = (M2 - M1);
p = 0.5 * (dM' / B * dM); 
end

