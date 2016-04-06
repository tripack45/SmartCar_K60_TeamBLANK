#ifndef ALGORITHM_H
#define ALGORITHM_H

void extern AlgorithmMain();

#define insert(a,b,c) if ((a)<(b)) a=b;else if ((a)>(c)) a=c;
#define judge_in(a,b,c) (((b)<=(a)&&(a)<=(c))?1:0)
#define insert_in(a,b,c) ((a)<(b)?(b):(a)>(c)?c:a)
#define maxab(a,b) ((a)<(b)?b:a)
#define minab(a,b) ((a)>(b)?b:a)
#define abs0(a) ((a)>0?a:0)
#define maxabs(a,b) (abs(a)<abs(b)?b:a)



#define EXP_SEN               F_SPDEXP_SEN
#define MOTOR_PID_P           F_SPDPID_P     //SPEED_KI
#define MOTOR_PID_I           F_SPDPID_I
#define MOTOR_PID_D           F_SPDPID_D     //SPEED_KP
#define MOTOR_PID_SENSITIVITY 7
#define TACHO_SENSITIVITY 1
#define MOTOR_DEAD_RUN 320
#define MOTOR_DEAD_REST 400
#define SPEED_MAX 700

typedef struct MotorPIDConf{
  //===========INPUTS============
   //USES ExpectSpeed
  s16 LastError; //st_nLastError
  //===========OUTPUTS===========
  //Returns Variable currspd
  u8 NOTHING;
} MotorPID;

//extern BoundaryDetector_Old boundary_detector_Old;
//extern GuideGenerator guide_generator;
//extern DirectionPID dir_pid;
extern MotorPID motor_pid;

//void DirCtrl();
//void DetectBoundary();
//s16 Dir_PID(s16 position);
s16 Speed_PID(u8 Expect);
void MotorCtrl();


//Public Types
typedef struct{
  u8 *img_buffer;
  u8 state;
  u8 isUnknown;
  u8 carPosX;
  u8 carPosY;
  u8 *LBoundaryX; 
  u8 *LBoundaryY; 
  u8 LBoundarySize;
  u8 *RBoundaryX; 
  u8 *RBoundaryY; 
  u8 RBoundarySize;
  u8 fittedBoundary;
  float lineAlpha;
  float lineBeta;
  s16 lineMSE;
  s16 circleX;
  s16 circleY;
  s16 circleRadius;
  s32 circleMSE;
  u8  isInnerCircle;
}CurrentControlState;
//=======================


//Algorithm_Visual
//===============BOUNDARY DETECTION=======================
#define TRUE              1
#define FALSE             0
#define DIS_ROW           4
#define DIS_COL           3
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
#define SAMPLE_RATE 5
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
#define ALGC1 -104
#define ALGC2 8170 // Scaled by 10000
#define ORIGIN_X 39
#define ORIGIN_Y 35
#define TRAPZOID_HEIGHT 51
#define TRAPZOID_UPPER 38
#define TRAPZOID_LOWER 70
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
#define SQUARE_ERROR_THRES 10
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
#define CROSSROAD_SHARPTURN_THRES 25

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
#define CROSSROAD_INERTIA               10



extern CurrentControlState currentState;

void ControllerUpdate();
void ControllerControl();

//==========END OF CONTROLLER============

//==========LinearStateHandler===========

#define DANGERZONE      20
#define FASTSPEED       30
#define LOWSPEED        13
#define DIR_SENSITIVITY  10

void LinearStateHandler();

//========END OF LinearStateHandler=======

//========CrossRoadStateHandler===========

#define TRACK_WIDTH          70
#define INVERSE_IMG_ROWS     150
#define DIR_SENSITIVITY_OLD  10
#define EXCEPT_RANGE         3

//=======END OF CrossRoadStateHandler======

//========CircleStateHandler===========

#define MSE_RATIO            2
#define OFFSET_THRES         10
#define OFFSET_DIR_RATIO         10
#define SPD_MAX            30
#define SPD_MiN            10
#define RADIUS_MIN           70
#define RADIUS_MAX           300
#define DIR_HALF             300
#define DIR_MAX              600
#define CURVE_DIR_RATIO      (RADIUS_MIN * DIR_HALF)
#define CURVE_SPD_RATIO      0.05f
#define OFFSET_SPD_RATIO     0.5f
#define BASIC_SPD            10
void CircleStateHandler();

//=======END OF CrossRoadStateHandler======

#endif
