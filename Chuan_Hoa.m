function [STECal] = Chuan_Hoa(STECal)
    minEnergy = min(STECal); 
    maxEnergy = max(STECal);
    for i = 1 : length(STECal) 
        STECal(i) = (STECal(i) - minEnergy) / (maxEnergy - minEnergy);
    end
end