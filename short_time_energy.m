function STE = short_time_energy(frames, length_frame)
    % Calculating Energy of the Signal
    STE = 0;
    for i = 1 : length_frame
        STE(i) = sum(frames(i, :) .^ 2);
    end
    %STE = STE ./ max(STE); %normalize data [0, 1]
    STE = (STE - min(STE)) / (max(STE) - min(STE));
end
