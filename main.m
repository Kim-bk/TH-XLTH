 close all; clear all; clc;
    %folders_name = ['01MDA'; '02FVA'; '03MAB'; '04MHB'; '05MVB'; '06FTB'; '07FTC'; '08MLD'; '09MPD'; '10MSD'; '11MVD'; '12FTD'; '14FHH';'15MMH'; '16FTH'; '17MTH'; '18MNK'; '19MXK'; '20MVK';'21MTL'; '22MHL'];
    vowels_name = ['a'; 'e'; 'i'; 'o'; 'u'];
    folders_name = ['23MTL'; '24FTL'; '25MLM'; '27MCM'; '28MVN'; '29MHN'; '30FTN'; '32MTP'; '33MHP'; '34MQP'; '35MMQ'; '36MAQ'; '37MDS';'38MDS'; '39MTS'; '40MHS'; '41MVS'; '42FQT';'43MNT'; '44MTT'; '45MDV'];
frame_duration = 0.03; %take frame duration 30msec

[first_index_stable, last_index_stable, Sig, fs] = SeparatingStableVowels(folders_name, vowels_name);

MFCC_ORDER = 13;
N_FFT = 1024;
frameLength=floor(fs *  frame_duration);
frameShiftLength=floor(fs * 0.015);
figure('Name','Dac trung 5 nguyen am theo FFT');
for i = 1 : length(vowels_name)
    MFCC=[];
    FFT = [];
    for j = 1 : length(folders_name)
        %ste = [STE{i, j}];
        [mfccOneVowel{i, j}] = [];
        [fftOneVowel{i, j}] = [];
        %frameCurrent = [frames{i, j}];
        for k = first_index_stable(i, j) : last_index_stable(i, j)
           % if (ste(k) >= Tste_avg*0.1) % vowels
                started = (frameLength * (k - 1) / 2) + 1;
                ended =  started + frameLength - 1 ;
                SignalCurrent = [Sig{i, j}];
                %mfccMatrix  = melcepst(frameCurrent(k, :), fs, 'M', MFCC_ORDER, floor(3 * log(fs)), frameLength, frameShiftLength);
                mfccMatrix  = melcepst(SignalCurrent(started:ended, 1).', fs, 'M', MFCC_ORDER, floor(3 * log(fs)), frameLength, frameShiftLength);
                [mfccOneVowel{i, j}] = [[mfccOneVowel{i, j}]; mfccMatrix];

                %Tinh pho bien do
                fftMatrix = abs(fft(SignalCurrent(started:ended, 1), N_FFT));
                fftMatrix = fftMatrix(1 : round(length(fftMatrix) / 2));
                [fftOneVowel{i, j}] = [[fftOneVowel{i, j}]; reshape(fftMatrix,1, N_FFT / 2)];
           % end
        end
        MFCC = [MFCC; [mfccOneVowel{i, j}]];
        FFT  = [FFT; [fftOneVowel{i,j}]];
        %mfccOneVowel{i, j} = Matrix_Average([mfccOneVowel{i, j}]);
    end
    [MFCC_avg(:, :, i)] = Matrix_Average(MFCC);
    [FFT_avg(:, :, i)] = Matrix_Average(FFT);
    
% xuat dac trung 5 nguyen am theo mfcc
%     figure('Name','Dac trung 5 nguyen am theo mfcc');
%     subplot(5, 1, i);
%     plot(MFCC_avg(:, :, i));
%     legend('Spectral Envelope');
%     ylabel('Amplitude');
%     title(strcat('Vowel', {' '}, char(vowels_name(i, :))));
%     datacursormode on;

%xuat dac trung 5 nguyen am theo fft
 
    subplot(5, 1, i);
    plot(FFT_avg(:, :, i));
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title(strcat('Vowel', {' '}, char(vowels_name(i, :))));
    datacursormode on;


%    [MFCC_Traning_2(:, :, i), ~, ~] =  v_kmeans(MFCC, 2); % k = 2 clusters
%    [MFCC_Traning_3(:, :, i), ~, ~] =  kmeanlbg(MFCC, 3); % k = 3 clusters
%    [MFCC_Traning_4(:, :, i), ~, ~] =  kmeanlbg(MFCC, 4); % k = 4 clusters
       [MFCC_Traning_5(:, :, i), ~, ~] =  v_kmeans(MFCC, 5); % k = 5 clusters
end
    figure('Name','Dac trung 5 nguyen am theo MFCC');
    for i = 1 : length(vowels_name)
    subplot(5, 1, i);
    plot(MFCC_avg(:, :, i));
    legend('Spectral Envelope');
    ylabel('Amplitude');
    title(strcat('Vowel', {' '}, char(vowels_name(i, :))));
    datacursormode on
    end
    
confusionMatrixFFT = zeros(length(vowels_name));
confusionMatrixMFCC = zeros(length(vowels_name));
fileID = fopen('Result.csv','w');
fprintf(fileID,'%s,%s,%s,%s\n','Serial','Original','IdentificationMFCC','Result');
fileID = fopen('Result2.csv','w');
fprintf(fileID,'%s,%s,%s,%s,%s,%s\n','Serial','Original','IdentificationFFT','ResultFFT','IdentificationMFCC','ResultMFCC');
% Test find confusion matrix
count = 0;
countCorrectFFT = 0;
countCorrectMFCC = 0;
for i = 1 : length(folders_name) % 1 -> 21 speaker
    for j = 1 : length(vowels_name) % 1 -> 5 vowels
        %tinh euclid cho mfcc
        %[minDist, minPosMFCC] = Euclidean_Distance_Vowel(MFCC_avg, [mfccOneVowel{j, i}]);
        [minDist, minPosMFCC] = Euclidean_Distance_Vowel(MFCC_Traning_5, [mfccOneVowel{j, i}]);
        %tinh euclid cho fft - kim
        dist2_a = euclid(FFT_avg(:,:,1), mean([fftOneVowel{j, i}]));
        dist2_e = euclid(FFT_avg(:, :, 2),mean([fftOneVowel{j, i}]));
        dist2_i = euclid(FFT_avg(:, :, 3), mean([fftOneVowel{j, i}]));
        dist2_o = euclid(FFT_avg(:, :, 4), mean([fftOneVowel{j, i}]));
        dist2_u = euclid(FFT_avg(:, :, 5), mean([fftOneVowel{j, i}]));
        [dist, minPosFFT] = min([dist2_a; dist2_e; dist2_i; dist2_o; dist2_u]);       
        
        firstFile = char(folders_name(i, :));
        original = char(vowels_name(j, :));
        compare = char(vowels_name(minPosMFCC, :));
        fileID = fopen('Result.csv','a+');
        count = count + 1;
        fprintf(fileID,'%d,',count);
        fprintf(fileID,'%s,',strcat(firstFile,'/',original));
        fprintf(fileID,'%s,',compare);

        
        if (j == minPosMFCC)
            fprintf(fileID,'%s','Correct');
            countCorrectMFCC = countCorrectMFCC + 1;
        else    
            fprintf(fileID,'%s','Incorrect');
        end
       
        fprintf(fileID,'\n');


        
%         firstFile = char(folders_name(i, :));
%         original = char(vowels_name(j, :));
%         compare2 = char(vowels_name(minPosMFCC, :));
%         compare1 = char(vowels_name(minPosFFT, :));
%         fileID = fopen('Result2.csv','a+');
%         count = count + 1;
%         fprintf(fileID,'%d,',count);
%         fprintf(fileID,'%s,',strcat(firstFile,'/',original));
%         fprintf(fileID,'%s,',compare1);
% 
        if (j == minPosFFT)
            countCorrectFFT = countCorrectFFT + 1;
        else    

        end
%         fprintf(fileID,'%s,',compare2);
%         if (j == minPosMFCC)
%             fprintf(fileID,'%s','Correct');
%             countCorrectMFCC = countCorrectMFCC + 1;
%         else    
%             fprintf(fileID,'%s','Incorrect');
%         end
%        
%         fprintf(fileID,'\n');
        
        %[minDist, minPos] = Euclidean_Distance_Vowel(MFCC_avg, Matrix_Average([mfccOneVowel{j, i}]));
        
        %Ma tran nham lan cua mfcc
        confusionMatrixMFCC(j, minPosMFCC)= confusionMatrixMFCC(j, minPosMFCC) + 1;
        
        %Ma tran nham lan cua fft
        confusionMatrixFFT(j, minPosFFT)= confusionMatrixFFT(j, minPosFFT) + 1;
    end
end

    percent = countCorrectMFCC /105  * 100;
     percentFFT = countCorrectFFT /105  * 100;
    txt = 'Số lượng file Correct (MFCC): ';
    txtt = 'Số lượng file Correct (FFT): ';
    txt2 = strcat(txt,num2str(percent),'%')
    txt3 = strcat(txtt,num2str(percentFFT),'%')
%     text(0,0.7,txt2,'FontSize',10)
%     text(0,0.3,txt3,'FontSize',10)
    
%     t = readtable('Result2.csv');
%     t
%     vars = {'Serial','Original','IdentificationFFT','ResultFFT','IdentificationMFCC','ResultMFCC'};
%     t = t(1:105,vars);
%     fig = uifigure;
%     fig.Position(3:4) = [500 200];
%     txt_title = uicontrol('Style', 'text','String', 'My Example Title');
%     uit = uitable(fig,'Data',t);
%     styleIndices = 'Incorrect';
%     uis = uistyle('HorizontalAlignment', 'center'); 
%     addStyle(uit, uis, 'Column', 1)
%     uit.ColumnSortable = true;
%     s = uistyle('BackgroundColor','#F5DEB3');
%     addStyle(uit,s,'column',3)
%     addStyle(uit,s,'column',4)
%     
%     s = uistyle('BackgroundColor','#F5F5F5');
%     addStyle(uit,s,'column',5)
%     addStyle(uit,s,'column',6)

    t = readtable('Result.csv');
    t3_data=t
    vars = {'Serial','Original','IdentificationMFCC','Result'};
    t = t(1:105,vars);
    fig = uifigure;
    fig.Position(3:4) = [500 200];
    txt_title = uicontrol('Style', 'text','String', 'My Example Title');
    uit = uitable(fig,'Data',t);
    styleIndices = 'Incorrect';
%     uis = uistyle('HorizontalAlignment', 'center'); 
%     addStyle(uit, uis, 'Column', 1)
    uit.ColumnSortable = true;
    
    figure('Name','Ma tran nham lan FFT','NumberTitle','off');
    t2=uitable;
    set(t2,'Position',[0 2 500 150])
    set(t2,'Data',confusionMatrixFFT);
    set(t2, 'ColumnName', {'/a/', '/e/', '/i/', '/o/','/u/'});
    set(t2, 'RowName', {'/a/', '/e/', '/i/', '/o/','/u/'});

    figure('Name','Ma tran nham lan MFCC','NumberTitle','off');
    t2=uitable;
    set(t2,'Position',[0 2 500 150])
    set(t2,'Data',confusionMatrixMFCC);
    set(t2, 'ColumnName', {'/a/', '/e/', '/i/', '/o/','/u/'});
    set(t2, 'RowName', {'/a/', '/e/', '/i/', '/o/','/u/'});
    fclose('all');
