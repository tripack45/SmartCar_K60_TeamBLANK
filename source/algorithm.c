

#include "includes.h"

void AlgorithmMain(){
  
   currentState.img_buffer=(void*)img_buffer;
   
   currentState.carPosX=60;
   currentState.carPosY=79;
   
   DetectBoundary();

   u8 LLength = boundaryDetector.LSectionTail
                - boundaryDetector.LSectionHead + 1;
   u8 RLength = boundaryDetector.RSectionTail
                - boundaryDetector.RSectionHead + 1;
   u8* boundaryX = NULL;
   u8* boundaryY = NULL;
   u8  length =0;
   u8  isLinear,isCrossroad;
   
   if(LLength <= 5 && RLength <= 5)
     goto unknown; //Not enough points for transfering
   
   if (LLength > RLength){
        boundaryX=boundaryDetector.boundaryX + boundaryDetector.LSectionHead;
        boundaryY=boundaryDetector.boundaryY + boundaryDetector.LSectionHead;
        length=InversePerspectiveTransform(boundaryX, boundaryY, LLength);
   } else {
        boundaryX=boundaryDetector.boundaryX + boundaryDetector.RSectionHead;
        boundaryY=boundaryDetector.boundaryY + boundaryDetector.RSectionHead;
        length=InversePerspectiveTransform(boundaryX, boundaryY, RLength);
   }
   
   if(length<=5)
     goto unknown; //Not enough points for analyzation
   
   isLinear=IsLinear(boundaryY,
                     boundaryX,
                     length,
                     &(linearDectect.alpha),
                     &(linearDectect.beta),
                     &(linearDectect.radius));
    
   isCrossroad=IsCrossroad(boundaryX,boundaryY,length);
   
   if(isCrossroad)
     currentState.state=CONTROL_STATE_CROSS;
   else if(isLinear)
     currentState.state=CONTROL_STATE_STRAIGHT;
   else
     currentState.state=CONTROL_STATE_TURN;
   
   currentState.isUnknown=0;
   
control:
  
   ControllerUpdate();
   ControllerControl();
   
   s16 tx=0;s16 ty=0;
   for(u8 i = 0;i < length; i++){
        tx += boundaryX[i];
        ty += boundaryY[i];
   }
   debugWatch[0]=isLinear;
   debugWatch[1]=(s32)linearDectect.alpha;
   debugWatch[2]=(s32)linearDectect.beta;         
   debugWatch[3]=(s32)linearDectect.radius;
   return;
  
/* this parts acts as exception handler
 * THIS CANNOT BE IN NORMAL ROUTHINE!
 */
unknown:
   currentState.isUnknown=1;
   goto control;
}


