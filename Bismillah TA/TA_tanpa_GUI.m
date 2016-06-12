[filename, user_canceled] = imgetfile;
if (user_canceled == 0)
    I = imread(filename);
    [disk,index,diskArea] = DiscSegmentation(I);
    blood = BloodVessel(I(:,:,2),disk);
    [cup,cupArea,green] = SegmenCup(I);
    CupToDiskRatio = sqrt(cupArea/diskArea);
    bloodISNT = ISNTBlood(blood);
    [imNrr,nrrISNT] = NRR(cup,disk);
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
    subplot(3,3,3),imshow(disk),title('Segmented disk');
    subplot(3,3,4),imshow(I(:,:,2)),title('Green Channel');
    subplot(3,3,5),imshow(green),title('Preprocessed cup');
    subplot(3,3,6),imshow(cup),title('Segmented cup');
    subplot(3,3,7),imshow(blood),title('Blood Vessel');
    subplot(3,3,9),imshow(imNrr),title('Neuro Retinal Rim');
    subplot(3,3,8),text(0.2,0.5,hasil);
end