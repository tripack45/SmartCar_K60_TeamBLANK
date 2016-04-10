#include "includes.h"
MotorPID motor_pid;

CurrentControlState currentState;
struct{
  u8 state;
  u8 candidateState;
  s16 candidateStateCounter;
  s16 crossCounter;
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
       if(currentState.lineMSE>13)
         str2turnCounter++;
       else 
         str2turnCounter--;
       if(str2turnCounter>3){
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
    Bell_Request(5);
    //currspd=FASTSPEED;
    //CrossroadStateHandler();
    LinearStateHandler();
    break;
  case CONTROL_STATE_TURN:
    currspd=LOWSPEED;
    //CircleStateHandler();
    CrossroadStateHandler();
    break;
  case CONTROL_STATE_CROSS:
    currspd=FASTSPEED;
    CrossroadStateHandler();
    break;
  case CONTROL_STATE_STR2TRN:
    //Bell_Request(5);
    currspd=LOWSPEED;
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
    if (currentState.circleX > currentState.carPosX) direction = -1;
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
  s16 nShift    = 0;        
  s16 nDenom    = 0;
  
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
      s16temp = (s16) ( insert_in(LBoundarycol[MZ + row] + RBoundarycol[MZ + row],
                                  s16temp - EXCEPT_RANGE, s16temp + EXCEPT_RANGE) );
      nShift = nShift + (s16temp -  currentState.carPosX * 2);
      nDenom = nDenom + 1;
    }else if (LBoundarycol[MZ + row]){
      s16temp = (s16) ( insert_in(LBoundarycol[MZ + row]*2 + TRACK_WIDTH,
                                  s16temp - EXCEPT_RANGE, s16temp + EXCEPT_RANGE) );
      nShift = nShift + (s16temp- currentState.carPosX * 2);
      nDenom = nDenom + 1;
    }else if (RBoundarycol[MZ + row]){
      s16temp = (s16) ( insert_in(RBoundarycol[MZ + row]*2 - TRACK_WIDTH,
                                  s16temp - EXCEPT_RANGE, s16temp + EXCEPT_RANGE) );
      nShift = nShift + (s16temp- currentState.carPosX * 2);
      nDenom = nDenom + 1;
    }
  }
  if (nDenom != 0) {
    g_nDirPos = nShift/nDenom;
  }else{
    g_nDirPos = g_nDirPos - currentState.carPosX * 2;
  }
  currdir = g_nDirPos * DIR_SENSITIVITY_OLD;
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
