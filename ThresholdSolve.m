function [threshold] = ThresholdSolve(STECal)
    [histo, x_arr] = hist(STECal, round(length(STECal)/0.5));
    M1 = 0;
    M2 = 0;
    M1Index = 0; 
    M2Index = 0;
    for i = 2 : length(histo) - 1 
        previous = i - 1;
        next = i + 1;
        while(histo(i) == histo(next))
            next = next + 1;
        end
        if(histo(i) > histo(previous) && histo(i) > histo(next)) 
            if(M1Index == 0)
                M1 = histo(i);
                M1Index = i;
            else
                M2 = histo(i);
                M2Index = i;
                break;
            end
        end
        i = next;
    end
    M1 = x_arr(M1Index);
    M2 = x_arr(M2Index);
    W =1000;
    threshold = (W * M1 + M2) / (W + 1);
end