function [disk , index, area] = DiscSegmentation(I)
    red = I(:,:,1);
    pre = Preprocessing(red,'disk');
    level = HistogramSmoothing(pre,'disk');
    iBw = im2bw(pre,level);
    
    iBw = imerode(iBw,strel('disk',50));
    stats = regionprops(iBw,'basic');
    [b,idx] = sort([stats.Area],'descend')
    index = stats(idx(1)).Centroid;
    index = int32(index);
    iBw = bwareaopen(iBw, b(1));
    iBw = imdilate(iBw,strel('disk',50));
    disk = iBw;
    area = sum(sum(disk));
end