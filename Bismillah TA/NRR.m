function [imNrr,y] = NRR(imCup,imDisk)
    mask = imread('mask.png');
    mask = im2bw(mask);
    imNrr = logical(imDisk .* (1-imCup));
    [h,w] = size(imNrr);
    
    mask1 = imresize(mask,[h w]);
    temporal = sum(sum(imNrr.*mask1));
    mask = imrotate(mask,90);
    mask1 = imresize(mask,[h w]);
    superior = sum(sum(imNrr.*mask1));
    mask = imrotate(mask,90);
    mask1 = imresize(mask,[h w]);
    nasal = sum(sum(imNrr.*mask1));
    mask = imrotate(mask,90);
    mask1 = imresize(mask,[h w]);
    inferior = sum(sum(imNrr.*mask1));
    y = (superior+inferior)/(nasal+temporal);
end