function [array] = generate_binary_vectors(letter, N)
    array = zeros(N, length(letter));
    for i=1:N
        for j=1:length(letter)
            array(i, j) = floor(rand/letter(j));
        end
    end
end

