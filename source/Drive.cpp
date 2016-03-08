#include "Camer.h"
#include "drive.h"
#include "motor.h"

//Dir
U8 DIR_P=20,DIR_D=100;
s32 g_nWeight[IMG_ROWS],g_nWeight2[IMG_ROWS];
s16 g_nDirPos,g_nDirPosH[3];
U8 g_nDirBeginRow=35,g_nDirLimit=10,g_nRowEnd=45,D_RET_MAX=150,g_bRATurn,g_nRABeginRow=30;
U16 g_nTurnTime;
u8 g_nMayRALCount,g_nMayRARCount;
u8 g_nDirPosHIndex=2;//Pos=position
u8 g_nServoOut;//0~180
//Speed
DRV_MOTOR_CONTEXT DrvpMotorContext;//speed/HISTORY_MAX/500lines*1000ms*N0/N1*(Pi*D)=speed/10*2*43/28*10/24*(Pi*4.6cm)=speed*1.8(cm/s)
s16 g_nSpeedSet;//0left1right,1==1.8cm/s
U8 g_nSpeedHigh=80,g_nSpeedLow=50;//1=18cm/s,but now it seems like abouot 1=5cm/s
//U8 SPEED_KP=15,SPEED_KI=70,SPEED_KD=0;
U8 SPEED_KP=30,SPEED_KI=10,SPEED_KD=0;

extern s16 GuideLine[IMG_ROWS][IMG_COLS];

static  S16 RtlScaleS16(S16 x,S16 l0,S16 h0,S16 l,S16 h){
	return (S16)(((S32)x-l0)*((S32)h-l)/((S32)h0-l0)+l);
}

static S16 RtlSquareS16(S16 number){
	return number*number;
}
void DirWeightInit(void){
	u8 row,NtpCFGTransfer=30,row0=15;
	for (row=0;row<row0;++row){
		g_nWeight[row]=row*row;
		g_nWeight2[row]=g_nWeight[row]*RtlScaleS16(RtlSquareS16(IMG_ROWS-row),0,IMG_ROWS*IMG_ROWS,1000,NtpCFGTransfer*100)/1000;
	}
	for (row=row0;row<IMG_ROWS;++row){
		g_nWeight[row]=(row-row0)*(row-row0);
		g_nWeight2[row]=g_nWeight[row]*RtlScaleS16(RtlSquareS16(IMG_ROWS-row),0,IMG_ROWS*IMG_ROWS,1000,NtpCFGTransfer*100)/1000;
	}
}
void DirCtrl(void){
	static u8 rowstart=1;
	u8 row,rowend=g_nMaxDirRow,nMidCol=2*IMG_MIDDLE,u8Tmp,u8Tmp2;
	u8 nDirSkewLimit=(s16)65*IMG_USED_PIXEL/100;
	s16 s16temp;
	s32 nShift=0,nDenom=0;
	rowend=insert_in(g_nMaxDirRow,0,g_nRowEnd);
	row=insert_in(g_nDirBeginRow,1,rowend-1);
	g_nDirPos=0;
	if (g_bBricChecked){
		if (g_nCount10ms-g_nBricTime>9){//Delay 0.1s
			g_bBricChecked=0;
		}
		if (g_bBricChecked==2)
			nMidCol=IMG_USED_BEGIN+IMG_MIDDLE;
		else if (g_bBricChecked==3)
			nMidCol=IMG_USED_END+IMG_MIDDLE;
	}
	for (row=row;row<=rowend; ++row)
	{
		g_nWidth[row]=insert_in(g_nWidth[row],g_nWidth[row-1]-2,g_nWidth[row-1]+2);
		if (g_nLCap[row]&& g_nRCap[row]){
			g_nDirPos=s16temp=(g_nLPos[row]+g_nRPos[row]);GuideLine[row][0]=(s16temp)/2;
			break;
		}
		else if (g_nLCap[row]){
			//g_nDirPos=s16temp=2*g_nLPos[row] - g_nWidth[row];GuideLine[row][0]=(s16temp)/2;
			g_nDirPos=s16temp=2*g_nLPos[row] - 2*g_nWidth[row];GuideLine[row][0]=(s16temp)/2;
			break;
		}
		else if (g_nRCap[row]){
			//g_nDirPos=s16temp=2*g_nRPos[row] + g_nWidth[row];GuideLine[row][0]=(s16temp)/2;
			g_nDirPos=s16temp=2*g_nRPos[row] +2* g_nWidth[row];GuideLine[row][0]=(s16temp)/2;
			break;
		}
	}
	for (row=row;row<=rowend;++row){
		g_nWidth[row]=insert_in(g_nWidth[row],g_nWidth[row-1]-2,g_nWidth[row-1]+2);
		if (g_nLCap[row]&& g_nRCap[row])
		{
			s16temp=insert_in((s16)g_nLPos[row]+g_nRPos[row],s16temp-12*row/IMG_ROWS,s16temp+12*row/IMG_ROWS);
			nShift+=(s16temp-nMidCol)*g_nWeight2[row];nDenom+=g_nWeight[row];GuideLine[row][0]=(s16temp)/2;
		}
		else if (g_nLCap[row])
		{
			s16temp=insert_in((s16)g_nLPos[row]*2-g_nWidth[row],s16temp-12*row/IMG_ROWS,s16temp+12*row/IMG_ROWS);
			nShift+=(s16temp-nMidCol)*g_nWeight2[row];nDenom+=g_nWeight[row];GuideLine[row][0]=(s16temp)/2;
		}
		else if (g_nRCap[row])
		{
			s16temp=insert_in((s16)g_nRPos[row]*2+g_nWidth[row],s16temp-12*row/IMG_ROWS,s16temp+12*row/IMG_ROWS);
			nShift+=(s16temp-nMidCol)*g_nWeight2[row];nDenom+=g_nWeight[row];GuideLine[row][0]=(s16temp)/2;
		}
	}
	if(g_nDirPos!=0){
		g_nDirPos=g_nDirPos-nMidCol;
		if(nDenom!=0){
			g_nDirPos=insert_in(nShift/nDenom,g_nDirPos-nDirSkewLimit,g_nDirPos+nDirSkewLimit);
		}//if nDenom==0 directly use g_nDirPos
	}else{
		g_nDirPos=(g_nDirPosH[0]+g_nDirPosH[1]+g_nDirPosH[2])/2;//keep turn more,especially for right-angle
	}
	if (g_bRAChecked==1){
		/*if ((g_nCount10ms-nRACheckTime>15)&&(minab(g_nMaxLRow,g_nMaxRRow)<IMG_ROWS/2)){//Delay till no updating nRACheckTime
			if (g_nMaxRRow>g_nMaxLRow+10){
				g_bRATurn=1;g_bRAChecked=0;g_nTurnTime=g_nCount10Hz;//turn left
			}else if (g_nMaxLRow>g_nMaxRRow+10){
				g_bRATurn=2;g_bRAChecked=0;g_nTurnTime=g_nCount10Hz;//turn right
			}
		}*/
		g_nMayRALCount=g_nMayRARCount=0;
		for (row=g_nRABeginRow;row<g_nRABeginRow+10;++row){
			if (g_nLCap[row]&&!g_nRCap[row]&&abs((s16)g_nLPos[row]-g_nWidth[row]/2-IMG_MIDDLE)<5) g_nMayRARCount++;
			else if (g_nRCap[row]&&!g_nLCap[row]&&abs((s16)g_nRPos[row]+g_nWidth[row]/2-IMG_MIDDLE)<5) g_nMayRALCount++;
		}
		if (g_nMayRALCount>RA_THRESHOLD_ROWS){
			g_bRATurn=1;g_bRAChecked=0;g_nTurnTime=g_nCount10ms;//turn left
		}
		if (g_nMayRARCount>RA_THRESHOLD_ROWS){
			g_bRATurn=2;g_bRAChecked=0;g_nTurnTime=g_nCount10ms;//turn left
		}
	}else if (g_bRAChecked>1){//Turn Triangle
		if (g_nCount10ms-nRACheckTime>9){//Turn 0.1s
			g_bRAChecked=1;
		}
		if (g_bRAChecked==2)
			g_nDirPos=g_nDirPosH[g_nDirPosHIndex]+IMG_COLS/10;
		else g_nDirPos=g_nDirPosH[g_nDirPosHIndex]-IMG_COLS/10;
	}
	if (g_bRATurn){
		if (g_nCount10ms-g_nTurnTime>15){//Turn 0.15s
			g_bRATurn=0;//std::cout<<"Out!"<<std::endl;
		}
		if (g_bRATurn==1)
			g_nDirPos=g_nDirPosH[g_nDirPosHIndex]+IMG_COLS/10;
		else g_nDirPos=g_nDirPosH[g_nDirPosHIndex]-IMG_COLS/10;//3
	}
	g_nDirPos=insert_in(g_nDirPos,-(s16)g_nDirLimit*IMG_USED_PIXEL/10,(s16)g_nDirLimit*IMG_USED_PIXEL/10);
	Dir_PID(-g_nDirPos);
	g_nDirPosHIndex=(g_nDirPosHIndex+1)%3;
	g_nDirPosH[g_nDirPosHIndex]=g_nDirPos;
}
void MotorCtrl(void){
	u8 SpeedRow=g_nMaxLRow+g_nMaxRRow-g_nMaxRow[g_nMaxRowIndex];
	if(g_nMaxRow[g_nMaxRowIndex]>=g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-1)%MAXROW_NUM]&&
			g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-1)%MAXROW_NUM]>=g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-2)%MAXROW_NUM]&&
			!(g_nMaxRow[g_nMaxRowIndex]==g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-1)%MAXROW_NUM]&&
					g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-1)%MAXROW_NUM]==g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-2)%MAXROW_NUM]))
		SpeedRow=insert_in(SpeedRow+IMG_ROWS*8/50,0,IMG_ROWS);
	else if(g_nMaxRow[g_nMaxRowIndex]<=g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-1)%MAXROW_NUM]&&
			g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-1)%MAXROW_NUM]<=g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-2)%MAXROW_NUM]&&
			!(g_nMaxRow[g_nMaxRowIndex]==g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-1)%MAXROW_NUM]&&
					g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-1)%MAXROW_NUM]==g_nMaxRow[(g_nMaxRowIndex+MAXROW_NUM-2)%MAXROW_NUM]))
		SpeedRow=insert_in(SpeedRow-IMG_ROWS*8/50,0,IMG_ROWS);
	if(SpeedRow<IMG_ROWS*15/50) g_nSpeedSet=(s16)g_nSpeedLow*10;//g_nSpeedHigh/2;
	else if(SpeedRow<IMG_ROWS*33/50) g_nSpeedSet=(s16)g_nSpeedLow*10;//*3/3
	else if(SpeedRow<IMG_ROWS*39/50) g_nSpeedSet=((s16)g_nSpeedHigh+g_nSpeedLow*2)*10/3;
	else if(SpeedRow<IMG_ROWS*46/50) g_nSpeedSet=((s16)g_nSpeedHigh+g_nSpeedLow)*10/2;
	else if(SpeedRow<IMG_ROWS*49/50) g_nSpeedSet=((s16)g_nSpeedHigh*2+g_nSpeedLow)*10/3;
	else g_nSpeedSet=(s16)g_nSpeedHigh*10;
	//if (MinULRow<IMG_ROWS||MinURRow<IMG_ROWS) {g_nSpeedSet=g_nSpeedLow;UTurn=TRUE;}
	if (g_bRAChecked&&g_nCount10ms-nRACheckTime>10)//delay 0.1s
		DrvpMotorContext.expect=300;
	else if (g_bBricChecked)
		DrvpMotorContext.expect=g_nSpeedLow*10;
	else
		DrvpMotorContext.expect=g_nSpeedSet;
}
void Dir_PID(s16 position){
	//s16temp=(Position*ServoP*(IMG_ROWS*11/10+MaxRow*2/10+MaxRow*MaxRow*(-80)/100/IMG_ROWS)/IMG_ROW/10+ServoD*(Position-lastPosition))/10/2;
	static s16 nLastPosition=0;
	s16 s16Tmp;
	s16Tmp=((s32)DIR_P*position+DIR_D*(position-nLastPosition))/10+DIR_PWM_ZERO;
	nLastPosition=position;
	//if (s16Tmp<DIR_PWM_ZERO) s16Tmp=((s32)s16Tmp-DIR_PWM_ZERO)*120/100+DIR_PWM_ZERO;
	insert(s16Tmp,DIR_PWM_MIN,DIR_PWM_MAX);
	g_nServoOut=(s16Tmp-DIR_PWM_MIN)*200/(DIR_PWM_MAX-DIR_PWM_MIN)-100;//-100~100
	ServoPWM(g_nServoOut);
	//if (g_bRAChecked) std::cout<<(s16)(s8)g_nServoOut<<std::endl;
	s16Tmp-=DIR_PWM_ZERO;
	//if (s16Tmp<0)
		//DrvpMotorContext[0].expect=RtlScaleS16(-s16Tmp,0,DIR_PWM_RANGE,DrvpMotorContext[0].expect,DrvpMotorContext[0].expect/2);
	//else if (s16Tmp>0)
		//DrvpMotorContext[1].expect=RtlScaleS16(s16Tmp,0,DIR_PWM_RANGE,DrvpMotorContext[1].expect,DrvpMotorContext[1].expect/2);
}
void Speed_PID(void){
	DRV_MOTOR_CONTEXT *mc;
	u16 current;
	s32 nError;
	static s32 st_nLastError={0},st_nLLastError={0};

#define ACTION(idx)\
	do{\
		mc=&DrvpMotorContext;\
		mc->speed=Accx()*200;\
		nError=mc->expect-mc->speed;\
		g_nPWM=insert_in((s32)g_nPWM+SPEED_KP*(nError-st_nLastError)\
				+SPEED_KI*nError+SPEED_KD*(nError+st_nLLastError\
						-2*st_nLastError),SPEED_PWM_MIN,SPEED_PWM_MAX);\
		st_nLLastError=st_nLastError;\
		st_nLastError=nError;\
	}while (0)
	
	ACTION(0);
	//g_nPWM[0]=g_nPWM[1]=5000;
	DRV_PWM_SetRatio16(g_nPWM);
}
void ServoPWM(s8 i){
	if (i>100) i=100;
	if (-i>100) i=-100;
	Servo_Output(i);
	//ServoDegree=i;
}
void DRV_PWM_SetRatio16(s16 ratio)//-32768~32767, 0 is 50%
{
	if (ratio>0){
		if (ratio<32767-MOTOR0_DEAD_ZONE_GO) ratio=ratio+MOTOR0_DEAD_ZONE_GO;
		else ratio=32767;
	}else if (ratio<0){
		if (ratio>-32768+MOTOR0_DEAD_ZONE_BACK) ratio=ratio-MOTOR0_DEAD_ZONE_BACK;
		else ratio=-32768;
	}
	ratio=-((s32)ratio*90)>>15;
        MotorL_Output(ratio);
}
