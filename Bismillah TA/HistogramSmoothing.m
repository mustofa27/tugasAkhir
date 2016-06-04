function y = HistogramSmoothing(Image,tipe)
    [p,val] = imhist(Image);
    p = p./numel(Image); % <== p(x) original histogram
    mean = 50;
    sigma = 6;
    f = normpdf(0:100,mean,sigma); % <== f(x) gaussian distribution
    p1 = conv(p,f); % <== p'(x) new histogram after applying gaussian filtering
    y = graythresh(p1);
end