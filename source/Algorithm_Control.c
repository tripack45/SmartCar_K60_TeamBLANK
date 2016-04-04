#include "includes.h"
MotorPID motor_pid;

CurrentControlState currentState;
struct{
  u8 state;
  u8 candidateState;
  u8 candidateStateCounter;
  u8 crossCounter;
}internalState;

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
    
    u8 counter=internalState.candidateStateCounter;
    if(currentState.state==internalState.candidateState){
      // The new state agress with candidate state
      // Grant 10 points if it agrees
      counter+=CONSISTENCY_AWARD;
    }else{
      // 30 pts punishment if it disagress
      counter -= INCONSISTENCY_PUNISHMENT;
      if(counter<0){
        // Change Candidate if the points reaches negative
        internalState.candidateState=currentState.state;
        counter=CONSISTENCY_AWARD;
      }
    }
    
    counter=(counter<80?counter:MAXIMUM_SCORE); //Cannot Exceeds 80pts
    if(counter>30){
      // 40pts to make the candidate official
      if(internalState.state != internalState.candidateState){
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
    break;
  case CONTROL_STATE_TURN:
    break;
  case CONTROL_STATE_CROSS:
    break;
  case CONTROL_STATE_STR2TRN:
    break;
  default:
    break;
  }
  return;
}

void LinearStateHandler(){
  if ( abs((s16)(currentState.lineAlpha * currentState.carPosY 
                 + currentState.lineBeta) - currentState.carPosX )  
      < DANGERZONE )
  {
        currdir = - ((s16)(currentState.lineBeta) - currentState.carPosX)
          * DIRSENSITIVITY;
        currspd = FASTSPEED;
      }else{
        currdir = - ((s16)(currentState.lineAlpha * currentState.carPosY + 
                           currentState.lineBeta) - currentState.carPosX) 
          * DIRSENSITIVITY;
        currspd = LOWSPEED;
      }
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