function dactrung_fft(fft_avgA, fft_avgE, fft_avgU, fft_avgI, fft_avgO)
    title_fig = 'Dac trung trung binh 5 nguyen am cua 21 nguoi theo FFT';
    figure('Name', title_fig);
    
    %A
    subplot(5,1,1);
    plot(fft_avgA); hold on;
    ylabel('Amplitude');
    title('Vowel A');
    datacursormode on
    
    %E
    subplot(5,1,2);
    plot(fft_avgE); hold on;
    ylabel('Amplitude');
    title('Vowel E');
    datacursormode on
    
   %I
    subplot(5,1,3);
    plot(fft_avgI); hold on;
    ylabel('Amplitude');
    title('Vowel I');
    datacursormode on
    
    %U
    subplot(5,1,4);
    plot(fft_avgU); hold on;
    ylabel('Amplitude');
    title('Vowel U');
    datacursormode on
    
    %0
    subplot(5,1,5);
    plot(fft_avgO); hold on;
    xlabel('Coefficient FFT'); ylabel('Amplitude');
    title('Vowel O');
    datacursormode on
end