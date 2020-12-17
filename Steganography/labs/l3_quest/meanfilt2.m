function [image] = meanfilt2(I)
%MEANFILT2 Summary of this function goes here
%   Detailed explanation goes here
image = imfilter(I, ones(3) / 9, 'symmetric');
end

