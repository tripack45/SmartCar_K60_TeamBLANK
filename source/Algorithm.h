#ifndef ALGORITHM_H
#define ALGORITHM_H

void AlgorithmMain();

u8 IsStartLine(u8 img_buffer[][IMG_COLS]);

#define insert(a,b,c) if ((a)<(b)) a=b;else if ((a)>(c)) a=c;
#define judge_in(a,b,c) (((b)<=(a)&&(a)<=(c))?1:0)
#define insert_in(a,b,c) ((a)<(b)?(b):(a)>(c)?(c):(a))
#define maxab(a,b) ((a)<(b)?b:a)
#define minab(a,b) ((a)>(b)?b:a)
#define abs0(a) ((a)>0?a:0)
#define maxabs(a,b) (abs(a)<abs(b)?b:a)


//Public Types
typedef struct{
  u8 *img_buffer;
  u8 state;
  u8 isStartLine;
  u8 isUnknown;
  u8 carPosX;
  u8 carPosY;
  s16 radialDis;
  u8 *LBoundaryX; 
  u8 *LBoundaryY; 
  u8 LBoundarySize;
  u8 *RBoundaryX; 
  u8 *RBoundaryY; 
  u8 RBoundarySize;
  u8 fittedBoundary;
  s32 lineAlpha;
  s32 lineBeta;
  s32 lineMSE;
  s16 circleX;
  s16 circleY;
  s16 circleRadius;
  s32 circleMSE;
  s8  innerCircleFlag; //-1 == left, 1 == Right
}CurrentControlState;
//=======================


//Algorithm_Visual
//===============BOUNDARY DETECTION=======================
#define TRUE              1
#define FALSE             0
#define DIS_ROW           4
#define DIS_COL           5
#define MZ                0
#define LBEGIN_SCAN       DIS_COL
#define LEND_SCAN         IMG_COLS / 2
#define WHITE_THRES       60
#define START_LINE_HEIGHT 10
#define BOUNDARY_LENGTH   300
#define DIR_LEFT          0
#define DIR_UP            1
#define DIR_RIGHT         2
#define DIR_DOWN          3

typedef struct BoundaryDectectorConf{
    //========INPUTS==========
    //image_buffer
    //=======OUTPUS==========
    u8 boundaryX[BOUNDARY_LENGTH];
    u8 boundaryY[BOUNDARY_LENGTH];
    u8 LSectionHead;
    u8 LSectionTail;
    u8 RSectionHead;
    u8 RSectionTail;
}BoundaryDetector;

void DetectBoundary();

u8 GuideLoc(u8 pointrow,u8 pointcol);

extern BoundaryDetector boundaryDetector;

//==============END OF BOUNDARY DETECTION================

//===============INVERSE TRANSFORM=================
#define SAMPLE_RATE 1
#define PERSPECTIVE_SCALE 70
#define REAL_WORLD_SCALE 50 // 70pts==50cm
/* Formula
 * Transform: y'= y / (c1*y + c2 )
 * InverseTr: y = c2*y'/(1 - c1*y )
 * The frame of reference is at the center of the
 * image, i.e. at (39,35)
 *   O ---------> x
 *    |
 *    |
 *    V y
*/
#define ALGC1 -159
#define ALGC2 10129 // Scaled by 10000
#define ORIGIN_X 38 
#define ORIGIN_Y 31
#define TRAPZOID_HEIGHT 33
#define TRAPZOID_UPPER 32
#define TRAPZOID_LOWER 53
/* Formula
   Standard_50(y')= Upeer + (Lower- Upper)* y' / Height
   x= PERSPECTIVE_SCALE * x' / Standard_50(y')
*/
u8 InversePerspectiveTransform(s8* xIn,s8* yIn, u8 size);
//===============END OF INVERSE TRANSFORM=================


//Algorithm_Analysis

/**********************************
*      Created by Jerry Yang      *
*      March. 27, 2016            *
***********************************/

/******* constant definitions *******/
#define HALF_TRACK 35
#define SELECT_STEP 5
#define BOUNDARY_NUM_MAX 128
#define SELECT_NUM_MAX 26
#define SQUARE_ERROR_THRES 10
#define STRAIGHT_MSE_CRIT 3
/************************************/

typedef struct LinearDectectorConf{
    //========INPUTS==========
    //boundaryX
    //boundaryY
    //=======OUTPUS==========
    float alpha;
    float beta;
    float radius;
}LinearDectect;


/****** function definitions ******/
void CurveFitting(CurrentControlState* CState);
/**********************************/

extern LinearDectect linearDectect;

//============Crossroad Detection=========

#define CROSSROAD_STRAIGHT_THRES  81
#define CROSSROAD_SHARPTURN_THRES 15

u8 IsCrossroad(u8* boundaryX,u8* boundaryY, u8 size);

//==========End of Crossroad Detection===

//==============Controller=============
#define CONTROL_STATE_STRAIGHT 0x01
#define CONTROL_STATE_TURN     0x02
#define CONTROL_STATE_CROSS    0x03
#define CONTROL_STATE_STR2TRN  0x04

#define CONSISTENCY_AWARD               10
#define INCONSISTENCY_PUNISHMENT        30
#define PROMOTION_REQUIREMENT           30
#define MAXIMUM_SCORE                   50
#define CROSSROAD_INERTIA               4



extern CurrentControlState currentState;

void ControllerUpdate();
void ControllerControl();

//==========END OF CONTROLLER============

//==========LinearStateHandler===========

#define DANGERZONE      20
#define FASTSPEED       F_LINE_HIGHSPD
#define LOWSPEED        F_LINE_LOWSPD
#define DIR_SENSITIVITY 8
#define LINEAR_PID_P    50
#define LINEAR_PID_D    10
#define ALPHA_BOUND     10
void LinearStateHandler();

//========END OF LinearStateHandler=======


//==========Str2TrnStateHandler===========

#define STR2TRN_CHANG_ZONE 10
void Str2TrnStateHandler();

//=======END OF Str2TrnStateHandler=======

//========CrossRoadStateHandler===========

#define TRACK_WIDTH          70
#define INVERSE_IMG_ROWS     150
#define DIR_SENSITIVITY_OLD  20
#define EXCEPT_RANGE         3
#define GOP_PID_P            F_DIRPID_P
#define GOP_PID_D            F_DIRPID_D
void CrossroadStateHandler();

//=======END OF CrossRoadStateHandler======

//========CircleStateHandler===========

#define MSE_RATIO            2
#define OFFSET_THRES         F_OFFSET_THRES
#define OFFSET_DIR_RATIO     F_OFFSET_DIR_RATIO
#define SPD_MAX              20
#define SPD_MIN              13
#define RADIUS_MIN           F_RADIUS_MIN
#define RADIUS_MAX           F_RADIUS_MAX
#define DIR_HALF             300
#define DIR_MAX              600
#define CURVE_DIR_RATIO      (RADIUS_MIN * DIR_HALF)
#define CURVE_SPD_RATIO      20
#define OFFSET_SPD_RATIO     2
#define BASIC_SPD            10
u32 Isqrt(s64 x );
void CircleStateHandler();

//=======END OF CircleStateHandler======


//=========SteeringAid==================


#define AID_SENSITIVITY F_AID_SENSITIVITY
#define BRAKE_SENSITIVITY F_BRAKE_SENSITIVITY
void SteeringAid ();
    //========INPUTS==========
    //currentState.lineAlpha
    //=======OUTPUS==========
    //currdir

//=========END OF SteeringAid============


//============Utility Functions=========


s16 Dir_PID(s16 position, u16 dir_P, u16 dir_D);

#define EXP_SEN               10
#define MOTOR_PID_P           F_SPDPID_P     //SPEED_KI
#define MOTOR_PID_I           F_SPDPID_I
#define MOTOR_PID_D           F_SPDPID_D     //SPEED_KP
#define MOTOR_PID_SENSITIVITY 13
#define TACHO_SENSITIVITY 1
#define MOTOR_DEAD_RUN 320
#define MOTOR_DEAD_REST 400
#define SPEED_MAX 700
s16 Speed_PID(s16 Expect);

s32 MALineAlpha(s32 input);
s32 MALineBeta(s32 input);
s16 MACircleX(s16 input);
s16 MACircleY(s16 input);
s16 MACircleRadius(s16 input);
//=========Moving Average========

//======================================
#endif
