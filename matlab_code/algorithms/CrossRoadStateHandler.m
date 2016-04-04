function [currdir currspd]=CrossroadStateHandler(img_buffer)
%constants
TrackWidth =...
    [34,35,35,36,37,37,38,39,40,40,...
    42,42,43,43,45,45,45,47,47,48,...
    49,50,50,51,51,52,53,53,53,55,...
    55,56,57,57,58,58,59,60,60,61,...
    61,62,63,63,64,64,64,66,66,66,...
    67,67,69,69,69,70,70,70,70,71,...
    72,72,72,73,73,74,75];
DIS_ROW             = uint8(4);
DIS_COL             = uint8(3);
IMG_ROWS            = size(img_buffer,1);
IMG_COLS            = size(img_buffer,2);
TRUE                = 1;
FALSE               = 0;
MZ                  = 0;
WHITE_THRES         = 60;

row                 = uint8(0);
col                 = uint8(0);
LBound              = uint8(zeros(IMG_ROWS,1));
RBound              = uint8(zeros(IMG_ROWS,1));
isLCaptured         = uint8(zeros(IMG_ROWS,1));
isRCaptured         = uint8(zeros(IMG_ROWS,1));



%OldDetectBoundary
for (row = IMG_ROWS - 1 - DIS_ROW - 1: -1 : 1)
    for (col = DIS_COL : IMG_COLS  - DIS_COL)
        if (img_buffer(MZ + row, MZ + col) > WHITE_THRES...
                && img_buffer(MZ + row, MZ + col - 1) < WHITE_THRES...
                && img_buffer(MZ + row, MZ + col + 1) > WHITE_THRES)
            LBound(MZ + row) = col;
            isLCaptured(MZ + row)= TRUE;
            break;
        end
    end
    for (col = IMG_COLS  - DIS_COL: -1 : DIS_COL)
        if (img_buffer(MZ + row, MZ + col) > WHITE_THRES...
                && img_buffer(MZ + row, MZ + col - 1) > WHITE_THRES...
                && img_buffer(MZ + row, MZ + col + 1) < WHITE_THRES)
            RBound(MZ + row) = col;
            isRCaptured(MZ + row) = TRUE;
            break;
        end
    end
end

%Dir and Speed Control
%constants
DIRSENSITIVITY      = 10;
EXCEPT_RANGE        = 3;

g_nDirPos           = int16(IMG_COLS);
nShift              = int16(0);
nDenom              = int16(0);
s16temp             = int16(0);
for (row=IMG_ROWS-DIS_ROW:-1:1)
    if (isLCaptured(MZ + row)&& isRCaptured(MZ + row))
        g_nDirPos = int16( (LBound(MZ + row)+RBound(MZ + row)) );
        break;
    elseif (isLCaptured(MZ + row))
        g_nDirPos = int16( 2*LBound(MZ + row) + TrackWidth(MZ + row) );
        break;
    elseif (isRCaptured(MZ + row))
        g_nDirPos = int16( 2*RBound(MZ + row) - TrackWidth(MZ + row) );
        break;
    end
end
s16temp = g_nDirPos;
for (row=row:-1:1)
    if (isLCaptured(MZ + row)&& isRCaptured(MZ + row))
        s16temp = int16( insert_in(LBound(MZ + row)+RBound(MZ + row),...
            s16temp - EXCEPT_RANGE, s16temp + EXCEPT_RANGE) );
        nShift = nShift + (s16temp-IMG_COLS);
        nDenom = nDenom + 1;
    elseif (isLCaptured(MZ + row))
        s16temp = int16( insert_in(LBound(MZ + row)*2+TrackWidth(MZ + row),...
            s16temp - EXCEPT_RANGE, s16temp + EXCEPT_RANGE) );
        nShift = nShift + (s16temp-IMG_COLS);
        nDenom = nDenom + 1;
    elseif (isRCaptured(MZ + row))
        s16temp = int16( insert_in(RBound(MZ + row)*2-TrackWidth(MZ + row),...
            s16temp - EXCEPT_RANGE, s16temp + EXCEPT_RANGE) );
        nShift = nShift + (s16temp-IMG_COLS);
        nDenom = nDenom + 1;
    end
    
end
if (nDenom~=0) 
    g_nDirPos=nShift/nDenom;
else
    g_nDirPos=g_nDirPos-IMG_COLS;
end
currdir = g_nDirPos * DIRSENSITIVITY;
currspd = 10;
end



function d=insert_in(a,b,c)
%insert_in(a,b,c) ((a)<(b)?(b):(a)>(c)?c:a)
if a<b
    d=b;
elseif a>c
    d=c;
else
    d=b;
end
end