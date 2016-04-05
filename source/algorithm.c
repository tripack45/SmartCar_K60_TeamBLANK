

#include "includes.h"

#define R(x) (currentState.x)
void AlgorithmMain(){
  
   currentState.img_buffer=(void*)img_buffer;
   
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
    
   //isCrossroad=IsCrossroad(boundaryX,boundaryY,length);
   
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
   goto control;
}


