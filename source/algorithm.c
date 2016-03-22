#include "includes.h"
#define MINUS(x,y) (x<y?0:x-y)
BoundaryDetector boundary_detector;
GuideGenerator guide_generator;
DirectionPID dir_pid;
MotorPID motor_pid;



void DetectBoundary(){
  u8 LBeginScan = IMG_BLACK_MID_WIDTH+ABANDON, LEndScan = IMG_COLS / 2 - IMG_BLACK_MID_WIDTH;
  u8 RBeginScan = IMG_COLS - IMG_BLACK_MID_WIDTH-ABANDON, REndScan = IMG_COLS / 2 + IMG_BLACK_MID_WIDTH;
  u8 row = 0, col = 0, LPredict = LBeginScan, RPredict= RBeginScan, BoundaryShift = 2, LUnCap = 0, RUnCap = 0;
  u16 counter=0;
  
  boundary_detector.straightGuide=0;

  
  for (row = IMG_ROWS-5; row >= 1; --row){
    guide_generator.RBoundaryFlag[row] = guide_generator.LBoundaryFlag[row] = FALSE;
    for (col = LBeginScan; col <= LEndScan; ++col){
      if ((s16)img_buffer[row][col + IMG_BLACK_MID_WIDTH] > WHITE_THRESHOLD &&
          (s16)img_buffer[row][col]<BLACK_THRESHOLD){
            LPredict = boundary_detector.LBound[row] = col;
            guide_generator.LBoundaryFlag[row] = TRUE;
            LUnCap = 0;
            break;
          }
    }
    
    LUnCap++;
    if (LUnCap > 8){LUnCap=8;}
    LBeginScan = MINUS(LPredict,BoundaryShift*LUnCap);
    if (LBeginScan < IMG_BLACK_MID_WIDTH + ABANDON) {
      LBeginScan = IMG_BLACK_MID_WIDTH + ABANDON;
    }
    LEndScan = LPredict+BoundaryShift*LUnCap;
    if (LEndScan > IMG_COLS - IMG_BLACK_MID_WIDTH - ABANDON) {LEndScan = IMG_COLS - IMG_BLACK_MID_WIDTH - ABANDON;}
    for (col = RBeginScan; col >= REndScan; --col){
      if ((s16)img_buffer[row][col - IMG_BLACK_MID_WIDTH] > WHITE_THRESHOLD &&
          img_buffer[row][col]<BLACK_THRESHOLD){
            RPredict = boundary_detector.RBound[row] = col;
            guide_generator.RBoundaryFlag[row] = TRUE;
            RUnCap = 0;
            break;
          }
    }
    
    RUnCap++;
    if (RUnCap > 8) {RUnCap=8;}
    RBeginScan = RPredict+BoundaryShift*RUnCap;
    if (RBeginScan > IMG_COLS - IMG_BLACK_MID_WIDTH - ABANDON) {RBeginScan = IMG_COLS - IMG_BLACK_MID_WIDTH - ABANDON;}
    REndScan = MINUS(RPredict,BoundaryShift*RUnCap);
    if (REndScan < IMG_BLACK_MID_WIDTH + ABANDON) {REndScan = IMG_BLACK_MID_WIDTH + ABANDON;}
  }
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
  u8 row;
  s16 s16temp;
  s32 nShift=0,nDenom=0;
  g_nDirPos=IMG_COLS;
  
  
  for (row=IMG_ROWS-5;row>=1; --row)
  {
    //TrackWidth[row]=insert_in(TrackWidth[row],TrackWidth[row-1]-2,TrackWidth[row-1]+2);
    if (guide_generator.LBoundaryFlag[row]&& guide_generator.RBoundaryFlag[row]){
      g_nDirPos=s16temp=(boundary_detector.LBound[row]+boundary_detector.RBound[row]);guide_generator.GuideLine[row][0]=(s16temp)/2;
      break;
    }
    else if (guide_generator.LBoundaryFlag[row]){
      g_nDirPos=s16temp=2*boundary_detector.LBound[row] + TrackWidth[row];guide_generator.GuideLine[row][0]=(s16temp)/2;
      break;
    }
    else if (guide_generator.RBoundaryFlag[row]){
      g_nDirPos=s16temp=2*boundary_detector.RBound[row] - TrackWidth[row];guide_generator.GuideLine[row][0]=(s16temp)/2;
      break;
    }
  }
  for (row=row;row>=1;--row){
    if (guide_generator.LBoundaryFlag[row]&& guide_generator.RBoundaryFlag[row])
    {
      s16temp=insert_in((s16)boundary_detector.LBound[row]+boundary_detector.RBound[row],s16temp-6*row/IMG_ROWS,s16temp+16*row/IMG_ROWS);
      nShift+=(s16temp-IMG_COLS);nDenom+=1;guide_generator.GuideLine[row][0]=(s16temp)/2;
    }
    else if (guide_generator.LBoundaryFlag[row])
    {
      s16temp=insert_in((s16)boundary_detector.LBound[row]*2+TrackWidth[row],s16temp-6*row/IMG_ROWS,s16temp+6*row/IMG_ROWS);
      nShift+=(s16temp-IMG_COLS);nDenom+=1;guide_generator.GuideLine[row][0]=(s16temp)/2;
    }
    else if (guide_generator.RBoundaryFlag[row])
    {
      s16temp=insert_in((s16)boundary_detector.RBound[row]*2-TrackWidth[row],s16temp-6*row/IMG_ROWS,s16temp+6*row/IMG_ROWS);
      nShift+=(s16temp-IMG_COLS);nDenom+=1;guide_generator.GuideLine[row][0]=(s16temp)/2;
    }
    
  }
  if (nDenom!=0&& g_nDirPos-IMG_COLS<DangerZone ) g_nDirPos=nShift/nDenom;
  else g_nDirPos=g_nDirPos-IMG_COLS;
  currdir=10*g_nDirPos;
}


s16 Dir_PID(s16 position){
  s16 s16Tmp,g_nServoOut;
  s16Tmp=((s32)DIR_P*position+DIR_D*(position-dir_pid.LastDirection))/10;
  dir_pid.LastDirection=position;
  //if (s16Tmp<DIR_PWM_ZERO) s16Tmp=((s32)s16Tmp-DIR_PWM_ZERO)*120/100+DIR_PWM_ZERO
  g_nServoOut=s16Tmp*(PID_SENSITIVITY);//-100~100
  return g_nServoOut;
  //if (g_bRAChecked) std::cout<<(s16)(s8)g_nServoOut<<std::endl;
}


/*void MotorCtrl(void){
u8 ExpectSpeed=boundary_detector.yaotui*2;
if (g_bRAChecked) ExpectSpeed=40;
}*/


s16 Speed_PID(u8 Expect){
  s16 Error,Speed,Power;
  Speed=tacho0*TACHO_SENSITIVITY;
  Error=Expect-Speed;
  Power=insert_in(MOTOR_PID_P*Error +MOTOR_PID_D*(Error-motor_pid.LastError),0,SPEED_MAX);
  motor_pid.LastError=Error;
  if (tacho0) 
    return MOTOR_DEAD_RUN-100*Power/SPEED_MAX*MOTOR_PID_SENSITIVITY;
  else 
    return MOTOR_DEAD_REST-100*Power/SPEED_MAX*MOTOR_PID_SENSITIVITY;
}