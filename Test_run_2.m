close all; clear all; clc;
folders_name = ['01MDA'; '02FVA'; '03MAB'; '04MHB'; '05MVB'; '06FTB'; '07FTC'; '08MLD'; '09MPD'; '10MSD'; '11MVD'; '12FTD'; '14FHH';'15MMH'; '16FTH'; '17MTH'; '18MNK'; '19MXK'; '20MVK';'21MTL'; '22MHL'];
vowels_name = ['a'; 'e'; 'i'; 'o'; 'u'];
frame_duration = 0.03; %take frame duration 30msec
path = 'C:\\Users\\Admin\\Downloads\\NguyenAmHuanLuyen-16k-20220105T023031Z-001\\NguyenAmHuanLuyen-16k\\';
for i = 1 : length(vowels_name)
    for j = 1 : length(folders_name)
        [x, fs] = audioread(strcat(path, char(folders_name(j, :)), '\\', char(vowels_name(i, :)), '.wav'));
        sampleSignal{i, j} = x;
        [frame_size(i, j), frame_length(i, j), frames{i, j}] = framing(x, fs, frame_duration);
        STE{i, j} = short_time_energy([frames{i, j}], frame_length(i, j));
        Tste(i, j) = threshold([STE{i, j}]);
        Signal{i, j} = x;
    end
end

[dx, dy] = size(Tste);
Tste_avg = sum(sum(Tste(:, :)) / dx) / dy;
for i = 1 : length(vowels_name)
    for j = 1 : length(folders_name)
        ste = [STE{i, j}];
        first_index_stable(i, j) = 0;
        last_index_stable(i, j) = 0;
        for index = 1 : length(ste)
            if (ste(index) >= Tste_avg*0.1) % Tste_avg*0.1
                % frame vowels
                if (first_index_stable(i, j) == 0)
                    first_index_stable(i, j) = index;
                end
                last_index_stable(i, j) = index;
            end
        end
        % split stable frame
        first_index_stable(i, j) = first_index_stable(i, j) + floor((last_index_stable(i, j) - first_index_stable(i, j) + 1) / 3);
        last_index_stable(i, j) = last_index_stable(i, j) - round((last_index_stable(i, j) - first_index_stable(i, j) + 1) / 3);
    end
end

MFCC_ORDER = 39;
N_FFT = 1024;
frameLength=floor(fs *  frame_duration);
frameShiftLength=floor(fs * 0.015);
for i = 1 : length(vowels_name)
    MFCC=[];
    FFT = [];
    for j = 1 : length(folders_name)
        %ste = [STE{i, j}];
        [mfccOneVowel{i, j}] = [];
        [fftOneVowel{i, j}] = [];
        frameCurrent = [frames{i, j}];
        for k = first_index_stable(i, j) : last_index_stable(i, j)
           % if (ste(k) >= Tste_avg*0.1) % vowels
            mfccMatrix  = melcepst(frameCurrent(k, :), fs, 'E', MFCC_ORDER, floor(3 * log(fs)), frameLength, frameShiftLength);
            [mfccOneVowel{i, j}] = [[mfccOneVowel{i, j}]; Matrix_Average(mfccMatrix)];
                
            %Tinh pho bien do
            SignalFrame = frameCurrent(k, :).';
            fftMatrix = fft(hamming(frameLength) .* SignalFrame, N_FFT);
            fftMatrix = abs(fftMatrix(1 : round(length(fftMatrix) / 2)));
            [fftOneVowel{i, j}] = [[fftOneVowel{i, j}]; reshape(fftMatrix,1, N_FFT / 2)];
            %end
        end
        mfccOneVowel{i, j} = Matrix_Average([mfccOneVowel{i, j}]);
        fftOneVowel{i, j} = Matrix_Average([fftOneVowel{i, j}]);
        MFCC = [MFCC; [mfccOneVowel{i, j}]];
        FFT  = [FFT; [fftOneVowel{i,j}]];
    end
    [MFCC_avg(:, :, i)] = Matrix_Average(MFCC);
    [FFT_avg(:, :, i)] = Matrix_Average(FFT);
 [MFCC_Traning_5(:, :, i), ~, ~] =  v_kmeans(MFCC, 5); % k = 5 clusters
end

figure('Name','Dac trung 5 nguyen am theo FFT');
for i = 1 : length(vowels_name)
    subplot(5, 1, i);
    plot(FFT_avg(:, :, i));
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title(strcat('Vowel', {' '}, char(vowels_name(i, :))));
    datacursormode on
end

confusionMatrix = zeros(length(vowels_name));
confusionMatrixFFT = zeros(length(vowels_name));

countCorrectMFCC = 0;
% Test find confusion matrix
for i = 1 : length(folders_name) % 1 -> 21 speaker
    for j = 1 : length(vowels_name) % 1 -> 5 vowels
        [minDist, minPos] = Euclidean_Distance_Vowel(MFCC_Traning_5, [mfccOneVowel{j, i}]);
        %[minDist, minPos] = Euclidean_Distance_Vowel(MFCC_avg, Matrix_Average([mfccOneVowel{j, i}]));
        confusionMatrix(j, minPos)= confusionMatrix(j, minPos) + 1;
        
        dist2_a = euclid(FFT_avg(:,:,1), [fftOneVowel{j, i}]);
        dist2_e = euclid(FFT_avg(:, :, 2), [fftOneVowel{j, i}]);
        dist2_i = euclid(FFT_avg(:, :, 3), [fftOneVowel{j, i}]);
        dist2_o = euclid(FFT_avg(:, :, 4), [fftOneVowel{j, i}]);
        dist2_u = euclid(FFT_avg(:, :, 5), [fftOneVowel{j, i}]);
        [dist, minPosFFT] = min([dist2_a; dist2_e; dist2_i; dist2_o; dist2_u]);
        confusionMatrixFFT(j, minPosFFT)= confusionMatrixFFT(j, minPosFFT) + 1;
        if minPos == j
            countCorrectMFCC = countCorrectMFCC + 1;
        end
    end
end
countCorrectMFCC*100/105