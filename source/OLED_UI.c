
#include "includes.h"

uint16 debug_num=0;
uint16 e_debug_num=0;
U32 tclk=0;
char debug_msg[]="CF= LF= PF= SF=";
  /*
  UI_Page homepage;
  UI_Page subpage0;
  homepage.sub_type = (enum Item_Type *) malloc (4*2);
  homepage.sub_type[0] = Item_Type_Menu;
  homepage.sub = (void **)malloc (4*2); // (void **)(UI_Page **)
  *((UI_Page **)(homepage.sub)+0) = (UI_Page *) &subpage0;
  subpage0.parent = (void *) &homepage;
  
  subpage0.sub = (void **)123;
  Oled_Putnum(0,0,(s16)((*((UI_Page **)homepage.sub+0))->sub));
  */
  //free(homepage.sub);
  //free(homepage.sub_type);


enum Item_Type{
    Item_Type_Menu,
    Item_Type_Para,
    Item_Type_Show,
    Item_Type_Func,
};

typedef struct {
  void * parent;   // UI_Page *
  enum Item_Type * sub_type; 
  void ** sub;  // UI_Page **
}UI_Page;


void UI_SystemInfo(){
  //Oled_Putstr(0,0,"Car Type"); Oled_Putnum(0,11,CAR_TYPE);
  //Oled_Putstr(1,0,"battery"); Oled_Putnum(1,11,battery);
  Oled_Putstr(2,0,"Dbg"); Oled_Putnum(2,5,debug_num);
                          Oled_Putnum(2,11,e_debug_num);
  Oled_Putstr(3,0,"pit0/1"); Oled_Putnum(3,5,(s16)pit0_time);
                              Oled_Putnum(3,11,(s16)pit1_time);
  //Oled_Putstr(4,0,"tac0/1"); Oled_Putnum(4,5,tacho0);
  //                            Oled_Putnum(4,11,tacho1);
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

void UI_Graph(u8* data){
  
}
















