function [LBoundary,RBoundary] = BoundaryDetector(currentState)
IMG_ROWS=size(currentState.img_buffer,1);
IMG_COLS=size(currentState.img_buffer,2);

%constant
TRUE              = int32(1);
FALSE             = int32(0);
DIS_ROW           = uint8(4);
DIS_COL           = uint8(3);
MZ                = uint8(1);
LBEGIN_SCAN       = uint8(DIS_COL);
LEND_SCAN         = uint8(IMG_COLS / 2);
WHITE_THRES       = int32(60);
START_LINE_HEIGHT = uint8(10);
BOUNDARY_LENGTH   = int32(300);

DIR_LEFT          = int32(0);
DIR_UP            = int32(1);
DIR_RIGHT         = int32(2);
DIR_DOWN          = int32(3);
%input: rawframe
%rawframe=f;
%output: rBoundary
%        lBoundary
Boundary=uint8(zeros(BOUNDARY_LENGTH,2));
LBoundary=uint8(zeros(BOUNDARY_LENGTH,2));
RBoundary=uint8(zeros(BOUNDARY_LENGTH,2));
endPoint=uint8(zeros(8,1));
row  = uint8(0);
col  = uint8(0);
step = uint8(0);
currBoundaryPtr = uint8(0);
isCaptured = uint8(FALSE);
for (row = IMG_ROWS - 1 - DIS_ROW - 1: -1 :...
        IMG_ROWS - 1 - DIS_ROW - 1 - START_LINE_HEIGHT)
    for (col = LBEGIN_SCAN : LEND_SCAN)
        if (currentState.img_buffer(MZ + row, MZ + col) > WHITE_THRES...
                && currentState.img_buffer(MZ + row, MZ + col - 1) < WHITE_THRES...
                && currentState.img_buffer(MZ + row, MZ + col + 1) > WHITE_THRES)
            Boundary(MZ + 0, MZ + 0) = row;
            Boundary(MZ + 0, MZ + 1) = col;
            isCaptured = TRUE;
            break;
        end
    end
    if (isCaptured)
        break;
    end
end
if (isCaptured)
    row = Boundary(MZ + 0, MZ + 0);
    col = Boundary(MZ + 0, MZ + 1);
    currBoundaryPtr = currBoundaryPtr + 1;
else
    row = IMG_ROWS - 1 - DIS_ROW - 1 ;
    col = LBEGIN_SCAN;
end

lastDirection         = uint8(DIR_UP);
isMoveable            = uint8(TRUE);
stepCounter           = uint8(0);
uncapturedStepCounter = uint8(0);
sectionTail           = uint8(zeros(5,1));
sectionHead           = uint8(zeros(5,1));
sectionCounter        = uint8(1);
while (isMoveable && row < IMG_ROWS - DIS_ROW -1 && stepCounter < 255)
    moveDirX=[-1,0,1,0];
    moveDirY=[0,-1,0,1];
    crit=[col > DIS_COL, row > 1, ...
        col < IMG_COLS - DIS_COL - 1, row < IMG_ROWS - DIS_ROW];
    isMoveable = FALSE;
    for( step = 0 : 3 )
        nextDir=mod(lastDirection + step + 3 , 4);
        if(currentState.img_buffer(MZ+ row+ moveDirY(MZ + nextDir), ...
                MZ+col+moveDirX(MZ + nextDir))> WHITE_THRES ...
                && crit(MZ+nextDir) ...
                )
            isMoveable       = TRUE;
            col              = col + moveDirX(MZ + nextDir);
            row              = row + moveDirY(MZ + nextDir);
            lastDirection    = nextDir;
            break;
        end
    end
    
    stepCounter = stepCounter + 1;
    %find out boundary
    if (      (currentState.img_buffer(MZ + row    , MZ + col + 1) < WHITE_THRES...
            || currentState.img_buffer(MZ + row    , MZ + col - 1) < WHITE_THRES...
            || currentState.img_buffer(MZ + row + 1, MZ + col    ) < WHITE_THRES...
            || currentState.img_buffer(MZ + row - 1, MZ + col    ) < WHITE_THRES)...
            &&(currentState.img_buffer(MZ + row    , MZ + col + 1) > WHITE_THRES...
            || currentState.img_buffer(MZ + row    , MZ + col - 1) > WHITE_THRES...
            || currentState.img_buffer(MZ + row + 1, MZ + col    ) > WHITE_THRES...
            || currentState.img_buffer(MZ + row - 1, MZ + col    ) > WHITE_THRES)...
            )%need improvement
        Boundary(MZ + currBoundaryPtr, MZ + 0) = row;
        Boundary(MZ + currBoundaryPtr, MZ + 1) = col;
        currBoundaryPtr = currBoundaryPtr + 1;
        uncapturedStepCounter = 0;
    else
        uncapturedStepCounter = uncapturedStepCounter + 1;
    end
    
    %divide the boundary
    if ( sectionHead(MZ + sectionCounter - 1) ~= currBoundaryPtr ...
            &&(((col ==  IMG_COLS - DIS_COL - 1  || row == 1 ...
            || col == DIS_COL ) ...
            && uncapturedStepCounter > 3) ...
            || ~(isMoveable && row < IMG_ROWS - DIS_ROW -1 ...
            && stepCounter < 255)) )
        if (currBoundaryPtr -1 ...
                - sectionHead(MZ + sectionCounter - 1) > 0 ...
                && currBoundaryPtr - 1 ...
                - sectionHead(MZ + sectionCounter - 1) < 20)
            sectionHead(MZ + sectionCounter - 1) = currBoundaryPtr;
        else
            sectionTail(MZ + sectionCounter - 1) =...
                currBoundaryPtr - 1;
            endPoint(MZ + 2 * (sectionCounter - 1)) =...
                guideLoc(Boundary(MZ + sectionTail(MZ + sectionCounter - 1),:));
            endPoint(MZ + 2 * (sectionCounter - 1)+1) =...
                guideLoc(Boundary(MZ + sectionHead(MZ + sectionCounter - 1),:));
            sectionCounter = sectionCounter +1;
            sectionHead(MZ + sectionCounter - 1) = currBoundaryPtr;
        end
    end
    
end

% code for drawing convinience not for c

if (~isempty(Boundary))
    switch sectionCounter
        case 5
            LBoundary = Boundary(MZ + sectionHead(1) :...
                MZ + sectionTail(2),:);
            RBoundary = Boundary(MZ + sectionHead(3) : ...
                MZ + sectionTail(4), : );
        case 4
            endPoint(5:6)=0;
            LBoundary=Boundary(MZ + sectionHead(1) : MZ + sectionTail(1),:);
            RBoundary=Boundary(MZ + sectionHead(2) : MZ + sectionTail(2),:);
        case 3
            LBoundary=Boundary(MZ + sectionHead(1) : MZ + sectionTail(1),:);
            RBoundary=Boundary(MZ + sectionHead(2) : MZ + sectionTail(2),:);
        case 2
            if (Boundary(MZ + sectionHead(1), MZ + 0)<Boundary(MZ + sectionTail(1),MZ + 0))
                RBoundary=Boundary(MZ + sectionHead(1):sectionTail(1),:);
            else
                LBoundary=Boundary(MZ + sectionHead(1):sectionTail(1),:);
            end
    end
end

if sum(LBoundary)>0
    LBoundary=LBoundary+1;
else
    LBoundary=[];
end

if sum(RBoundary)>0
    RBoundary=RBoundary+1;
else
    RBoundary=[];
end

end

function endPoint=guideLoc(point)
MZ=1;
DIS_COL=3;
IMG_COLS=77;
IMG_ROWS=67;
endPoint=0;
if (point(1)<IMG_ROWS/2)
    endPoint=endPoint+4;
end
if (point(2)>IMG_COLS/2)
    endPoint=endPoint+2;
end
if (point(2)>=MZ+IMG_COLS-DIS_COL-3 || point(2)<=MZ+DIS_COL+2)
    endPoint=endPoint+2;
else
    endPoint=endPoint+1;
end
end

