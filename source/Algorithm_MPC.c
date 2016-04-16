#include "includes.h"
//=========Model Predicting Controlling=====

#define MPC_INTERVAL 2 // 2 frames per perdiction
#define MPC_N 15 // Sampling Period
#define MPC_P 15 // Perdiction Horizon

// @spd=20
float MPCModel1[MPC_N]={0.0022f  , 0.0087f  , 0.0196f , 0.0348f , 0.0542f ,
                        0.0778f  , 0.1054f  , 0.1369f , 0.1721f , 0.2110f,
                        0.2532f  , 0.2988f  , 0.3473f , 0.3987f , 0.4527f};
float MPCControlVec1[MPC_P]={0.209f, 0.698f ,1.167f, 1.470f, 1.649f,
                             1.771f, 1.824f ,1.794f, 1.668f, 1.432f,
                             1.076f, 0.587f ,-0.045f ,-0.830f,-1.773f}; 

//@spd=10
float MPCModel2[MPC_N]={0.000548,0.002190,0.004924,0.008748,0.013658,
                        0.019647,0.026709,0.034837,0.044020,0.054249,
                        0.065512,0.077796,0.091088,0.105373,0.120634}; 
float MPCControlVec2[MPC_P]={0.062751,0.231075,0.458283,0.701802,0.924118,
                             1.103712,1.232933,1.304177,1.309902,1.242638,
                             1.095004,0.859724,0.529636,0.097707,-0.442949};

float* MPCModel=MPCModel2;
float* MPCControlVec=MPCControlVec2;

float MPCPrediction[MPC_P]={0}; 

float MPCCorrectionVec[MPC_P]={1,1,1,1,1,
                               1,1,1,1,1,
                               1,1,1,1,1};
float MPCLastOut=0;

//Obtained Through Offline Calculations


// The dynamics Matrix, P by M

void MPC_Initialize(){
  //Initialize Dynamcis Matrix
  
}

s16 MPC(int y, int setPoint){
  //Error Prediction
  float error = y - MPCPrediction[0];
  for(int p=0; p < MPC_P; p++)
    MPCPrediction[p] += MPCCorrectionVec[p] * error; 
  //Rolling Forward
  for(int p=0; p < MPC_P-1; p++)
    MPCPrediction[p] = MPCPrediction[p+1];
  
  float deltaControl =0;
  for(int p=0; p < MPC_P; p++)
    deltaControl += (setPoint - MPCPrediction[p]) * MPCControlVec[p];
  
  MPCLastOut += deltaControl;
  
  for(int p=0; p< MPC_P; p++){
    if(p>=MPC_N)
      MPCPrediction[p]+=MPCModel[MPC_N-1] * deltaControl;
    else
      MPCPrediction[p]+=MPCModel[p] * deltaControl;
  }
  
  return (s16)(int)MPCLastOut;
}



