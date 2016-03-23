#include "includes.h"

#define GET_INT16_FROM_UINT8(x,y) ((int16)(uint16)((uint16)(x<<8)+(uint16)(y)))


int16* varAddr=(void*)NULL;
u8 isDebugging=0;

//Debug Menu
u8 varEdit=14; u8 isEditing=0;

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
    if(varAddr==NULL)return;
    *varAddr=SAVE_VAR;
    (*varAddr)+=5;
    SAVE_VAR=*varAddr;
    return;
  case CMDVARMINUS:
    if(varAddr==NULL)return;
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
  if(varAddr!=NULL)
    (*varAddr)=SAVE_VAR;
}

void SaveVariable(){
  if(varAddr!=NULL)
    SAVE_VAR=*varAddr;
    Flash_Write(0);
}

const char* varName[]=
              {"0  RESERVE",           //Flash[0]
               "1  NONE",             //Flash[1]
               "2  NONE",             //Flash[2]
               "3  NONE",             //Flash[3]
               "4  NONE",             //Flash[4]
               "5  NONE",             //Flash[5]
               "6  NONE",             //Flash[6]
               "7  NONE",             //Flash[7]
               "8  NONE",             //Flash[8]
               "9  NONE",             //Flash[9]
               "10 SpdPd_I",          //Flash[10]
               "11 EXP_SEN",          //Flash[11]
               "12 SpdPd_P",          //Flash[12]
               "13 SpdPd_D",          //Flash[13]
               "14 USRVAR",           //Flash[14] 
               "15 STEPLEN"};         //Flash[15]   


void DebugKeyPress1(){
  if(isEditing){
    if(varEdit==14){//User Variable
      ExecuteDebugCommand(CMDVARPLUS,NULL);
      return;
    }
    if(varEdit==15){
      STEPLENGTH++;
      return;
    }
    flashData[varEdit]+=STEPLENGTH;
  }else
    varEdit=(varEdit+1)&0x0f;
}

void DebugKeyPress2(){
  if(isEditing){ 
    if(varEdit==14){//User Variable
      ExecuteDebugCommand(CMDVARMINUS,NULL);
      return;
    }
    if(varEdit==15){
      STEPLENGTH--;
      return;
    }
    flashData[varEdit]-=STEPLENGTH;
  }
  else
    varEdit=(varEdit-1)&0x000f;
  
}

void DebugKeyPress3(){
  if(isEditing)
    ExecuteDebugCommand(CMDSAVEPARA,NULL);
  isEditing=1-isEditing;
}

void UI_Debug(){
  if(isEditing){
    Oled_Putstr(1,0,"Editing:   ");
  }
  else{
    Oled_Putstr(1,0,"Select Var ");
  }
  Oled_Putnum(1,11,varEdit);
  
  Oled_Putstr(3,0,"NONE"); Oled_Putnum(3,11,0);
  Oled_Putstr(4,0,"USERVAR"); Oled_Putnum(4,11,*varAddr);
  Oled_Putstr(5,0,"CURRDIR"); Oled_Putnum(5,11,currdir);
  Oled_Putstr(6,0,"CURRSPD"); Oled_Putnum(6,11,currspd);
  
  Oled_Putstr(7,0,"           ");
  Oled_Putstr(7,0,(u8*)(varName[varEdit]));
  Oled_Putnum(7,11,flashData[varEdit]);
}

