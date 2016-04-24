function [img_o ] = CobelDetection(img)
    MZ = 1;
    IMG_ROWS = K60Server.imageHeight;
    IMG_COLS = K60Server.imageWidth;
    COBEL_THRES = 34;
    imgCobel = zeros(IMG_ROWS,IMG_COLS);
    
    
    for (i = 2:IMG_COLS-4)
        for (j = 1:IMG_ROWS-4);
            gx1 = img(MZ + j    ,MZ + i + 2) - img(MZ + j    , MZ + i);
            gx2 = img(MZ + j + 1,MZ + i + 2) - img(MZ + j + 1, MZ + i);
            gx3 = img(MZ + j + 2,MZ + i + 2) - img(MZ + j + 2, MZ + i);
            gx  = gx1 + 2 * gx2 + gx3;
            
            gy1 = img(MZ + j,MZ + i)     - img(MZ + j + 2, MZ + i);
            gy2 = img(MZ + j,MZ + i + 1) - img(MZ + j + 2, MZ + i + 1);
            gy3 = img(MZ + j,MZ + i + 2) - img(MZ + j + 2, MZ + i + 2);
            gy  = gy1 + 2 * gy2 + gy3;
            
            g= abs(gx)+abs(gy);
            
            imgCobel(MZ + j, MZ + i)=g/5;
        end
    end
    disp(max(imgCobel(:)));
    img_o = imgCobel>COBEL_THRES;
end

