function [indexSequence] = indexSequenceGenerator(rowsNumber, colsNumber, n)
%INDEXSEQUENCEGENERATOR Summary of this function goes here
%   Detailed explanation goes here
dy = floor(rowsNumber/n);
dx = floor(colsNumber/n);

lenght = dy * dx;

cols = zeros(1, lenght);
rows = zeros(1, lenght);

center = ceil(n/2);

cols(1) = center;
rows(1) = center;

index = 2;
while 1
    colNext = cols(index - 1) + n;
    if colNext < colsNumber
        cols(index) = colNext;
        rows(index) = rows(index - 1);
    else
        rowNext = rows(index - 1) + n;
        if rowNext < rowsNumber
            cols(index) = center;
            rows(index) = rowNext;
        else
            break
        end
    end
        
    
    index = index + 1;
end

disp(rows);
disp(cols);
indexSequence = rowsNumber * rows + cols;

end

