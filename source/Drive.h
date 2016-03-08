/*
 * Drv.h
 *
 *  Created on: Jul 7, 2014
 *      Author: ZZH
 */

#ifndef DRV_H_
#define DRV_H_
#include "typedef.h"

#define MOTOR0_DEAD_ZONE_GO 0//left motor go dead output
#define MOTOR1_DEAD_ZONE_GO 0 //right motor go dead output
#define MOTOR0_DEAD_ZONE_BACK 3000 //left motor back dead output
#define MOTOR1_DEAD_ZONE_BACK 3000 //right motor back dead output
#define DIR_PWM_ZERO 1460//servo 0 point
#define DIR_PWM_MIN 1280//safe dir/servo limit,turn the 50cm turn need min 110!
#define DIR_PWM_MAX 1640
#define DIR_PWM_RANGE 180
#define SPEED_PWM_MIN (-32767/3*2)//safe speed/motor limit
#define SPEED_PWM_MAX (32767/3*2)
#define HISTORY_MAX (10)//10*1ms
#define RA_THRESHOLD_ROWS 6

typedef struct _DRV_MOTOR_CONTEXT{
	S16 expect,speed;
	U16 index;
	U16 history[HISTORY_MAX];
} DRV_MOTOR_CONTEXT;



extern DRV_MOTOR_CONTEXT DrvpMotorContext;
extern S16 g_nPWM;
extern U8 DIR_P,DIR_D;
extern U8 SPEED_KP,SPEED_KI,SPEED_KD;
extern s16 g_nDirPosH[3];
extern u8 g_nDirPosHIndex,g_nServoOut;

void DirWeightInit(void);
void DirCtrl(void);
void MotorCtrl(void);
void Dir_PID(s16 position);
void Speed_PID(void);

//c++
void ServoPWM(s8 i);
void DRV_PWM_SetRatio16(s16 ratio);//0 is left, 1 is right

//error
#define g_nCount10ms 0




#endif /* DRV_H_ */
