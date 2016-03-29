#include "includes.h"
MotorPID motor_pid;

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