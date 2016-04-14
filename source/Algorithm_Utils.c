#include "includes.h"

#define MA(fname,type)          \
type MA##fname(type input){     \
  static u8  index = 0;         \
  static type inputLog[5]={0};  \
  static s32  sum=0;            \
  sum -= inputLog[index];       \
  sum += input;                 \
  inputLog[index]=input;        \
  index++;                      \
  index %= 5;                   \
  return sum / 5;               \
}

//======= Those are all functions==========
MA(LineAlpha,s32)
MA(LineBeta,s32)
MA(CircleX,s16)
MA(CircleY,s16)
MA(CircleRadius,s16)
//=========================================

s16 Speed_PID(s16 expect){
  static u8 launchFlag=0;
  static s16 sumError=0;
  static s16 lastError=0;
  s16 speed=tacho0;
  s16 error=expect-speed;
  s16 output=0;
  
  if(error>15)launchFlag=1;
  
  if(launchFlag){
    if(error<5)launchFlag=0;
    return SPEED_MAX;
  }
  
  s16 delta = error-lastError;
  s16 base = expect * EXP_SEN;
  s16 termP = error * MOTOR_PID_P;
  s16 termI = sumError * MOTOR_PID_I / 100;
  s16 termD = delta * MOTOR_PID_D;
 
  output =  base + termP + termI + termD;

  lastError=error;
  sumError+=error;
  
  if (tacho0)
    output = MOTOR_DEAD_RUN + 100 * output / SPEED_MAX * MOTOR_PID_SENSITIVITY;
  else
    output = MOTOR_DEAD_REST + 100 * output / SPEED_MAX * MOTOR_PID_SENSITIVITY;
  
  return output;
}

s16 Dir_PID(s16 position, u16 dir_P, u16 dir_D){
  s16 outputDir;
  static s16 lastDirection = 0;
  outputDir = ( (s32) dir_P * position 
               + (s32) dir_D * (position - lastDirection ))/100;
  lastDirection = position;
  return outputDir;
}