#include "includes.h"

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
    currspd=LOWSPEED+3;
    CrossroadStateHandler();
    break;
  case CONTROL_STATE_STR2TRN:
    //Bell_Request(5);
    if(tacho0>LOWSPEED+3){
      currspd= LOWSPEED - 25;
      currspd= (currspd < 0) ? 0 : currspd;
    }
    CrossroadStateHandler();
    break;
  default:
    break;
  }
  return;
}
