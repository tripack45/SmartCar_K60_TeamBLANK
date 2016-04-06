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

void ControllerUpdate(){
  if(!currentState.isUnknown){
    if(internalState.state==0){
      //First time running
      internalState.state = currentState.state;
      internalState.candidateState = currentState.state;
      internalState.candidateStateCounter = CONSISTENCY_AWARD;
      return;
    }
    
    if(internalState.state==3){
      // if the established situation is crossroad;
      // maintain the state for a period of time
      if(internalState.crossCounter>0){
        internalState.crossCounter--;
        //waiting is not over yet
        return;
      }
    }
    
    s16 counter=internalState.candidateStateCounter;
    if(currentState.state==internalState.candidateState){
      // The new state agress with candidate state
      // Grant 10 points if it agrees
      counter+=CONSISTENCY_AWARD;
    }else{
      // 30 pts punishment if it disagress
      counter -= INCONSISTENCY_PUNISHMENT;
      if(counter < 0){
        // Change Candidate if the points reaches negative
        internalState.candidateState=currentState.state;
        counter=CONSISTENCY_AWARD;
      }
    }
    
    counter=(counter<80?counter:MAXIMUM_SCORE); //Cannot Exceeds 80pts
    if(counter>30){
      // 40pts to make the candidate official
      if(internalState.state != internalState.candidateState){
        Bell_Request(5);
        // if requires to swich state
        internalState.state=internalState.candidateState;
        if(internalState.state == 3)
          internalState.crossCounter=CROSSROAD_INERTIA;
      }
    }
    internalState.candidateStateCounter=counter;
  }
  return;
}

void ControllerControl(){
  switch(internalState.state){
  case CONTROL_STATE_STRAIGHT:
    LinearStateHandler();
    break;
  case CONTROL_STATE_TURN:
    CrossroadStateHandler();
    break;
  case CONTROL_STATE_CROSS:
    break;
  case CONTROL_STATE_STR2TRN:
    break;
  default:
    break;
  }
  debugWatch[0]=internalState.state;
  return;
}

void LinearStateHandler(){
  if ( abs((s16)(currentState.lineAlpha * currentState.carPosY 
                 + currentState.lineBeta) - currentState.carPosX )  
      < DANGERZONE )
  {
        currdir = - ((s16)(currentState.lineBeta) - currentState.carPosX)
          * DIR_SENSITIVITY;
        currspd = FASTSPEED;
      }else{
        currdir = - ((s16)(currentState.lineAlpha * currentState.carPosY + 
                           currentState.lineBeta) - currentState.carPosX) 
          * DIR_SENSITIVITY;
        currspd = LOWSPEED;
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


void MotorCtrl(void){
  //need ifSpeedUp
  //if (direction_generator.ifSpeedUp){
  //currspd=30;
  //}
  //else{
  currspd=20;
  //}
}

s16 Speed_PID(u8 Expect){
  s16 Error,Speed,Power;
  static s16 sumError=0; 
  Speed=tacho0*TACHO_SENSITIVITY;
  Error=Expect-Speed;
  Power=insert_in(Expect*EXP_SEN+MOTOR_PID_I*sumError/100+MOTOR_PID_P*Error +MOTOR_PID_D*(Error-motor_pid.LastError),0,SPEED_MAX);
  motor_pid.LastError=Error;
  sumError+=Error;
  if (tacho0) 
    return MOTOR_DEAD_RUN+100*Power/SPEED_MAX*MOTOR_PID_SENSITIVITY;
  else 
    return MOTOR_DEAD_REST+100*Power/SPEED_MAX*MOTOR_PID_SENSITIVITY;
}