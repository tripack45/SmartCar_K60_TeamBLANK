

#include "includes.h"

void AlgorithmMain(){
   DetectBoundary();
   
   u8 LLength = boundaryDetector.LSectionTail 
                - boundaryDetector.LSectionHead + 1;
   u8 RLength = boundaryDetector.RSectionTail 
                - boundaryDetector.RSectionHead + 1;
   u8* boundaryX = NULL;
   u8* boundaryY = NULL;
   u8  length =0;
   if (LLength > RLength){
        boundaryX=boundaryDetector.boundaryX + boundaryDetector.LSectionHead;
        boundaryY=boundaryDetector.boundaryY + boundaryDetector.LSectionHead;
        InversePerspectiveTransform(
            boundaryX, boundaryY, LLength
        );
        length=LLength;
   } else {
        boundaryX=boundaryDetector.boundaryX + boundaryDetector.RSectionHead;
        boundaryY=boundaryDetector.boundaryY + boundaryDetector.RSectionHead;
        InversePerspectiveTransform(
            boundaryX, boundaryY, RLength
        );
        length=RLength;
   }
   s16 tx=0;s16 ty=0;
   for(u8 i = 0;i < length; i++){
        tx += boundaryX[i];
        ty += boundaryY[i];
   }
   
   debugWatch[0]=tx;
   debugWatch[1]=ty;
}


