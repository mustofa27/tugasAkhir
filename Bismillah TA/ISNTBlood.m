function y = ISNTBlood(imBlood)
    mask = imread('mask.png');
    mask = im2bw(mask);
    [h,w] = size(imBlood);
    
    mask1 = imresize(mask,[h w]);
    temporal = sum(sum(imBlood.*mask1));
    mask = imrotate(mask,90);
    mask1 = imresize(mask,[h w]);
    superior = sum(sum(imBlood.*mask1));
    mask = imrotate(mask,90);
    mask1 = imresize(mask,[h w]);
    nasal = sum(sum(imBlood.*mask1));
    mask = imrotate(mask,90);
    mask1 = imresize(mask,[h w]);
    inferior = sum(sum(imBlood.*mask1));
    if(nasal+temporal == 0)
        y = 0;
    else
        y = (superior+inferior)/(nasal+temporal);
    end
end