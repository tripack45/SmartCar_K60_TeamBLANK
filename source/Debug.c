#include "includes.h"

#define GET_INT16_FROM_UINT8(x,y) ((int16)(uint16)((uint16)(x<<8)+(uint16)(y)))


int16* varAddr=(void*)&currspd;

void Debug_Init(){
  //Load the saved value into the position
  LoadVariable();
}

void ExecuteDebugCommand(u8 CmdNumber, u8* para){
  int16 paraInt16=0;
  if(para!=NULL)
    paraInt16=GET_INT16_FROM_UINT8(para[0],para[1]);
  //int16 para= (int16)( ((u16)cmdbuf[2])<<8 + ((u16)cmdbuf[3]));
  switch(CmdNumber){
  case CMDACK :
    return;
    
  case CMDKILL:
    DebugDeadlock();
    return;
    
  case CMDSET_SPD :
    return;
  case CMDSET_DIR :
    return;

  case CMDVARPLUS:
    *varAddr=SAVE_VAR;
    (*varAddr)+=5;
    SAVE_VAR=*varAddr;
    return;
  case CMDVARMINUS:
    *varAddr=SAVE_VAR;
    (*varAddr)-=5;
    SAVE_VAR=*varAddr;
    return;
  case CMDSAVEPARA:
    SaveVariable();
    return;
  }
}

void DebugDeadlock(){
  //Emergency Stop
  MotorL_Output(0);
  Servo_Output(0);
  for(int i=0;i<1000;i++)asm("NOP");
  __disable_irq();
  Oled_Clear();
  Oled_Putstr(3,0,"SYSTEM DEADLOCK");
  while(1){
    asm("NOP"); asm("NOP");
    asm("NOP"); asm("NOP");
  }
}

void LoadVariable(){
    (*varAddr)=SAVE_VAR;
}

void SaveVariable(){
    SAVE_VAR=*varAddr;
    Flash_Write(0);
}

void UI_Debug(){
   Oled_Putstr(2,0,"Select:");    Oled_Putnum(2,11,5);
   Oled_Putstr(3,0,"4 NONE"); Oled_Putnum(3,11,0);
   Oled_Putstr(4,0,"2 SAVEVAR"); Oled_Putnum(4,11,SAVE_VAR);
   Oled_Putstr(5,0,"3 CURRDIR"); Oled_Putnum(5,11,currdir);
   Oled_Putstr(6,0,"4 CURRSPD"); Oled_Putnum(6,11,currspd);
   Oled_Putstr(7,0,"5 USR_VAR"); Oled_Putnum(7,11,*varAddr);
   Oled_Putstr(1,0,"Prs Key3 to Save");
}

