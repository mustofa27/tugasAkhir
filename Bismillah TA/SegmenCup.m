function [cup,area,green] = SegmenCup(I)   
    green = I(:,:,2);
    green = Preprocessing(green,'cup');
    level = HistogramSmoothing(green);
    iBw = im2bw(green,level);
    iBw = imdilate(iBw,strel('disk',50));
    iBw = imerode(iBw,strel('disk',50));
    stats = regionprops(iBw,'basic');
    [b,idx] = sort([stats.Area],'ascend');
    l = double(int64((mean2(b)+b(1))/2));
    iBw = bwareaopen(iBw, l);
    cup = iBw;  
    area = sum(sum(cup));
end