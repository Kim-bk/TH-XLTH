function [VowelArray] = XulyTiengNoi(totalFrame , STECal , threshold)
    VowelArray = zeros(1, totalFrame); 
    for i = 1 : totalFrame 
        if(STECal(i) >threshold ) 
            VowelArray(i) = 1; 
        else
            VowelArray(i) = 0; 
        end
    end
end