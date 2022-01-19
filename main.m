clc; close all; clear all;

folders_name = ['01MDA' '02FVA' '03MAB' '04MHB' '05MVB' '06FTB' '07FTC' '08MLD' '09MPD' '10MSD' '11MVD' '12FTD' '14FHH' '15MMH' '16FTH' '17MTH' '18MNK' '19MXK' '20MVK' '21MTL' '22MHL'];
path = 'C:\Users\ASUS\OneDrive\Desktop\Thi TH 2\NguyenAmHuanLuyen-16k\';

% folders_name = ['23MTL' '24FTL' '25MLM' '27MCM' '28MVN' '29MHN' '30FTN' '32MTP' '33MHP' '34MQP' '35MMQ' '36MAQ' '37MDS' '38MDS' '39MTS' '40MHS' '41MVS' '42FQT' '43MNT' '44MTT' '45MDV'];
% path = 'C:\Users\ASUS\OneDrive\Desktop\Thi TH 2\NguyenAmKiemThu-16k\';
num_files = length(folders_name) / 5;
vowels = ['a' 'e' 'i' 'o' 'u'];

%tao mang luu cac tong cac vector dac trung mfcc tinh duoc tu 105 file
sum_a = 0;
sum_e  = 0;
sum_i  = 0;
sum_o =0;
sum_u =0;

confusionMatrix = zeros(5);

i = 1;
for j = 1 : num_files
    tg = [folders_name(i) folders_name(i+1) folders_name(i+2) folders_name(i+3) folders_name(i+4)];
    
    %lay duoc duong dan tuyet doi
    file_name_a = [path tg '\a.wav']; %doc cac file la nguyen am A
    file_name_e = [path tg '\e.wav']; %doc cac file la nguyen am E
    file_name_i = [path tg '\i.wav']; %doc cac file la nguyen am I
    file_name_o = [path tg '\o.wav']; %doc cac file la nguyen am O
    file_name_u = [path tg '\u.wav']; %doc cac file la nguyen am U
    
    %doc tin hieu
    [data1, fs1] = audioread(file_name_a);
    [data2, fs2] = audioread(file_name_e);
    [data3, fs3] = audioread(file_name_i);
    [data4, fs4] = audioread(file_name_o);
    [data5, fs5] = audioread(file_name_u);
    
    %tinh tong cac vector mfcc theo tung nguyen am
    sum_a = sum_a + do_task(data1,fs1);  
    sum_e = sum_e + do_task(data2,fs2);   
    sum_i = sum_i + do_task(data3,fs3);   
    sum_o = sum_o + do_task(data4,fs4);   
    sum_u = sum_u + do_task(data5,fs5);   
    
    i = i + 5;
end

%tinh trung binh cac vector mfcc cua tung nguyen am
avg_a = sum_a / num_files;
avg_e = sum_e / num_files;
avg_i = sum_i / num_files;
avg_o = sum_o / num_files;
avg_u = sum_u / num_files;

%chay lai 105 file nguyen am de tinh do chinh xác
i = 1;
correct = 0;
for j = 1 : num_files
    tg = [folders_name(i) folders_name(i+1) folders_name(i+2) folders_name(i+3) folders_name(i+4)];
    
    file_name_a = [path tg '\a.wav']; %doc cac file la nguyen am A
    file_name_e = [path tg '\e.wav']; %doc cac file la nguyen am E
    file_name_i = [path tg '\i.wav']; %doc cac file la nguyen am I
    file_name_o = [path tg '\o.wav']; %doc cac file la nguyen am O
    file_name_u = [path tg '\u.wav']; %doc cac file la nguyen am U
    
    [data1, fs1] = audioread(file_name_a);
    [data2, fs2] = audioread(file_name_e);
    [data3, fs3] = audioread(file_name_i);
    [data4, fs4] = audioread(file_name_o);
    [data5, fs5] = audioread(file_name_u);
    
    %Tinh khoang cach -  Euclid cho tung nguyen am
    %A
    mfcc_a = do_task(data1,fs1);
    dist2_a = euclid(mfcc_a, avg_a);
    dist2_e = euclid(mfcc_a, avg_e);
    dist2_i = euclid(mfcc_a, avg_i);
    dist2_u = euclid(mfcc_a, avg_u);
    dist2_o = euclid(mfcc_a, avg_o);
    dist_1 = [dist2_a, dist2_e, dist2_i, dist2_u, dist2_o];
   
    if(minimum(dist_1) == dist2_a)
        correct = correct + 1;
        confusionMatrix(1,1) = confusionMatrix(1,1) + 1;
    elseif(minimum(dist_1) == dist2_e)
        confusionMatrix(1, 2) = confusionMatrix(1, 2)  + 1;
    elseif(minimum(dist_1) == dist2_i)
        confusionMatrix(1, 3) = confusionMatrix(1, 3)  + 1;
    elseif(minimum(dist_1) == dist2_o)
         confusionMatrix(1, 4) = confusionMatrix(1,4)  + 1;
    elseif(minimum(dist_1) == dist2_u)
         confusionMatrix(1, 5) = confusionMatrix(1, 5)  + 1;
    end
 
     %E
    mfcc_e = do_task(data2,fs2);   
    dist2_a = euclid(mfcc_e, avg_a);
    dist2_e = euclid(mfcc_e, avg_e);
    dist2_i = euclid(mfcc_e, avg_i);
    dist2_u = euclid(mfcc_e, avg_u);
    dist2_o = euclid(mfcc_e, avg_o);
    dist_5 = [dist2_a, dist2_e, dist2_i, dist2_u, dist2_o];
  
    if(minimum(dist_5) == dist2_e)
        correct = correct + 1;
        confusionMatrix(2,2) = confusionMatrix(2,2) + 1;
    elseif(minimum(dist_5) == dist2_a)
        confusionMatrix(2, 1) = confusionMatrix(2, 1)  + 1;
    elseif(minimum(dist_5) == dist2_i)
        confusionMatrix(2, 3) = confusionMatrix(2, 3)  + 1;
    elseif(minimum(dist_5) == dist2_o)
         confusionMatrix(2, 4) = confusionMatrix(2,4)  + 1;
    elseif(minimum(dist_5) == dist2_u)
         confusionMatrix(2, 5) = confusionMatrix(2, 5)  + 1;
    end
    
    %I
    mfcc_i = do_task(data3,fs3);   
    dist2_a = euclid(mfcc_i, avg_a);
    dist2_e = euclid(mfcc_i, avg_e);
    dist2_i = euclid(mfcc_i, avg_i);
    dist2_u = euclid(mfcc_i, avg_u);
    dist2_o = euclid(mfcc_i, avg_o);
    dist_2 = [dist2_a, dist2_e, dist2_i, dist2_u, dist2_o];
   
    if(minimum(dist_2) == dist2_i)
        correct = correct + 1;
     confusionMatrix(3,3) = confusionMatrix(3,3) + 1;
    elseif(minimum(dist_2) == dist2_e)
        confusionMatrix(3, 2) = confusionMatrix(3, 2)  + 1;
    elseif(minimum(dist_2) == dist2_a)
        confusionMatrix(3, 1) = confusionMatrix(3, 1)  + 1;
    elseif(minimum(dist_2) == dist2_o)
         confusionMatrix(3, 4) = confusionMatrix(3,4)  + 1;
    elseif(minimum(dist_2) == dist2_u)
         confusionMatrix(3, 5) = confusionMatrix(3, 5)  + 1;
    end
    
  %O
    mfcc_o = do_task(data4,fs4);   
    dist2_a = euclid(mfcc_o, avg_a);
    dist2_e = euclid(mfcc_o, avg_e);
    dist2_i = euclid(mfcc_o, avg_i);
    dist2_u = euclid(mfcc_o, avg_u);
    dist2_o = euclid(mfcc_o, avg_o);
    dist_3 = [dist2_a, dist2_e, dist2_i, dist2_u, dist2_o];
    
    if(minimum(dist_3) == dist2_o)
        correct = correct + 1;
    confusionMatrix(4,4) = confusionMatrix(4,4) + 1;
    elseif(minimum(dist_3) == dist2_e)
        confusionMatrix(4, 2) = confusionMatrix(4, 2)  + 1;
    elseif(minimum(dist_3) == dist2_i)
        confusionMatrix(4, 3) = confusionMatrix(4, 3)  + 1;
    elseif(minimum(dist_3) == dist2_a)
         confusionMatrix(4, 1) = confusionMatrix(4,1)  + 1;
    elseif(minimum(dist_3) == dist2_u)
         confusionMatrix(4, 5) = confusionMatrix(4, 5)  + 1;
    end
    
    %U
    mfcc_u = do_task(data5,fs5);
    dist2_a = euclid(mfcc_u, avg_a);
    dist2_e = euclid(mfcc_u, avg_e);
    dist2_i = euclid(mfcc_u, avg_i);
    dist2_u = euclid(mfcc_u, avg_u);
    dist2_o = euclid(mfcc_u, avg_o);
    dist_4= [dist2_a, dist2_e, dist2_i, dist2_u, dist2_o];
   
    if(minimum(dist_4) == dist2_u)
        correct = correct + 1;
        confusionMatrix(5,5) = confusionMatrix(5,5) + 1;
    elseif(minimum(dist_4) == dist2_e)
        confusionMatrix(5, 2) = confusionMatrix(5, 2)  + 1;
    elseif(minimum(dist_4) == dist2_i)
        confusionMatrix(5, 3) = confusionMatrix(5, 3)  + 1;
    elseif(minimum(dist_4) == dist2_o)
         confusionMatrix(5, 4) = confusionMatrix(5,4)  + 1;
    elseif(minimum(dist_4) == dist2_a)
         confusionMatrix(5, 1) = confusionMatrix(5, 1)  + 1;
    end
    
    i = i + 5;
end

fprintf('So Files xac dinh dung: %d/105 Files\n', correct);
fprintf('Do chinh xac nhan dang: %0.2f phan tram\n', (correct / 105 ) * 100);
%xuat dac trung trung binh cua 5 nguyen am 

dactrung_mfcc(avg_a, avg_e, avg_e, avg_i, avg_o);
confusionMatrix
% dactrung_fft(avg_a, avg_e, avg_e, avg_i, avg_o);



