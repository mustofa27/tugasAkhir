function I = BottomHat(green,SE)
    I = imdilate(green,SE);
    I = imerode(I,SE);
    I = I-green;
end