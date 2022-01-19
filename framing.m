function [frame_size, frame_length, frames] = framing(x, fs, frame_duration)
    frame_size = round(frame_duration*fs); % number samples in a frame of signal
    shift_frame = 0.01 * fs;
    total_samples = length(x);
    i = 1;
    index = 1;
    while((index + frame_size) < total_samples)
        frames(i,:) = x(floor(index):floor(index + frame_size - 1));
        frame_length = i;
        index = index + shift_frame;
        i = i + 1;
    end
end