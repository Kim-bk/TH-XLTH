function dactrung_mfcc(mfcc_avgA, mfcc_avgE, mfcc_avgU, mfcc_avgI, mfcc_avgO)
    title_fig = 'Dac trung trung binh 5 nguyen am cua 21 nguoi';
    figure('Name', title_fig);
    
    %A
    subplot(5,1,1);
    plot(mfcc_avgA); hold on;
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title('Vowel A');
    datacursormode on
    
    %E
    subplot(5,1,2);
    plot(mfcc_avgE); hold on;
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title('Vowel E');
    datacursormode on
    
   %I
    subplot(5,1,3);
    plot(mfcc_avgI); hold on;
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title('Vowel I');
    datacursormode on
    
    %U
    subplot(5,1,4);
    plot(mfcc_avgU); hold on;
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title('Vowel U');
    datacursormode on
    
    %0
    subplot(5,1,5);
    plot(mfcc_avgO); hold on;
    legend('Spectral Envelope');
    xlabel('Coefficient MFCC'); ylabel('Amplitude');
    title('Vowel O');
    datacursormode on
end