function SilenceArray = XacDinhKhoangLang(VowelArray, frameTotal) %xac dinh khoang de in ra 
    SilenceArray = [];
    indexSilence = 1;
    skipp = 0;
    for i = 1 : frameTotal
        if(skipp > 0)
            skipp = skipp - 1;
            continue;
        end
       
        if(VowelArray(i) == 0)
            count = i;
            while(count < frameTotal && VowelArray(count + 1) == 0)
                count = count + 1;
            end
            if(count - i >= 14)
                SilenceArray(indexSilence, 1) = i;
                SilenceArray(indexSilence, 2) = count;
                indexSilence = indexSilence + 1;
                skipp = count - i;
            end
        end
    end
end