#ifndef ALGORITHM_H
#define ALGORITHM_H

#include "cam.h"
#include "motor.h"

#define insert(a,b,c) if ((a)<(b)) a=b;else if ((a)>(c)) a=c;
#define judge_in(a,b,c) (((b)<=(a)&&(a)<=(c))?1:0)
#define insert_in(a,b,c) ((a)<(b)?(b):(a)>(c)?c:a)
#define maxab(a,b) ((a)<(b)?b:a)
#define minab(a,b) ((a)>(b)?b:a)
#define abs0(a) ((a)>0?a:0)
#define maxabs(a,b) (abs(a)<abs(b)?b:a)

#define IMG_BLACK_MID_WIDTH 2 
#define CONTRAST_THRESHOLD 8 //g_nEdgThre
#define BLACK_THRESHOLD 50    //g_nBlacThre
#define WHITE_THRESHOLD 60
#define ABANDON 2

typedef struct BoundaryDectectorConf{
  uint8 LBound[IMG_ROWS+1]; //nCBLLPos
  uint8 RBound[IMG_ROWS+1]; //nCBLRPos
  uint8 yaotui; //Return a line number which indicates how long the middle line lasts
}BoundaryDetector;

extern const u8 TrackWidth[IMG_ROWS];
typedef struct GuideGeneratorConf{
  //========INPUTS==========
  uint8 LBoundaryFlag[IMG_ROWS]; //g_nLCap
  uint8 RBoundaryFlag[IMG_ROWS]; //g_nRCap
  //=======OUTPUS==========
  s16 GuideLine[IMG_ROWS][1];     //GuideLine
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
#define PID_SENSITIVITY 1
#define DangerZone 60
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

void DirCtrl();
void DetectBoundary();
s16 Dir_PID(s16 position);

#endif