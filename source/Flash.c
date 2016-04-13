/*
Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
Date : 2016/01/15
License : MIT
*/
#include "includes.h"


// ===== Global Variables =====

U16 flashData[DATA_NUM];

U16 data_initial[DATA_NUM]={
  1,	        //data flag
  90,	        //F_DIRPID_P
  70,	        //F_RADIUS_MIN
  300,	        //F_RADIUS_MAX
  10,	        //F_OFFSET_THRES
  10,	        //F_OFFSET_DIR_RATIO
  15,	        //F_LINE_LOWSPD
  15,	        //F_LINE_HIGHSPD   
  30,            //F_AID_SENSITIVITY
  20,            //F_DIRPID_D
  50,           //Spped PD_I
  10,           //Speed Sensitivity 
  30,           //Spped PD_P
  10,           //Speed PD_D
  25,           // SAVE_VAR
  1,            // STEPLENGTH
};




// ======= APIs =======


void Flash_Write(U16 sector){
  U32 addr = ADDR + sector*SECTOR_SIZE;
  __disable_irq();
  Flash_Erase(sector);
  Flash_Program(sector,DATA_NUM,flashData);
  __enable_irq();
}


U16 Flash_Read(U16 sector,U16 data_index){
  U16* addr = (U16*)(ADDR + sector*SECTOR_SIZE + data_index * 0x02);
  return *addr;
}


void Flash_Data_Update(U16 sector){
  U8 i;
  for(i=0;i<DATA_NUM;i++){
    flashData[i] = Flash_Read(sector,i);
  }
}

void Flash_Data_Reset(void){
  U16 i;
  for(i=0;i<DATA_NUM;i++){
    flashData[i] = data_initial[i];
  }
  Flash_Write(0);
}

  // Init
void Flash_Init(void){
  FMC->PFB0CR|=FMC_PFB0CR_S_B_INV_MASK;
  FMC->PFB1CR|=FMC_PFB0CR_S_B_INV_MASK;
  while(!(FTFL->FSTAT&FTFL_FSTAT_CCIF_MASK));
  FTFL->FSTAT=FTFL_FSTAT_ACCERR_MASK|FTFL_FSTAT_FPVIOL_MASK;
  
  // check data_flag
  if(Flash_Read(0,0)!=1) Flash_Data_Reset();
  else Flash_Data_Update(0);
}



// ======= Basic Drivers ======

U8 Flash_Erase(U16 num){
  union{
    U32 Word;
    U8  Byte[4];
  }FlashDestination;
  FlashDestination.Word=ADDR+num*SECTOR_SIZE;
  FTFL->FCCOB0=FTFL_FCCOB0_CCOBn(ERSSCR);
  FTFL->FCCOB1=FlashDestination.Byte[2];
  FTFL->FCCOB2=FlashDestination.Byte[1];
  FTFL->FCCOB3=FlashDestination.Byte[0];
  if(FlashCMD()==1){return 1;}//Error
  return 0;//Success
}

U8 Flash_Program(U16 num, U16 WriteCounter, U16 *DataSource){
  U32 size;
  U32 destaddr;
  union{
    U32 Word;
    U8 Byte[4];
  }FlashDestination; 
  FTFL->FCCOB0=PGM4;
  destaddr=(ADDR+num*SECTOR_SIZE);
  FlashDestination.Word=destaddr;
  for(size=0;size<WriteCounter;size+=2,FlashDestination.Word+=4,DataSource+=2){
    FTFL->FCCOB1=FlashDestination.Byte[2];
    FTFL->FCCOB2=FlashDestination.Byte[1];
    FTFL->FCCOB3=FlashDestination.Byte[0];
    FTFL->FCCOB4=DataSource[1]>>8;
    FTFL->FCCOB5=DataSource[1]&0xFF;
    FTFL->FCCOB6=DataSource[0]>>8;
    FTFL->FCCOB7=DataSource[0]&0xFF;    
    if(FlashCMD()==1)return 2;
  }
  return 0;
}


static U8 FlashCMD(void){
  FTFL->FSTAT=FTFL_FSTAT_ACCERR_MASK|FTFL_FSTAT_FPVIOL_MASK;
  FTFL->FSTAT=FTFL_FSTAT_CCIF_MASK;
  while(!(FTFL->FSTAT&FTFL_FSTAT_CCIF_MASK));
  if(FTFL->FSTAT&(FTFL_FSTAT_ACCERR_MASK|FTFL_FSTAT_FPVIOL_MASK|FTFL_FSTAT_MGSTAT0_MASK)){return 1;}//Failed
  return 0;//Success
}
