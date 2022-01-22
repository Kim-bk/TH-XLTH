close all; clear all; clc;

folders_name = ['01MDA'; '02FVA'; '03MAB'; '04MHB'; '05MVB'; '06FTB'; '07FTC'; '08MLD'; '09MPD'; '10MSD'; '11MVD'; '12FTD'; '14FHH';'15MMH'; '16FTH'; '17MTH'; '18MNK'; '19MXK'; '20MVK';'21MTL'; '22MHL'];
vowels_name = ['a'; 'e'; 'i'; 'o'; 'u'];
%folders_name = ['23MTL'; '24FTL'; '25MLM'; '27MCM'; '28MVN'; '29MHN'; '30FTN'; '32MTP'; '33MHP'; '34MQP'; '35MMQ'; '36MAQ'; '37MDS';'38MDS'; '39MTS'; '40MHS'; '41MVS'; '42FQT';'43MNT'; '44MTT'; '45MDV'];

frame_duration = 0.03; %take frame duration 30msec

[first_index_stable, last_index_stable, Sig, fs] = SeparatingStableVowels(folders_name, vowels_name);

MFCC_ORDER = 26;
N_FFT = 1024;
frameLength=floor(fs *  frame_duration);
frameShiftLength=floor(fs * 0.015);
figure('Name','Dac trung 5 nguyen am theo mfcc');
for i = 1 : length(vowels_name)
    MFCC=[];
    FFT = [];
    for j = 1 : length(folders_name)
        [mfccOneVowel{i, j}] = [];
        [fftOneVowel{i, j}] = [];
        for k = first_index_stable(i, j) : last_index_stable(i, j)
            started = (frameLength * (k - 1)/2) + 1;
            ended =  started + frameLength - 1 ;
            SignalCurrent = [Sig{i, j}];
            mfccMatrix  = melcepst(SignalCurrent(started:ended, 1).', fs, 'E', MFCC_ORDER - 1, floor(3 * log(fs)), frameLength, frameShiftLength);
            [mfccOneVowel{i, j}] = [[mfccOneVowel{i, j}]; Matrix_Average(mfccMatrix)];

            %Tinh pho bien do
            fftMatrix = abs(fft(hamming(frameLength) .* SignalCurrent(started:ended, 1), N_FFT));
            fftMatrix = fftMatrix(1 : round(length(fftMatrix) / 2));
            [fftOneVowel{i, j}] = [[fftOneVowel{i, j}]; Matrix_Average(reshape(fftMatrix,1, N_FFT / 2))];
        end
        mfccOneVowel{i, j} = Matrix_Average([mfccOneVowel{i, j}]);
        fftOneVowel{i, j} = Matrix_Average([fftOneVowel{i, j}]);
        MFCC = [MFCC; [mfccOneVowel{i, j}]];
        FFT  = [FFT; [fftOneVowel{i,j}]];
        %mfccOneVowel{i, j} = Matrix_Average([mfccOneVowel{i, j}]);
    end
    [MFCC_avg(:, :, i)] = Matrix_Average(MFCC);
    [FFT_avg(:, :, i)] = Matrix_Average(FFT);

    %xuat dac trung 5 nguyen am theo fft
    subplot(5, 1, i);
    plot(abs(FFT_avg(:, :, i)));
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title(strcat('Vowel', {' '}, char(vowels_name(i, :))));
    datacursormode on;

    [MFCC_Traning_5(:, :, i), ~, ~] =  v_kmeans(MFCC, 5); % k = 5 clusters
    dlmwrite(strcat(char(vowels_name(i, :)),'.txt'), MFCC_Traning_5(:, :, i), 'delimiter', ' ','newline', 'pc', 'precision',10);
end

%xuat dac trung 5 nguyen am theo MFCC
figure('Name','Dac trung 5 nguyen am theo MFCC');
for i = 1 : length(vowels_name)
    subplot(5, 1, i);
    plot(MFCC_avg(:, :, i));
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title(strcat('Vowel', {' '}, char(vowels_name(i, :))));
    datacursormode on
end
