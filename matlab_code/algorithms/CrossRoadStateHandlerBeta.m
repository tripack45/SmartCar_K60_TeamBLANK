function [currdir currspd]=CrossRoadStateHandlerBeta(currentState)
%constants
TRACKWIDTH      = 70;
boundaryPTR     = uint8(0);
IMG_ROWS        = 150;
IMG_COLS        = 150;
LBoundarycol    = uint8(zeros(IMG_ROWS,1));
RBoundarycol    = uint8(zeros(IMG_ROWS,1));
MZ              = 1;
DIS_ROW         = uint8(5);



%DetectBoundary
for (boundaryPTR = 0: currentState.LBoundarySize-1)
    if (~LBoundarycol(MZ + currentState.LBoundaryY(MZ + boundaryPTR)))
        LBoundarycol(MZ + currentState.LBoundaryY(MZ + boundaryPTR)) =...
            currentState.LBoundaryX(MZ + boundaryPTR);
    end
end
for (boundaryPTR = 0: currentState.RBoundarySize-1)
    if (~RBoundarycol(MZ + currentState.RBoundaryY(MZ + boundaryPTR)))
        RBoundarycol(MZ + currentState.RBoundaryY(MZ + boundaryPTR)) =...
            currentState.RBoundaryX(MZ + boundaryPTR);
    end
end



%Dir and Speed Control
%constants
DIRSENSITIVITY      = 10;
EXCEPT_RANGE        = 3;

row                 = uint8(0);
g_nDirPos           = int16(IMG_COLS);
nShift              = int16(0);
nDenom              = int16(0);
s16temp             = int16(0);
for (row=IMG_ROWS-DIS_ROW:-1:1)
    if (LBoundarycol(MZ + row)&& RBoundarycol(MZ +row))
        g_nDirPos = int16( (LBoundarycol(MZ + row)+RBoundarycol(MZ + row)) );
        break;
    elseif (LBoundarycol(MZ + row))
        g_nDirPos = int16( 2*LBoundarycol(MZ + row) + TRACKWIDTH );
        break;
    elseif (RBoundarycol(MZ + row))
        g_nDirPos = int16( 2*RBoundarycol(MZ + row) - TRACKWIDTH );
        break;
    end
end
s16temp = g_nDirPos;
for (row=row:-1:1)
    if (LBoundarycol(MZ + row)&& RBoundarycol(MZ + row))
        s16temp = int16( insert_in(LBoundarycol(MZ + row)+RBoundarycol(MZ + row),...
            s16temp - EXCEPT_RANGE, s16temp + EXCEPT_RANGE) );
        nShift = nShift + (s16temp-IMG_COLS);
        nDenom = nDenom + 1;
    elseif (LBoundarycol(MZ + row))
        s16temp = int16( insert_in(LBoundarycol(MZ + row)*2+TRACKWIDTH,...
            s16temp - EXCEPT_RANGE, s16temp + EXCEPT_RANGE) );
        nShift = nShift + (s16temp-IMG_COLS);
        nDenom = nDenom + 1;
    elseif (RBoundarycol(MZ + row))
        s16temp = int16( insert_in(RBoundarycol(MZ + row)*2-TRACKWIDTH,...
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