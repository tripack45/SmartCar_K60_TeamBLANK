

#include "includes.h"

#define R(x) (currentState.x)
void AlgorithmMain(){
   
   currentState.img_buffer=(void*)img_buffer;
   currentState.isUnknown=0;
   currentState.fittedBoundary=0;
   currentState.isInnerCircle=0;
   DetectBoundary();
   
   currentState.carPosX=60;
   currentState.carPosY=79;
   u8  isLinear,isCrossroad;
   
   if(R(LBoundarySize) <= 5 && R(RBoundarySize) <= 5)
     goto unknown; //Not enough points for transfering
   
   if(currentState.LBoundarySize>0)
      InversePerspectiveTransform(
         R(LBoundaryX), R(LBoundaryY), R(LBoundarySize));
   if(currentState.RBoundarySize>0)
      InversePerspectiveTransform(
         R(RBoundaryX), R(RBoundaryY), R(RBoundarySize));
   
   if( R(LBoundarySize)>R(RBoundarySize) )
      isCrossroad=IsCrossroad(R(LBoundaryX),R(LBoundaryY),R(LBoundarySize));
   else
      isCrossroad=IsCrossroad(R(RBoundaryX),R(RBoundaryY),R(RBoundarySize));
   
   CurveFitting(&currentState);
   if(currentState.isUnknown)
     goto unknown;
  
   if(isCrossroad)
     currentState.state=CONTROL_STATE_CROSS;
   else if(currentState.lineMSE <= 1){
     currentState.state=CONTROL_STATE_STRAIGHT;
     if(currentState.fittedBoundary==1)
        currentState.lineBeta += 35;
     else if (currentState.fittedBoundary==2)
        currentState.lineBeta -= 35;
   }else{
     currentState.state=CONTROL_STATE_TURN;
   }
   currentState.isUnknown=0;
   
control:
  
   ControllerUpdate();
   ControllerControl();
   /*
   s16 tx=0;s16 ty=0;
   for(u8 i = 0;i < length; i++){
        tx += boundaryX[i];
        ty += boundaryY[i];
   }
   debugWatch[0]=isLinear;
   debugWatch[1]=(s32)linearDectect.alpha;
   debugWatch[2]=(s32)linearDectect.beta;         
   debugWatch[3]=(s32)linearDectect.radius;
   */
   return;
  
/* this parts acts as exception handler
 * THIS CANNOT BE IN NORMAL ROUTHINE!
 */
unknown:
   currentState.isUnknown=1;
   return;
}


