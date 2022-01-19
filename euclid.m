function dist = euclid(vector1, vector2)
    temp = 0;
    for i = 1 : length(vector1)
        temp = temp + (vector1(i) - vector2(i)).^2;
    end
    dist = sqrt(temp);
end