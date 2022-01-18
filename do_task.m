function [mfcc_mean] = do_task(data, fs)
    frame_duration = 0.03;                      %thoi gian cua 1 khung 30 ms
    n = length(data);                                 %chieu dai tin hieu (samples)
    frame_len = round(frame_duration * fs); %kich thuoc 1 frame (samples)  
    num_frames = floor(n/frame_len);        %tong so frame cua tin hieu
    
    %phan frame cho tin hieu
    frames = framing(data, fs, frame_duration); 
    f0 = zeros(1, num_frames);

    %tinh STE cho tung frames
    [row, col] = size(frames);
    STE = 0;
    for i = 1 : row 
        STE(i) = sum(frames(i,:).^2);   
    end

    STE = STE./max(STE); %chuan hoa du lieu STE 
 
    %tinh STE cho tung mau trong tung frames
    STE_wave = 0; 
    for j = 1 : length(STE)
        l = length(STE_wave);
        STE_wave(l : l + frame_len) = STE(j); 
    end
    
    %ve STE, ZCR, cung voi tin hieu 
    t = (0 : length(data) - 1) / fs; %thoi gian cua tin hieu(s)
    t1 = (0  : length(STE_wave) - 1) / fs;
    
    %phan doan Vowel 
    %xac dinh nguong thong qua thong ke file lab
    %nguong gia tri ste dung chung
    t_ste = 0.00354;
    index  = 1;
    for i = 1 : num_frames
        %Vowel                                               
        if(STE(i) > t_ste )
            vowel_frames(index) = i;
            index = index + 1;
        end     
    end
  
    %tim vi tri khung trong vung on dinh
     j = 1 ;
    first_index = vowel_frames(1) +  round( length(vowel_frames) / 3);
    last_index = first_index +  round( length(vowel_frames) / 3);
    for i = first_index : last_index
        stable_frames(j) = i;
        j = j + 1;
    end  
 
    nc = 13;  % so luong he so MFCC
    mfcc_sum = zeros(1, nc);
    
    %duyet qua cac khung o vung on dinh
    for i = 1 : length(stable_frames) 
         data_stable = data((stable_frames(i) - 1) * frame_len + 1: stable_frames(i) * frame_len);
         % tinh mfcc cua khung tin hieu do
          mfcc = v_melcepst(data_stable, fs, 'M', nc); 
%       [centerVectors] = v_kmeanlbg(mfcc, 9);
              
         %tinh tong mfcc cua cac khung trong vung on dinh
         mfcc_sum = mfcc_sum + mean(mfcc); 
         
             %Cach thay
%          MfccVectors = v_melcepst(data_stable, fs, 'E', nc - 1, floor(3*log(fs)), 0.03*fs, 0.01*fs);
%          [centerVectors] = v_kmeans(MfccVectors, 5);
%          mfcc_sum = mfcc_sum + mean(centerVectors); 
    end
    %tinh vector dac trung mfcc trung binh cua cac khung on dinh
    mfcc_mean = mfcc_sum / length(stable_frames); 
end