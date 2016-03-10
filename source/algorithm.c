#include "includes.h"

BoundaryDetector boundary_detector;
GuideGenerator guide_generator;
DirectionPID dir_pid;

void DetectBoundary(){
  u8 nLBeginScan = 2, nLEndScan = IMG_COLS-2;
  u8 row=0; u8 col=0;
  for (row = 0; row<IMG_ROWS; ++row) {guide_generator.RBoundaryFlag[row] = guide_generator.LBoundaryFlag[row] = FALSE;
  for (col = nLBeginScan; col <= nLEndScan; ++col){//IMG_MIDDLE
    if ((s16)img_buffer[row][col + 2] - img_buffer[row][col - 1]>CONTRAST_THRESHOLD &&
        img_buffer[row][col - 2]<BLACK_THRESHOLD /*&&
        img_buffer[row][col - IMG_BLACK_MID_WIDTH]>BLACK_THRESHOLD*/){
          boundary_detector.LBound[row] = col;
          guide_generator.LBoundaryFlag[row] = TRUE;
          break;
	}
  }
  for (col = nLEndScan; col >= nLBeginScan; --col){
    if ((s16)img_buffer[row][col - 2] - img_buffer[row][col + 1]>CONTRAST_THRESHOLD &&
        img_buffer[row][col + 2]<BLACK_THRESHOLD /*&& 
        img_buffer[row][col + IMG_BLACK_MID_WIDTH]>BLACK_THRESHOLD*/){
          boundary_detector.RBound[row] = col;
          guide_generator.RBoundaryFlag[row] = TRUE;
          break;
	}
  }}
}


//Dir
U8 DIR_P=20,DIR_D=100;
//s32 g_nWeight[IMG_ROWS],g_nWeight2[IMG_ROWS];
s16 g_nDirPos;//g_nDirPosH[3];


const u8 TrackWidth[IMG_ROWS]=
{34,35,35,36,37,37,38,39,40,40,
 42,42,43,43,45,45,45,47,47,48,
 49,50,50,51,51,52,53,53,53,55,
 55,56,57,57,58,58,59,60,60,61,
 61,62,63,63,64,64,64,66,66,66,
 67,67,69,69,69,70,70,70,70,71,
 72,72,72,73,73,74,75};

void DirCtrl(void){
  u8 row,nMidCol=IMG_COLS;
  s16 s16temp;
  g_nDirPos=0;
  
  for (row=IMG_ROWS;row>=1; --row)
  {
    //TrackWidth[row]=insert_in(TrackWidth[row],TrackWidth[row-1]-2,TrackWidth[row-1]+2);
    if (guide_generator.LBoundaryFlag[row]&& guide_generator.RBoundaryFlag[row]){
      g_nDirPos=s16temp=(boundary_detector.LBound[row]+boundary_detector.RBound[row]);guide_generator.GuideLine[row][0]=(s16temp)/2;
      break;
    }
    else if (guide_generator.LBoundaryFlag[row]){
      g_nDirPos=s16temp=2*boundary_detector.LBound[row] - TrackWidth[row];guide_generator.GuideLine[row][0]=(s16temp)/2;
      break;
    }
    else if (guide_generator.RBoundaryFlag[row]){
      g_nDirPos=s16temp=2*boundary_detector.RBound[row] + TrackWidth[row];guide_generator.GuideLine[row][0]=(s16temp)/2;
      break;
    }
  }
  g_nDirPos=g_nDirPos-nMidCol;
  currdir=Dir_PID(g_nDirPos);
}


s16 Dir_PID(s16 position){
  s16 s16Tmp,g_nServoOut;
  s16Tmp=((s32)DIR_P*position+DIR_D*(position-dir_pid.LastDirection))/10;
  dir_pid.LastDirection=position;
  //if (s16Tmp<DIR_PWM_ZERO) s16Tmp=((s32)s16Tmp-DIR_PWM_ZERO)*120/100+DIR_PWM_ZERO
  g_nServoOut=s16Tmp/(PID_SENSITIVITY);//-100~100
  return g_nServoOut;
  //if (g_bRAChecked) std::cout<<(s16)(s8)g_nServoOut<<std::endl;
}

