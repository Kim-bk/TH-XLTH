function [frames] = framing(x, fs, frame_duration)
    frame_size = round(frame_duration * fs); %kích thuoc 1 khung (mau) 
    n = length(x);                           %do dai tin hieu (mau)
    num_frames = floor(n/frame_size);        %tong so khung 
    temp = 0;

    for i = 1 : num_frames 
        frames(i,:) = x(temp + 1 : temp + frame_size); 
        temp = temp + frame_size;
    end
end