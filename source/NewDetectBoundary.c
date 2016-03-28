#include "includes.h"
NewBoundaryDetector new_boundary_detector;


void NewDetectBoundary(){
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
                new_boundary_detector.boundary[MZ + 0] [MZ + 0] = row;
                new_boundary_detector.boundary[MZ + 0] [MZ + 1] = col;
                isCaptured = TRUE;
                break;
            }
        }
        if (isCaptured){
            break;
        }
    }
    if (isCaptured){
        row = new_boundary_detector.boundary[MZ + 0] [MZ + 0];
        col = new_boundary_detector.boundary[MZ + 0] [MZ + 1];
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
        //find out new_boundary_detector.boundary
        if (      (img_buffer[MZ + row    ] [MZ + col + 1] < WHITE_THRES
                || img_buffer[MZ + row    ] [MZ + col - 1] < WHITE_THRES
                || img_buffer[MZ + row + 1] [MZ + col    ] < WHITE_THRES
                || img_buffer[MZ + row - 1] [MZ + col    ] < WHITE_THRES)
                &&(img_buffer[MZ + row    ] [MZ + col + 1] > WHITE_THRES
                || img_buffer[MZ + row    ] [MZ + col - 1] > WHITE_THRES
                || img_buffer[MZ + row + 1] [MZ + col    ] > WHITE_THRES
                || img_buffer[MZ + row - 1] [MZ + col    ] > WHITE_THRES)
            ){//need improvement
            new_boundary_detector.boundary[MZ + currBoundaryPtr] [MZ + 0] = row;
            new_boundary_detector.boundary[MZ + currBoundaryPtr] [MZ + 1] = col;
            currBoundaryPtr ++;
            uncapturedStepCounter = 0;
        }else{
            uncapturedStepCounter ++;
        }

        //divide the new_boundary_detector.boundary
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
                    GuideLoc(new_boundary_detector.boundary
                             [MZ + sectionTail[MZ + sectionCounter - 1]][1],
                             new_boundary_detector.boundary
                             [MZ + sectionTail[MZ + sectionCounter - 1]][2]);
                endPoint[MZ + 2 * (sectionCounter - 1)+1] =
                    GuideLoc(new_boundary_detector.boundary
                             [MZ + sectionHead[MZ + sectionCounter - 1]][1],
                             new_boundary_detector.boundary
                             [MZ + sectionHead[MZ + sectionCounter - 1]][2]);
                sectionCounter ++;
                sectionHead[MZ + sectionCounter - 1] = currBoundaryPtr;
            }
        }

    }
    switch (sectionCounter){
    case 5: {
      new_boundary_detector.LSectionHead = sectionHead[1];
      new_boundary_detector.LSectionTail = sectionTail[2];  
      new_boundary_detector.RSectionHead = sectionHead[3];  
      new_boundary_detector.RSectionTail = sectionTail[4];  
      break;
    }
    case 4: {
      new_boundary_detector.LSectionHead = sectionHead[1];
      new_boundary_detector.LSectionTail = sectionTail[1];  
      new_boundary_detector.RSectionHead = sectionHead[2];  
      new_boundary_detector.RSectionTail = sectionTail[2];  
      break;
    }
    case 3: {
      new_boundary_detector.LSectionHead = sectionHead[1];
      new_boundary_detector.LSectionTail = sectionTail[1];  
      new_boundary_detector.RSectionHead = sectionHead[2];  
      new_boundary_detector.RSectionTail = sectionTail[2];  
      break;
    }
    case 2: {
      if (  new_boundary_detector.boundary[MZ + sectionHead[1]] [MZ + 0] 
          < new_boundary_detector.boundary[MZ + sectionTail[1]] [MZ + 0]){
            new_boundary_detector.LSectionHead = 0;
            new_boundary_detector.LSectionTail = 0;  
            new_boundary_detector.RSectionHead = sectionHead[1];  
            new_boundary_detector.RSectionTail = sectionTail[1]; 
          }else{
            new_boundary_detector.LSectionHead = sectionHead[1];
            new_boundary_detector.LSectionTail = sectionTail[1];  
            new_boundary_detector.RSectionHead = 0;  
            new_boundary_detector.RSectionTail = 0; 
          }
      break;
    }
    default :{
      new_boundary_detector.LSectionHead = sectionHead[1];
      new_boundary_detector.LSectionTail = sectionTail[1];  
      new_boundary_detector.RSectionHead = sectionHead[2];  
      new_boundary_detector.RSectionTail = sectionTail[2];
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
