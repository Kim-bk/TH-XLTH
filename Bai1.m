function [STE_Line, first_index_stable, last_index_stable, SignalSample, Fs] = Bai1(fileName)
    [Sig, Fs] = audioread(fileName);
    SignalSample = Sig;
    Sig = Sig./abs(max(Sig));
    samples = length(Sig);
    frameDuration = 0.03;
    frameLength = round(Fs * frameDuration);
    frameTotalNoFrameShift = floor(samples / frameLength); 
    totalFrame = 2*frameTotalNoFrameShift - 1;
    %Sig = medianFilter(Sig,7);
    [STECal,STE_Line] = STE(Sig, totalFrame, frameLength);
    
    [STECal_Line] = Chuan_Hoa(STE_Line);
    [STECal1] = Chuan_Hoa(STECal);

   % threshold =0.0266;
    threshold =ThresholdSolve(STECal1);
    global count;
    count = count + 1;
    global thresholdArray;
    thresholdArray(count) = threshold;
    VowelArray = XulyTiengNoi(totalFrame , STECal1 , threshold);
    global thresholdArrayTay;
    thresholdArrayTay =thresholdArrayTay + threshold;
    SilenceArray = XacDinhKhoangLang(VowelArray, totalFrame);
%     fileID = fopen('haha.txt', 'a+');
%     fprintf(fileID,'%s \n',fileName);
%     fprintf(fileID,'%d ',SilenceArray);
%     fprintf(fileID,'\n');

    first_index_stable = 0;
    for i = 1: length(VowelArray)
        if VowelArray(i) == 1
            if (first_index_stable == 0)
                first_index_stable = i;
            end
            last_index_stable = i;
        end
    end

%     figure('name',fileName);
% 
%     subplot(3,1,1);    
%     p1=plot(Sig);
    %plot(STECal,'Color','red');
%     title('Phan tich vowel va silence (STE)');
%     hold on;
%     plot(STECal_Line,'Color','r');
%     hold on; grid on;
%     for j = 1: size(SilenceArray)
%         start =  SilenceArray(j, 1);
%         endd = SilenceArray(j, 2);
%         
%         start1 = ((start - 1) / 2) * frameLength;
%         endd1 = (endd * frameLength) - (frameLength * (endd - 1) / 2);
%         
%         plot ([start1 start1],[-1 1],'b');
%         plot ([endd1 endd1],[-1 1],'b');
%     end

%     hold off;
% 
%     xlabel('Thoi gian (s)'); 
%     ylabel('Bien do');
%     SilencthresholdthresholdeArray
%     threshold
%     frameLength
%     frameTotalNoFrameShift
%   totalFrame
    nguongmeanhaha = mean(thresholdArray);
end