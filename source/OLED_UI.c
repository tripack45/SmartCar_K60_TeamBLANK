
#include "includes.h"

uint16 debug_num=0;
uint16 e_debug_num=0;
U32 tclk=0;
char debug_msg[]="CF= LF= PF= SF=";

void UI_SystemInfo(){
  //Oled_Putstr(0,0,"Car Type"); Oled_Putnum(0,11,CAR_TYPE);
  Oled_Putstr(1,0,"battery"); Oled_Putnum(1,11,battery);
  Oled_Putstr(2,0,"Dbg"); Oled_Putnum(2,5,debug_num);
                          Oled_Putnum(2,11,e_debug_num);
  Oled_Putstr(3,0,"pit0/1"); Oled_Putnum(3,5,(s16)pit0_time);
                              Oled_Putnum(3,11,(s16)pit1_time);
  Oled_Putstr(4,0,"tac0/1"); Oled_Putnum(4,5,tacho0);
                              Oled_Putnum(4,11,tacho1);
  Oled_Putstr(5,0,(void*)debug_msg);
#if (CAR_TYPE==0)   // Magnet and Balance
  
  Oled_Putstr(7,0,"accx"); Oled_Putnum(7,11,accx);
  
#elif (CAR_TYPE==1)     // CCD
  
  
#else               // Camera
  Oled_Putstr(6,0,"Send"); 
  Oled_Putnum(6,5,last_sent_frame);
  Oled_Putnum(6,11,send_diff);
  Oled_Putstr(7,0,"cam"); 
  Oled_Putnum(7,5,last_processed_frame);
  Oled_Putnum(7,11,process_diff);
  //cam_acquired_frames=0;
#endif
}
















