% binary seacrh theshold

function T = threshold(x)
    x = sort(x);
    f = x(x > min(x));
    g = x(x < max(x));
    T = binarySearch(f, g, min(x), max(x));
end