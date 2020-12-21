function [indexSequence] = coordinatesGenerator(image, windowSize)
%INDEXSEQUENCEGENERATOR Summary of this function goes here
%   Detailed explanation goes here
[rowsNumber, colsNumber] = size(image);

cols = zeros(1, 2);
rows = zeros(1, 2);

cols(1) = windowSize;
rows(1) = windowSize;

index = 2;
while 1
    colNext = cols(index - 1) + windowSize;
    if colNext < colsNumber - windowSize
        cols(index) = colNext;
        rows(index) = rows(index - 1);
    else
        rowNext = rows(index - 1) + windowSize;
        if rowNext < rowsNumber - windowSize
            cols(index) = windowSize;
            rows(index) = rowNext;
        else
            break
        end
    end
    index = index + 1;
end
indexSequence = sub2ind(size(image), rows, cols);
end

