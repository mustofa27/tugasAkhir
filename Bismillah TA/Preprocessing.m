function y = Preprocessing(x,tipe)
    y = double(x);
    y1 = double(x);
    if(strcmp(tipe,'disk') == 1)
        y = imdilate(y,strel('disk',25));
        y = imerode(y,strel('disk',25));
    end 
    tmp = y1(:);
    xBar = mean(tmp)
    xStd = std(tmp)
    if(strcmp(tipe,'disk') == 1)
        y1 = y1-(xBar);
        y = y-(xBar);
    elseif (strcmp(tipe,'cup') == 1)
        y1 = y1-(xBar+xStd);
        y = y-(xBar+xStd);
    end
    if(strcmp(tipe,'disk') == 1)
        iter = 5; 
    else
        iter = 7;
    end
    y = uint8(y);
    x = y;
    x(x==0) = max(max(y));
    for i = 1 : iter
        y = uint8(y - min(min(x)));
    end
end