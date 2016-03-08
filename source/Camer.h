/*
 * Cam.h
 *
 *  Created on: Jul 4, 2014
 *      Author: Administrator
 */

#ifndef CAM_H_
#define CAM_H_

#define IMG_ROWS (59) //max 96
#define IMG_COLS (120) //max 176
#define IMG_STEP 4	//for convenient

#define	IMG_START_ROW 22 //min clear row, 17 for P
#define	IMG_END 258 //for 525lines, 304 for P
#define	IMG_USED_BEGIN 11 //8-1+2+1,+2 for col-2,+1 for noise
#define	IMG_USED_END 111 //115-1-2-1,-2 for col+2,-1 for noise
#define IMG_MID_BEGIN 32//IMG_USED_BEGIN+g_nWidth[0]*0.02s*300cm/s/40cm
#define IMG_MID_END 90//IMG_USED_END-g_nWidth[0]*6/40
#define IMG_BLACK_MID_WIDTH 15//observed row==0 max width
#define IMG_BLACK_MID_BEGIN 24//insert_in(IMG_MIDDLE-g_nWidth[0]/2,IMG_USED_BEGIN,IMG_USED_END)
#define IMG_BLACK_MID_END 98//insert_in(IMG_MIDDLE+g_nWidth[0]/2,IMG_USED_BEGIN,IMG_USED_END)
#define IMG_MAX_SLOPE 98 //(IMG_USED_END-IMG_USED_BEGIN)
#define	IMG_USED_PIXEL 103 //(IMG_MAX_SLOPE+5)
#define ROW_MAX 240
#define	COL_MAX 320	//just tell the parameter of the camera

//
#define PREDICT_AREA 4 //for 2 points' max predicting error(+/-) is 5,so here choose 4 for efficiency
//for 3 points' max error is 4.5,so 4 is also the best choice
#define PREDICT_ERROR 1	//for 3 points' error per row is 1(here error mostly only refers to one side)
#define PREDICT_LINE_DISTORTION_ROW 2 //from the picture we get the horizontal line's taken rows-1
#define PREDICT_BEFORE_SLOPE_ROW 4 //for the height/width of the crossroad on the picture>0.5,and 5 points' error per row is 0.5
#define PREDICT_BOUND_SLOPE 4 //the minimum slope of most U turn's end captured
#define PREDICT_BOUND_BEFORE_SLOPE 12 //PREDICT_BEFORE_SLOPE_ROW*(PREDICT_BOUND_SLOPE - 1)//the max nBeforeSlope that can be accepted
#define ERROR_DENOMINATOR 4	//0.20 for measure error,0.05 for obstacle's error
#define IN_ERROR_DENOMINATOR 4	
#define OUT_ERROR_DENOMINATOR 4	
#define IN1_ERROR_DENOMINATOR 3
#define ERROR_SUB 24
#define LEFT 0
#define RIGHT 1
#define MAXROW_NUM 4
#define MIN_MOTOR_ROW 10
#define MIN_RIGHTANGLE_COUNT 20
#define RATRI_THRESHOLD1 3
#define RATRI_THRESHOLD2 7
#define BRICK_THRESHOLD 6
#define MAX_LOSTROW 4  
//

#include "typedef.h"
//
static const u8 g_nWidthRef[IMG_ROWS]=
{132,130,128,126,124,122,120,118,116,114,
112,110,108,106,104,103,101,99,97,95,
93,91,89,87,85,83,81,79,77,76,
75,73,71,69,67,65,63,61,59,57,
55,53,51,49,48,46,44,42,40,38,
36,34,32,30,28,26,24,22,20};
/*{125,124,122,121,119,118,116,115,113,112,
110,109,107,106,104,103,101,100,98,97,
95,94,92,90,89,87,86,84,83,81,
80,78,77,75,74,72,71,69,68,66,
65,63,62,60,58,57,55,54,52,51,
49,48,46,45,43,42,40,39,37};*/
static const u8 g_nDisPoiRow[IMG_ROWS]=
{0,24,44,61,76,89,100,110,119,127,
134,141,147,152,157,162,166,170,174,177,
180,183,186,189,191,193,196,198,200,201,
203,205,207,208,210,211,212,214,215,216,
217,218,219,220,221,222,223,224,225,226,
227,228,229,230,231,232,233,234,235};

extern U8 g_nEdgThre,g_nBlacThre,IMG_MIDDLE,START_TIME,SAFE,BRICK_DELAY,ZEBRA_DELAY,g_nZebraTurn;
extern b2 g_nLCap[IMG_ROWS],g_nRCap[IMG_ROWS],g_nLCapTB[IMG_ROWS],g_nRCapTB[IMG_ROWS];
extern u8 g_nLPos[IMG_ROWS+1],g_nRPos[IMG_ROWS+1],g_nLPosTB[IMG_ROWS],g_nRPosTB[IMG_ROWS],g_nWidth[IMG_ROWS+1];
extern u8 g_nLastMidPos,g_nMaxLRow,g_nMaxRRow,g_nMaxDirRow,g_nMinLTBRow,g_nMinRTBRow;
extern u8 g_nMaxRowIndex,g_nMaxRow[MAXROW_NUM],g_nStop,g_nCheckB,g_nCheckZB;
extern b2 g_bRAChecked,g_bBricChecked;//In Right-angle
extern u16 nRACheckTime,g_nBricTime;//Control Forced Drive In Start& interval
extern u8 g_bCBLChecked;

void GetLine(void);
void ComplementImg(u8 rowH,u8 rowL,b2 LR);
//
extern U8 g_nCamFrameIndex,g_nNowRow;
extern U8 g_nCamFrameBuffer[IMG_ROWS][IMG_COLS];

void CamInitSystem(void);
void ADC12_Init(void);
void DMA_Init(void);

#endif /* CAM_H_ */
