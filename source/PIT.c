/*
Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
Date : 2015/12/01
License : MIT
*/

#include "includes.h"


// ========= Variables =========

//--- global ---
U32 time_us = 0;
U32 pit0_time;
U32 pit1_time; 

//--- local ---
U32 pit1_time_tmp;

// =========== PIT 1 ISR =========== 
// ====  UI Refreshing Loop  ==== ( Low priority ) 

void PIT1_IRQHandler(){
  PIT->CHANNEL[1].TFLG |= PIT_TFLG_TIF_MASK;
  
  pit1_time_tmp = PIT2_VAL();
  
  //------------------------
  
  //LED1_Tog();
  
  UI_Operation_Service();
  
  Bell_Service();
    
  if(SW1()){
    if(isDebugging)Oled_Clear();
    isDebugging=0;
    UI_SystemInfo();
  }else{ 
    if(!isDebugging)Oled_Clear();
    isDebugging=1;
    UI_Debug();
  }
  //------------ Other -------------
  
  pit1_time_tmp = pit1_time_tmp - PIT2_VAL();
  pit1_time_tmp = pit1_time_tmp / (g_bus_clock/10000); //100us
  pit1_time = pit1_time_tmp;
  
}



//============ PIT 0 ISR  ==========
// ====  Control  ==== ( High priority )

void PIT0_IRQHandler(){
  PIT->CHANNEL[0].TFLG |= PIT_TFLG_TIF_MASK;
  
  time_us += PIT0_PERIOD_US;

  //LED2_Tog();
  
  
  //-------- System info -----
  
  pit0_time = PIT2_VAL();
    
  battery = Battery();
  
  debug_msg[2]=current_frame_indicator+'0';
  debug_msg[6]=last_frame_indicator+'0';
  debug_msg[10]=processing_frame_indicator+'0';
  debug_msg[14]=sending_frame_indicator+'0';
  //-------- Get Sensers -----
  
  
  // Tacho
  Tacho0_Get();
  Tacho1_Get();
  
  
  // UI operation input
  ui_operation_cnt += tacho0;  // use tacho0 or tacho1
  
  if(!isDebugging){
    Servo_Output(currdir);
    if(SW2())MotorL_Output( Speed_PID(currspd) );
  }else{
    Servo_Output(currdir);
    if(SW2())MotorL_Output(0);
  }
  
#if (CAR_TYPE==0)   // Magnet and Balance
  
  Mag_Sample();
  
  gyro1 = Gyro1();
  gyro2 = Gyro2();
  
  
  
#elif (CAR_TYPE==1)     // CCD
  
  CCD1_GetLine();
  CCD2_GetLine();

#else 
  // Camera
#ifdef ENABLE_USB
  if(usb_valid)cam_usb();
#endif
  // Results of camera are automatically put in cam_buffer[].
  
  
#endif
  
  
  
  pit0_time = pit0_time - PIT2_VAL();
  pit0_time = pit0_time / (g_bus_clock/1000000); //us
  
}




// ======= INIT ========

void PIT0_Init(u32 period_us)
{ 
                   
  SIM->SCGC6 |= SIM_SCGC6_PIT_MASK;
  
  PIT->MCR = 0x00;
 
  NVIC_EnableIRQ(PIT0_IRQn); 
  NVIC_SetPriority(PIT0_IRQn, NVIC_EncodePriority(NVIC_GROUP, 1, 2));

  //period = (period_ns/bus_period_ns)-1
  PIT->CHANNEL[0].LDVAL |= period_us/100*(g_bus_clock/1000)/10-1; 
  
  PIT->CHANNEL[0].TCTRL |= PIT_TCTRL_TIE_MASK |PIT_TCTRL_TEN_MASK;

};

void PIT1_Init(u32 period_us)
{ 
                   
  SIM->SCGC6 |= SIM_SCGC6_PIT_MASK;
  
  PIT->MCR = 0x00;
 
  NVIC_EnableIRQ(PIT1_IRQn); 
  NVIC_SetPriority(PIT1_IRQn, NVIC_EncodePriority(NVIC_GROUP, 3, 0));

  //period = (period_ns/bus_period_ns)-1
  PIT->CHANNEL[1].LDVAL |= period_us/100*(g_bus_clock/1000)/10-1; 
  
  PIT->CHANNEL[1].TCTRL |= PIT_TCTRL_TIE_MASK |PIT_TCTRL_TEN_MASK;

}

void PIT2_Init()
{ 
                   
  SIM->SCGC6 |= SIM_SCGC6_PIT_MASK;
  
  PIT->MCR = 0x00;

  //period = (period_ns/bus_period_ns)-1
  PIT->CHANNEL[2].LDVAL = 0xffffffff; 
  
  PIT->CHANNEL[2].TCTRL |= PIT_TCTRL_TEN_MASK;

}