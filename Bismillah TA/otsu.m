function level = otsu(I)
    histogramCounts = imhist(I);
    total = sum(histogramCounts);
    sumB = 0;
    wKelas1 = 0;
    maximum = 0.0;
    histogramCounts = histogramCounts/total;
    sum1 = dot( (0:255), histogramCounts);
    total = sum(histogramCounts);
    for i=1:256
        wKelas1 = wKelas1 + histogramCounts(i);
        if (wKelas1 == 0)
            continue;
        end
        wKelas2 = total - wKelas1;
        if (wKelas2 == 0)
            break;
        end
        sumB = sumB +  (i-1) * histogramCounts(i);
        meanKelas1 = sumB / wKelas1;
        meanKelas2 = (sum1 - sumB) / wKelas2;
        stdAntarKelas = wKelas1 * wKelas2 * (meanKelas1 - meanKelas2) * (meanKelas1 - meanKelas2);
        if ( stdAntarKelas >= maximum )
            level = i-1;
            maximum = stdAntarKelas;
        end
    end
    level = level/255;
end