function [STECal,STE_Line] = STE(x, frameTotal, frameLength)
    STECal = zeros(1, frameTotal); % tinh nang luong cua moi frame
    for i = 1 : frameTotal
        start = (frameLength * (i - 1) / 2) + 1;
        endd =  start + frameLength - 1 ;
        frameI = x(start : endd);
        STECal(i) = sum(frameI.^2);
        STE_Line(start : endd) = STECal(i);
    end
end