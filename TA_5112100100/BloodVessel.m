function y = BloodVessel(greenChan,disk)

    greenChan =  medfilt2(greenChan);
    greenChan = imerode(greenChan,strel('disk',5));
    greenChan = imdilate(greenChan,strel('disk',3));
    
    gr = BottomHat(greenChan,strel('diamond',20));
    level = 2.7*std(std(double(gr)))/255;
    y = im2bw(gr,level);
    y = imopen(y,strel('diamond',5));
    y = imclose(y,strel('diamond',5));
    y = y.*disk;
end