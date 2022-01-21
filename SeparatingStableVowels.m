
function [first_index_stable, last_index_stable, Sig, fs] = SeparatingStableVowels(folders_name, vowels_name)
    global count;
    count = 0;
    global thresholdArray;
    thresholdArray = [];
    global nguongmean;
    nguongmean = 0;
    global thresholdArrayTay;
    thresholdArrayTay = 0;
    path = 'D:\ITBOOK\ThirdYear\XuLyTinHieuSo\Thi TH\final\TH-XLTH\NguyenAmHuanLuyen-16k\';
    for i = 1 : length(vowels_name)
        for j = 1 : length(folders_name)
            [STECel, first_index_vowel_frame(i, j), last_index_vowel_frame(i, j), Sig{i, j}, fs] = Bai1(strcat(path, char(folders_name(j, :)), '\\', char(vowels_name(i, :)), '.wav'));
         
            % split 1/3 middle stable frame
            first_index_stable(i, j) = first_index_vowel_frame(i, j) + floor((last_index_vowel_frame(i, j) - first_index_vowel_frame(i, j) + 1) / 3);
            last_index_stable(i, j) = last_index_vowel_frame(i, j) - round((last_index_vowel_frame(i, j) - first_index_vowel_frame(i, j) + 1) / 3);
        end
    end
    hahaha = thresholdArrayTay / count;
    thresholdAvg = mean(thresholdArray);
%     fileID = fopen('haha.txt', 'a+');
%     fprintf(fileID,'%6.4f ', thresholdAvg);
end



