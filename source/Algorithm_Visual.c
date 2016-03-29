#include "includes.h"
BoundaryDetector boundary_detector;




u8 InversePerspectiveTransform(u8* xIn,u8* yIn, u8 size){
    u8* xOut=xIn;
    u8* yOut=yIn;
    for(u8 i=0;i<size;i+=SAMPLE_RATE){
        int32 numerator = PERSPECTIVE_SCALE * (xIn[i] - ORIGIN_X) * TRAPZOID_HEIGHT;
        int32 denominator = TRAPZOID_UPPER * TRAPZOID_HEIGHT  
                + (TRAPZOID_LOWER - TRAPZOID_UPPER) * (yIn[i] - 3);
        (*xOut)=numerator/denominator + ORIGIN_X;
        xOut ++; 
        numerator = PERSPECTIVE_SCALE* ALGC2 * (yIn[i] - ORIGIN_Y);
        denominator = REAL_WORLD_SCALE * (10000 - ALGC1 * (yIn[i] - ORIGIN_Y));
        (*yOut)=numerator/denominator + ORIGIN_Y;
        yOut ++;
   }   
   return (xOut - xIn); //Returns number of points processed    
}




void DetectBoundary(){
    u8 endPoint[8];
    u8 row;
    u8 col;
    u8 currBoundaryPtr = 0;
    u8 isCaptured = FALSE;
    for (row = IMG_ROWS - 1 - DIS_ROW - 1;
    row >= IMG_ROWS - 1 - DIS_ROW - 1 - START_LINE_HEIGHT; row--){
        for (col = LBEGIN_SCAN; col <= LEND_SCAN; col++){
            if (img_buffer[MZ + row] [MZ + col] > WHITE_THRES
                    && img_buffer[MZ + row] [MZ + col - 1] < WHITE_THRES
                    && img_buffer[MZ + row] [MZ + col + 1] > WHITE_THRES){
                boundary_detector.boundaryY [MZ + 0] = row;
                boundary_detector.boundaryX [MZ + 0] = col;
                isCaptured = TRUE;
                break;
            }
        }
        if (isCaptured){
            break;
        }
    }
    if (isCaptured){
        row = boundary_detector.boundaryY [MZ + 0] ;
        col = boundary_detector.boundaryX [MZ + 0] ;
        currBoundaryPtr = currBoundaryPtr + 1;
    }else{
        row = IMG_ROWS - 1 - DIS_ROW - 1 ;
        col = LBEGIN_SCAN;
    }

    u8 step;
    u8 lastDirection         = DIR_UP;
    u8 isMoveable            = TRUE;
    u8 stepCounter           = 0;
    u8 uncapturedStepCounter = 0;
    u8 sectionTail[5]        = {0, 0, 0, 0, 0};
    u8 sectionHead[5]        = {0, 0, 0, 0, 0};
    u8 sectionCounter        = 1;
    const u8 moveDirX[4]={-1,0,1,0};
    const u8 moveDirY[4]={0,-1,0,1};
    u8 nextDir;
    while (isMoveable && row < IMG_ROWS - DIS_ROW -1 && stepCounter < 255){
    u8 crit[4]={col > DIS_COL, row > 1,
    col < IMG_COLS - DIS_COL - 1, row < IMG_ROWS - DIS_ROW};
        isMoveable = FALSE;
        for( step = 0; step <=3; step++){
            nextDir = (lastDirection + step + 3) % 4;
            if(img_buffer[MZ+ row+ moveDirY[MZ + nextDir]]
                [MZ+col+moveDirX[MZ + nextDir]]> WHITE_THRES
                && crit[MZ+nextDir]
                ){
                isMoveable       = TRUE;
                col              = col + moveDirX[MZ + nextDir];
                row              = row + moveDirY[MZ + nextDir];
                lastDirection    = nextDir;
                break;
                }
        }

        stepCounter ++;
        //find out boundary_detector.boundary
        if (      (img_buffer[MZ + row    ] [MZ + col + 1] < WHITE_THRES
                || img_buffer[MZ + row    ] [MZ + col - 1] < WHITE_THRES
                || img_buffer[MZ + row + 1] [MZ + col    ] < WHITE_THRES
                || img_buffer[MZ + row - 1] [MZ + col    ] < WHITE_THRES)
                &&(img_buffer[MZ + row    ] [MZ + col + 1] > WHITE_THRES
                || img_buffer[MZ + row    ] [MZ + col - 1] > WHITE_THRES
                || img_buffer[MZ + row + 1] [MZ + col    ] > WHITE_THRES
                || img_buffer[MZ + row - 1] [MZ + col    ] > WHITE_THRES)
            ){//need improvement
            boundary_detector.boundaryY [MZ + currBoundaryPtr] = row;
            boundary_detector.boundaryX [MZ + currBoundaryPtr] = col;
            currBoundaryPtr ++;
            uncapturedStepCounter = 0;
        }else{
            uncapturedStepCounter ++;
        }

        //divide boundary
        if ( sectionHead[MZ + sectionCounter - 1] != currBoundaryPtr
                &&(((col ==  IMG_COLS - DIS_COL - 1  || row == 1
                || col == DIS_COL )
                && uncapturedStepCounter > 3)
                || !(isMoveable && row < IMG_ROWS - DIS_ROW -1
                && stepCounter < 255)) ){
            if (currBoundaryPtr -1
                    - sectionHead[MZ + sectionCounter - 1] > 0
                    && currBoundaryPtr - 1
                    - sectionHead[MZ + sectionCounter - 1] < 20){
                sectionHead[MZ + sectionCounter - 1] = currBoundaryPtr;
            }else{
                sectionTail[MZ + sectionCounter - 1] =
                    currBoundaryPtr - 1;
                endPoint[MZ + 2 * (sectionCounter - 1)] =
                    GuideLoc(boundary_detector.boundaryY
                             [MZ + sectionTail[MZ + sectionCounter - 1]],
                             boundary_detector.boundaryX
                             [MZ + sectionTail[MZ + sectionCounter - 1]]);
                endPoint[MZ + 2 * (sectionCounter - 1)+1] =
                    GuideLoc(boundary_detector.boundaryY
                             [MZ + sectionHead[MZ + sectionCounter - 1]],
                             boundary_detector.boundaryX
                             [MZ + sectionHead[MZ + sectionCounter - 1]]);
                sectionCounter ++;
                sectionHead[MZ + sectionCounter - 1] = currBoundaryPtr;
            }
        }

    }
    switch (sectionCounter){
    case 5: {
      boundary_detector.LSectionHead = sectionHead[1];
      boundary_detector.LSectionTail = sectionTail[2];  
      boundary_detector.RSectionHead = sectionHead[3];  
      boundary_detector.RSectionTail = sectionTail[4];  
      break;
    }
    case 4: {
      boundary_detector.LSectionHead = sectionHead[1];
      boundary_detector.LSectionTail = sectionTail[1];  
      boundary_detector.RSectionHead = sectionHead[2];  
      boundary_detector.RSectionTail = sectionTail[2];  
      break;
    }
    case 3: {
      boundary_detector.LSectionHead = sectionHead[1];
      boundary_detector.LSectionTail = sectionTail[1];  
      boundary_detector.RSectionHead = sectionHead[2];  
      boundary_detector.RSectionTail = sectionTail[2];  
      break;
    }
    case 2: {
      if (  boundary_detector.boundaryY[MZ + sectionHead[1]]  
          < boundary_detector.boundaryY[MZ + sectionTail[1]] ){
            boundary_detector.LSectionHead = 0;
            boundary_detector.LSectionTail = 0;  
            boundary_detector.RSectionHead = sectionHead[1];  
            boundary_detector.RSectionTail = sectionTail[1]; 
          }else{
            boundary_detector.LSectionHead = sectionHead[1];
            boundary_detector.LSectionTail = sectionTail[1];  
            boundary_detector.RSectionHead = 0;  
            boundary_detector.RSectionTail = 0; 
          }
      break;
    }
    default :{
      boundary_detector.LSectionHead = sectionHead[1];
      boundary_detector.LSectionTail = sectionTail[1];  
      boundary_detector.RSectionHead = sectionHead[2];  
      boundary_detector.RSectionTail = sectionTail[2];
    }
    }
    
}


u8 GuideLoc(u8 pointrow,u8 pointcol){
    u8 endPoint = 0;
    if (pointrow < IMG_ROWS / 2){ //maybe #define is better
        endPoint += 4;
    }
    if (pointcol > IMG_COLS / 2){ //maybe #define is better
        endPoint += 2;
    }
    if (pointcol == IMG_COLS - DIS_COL - 1 || pointcol == DIS_COL){
        endPoint += 2;
    }else{
        endPoint += 1;
    }
    return endPoint;
}

