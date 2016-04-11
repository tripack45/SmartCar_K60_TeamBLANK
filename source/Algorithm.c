

#include "includes.h"

#define R(x) (currentState.x)
void AlgorithmMain(){
   
   currentState.img_buffer=(void*)img_buffer;
   currentState.isUnknown=0;
   currentState.fittedBoundary=0;
   currentState.innerCircleFlag=0;
   currentState.isStartLine=0;
   DetectBoundary();
   
   currentState.carPosX=85;
   currentState.carPosY=101;
   u8  isLinear,isCrossroad;
   u16 distance;
   
   static u8 startLineCounter=0;
   static u8 startLineFlag=0;
   if(startLineCounter==0)
      currentState.isStartLine=IsStartLine((void*)currentState.img_buffer);
      if(currentState.isStartLine){
        startLineCounter=100;
        startLineFlag++;
      }
   else{
      startLineCounter--;
   }
   if(startLineFlag>1){
     currspd=0;
     for(;;)
   }
      
   
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
   if(currentState.isUnknown)goto unknown;
    
   if((s16)currentState.circleX<(s16)currentState.carPosX)
     currentState.innerCircleFlag=-1;
   else
     currentState.innerCircleFlag=1;
   
   if(isCrossroad)
     currentState.state=CONTROL_STATE_CROSS;
   else if(currentState.lineMSE <= STRAIGHT_MSE_CRIT){
     currentState.state=CONTROL_STATE_STRAIGHT;
     if(currentState.fittedBoundary==1)
        currentState.lineBeta += 35 * 100;
     else if (currentState.fittedBoundary==2)
        currentState.lineBeta -= 35 * 100;
   }else{
     currentState.state=CONTROL_STATE_TURN;
    
    s32 diffX = (currentState.carPosX) - (currentState.circleX);
    s32 diffY = (currentState.carPosY) - (currentState.circleY);
    u32 distance = ( diffX * diffX + diffY * diffY);
    distance = Isqrt(distance);
     
    if(distance > currentState.circleRadius){
       currentState.circleRadius = currentState.circleRadius + 35;
     }else{
       currentState.circleRadius = currentState.circleRadius - 35;
     }
   }
   currentState.isUnknown=0;
   
control:
   ITM_EVENT16_WITH_PC(1,ABS(currentState.lineMSE));
   ITM_EVENT32_WITH_PC(2,ABS(currentState.circleMSE));
   
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

u32 Isqrt(s64 x){
	s32 begin = 0;
	s32 end = x;
	s32 med = 0;
	s32 med2 = 0;
	while (end - begin > 1){
		med = (begin + end) / 2;
		med2 = x / med;
		if (med == med2){
			return med;
		}
		else if (med2 < med){
			end = med;
		}
		else{
			begin = med;
		}
	}
	return begin;
}


