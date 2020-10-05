function [] = custom_disp(M, Mo, B, Bo, ind)
%CUSTOM_DISP Summary of this function goes here
%   Detailed explanation goes here
fprintf("M(%d)\n", ind);
disp(M);
fprintf("B(%d)\n", ind);
disp(B);


fprintf("~M(%d)\n", ind);
disp(Mo);
fprintf("~B(%d)\n", ind);
disp(Bo);
fprintf("\n\n");
end

