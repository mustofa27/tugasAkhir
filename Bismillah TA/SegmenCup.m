function [cup,area,green] = SegmenCup(I)   
    green = I(:,:,2);
    I = Preprocessing(green,'cup');
    level = HistogramSmoothing(I,'cup');
    iBw = im2bw(I,level);
    iBw = imdilate(iBw,strel('disk',50));
    iBw = imerode(iBw,strel('disk',50));
    stats = regionprops(iBw,'basic');
    [b,idx] = sort([stats.Area],'ascend');
    l = double(int64((mean2(b)+b(1))/2));
    iBw = bwareaopen(iBw, l);
    cup = iBw;
    
    area = sum(sum(cup));
    
end