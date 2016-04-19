#include "includes.h"
//=========Model Predicting Controlling=====

#define MPC_INTERVAL 2 // 2 frames per perdiction
#define MPC_N 10// Sampling Period
#define MPC_P 10 // Perdiction Horizon

// @spd=20
float MPCModel1[MPC_N]={0.0022f  , 0.0087f  , 0.0196f , 0.0348f , 0.0542f ,
                        0.0778f  , 0.1054f  , 0.1369f , 0.1721f , 0.2110f};
float MPCControlVec1[MPC_P]={0.209f, 0.698f ,1.167f, 1.470f, 1.649f,
                             1.771f, 1.824f ,1.794f, 1.668f, 1.432f}; 

//@spd=10
float MPCModel2[MPC_N]={0.000548,0.002190,0.004924,0.008748,0.013658,0.019647,0.026709,0.034837,0.044020,0.054249};
float MPCControlVec2[MPC_P]={0.173118,0.602877,1.071223,1.535874,1.908167,2.151732,2.250668,2.205667,2.025825,1.720388};

float* MPCModel=MPCModel2;
float* MPCControlVec=MPCControlVec2;

float MPCPrediction[MPC_P]={1}; 

float MPCCorrectionVec[MPC_P]={1,0.11,0.11,0.11,0.11,
                               0.11,0.11,0.11,0.11,0.11};
float MPCLastOut=0;


void MPCHandler(){
  static u8 flag=0;
  if(flag){
    s32 numerator = currentState.carPosX * 100
      - currentState.lineAlpha * currentState.carPosY 
        - currentState.lineBeta;
    //s32 numerator = ABS(numerator);
    s64 denominator = (s64)currentState.lineAlpha * (s64)currentState.lineAlpha + 10000;
    s32 denom = Isqrt(denominator);
    float distance = numerator/(float)denom;
    debugWatch[1]=(s16)(s32)distance;
    float dir=MPC(distance, 0);
    currdir=(s16)(s32)dir;
  }else{
    flag=1-flag;
  }
}
  
  

float MPC(float y, int setPoint){
  //Error Prediction
  float error = y - MPCPrediction[0];
  for(int p=0; p < MPC_P; p++)
    MPCPrediction[p] += MPCCorrectionVec[p] * error; 
  //Rolling Forward
  for(int p=0; p < MPC_P-1; p++)
    MPCPrediction[p] = MPCPrediction[p+1];
  
  float deltaControl =0;
  for(int p=0; p < MPC_P; p++){
    volatile float e= setPoint -MPCPrediction[p];
    volatile float k= MPCControlVec[p];
    deltaControl += e * k;
    //deltaControl += ((float)setPoint - MPCPrediction[p]) * MPCControlVec[p];
  }
  
  MPCLastOut += deltaControl;
  
  for(int p=0; p< MPC_P; p++){
    if(p>=MPC_N)
      MPCPrediction[p]+=MPCModel[MPC_N-1] * deltaControl;
    else
      MPCPrediction[p]+=MPCModel[p] * deltaControl;
  }
  
  return MPCLastOut;
}



