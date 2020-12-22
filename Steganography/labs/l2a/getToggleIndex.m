function [index] = getToggleIndex(index, image, weightMatrix, Cw_bit)
%getToggleIndex Summary of this function goes here
%   Detailed explanation goes here

sz = size(image);
[x0, y0] = ind2sub(sz, index);

[windowSize, ~] = size(weightMatrix);
r = floor(windowSize / 2); %radius of window

toggleArea = image(x0 - r: x0 + r, y0 - r: y0 + r);
candidatesIndecies = find(toggleArea == Cw_bit);
disp(toggleArea);
disp(find(toggleArea == Cw_bit));

[s, ~] = size(candidatesIndecies);
%disp("here");
%disp(s);
if s == 1 || s == 1
    index = -1;
else
    %disp("here");
    %if center bit is canditate we need to exclude this bit from candidates
    centerBit = ceil(power(windowSize, 2) / 2); 
    if ismember(centerBit, candidatesIndecies)
        candidatesIndecies(candidatesIndecies == centerBit) = [];
        s = s - 1;
    end
    
    %disp("here");
    offset = ceil(windowSize / 2);
    weightArray = zeros(1, s);
    %disp(candidatesIndecies);
    %disp(s);
    [rowIndex, colIndex] = ind2sub(size(toggleArea), candidatesIndecies);
    rowIndex = rowIndex + x0 - offset;
    colIndex = colIndex + y0 - offset;
    %disp(rowIndex);
    %disp(colIndex);
    
    for k = 1:s
        i = rowIndex(k);
        j = colIndex(k);
        window = image(i - r: i + r, j - r: j + r);
        weightArray(k) = weightCalculator(weightMatrix, window);
    end
    
    [~, k] = max(weightArray);
    index = sub2ind(sz, rowIndex(k), colIndex(k));
    
end


end

