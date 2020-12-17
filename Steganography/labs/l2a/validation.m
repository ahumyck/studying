function [result] = validation(indecies, imageSize, r)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
result = 1;

s = size(indecies, 2);

for i = s
    [x0, y0] = ind2sub(imageSize, indecies(i));
    for j = s
        [x, y] = ind2sub(imageSize, indecies(i));
        if abs(x - x0) < r || abs(y - y0) < r
            result = -1;
            break;
        end
    end
    if result == -1
        break
    end
end

end

