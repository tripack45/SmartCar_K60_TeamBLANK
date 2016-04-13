#include "includes.h"

void LinearStateHandler(){
  
  if (ABS(currentState.lineAlpha)  > ALPHA_BOUND){
    CrossroadStateHandler();
    currspd = LOWSPEED;
    return;
  }
  
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

void SteeringAid(){
  s32 delta = currentState.lineAlpha<60 ? 0 : currentState.lineAlpha;
  delta = delta * ABS(delta);
  delta = delta * AID_SENSITIVITY / 10000;
  /*
  s16 dirDiff = currentState.lineAlpha 
              * currentState.lineAlpha 
              * currentState.lineAlpha 
              * AID_SENSITIVITY
              / 100 / 100 / 100;
  */
  currdir += (s16)delta;
  currspd -= ABS(delta) * BRAKE_SENSITIVITY / AID_SENSITIVITY / 10;
                
}
