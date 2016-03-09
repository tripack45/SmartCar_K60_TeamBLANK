#ifndef ALGORITHM_H
#define ALGORITHM_H

#include "cam.h"

typedef struct BoundaryDectectorConf{
  uint8 LBound[IMG_ROWS];
  uint8 RBound[IMG_ROWS];
}BoundaryDetector;

typedef struct GuideGeneratorConf{
  //========INPUTS==========
  uint8 TrackWidth[IMG_ROWS+1];  //g_nWidth
  uint8 LBoundaryFlag[IMG_ROWS]; //g_nLCap
  uint8 RBoundaryFlag[IMG_ROWS]; //g_nLCap
  //=======OUTPUS==========
  s16 DGuidePos;                 //g_nDirPos
}GuideGenerator;

typedef struct DirectionGeneratorConf{
  //===========INPUTS============
     //USES DGuidePos
  //===========OUTPUTS===========
     //Returns INPUT
  u8 NOTHING;
}DirectionGeneratior;

#define PID_P 20        //DIR_P
#define PID_I 0         //DIR_I
#define PID_D 100       //DIR_D
typedef struct DirectionPIDConf{
  //===========INPUTS==============
    //Uses DGuidePos
   s16 LastDirection; //nLastPostion
  //=============OUTPUS=============
    //Global Variable currdir
  u8 NOTHING;
}DirectionPID;

extern BoundaryDetector boundary_detector;
extern GuideGenerator guide_generator;
extern DirectionPID dir_pid;
#endif