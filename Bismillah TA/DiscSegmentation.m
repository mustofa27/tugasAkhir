function [disk , index, area] = DiscSegmentation(I)
    red = I(:,:,1);
    pre = Preprocessing(red,'disk');
    level = pre(:);
    level(level == 0) = max(level);
    mini = min(level);
    level = pre(:);
    level(level == 0) = NaN;
    rerata = nanmean(level);
    rerata = (mini + rerata)/2;
    iBw = pre>(mini + rerata)/2;
    
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