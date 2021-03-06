#include "includes.h"
BoundaryDetector boundaryDetector;




u8 InversePerspectiveTransform(s8* xIn,s8* yIn, u8 size){
    u8* xOut=xIn;
    u8* yOut=yIn;
    s32 numerator=0;
    s32 denominator=0;
    for(u8 i=0;i<size;i+=SAMPLE_RATE){
        
        numerator = PERSPECTIVE_SCALE * (xIn[i] - ORIGIN_X) * TRAPZOID_HEIGHT;
        denominator = TRAPZOID_UPPER * TRAPZOID_HEIGHT  
                + (TRAPZOID_LOWER - TRAPZOID_UPPER) * (yIn[i] - 3);
        (*xOut)=numerator/denominator;
        (*xOut) += ORIGIN_X + 50;
        xOut ++;
        
        numerator = PERSPECTIVE_SCALE* ALGC2 * (yIn[i] - ORIGIN_Y);
        denominator = REAL_WORLD_SCALE * (10000 - ALGC1 * (yIn[i] - ORIGIN_Y));
        (*yOut)=numerator/denominator;
        (*yOut)+= ORIGIN_Y + 40;
        yOut ++;
   }   
   return (xOut - (u8*)xIn); //Returns number of points processed    
}




void DetectBoundary(){
    //u8 endPoint[8];
    u8 row;
    u8 col;
    u8 currBoundaryPtr = 0;
    u8 isCaptured = FALSE;
    for (row = IMG_ROWS - 1 - DIS_ROW - 1;
         row >= IMG_ROWS - 1 - DIS_ROW - 1 - START_LINE_HEIGHT;
         row--){
        for (col = LBEGIN_SCAN; col <= LEND_SCAN; col++){
            if (img_buffer[MZ + row] [MZ + col] > WHITE_THRES
                    && img_buffer[MZ + row] [MZ + col - 1] < WHITE_THRES
                    && img_buffer[MZ + row] [MZ + col + 1] > WHITE_THRES){
                boundaryDetector.boundaryY [MZ + 0] = row;
                boundaryDetector.boundaryX [MZ + 0] = col;
                isCaptured = TRUE;
                break;
            }
        }
        if (isCaptured){
            break;
        }
    }
    if (isCaptured){
        row = boundaryDetector.boundaryY [MZ + 0] ;
        col = boundaryDetector.boundaryX [MZ + 0] ;
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
    u8 sectionTail[]         = {0, 0, 0, 0, 0};
    u8 sectionHead[]         = {0, 0, 0, 0, 0};
    u8 sectionCounter        = 1;
    s8 moveDirX[]            = {-1,0,1,0};
    s8 moveDirY[]            = {0,-1,0,1};
    u8 nextDir;
    
    while (isMoveable && row < IMG_ROWS - DIS_ROW -1 && stepCounter < 255){
        u8 crit[]={col > DIS_COL,
                  row > 1,
                  col < IMG_COLS - DIS_COL - 1,
                  row < IMG_ROWS - DIS_ROW
                  };
        isMoveable = FALSE;
        for( step = 0; step <=3; step++){
            nextDir = (lastDirection + step + 3) & 0x03;
            if(img_buffer[MZ + row + 
               moveDirY[MZ + nextDir]][MZ+col+moveDirX[MZ + nextDir]]> WHITE_THRES
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
        //find out boundaryDetector.boundary
        if (      (img_buffer[MZ + row    ] [MZ + col + 1] < WHITE_THRES
                || img_buffer[MZ + row    ] [MZ + col - 1] < WHITE_THRES
                || img_buffer[MZ + row + 1] [MZ + col    ] < WHITE_THRES
                || img_buffer[MZ + row - 1] [MZ + col    ] < WHITE_THRES)
                &&(img_buffer[MZ + row    ] [MZ + col + 1] > WHITE_THRES
                || img_buffer[MZ + row    ] [MZ + col - 1] > WHITE_THRES
                || img_buffer[MZ + row + 1] [MZ + col    ] > WHITE_THRES
                || img_buffer[MZ + row - 1] [MZ + col    ] > WHITE_THRES)
            ){//need improvement
            boundaryDetector.boundaryY [MZ + currBoundaryPtr] = row;
            boundaryDetector.boundaryX [MZ + currBoundaryPtr] = col;
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
                //endPoint[MZ + 2 * (sectionCounter - 1)] =
                //    GuideLoc(boundaryDetector.boundaryY
                //             [MZ + sectionTail[MZ + sectionCounter - 1]],
                //             boundaryDetector.boundaryX
                 //            [MZ + sectionTail[MZ + sectionCounter - 1]]);
                //endPoint[MZ + 2 * (sectionCounter - 1)+1] =
                //    GuideLoc(boundaryDetector.boundaryY
                //             [MZ + sectionHead[MZ + sectionCounter - 1]],
                //             boundaryDetector.boundaryX
                //             [MZ + sectionHead[MZ + sectionCounter - 1]]);
                sectionCounter ++;
                sectionHead[MZ + sectionCounter - 1] = currBoundaryPtr;
            }
        }

    }
    switch (sectionCounter){
    case 5: {
      currentState.LBoundaryX    = boundaryDetector.boundaryX + sectionHead[0];
      currentState.LBoundaryY    = boundaryDetector.boundaryY + sectionHead[0];
      currentState.LBoundarySize = sectionTail[1] - sectionHead[0] +1 ;
      currentState.RBoundaryX    = boundaryDetector.boundaryX + sectionHead[2];
      currentState.RBoundaryY    = boundaryDetector.boundaryY + sectionHead[2];
      currentState.RBoundarySize = sectionTail[3] - sectionHead[2] +1 ;
      //boundaryDetector.LSectionHead = sectionHead[0];
      //boundaryDetector.LSectionTail = sectionTail[1];  
      //boundaryDetector.RSectionHead = sectionHead[2];  
      //boundaryDetector.RSectionTail = sectionTail[3];  
      break;
    }
    case 4: {
      currentState.LBoundaryX    = boundaryDetector.boundaryX + sectionHead[0];
      currentState.LBoundaryY    = boundaryDetector.boundaryY + sectionHead[0];
      currentState.LBoundarySize = sectionTail[0] - sectionHead[0] +1 ;
      currentState.RBoundaryX    = boundaryDetector.boundaryX + sectionHead[1];
      currentState.RBoundaryY    = boundaryDetector.boundaryY + sectionHead[1];
      currentState.RBoundarySize = sectionTail[1] - sectionHead[1] +1 ;
      //boundaryDetector.LSectionHead = sectionHead[0];
      //boundaryDetector.LSectionTail = sectionTail[0];  
      //boundaryDetector.RSectionHead = sectionHead[1];  
      //boundaryDetector.RSectionTail = sectionTail[1];  
      break;
    }
    case 3: {
      currentState.LBoundaryX    = boundaryDetector.boundaryX + sectionHead[0];
      currentState.LBoundaryY    = boundaryDetector.boundaryY + sectionHead[0];
      currentState.LBoundarySize = sectionTail[0] - sectionHead[0] +1 ;
      currentState.RBoundaryX    = boundaryDetector.boundaryX + sectionHead[1];
      currentState.RBoundaryY    = boundaryDetector.boundaryY + sectionHead[1];
      currentState.RBoundarySize = sectionTail[1] - sectionHead[1] +1 ;
      //boundaryDetector.LSectionHead = sectionHead[0];
      //boundaryDetector.LSectionTail = sectionTail[0];  
      //boundaryDetector.RSectionHead = sectionHead[1];  
      //boundaryDetector.RSectionTail = sectionTail[1];  
      break;
    }
    case 2: {
      if (  boundaryDetector.boundaryY[MZ + sectionHead[0]]  
          < boundaryDetector.boundaryY[MZ + sectionTail[0]] ){
            currentState.LBoundarySize = 0 ;
            currentState.RBoundaryX    = boundaryDetector.boundaryX + sectionHead[0];
            currentState.RBoundaryY    = boundaryDetector.boundaryY + sectionHead[0];
            currentState.RBoundarySize = sectionTail[0] - sectionHead[0] +1 ;
            //boundaryDetector.LSectionHead = 0;
            //boundaryDetector.LSectionTail = 0;  
            //boundaryDetector.RSectionHead = sectionHead[0];  
            //boundaryDetector.RSectionTail = sectionTail[0]; 
          }else{
            currentState.LBoundaryX    = boundaryDetector.boundaryX + sectionHead[0];
            currentState.LBoundaryY    = boundaryDetector.boundaryY + sectionHead[0];
            currentState.LBoundarySize = sectionTail[0] - sectionHead[0] +1 ;
            currentState.RBoundarySize = 0 ;
            //boundaryDetector.LSectionHead = sectionHead[0];
            //boundaryDetector.LSectionTail = sectionTail[0];  
            //boundaryDetector.RSectionHead = 0;  
            //boundaryDetector.RSectionTail = 0; 
          }
      break;
    }
    default :{
      currentState.LBoundarySize = 0 ;
      currentState.RBoundarySize = 0 ;
    }
    }
    
}


u8 GuideLoc(u8 pointrow,u8 pointcol){
    return 1;
}

u8 uGuideLoc(u8 pointrow,u8 pointcol){
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

