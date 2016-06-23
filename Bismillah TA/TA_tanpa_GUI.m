[filename, user_canceled] = imgetfile;
if (user_canceled == 0)
    I = imread(filename);
    [disk,index,diskArea] = DiscSegmentation(I);
    blood = BloodVessel(I(:,:,2),disk);
    [cup,cupArea,green] = SegmenCup(I);
    %cropping
    [row,col]=find(disk);
    row_t = min(row);
    col_t = min(col);
    disk1 = disk;
    cup1 = cup;
    blood1 = blood;
    %%%%%%%%%%%%%
    disk = imcrop(disk,[col_t row_t max(col)-col_t max(row)-row_t]);
    %%%%%%%%%%%%%
    cup = imcrop(cup,[col_t row_t max(col)-col_t max(row)-row_t]);
    %%%%%%%%%%%%%
    blood = imcrop(blood,[col_t row_t max(col)-col_t max(row)-row_t]);
    %%%%%%%%%%%%%
    CupToDiskRatio = sqrt(cupArea/diskArea);
    bloodISNT = ISNTBlood(blood);
    [imNrr,nrrISNT] = NRR(cup,disk);
    newData = csvread('newdataTA_Train.csv');
    newDataset = [newData(:,1) newData(:,2) newData(:,3)];
    newGroup = newData(:,4);
    svmModel = svmtrain(newDataset, newGroup, ...
                 'Autoscale',true, 'Showplot',false, 'Method','SMO', ...
                 'BoxConstraint',2e-1, 'Kernel_Function','linear');
             pred = svmclassify(svmModel, [CupToDiskRatio nrrISNT bloodISNT], 'Showplot',false);
    if pred == 1
        hasil = 'Glaukoma';
    else
        hasil = 'Normal';
    end
    
    subplot(3,3,1),imshow(I(:,:,1)),title('Red Channel');
    subplot(3,3,2),imshow(Preprocessing(I(:,:,1),'disk')),title('Preprocessed disk');
    subplot(3,3,3),imshow(disk1),title('Segmented disk');
    subplot(3,3,4),imshow(I(:,:,2)),title('Green Channel');
    subplot(3,3,5),imshow(green),title('Preprocessed cup');
    subplot(3,3,6),imshow(cup1),title('Segmented cup');
    subplot(3,3,7),imshow(blood1),title('Blood Vessel');
    subplot(3,3,9),imshow(imNrr),title('Neuro Retinal Rim');
    subplot(3,3,8),text(0.2,0.5,hasil);
end