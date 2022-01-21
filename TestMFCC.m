 close all; clear all; clc;
    folders_name = ['01MDA'; '02FVA'; '03MAB'; '04MHB'; '05MVB'; '06FTB'; '07FTC'; '08MLD'; '09MPD'; '10MSD'; '11MVD'; '12FTD'; '14FHH';'15MMH'; '16FTH'; '17MTH'; '18MNK'; '19MXK'; '20MVK';'21MTL'; '22MHL'];
    vowels_name = ['a'; 'e'; 'i'; 'o'; 'u'];
    folders_name2 = ['01MDA'; '02FVA'; '03MAB'; '04MHB'; '05MVB'; '06FTB'; '07FTC'; '08MLD'; '09MPD'; '10MSD'; '11MVD'; '12FTD'; '14FHH';'15MMH'; '16FTH'; '17MTH'; '18MNK'; '19MXK'; '20MVK';'21MTL'; '22MHL'];

frame_duration = 0.03; %take frame duration 30msec

% path = 'C:\\Users\\Admin\\Downloads\\NguyenAmHuanLuyen-16k-20220105T023031Z-001\\NguyenAmHuanLuyen-16k\\';
% for i = 1 : length(vowels_name)
%     for j = 1 : length(folders_name)
%         [x, fs] = audioread(strcat(path, char(folders_name(j, :)), '\\', char(vowels_name(i, :)), '.wav'));
%         x = (x - min(x)) ./ (max(x) - min(x)); % chuan hoa signal
%         sampleSignal{i, j} = x;
%         [frame_size(i, j), frame_length(i, j), frames{i, j}] = framing(x, fs, frame_duration);
%         STE{i, j} = short_time_energy([frames{i, j}], frame_length(i, j));
%         Tste(i, j) = threshold([STE{i, j}]);
%     end
% end
% 
% [dx, dy] = size(Tste);
% Tste_avg = sum(sum(Tste(:, :)) / dx) / dy;
% 
% for i = 1 : length(vowels_name)
%     for j = 1 : length(folders_name)
%         ste = [STE{i, j}];
%         first_index_stable(i, j) = 0;
%         last_index_stable(i, j) = 0;
%         for index = 1 : length(ste)
%             if (ste(index) >= Tste_avg*0.1) % Tste_avg*0.1
%                 % frame vowels
%                 if (first_index_stable(i, j) == 0)
%                     first_index_stable(i, j) = index;
%                 end
%                 last_index_stable(i, j) = index;
%             end
%         end
%         % split stable frame
%         first_index_stable(i, j) = first_index_stable(i, j) + floor((last_index_stable(i, j) - first_index_stable(i, j) + 1) / 3);
%         last_index_stable(i, j) = last_index_stable(i, j) - round((last_index_stable(i, j) - first_index_stable(i, j) + 1) / 3);
%     end
% end

[first_index_stable, last_index_stable, Sig, fs] = SeparatingStableVowels(folders_name, vowels_name);

MFCC_ORDER = 13;
N_FFT = 1024;
frameLength=floor(fs *  frame_duration);
frameShiftLength=floor(fs * 0.015);
figure;
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
    figure('Name','Dac trung 5 nguyen am theo mfcc');
    subplot(6, 1, i);
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

confusionMatrixFFT = zeros(length(vowels_name));
confusionMatrixMFCC = zeros(length(vowels_name));
fileID = fopen("Result.csv","w");
fprintf(fileID,'%s,%s,%s,%s\n','Serial','Original','IdentificationMFCC','Result');
fileID = fopen("Result2.csv","w");
fprintf(fileID,'%s,%s,%s,%s,%s,%s\n','Serial','Original','IdentificationFFT','ResultFFT','IdentificationMFCC','ResultMFCC');
% Test find confusion matrix
count = 0;
countCorrectFFT = 0;
countCorrectMFCC = 0;
for i = 1 : length(folders_name) % 1 -> 21 speaker
    for j = 1 : length(vowels_name) % 1 -> 5 vowels
        %tinh euclid cho mfcc
        [minDist, minPosMFCC] = Euclidean_Distance_Vowel(MFCC_avg, [mfccOneVowel{j, i}]);
        
        %tinh euclid cho fft - kim
        dist2_a = euclid(FFT_avg(:,:,1), mean([fftOneVowel{j, i}]));
        dist2_e = euclid(FFT_avg(:, :, 2),mean([fftOneVowel{j, i}]));
        dist2_i = euclid(FFT_avg(:, :, 3), mean([fftOneVowel{j, i}]));
        dist2_o = euclid(FFT_avg(:, :, 4), mean([fftOneVowel{j, i}]));
        dist2_u = euclid(FFT_avg(:, :, 5), mean([fftOneVowel{j, i}]));
        [dist, minPosFFT] = min([dist2_a; dist2_e; dist2_i; dist2_o; dist2_u]);
        folders_name2 = cellstr(folders_name2);
       
%         
%         firstFile = char(folders_name(i, :));
%         original = char(vowels_name(j, :));
%         compare = char(vowels_name(minPosMFCC, :));
%         fileID = fopen("Result2.csv","a+");
%         count = count + 1;
%         fprintf(fileID,'%d,',count);
%         fprintf(fileID,'%s,',strcat(firstFile,'/',original));
%         fprintf(fileID,'%s,',compare);
% 
%         
%         if (j == minPosMFCC)
%             fprintf(fileID,'%s',"Đúng");
%             countCorrect = countCorrect + 1;
%         else    
%             fprintf(fileID,'%s',"Sai");
%         end
%        
%         fprintf(fileID,'\n');


        
        firstFile = char(folders_name(i, :));
        original = char(vowels_name(j, :));
        compare2 = char(vowels_name(minPosMFCC, :));
        compare1 = char(vowels_name(minPosFFT, :));
        fileID = fopen("Result2.csv","a+");
        count = count + 1;
        fprintf(fileID,'%d,',count);
        fprintf(fileID,'%s,',strcat(firstFile,'/',original));
        fprintf(fileID,'%s,',compare1);

        if (j == minPosFFT)
            fprintf(fileID,'%s',"Đúng,");
            countCorrectFFT = countCorrectFFT + 1;
        else    
            fprintf(fileID,'%s',"Sai,");
        end
        fprintf(fileID,'%s,',compare2);
        if (j == minPosMFCC)
            fprintf(fileID,'%s',"Đúng");
            countCorrectMFCC = countCorrectMFCC + 1;
        else    
            fprintf(fileID,'%s',"Sai");
        end
       
        fprintf(fileID,'\n');
        
        %[minDist, minPos] = Euclidean_Distance_Vowel(MFCC_avg, Matrix_Average([mfccOneVowel{j, i}]));
        
        %Ma tran nham lan cua mfcc
        confusionMatrixMFCC(j, minPosMFCC)= confusionMatrixMFCC(j, minPosMFCC) + 1;
        
        %Ma tran nham lan cua fft
        confusionMatrixFFT(j, minPosFFT)= confusionMatrixFFT(j, minPosFFT) + 1;
    end
end

    subplot(6,1,6)
    percent = countCorrectMFCC /105  * 100;
     percentFFT = countCorrectFFT /105  * 100;
    txt = 'Số lượng file đúng (MFCC): ';
    txtt = 'Số lượng file đúng (FFT): ';
    txt2 = strcat(txt,num2str(percent),'%');
    txt3 = strcat(txtt,num2str(percentFFT),'%');
    text(0,0.7,txt2,'FontSize',10)
    text(0,0.3,txt3,'FontSize',10)
    
    t = readtable('Result2.csv');
    t
    vars = {'Serial','Original','IdentificationFFT','ResultFFT','IdentificationMFCC','ResultMFCC'};
    t = t(1:105,vars);
    fig = uifigure;
    fig.Position(3:4) = [500 200];
    txt_title = uicontrol('Style', 'text','String', 'My Example Title');
    uit = uitable(fig,'Data',t);
    styleIndices = 'Sai';
    uis = uistyle('HorizontalAlignment', 'center'); 
    addStyle(uit, uis, 'Column', 1)
    uit.ColumnSortable = true;
    s = uistyle('BackgroundColor','#F5DEB3');
    addStyle(uit,s,'column',3)
    addStyle(uit,s,'column',4)

%     t = readtable('Result.csv');
%     t3_data=t
%     vars = {'Serial','Original','IdentificationMFCC','Result'};
%     t = t(1:105,vars);
%     fig = uifigure;
%     fig.Position(3:4) = [500 200];
%     txt_title = uicontrol('Style', 'text','String', 'My Example Title');
%     uit = uitable(fig,'Data',t);
%     styleIndices = 'Sai';
%     uis = uistyle('HorizontalAlignment', 'center'); 
%     addStyle(uit, uis, 'Column', 1)
%     uit.ColumnSortable = true;
    
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
