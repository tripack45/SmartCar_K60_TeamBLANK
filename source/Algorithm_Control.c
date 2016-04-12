#include "includes.h"
MotorPID motor_pid;

CurrentControlState currentState;
struct{
  u8 state;
  u8 candidateState;
  s16 candidateStateCounter;
  s16 crossCounter;
  u8 startLineCount;
}internalState;

void CrossroadStateHandler();
void LinearStateHandler();
void CircleStateHandler();

void ControllerUpdate(){
  if(!currentState.isUnknown){
    if(internalState.state==0){
      //First time running
      internalState.state = currentState.state;
      internalState.candidateState = currentState.state;
      internalState.candidateStateCounter = CONSISTENCY_AWARD;
      return;
    }
    
    if(internalState.state==CONTROL_STATE_CROSS){
      // if the established situation is crossroad;
      // maintain the state for a period of time
      if(internalState.crossCounter>0){
        internalState.crossCounter--;
        //waiting is not over yet
        return;
      }
    } 
    
    if(internalState.state == CONTROL_STATE_STR2TRN){
       static char str2turnCounter=0;
       str2turnCounter++;
       if(currentState.lineMSE>13)
         str2turnCounter++;
       if(str2turnCounter>20){
         internalState.state = CONTROL_STATE_TURN;
         str2turnCounter=0;
       }
       return;
    }
    
    if(currentState.state==internalState.candidateState){
      // The new state agress with candidate state
      // Grant 10 points if it agrees
      internalState.candidateStateCounter+=CONSISTENCY_AWARD;
      if( internalState.candidateStateCounter > 80)
        internalState.candidateStateCounter= 80;
      if(internalState.candidateStateCounter>30)
      if(internalState.state != internalState.candidateState){
        // 40pts to make the candidate official  
        
        if(internalState.state == CONTROL_STATE_STRAIGHT)
        if(internalState.candidateState == CONTROL_STATE_TURN){
           //Straight-Turn 
           internalState.state = CONTROL_STATE_STR2TRN;
           return;
        }
        internalState.state=internalState.candidateState;
        
        if(internalState.state == CONTROL_STATE_CROSS)
          internalState.crossCounter=CROSSROAD_INERTIA;
      }
    }else{
      // 30 pts punishment if it disagress
      internalState.candidateStateCounter -= INCONSISTENCY_PUNISHMENT;
      if(internalState.candidateStateCounter < 0){
        // Change Candidate if the points reaches negative
        internalState.candidateState=currentState.state;
        internalState.candidateStateCounter=CONSISTENCY_AWARD;
      }
    }
  }
  return;
}

void ControllerControl(){
  switch(internalState.state){
  case CONTROL_STATE_STRAIGHT:
    //Bell_Request(5);
    //currspd=FASTSPEED;
    //CrossroadStateHandler();
    LinearStateHandler();
    break;
  case CONTROL_STATE_TURN:
    //Bell_Request(5);
    currspd=LOWSPEED;
    //CircleStateHandler();
    CrossroadStateHandler();
    SteeringAid ();
    break;
  case CONTROL_STATE_CROSS:
    //Bell_Request(5);
    currspd=LOWSPEED;
    CrossroadStateHandler();
    break;
  case CONTROL_STATE_STR2TRN:
    Bell_Request(5);
    if(tacho0>LOWSPEED-5){
      currspd=5;
    }
    CrossroadStateHandler();
    break;
  default:
    break;
  }
  debugWatch[0]=internalState.state;
  return;
}

void LinearStateHandler(){
  s16 tCarX=(s32)(currentState.lineAlpha * currentState.carPosY 
                 + currentState.lineBeta) / 100 - currentState.carPosX;
  
  //ITM_EVENT16_WITH_PC(1,ABS(tCarX));
  //ITM_EVENT16_WITH_PC(2,currentState.lineBeta);
    
  s16 tDirH=((s16)(currentState.lineBeta / 100) - currentState.carPosX) * DIR_SENSITIVITY;
  s16 tDirL= tCarX * DIR_SENSITIVITY;
   
    //ITM_EVENT16_WITH_PC(2, ABS(tDirH) );
  if (  (ABS(tCarX)) < DANGERZONE ){
    currdir = Dir_PID( tDirH, LINEAR_PID_P, LINEAR_PID_D);
    currspd = FASTSPEED;
  }else{
    currdir = Dir_PID( tDirL, LINEAR_PID_P, LINEAR_PID_D); 
    currspd = LOWSPEED;
  }
}

void Str2TrnStateHandler(){
  s16 tCarX=(s32)(currentState.lineAlpha * currentState.carPosY 
                 + currentState.lineBeta) / 100 - currentState.carPosX;
  
  //ITM_EVENT16_WITH_PC(1,ABS(tCarX));
  //ITM_EVENT16_WITH_PC(2,currentState.lineBeta);
    
  s16 tDirH=((s16)(currentState.lineBeta / 100) - currentState.carPosX + 
             currentState.innerCircleFlag * STR2TRN_CHANG_ZONE) * DIR_SENSITIVITY;
  s16 tDirL= tCarX * DIR_SENSITIVITY;
  currspd = LOWSPEED;
    //ITM_EVENT16_WITH_PC(2, ABS(tDirH) );
  if (  (ABS(tCarX)) < DANGERZONE ){
    currdir = tDirH;
  }else{
    currdir = tDirL; 
  }
}


void CircleStateHandler(){
  if (currentState.lineMSE < MSE_RATIO * currentState.circleMSE){
    LinearStateHandler();
    return;
  }else{
    s32 offset=0;
    s16 theta=0;
    s16 speed=0;
    s8 direction = 1;
    s32 diffX = currentState.carPosX - currentState.circleX;
    s32 diffY = currentState.carPosY - currentState.circleY;
    direction = currentState.innerCircleFlag;
    offset = Isqrt(diffX * diffX + diffY * diffY) - currentState.circleRadius;
    if (offset < OFFSET_THRES && offset > -OFFSET_THRES){
      theta = direction * CURVE_DIR_RATIO / currentState.circleRadius
                       + OFFSET_DIR_RATIO * offset;
      if (theta > DIR_MAX || theta < -DIR_MAX){
         currdir = direction * DIR_MAX;
         currspd = BASIC_SPD;
         return;
      }
      speed =  currentState.circleRadius / CURVE_SPD_RATIO 
               - offset / OFFSET_SPD_RATIO  + BASIC_SPD;
      if (speed > SPD_MAX) speed = SPD_MAX;
      if (speed < SPD_MIN) speed = SPD_MIN;
      currdir = theta;
      currspd = speed;
      return;
    }
    if (offset < 0){
      currdir = 0;
      currspd = SPD_MAX;
      return;
    }else{
      currdir = direction * DIR_MAX;
      currspd = SPD_MIN;
      return;
    }
  }
}

void CrossroadStateHandler(){
  u8 boundaryPTR;
  u8 LBoundarycol[INVERSE_IMG_ROWS] = {0};        
  u8 RBoundarycol[INVERSE_IMG_ROWS] = {0};
  
  //DetectBoundary
  for (boundaryPTR = 0; boundaryPTR < currentState.LBoundarySize; boundaryPTR++ ){
    if (!LBoundarycol[MZ + currentState.LBoundaryY[MZ + boundaryPTR]]){
      LBoundarycol[MZ + currentState.LBoundaryY[MZ + boundaryPTR]] =
        currentState.LBoundaryX[MZ + boundaryPTR];
    }
  }
  for (boundaryPTR = 0; boundaryPTR < currentState.RBoundarySize; boundaryPTR++ ){
    if (!RBoundarycol[MZ + currentState.RBoundaryY[MZ + boundaryPTR]]){
      RBoundarycol[MZ + currentState.RBoundaryY[MZ + boundaryPTR]] =
        currentState.RBoundaryX[MZ + boundaryPTR];
    }
  }
  
  //Dir and Speed Control
  
  u8 row;
  s16 s16temp;
  s16 g_nDirPos = currentState.carPosX * 2;
  s32 nShift    = 0;        
  s32 nDenom    = 0;
//#define TF(x) ( ( ((x)+20)>50 )?50:((x)+20))
#define TF(x) 1;
  s16 weight;

  for (row = INVERSE_IMG_ROWS - DIS_ROW; row > 0; row-- ){
    if (LBoundarycol[MZ + row]&& RBoundarycol[MZ + row]){
      g_nDirPos = (s16) ( (LBoundarycol[MZ + row] + RBoundarycol[MZ + row]) );
      break;
    }else if (LBoundarycol[MZ + row]){
      g_nDirPos = (s16) ( 2*LBoundarycol[MZ + row] + TRACK_WIDTH );
      break;
    }else if (RBoundarycol[MZ + row]){
      g_nDirPos = (s16) ( 2*RBoundarycol[MZ + row] - TRACK_WIDTH );
      break;
    }
  }
  s16temp = g_nDirPos;
  for (row=row; row>0; row-- ){
    if (LBoundarycol[MZ + row]&& RBoundarycol[MZ + row]){
      weight =TF(currentState.carPosY - row);
      s16temp = (s16)LBoundarycol[MZ + row] + RBoundarycol[MZ + row];
       nShift = nShift + (s16temp -  (s16)currentState.carPosX * 2) 
                * weight ;
      nDenom = nDenom + weight;
    }else if (LBoundarycol[MZ + row]){
      weight =TF(currentState.carPosY - row);
      s16temp = (s16) LBoundarycol[MZ + row]*2 + TRACK_WIDTH;
      nShift = nShift +  (s16temp- (s16)currentState.carPosX * 2)
              *  weight;
      nDenom = nDenom +  weight;
    }else if (RBoundarycol[MZ + row]){
      weight =TF(currentState.carPosY - row);
      s16temp = (s16) RBoundarycol[MZ + row]*2 - TRACK_WIDTH;
      nShift = nShift +  (s16temp - (s16)currentState.carPosX * 2)
            *  weight;
      nDenom = nDenom +  weight;
    }
    ITM_EVENT32_WITH_PC(1,nDenom);
  }
  if (nDenom != 0) {
    currdir = Dir_PID( (s16)(nShift/nDenom) * DIR_SENSITIVITY_OLD , GOP_PID_P, GOP_PID_D);
  }else{
    currdir = Dir_PID( (g_nDirPos - (s16) currentState.carPosX * 2) * DIR_SENSITIVITY_OLD,
                        GOP_PID_P, GOP_PID_D);
  }
  //currspd = 10;
}



s16 Speed_PID(s16 Expect){
  s16 Error,Speed,Power;
  static s16 sumError=0; 
  Speed=tacho0 * TACHO_SENSITIVITY;
  Error=Expect-Speed;
  Power=insert_in( Expect * EXP_SEN
                  + MOTOR_PID_I * sumError / 100 
                  + MOTOR_PID_P * Error 
                  + MOTOR_PID_D * (Error - motor_pid.LastError),
                  -SPEED_MAX * 2,SPEED_MAX);
  motor_pid.LastError=Error;
  sumError+=Error;
  if (tacho0) 
    return MOTOR_DEAD_RUN + 100 * Power / SPEED_MAX * MOTOR_PID_SENSITIVITY;
  else 
    return MOTOR_DEAD_REST + 100 * Power / SPEED_MAX*MOTOR_PID_SENSITIVITY;
}

s16 Dir_PID(s16 position, u16 dir_P, u16 dir_D){
  s16 outputDir;
  static s16 lastDirection = 0;
  outputDir = ( (s32) dir_P * position 
               + (s32) dir_D * (position - lastDirection ))/100;
  lastDirection = position;
  return outputDir;
}

void SteeringAid (){
  s16 dirDiff = currentState.lineAlpha 
              * currentState.lineAlpha 
              * currentState.lineAlpha 
              * AID_SENSITIVITY
              / 100 / 100 / 100;
  currdir += dirDiff;
                
}
