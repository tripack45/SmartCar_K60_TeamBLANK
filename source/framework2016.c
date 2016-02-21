/*
Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
Date : 2015/12/01
License : MIT
*/


#include "includes.h"


U8 ADC0_enabled = 0;
U8 ADC1_enabled = 0;


void main (void)
{
  
  // --- System Initiate ---
  
  __disable_irq();
  
  HMI_Init();
  PIT0_Init(PIT0_PERIOD_US);
  PIT1_Init(PIT1_PERIOD_US);
  PIT2_Init();
  
  Flash_Init();
  
  if(!SW2()){
      UART_Init(921600);
  }else if(!SW3()){
      UART_Init(460800);
  }else{
      UART_Init(115200);
  } 
  //UART_Configure_DMA();
  UART_SetMode(UART_MODE_DMA_MANNUAL);
 
  Motor_Init();
  Tacho_Init();
  Servo_Init();
  
#if (CAR_TYPE==0)   // Magnet and Balance
  
  Mag_Init();
  LPLD_MMA8451_Init();
  Gyro_Init();
  
#elif (CAR_TYPE==1)     // CCD
  
  CCD_Init();
  
#else               // Camera
  
  Cam_Init();
  
#endif
  
  //-- Press Key 1 to Continue --
  Oled_Putstr(7,1,"Press Key1 to go on");
  while (Key1());while (!Key1());
  Oled_Clear();
/* 
UART_SetMode(UART_MODE_DMA_MANNUAL);
  
//const char welcome_msg[]="Team [BLANK], JI-SJTU";
//Bluetooth_SendDataChunkSync((void*)welcome_msg,sizeof(welcome_msg)-1);
//UART_SetMode(UART_MODE_DMA_CONTINUOUS);
 
  uint8 tdata[50][100]={0};
  uint8 *p=(uint8*)tdata;
  int t=sizeof(tdata);
  for(int i=1;i<t;i++){
    p[i]=p[i-1]+1;
  }
  //preparing testdata
  //TICK();
  t=1;
  while(t--)
    Bluetooth_SendDataChunkSync((uint8*)tdata,sizeof(tdata));
  //TOCK();*/
//UART_SetMode(UART_MODE_DMA_CONTINUOUS);

  ////// System Initiated ////
  
  // --- Flash test --- 
  // To use this test, turn off Switch 1 first
  if(!SW1()){
    __disable_irq();
    Oled_Clear();
    Oled_Putstr(0,0,"data[1] in flash is:");
    Oled_Putstr(2,0,"data[1] in flash is:");
    Oled_Putnum(1,11,Flash_Read(0,1));
    data[1] = Flash_Read(0,1)+1;
    Flash_Write(0);
    __disable_irq();
    Oled_Putnum(3,11,Flash_Read(0,1));
    //-- Press Key 1 to Continue --
    Oled_Putstr(6,1,"Press Key1 to go on");
    while (Key1());
    Oled_Clear();
    ///// Flash test End///
    __enable_irq(); 
    if(!SW4()){
      Bluetooth_Configure();
    }
  }
  __enable_irq(); 



  while(1)
  {
    // Don't use oled or sensors' functions here !!!
    
   
#if (CAR_TYPE==0)
    
  accx = Accx();    // this might be blocked , so put here instead of interrupt
  //accy = Accy();
  //accz = Accz();
    
#elif (CAR_TYPE==2)
    Cam_Algorithm();    // 
#endif
    
  } 
}






// ===== System Interrupt Handler  ==== ( No Need to Edit )

void BusFault_Handler(){
  Oled_Clear();
  Oled_Putstr(1,5,"Bus Fault");
  Oled_Putstr(4,1,"press Key1 to goon");
  while(Key1());
  
  return;
}


void NMI_Handler(){
  Oled_Clear();
  Oled_Putstr(1,5,"NMI Fault");
  Oled_Putstr(4,1,"press Key1 to goon");
  while(Key1());
  
  return;
}

void HardFault_Handler(void)
{
  //LED1_Tog();
  Oled_Clear();
  Oled_Putstr(1,5,"Hard Fault");
  Oled_Putstr(4,1,"press Key1 to goon");
  while(Key1());
  
  return;
}


void DefaultISR(void)
{
  Oled_Clear();
  Oled_Putstr(1,5,"Default ISR");
  Oled_Putstr(4,2,"press Key1 to goon");
  while(Key1());

  return;
}
