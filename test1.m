    
path = 'C:\Users\ASUS\OneDrive\Desktop\Thi TH 2\NguyenAmHuanLuyen-16k\06FTB\u.wav';

    [data, fs] = audioread(path);
    frame_duration = 0.03;                      %thoi gian cua 1 khung 30 ms
    n = length(data);                                 %chieu dai tin hieu (samples)
    frame_len = round(frame_duration * fs); %kich thuoc 1 frame (samples)  
    num_frames = floor(n/frame_len);        %tong so frame cua tin hieu
    
    %phan frame cho tin hieu
    frames = framing(data, fs, frame_duration); 