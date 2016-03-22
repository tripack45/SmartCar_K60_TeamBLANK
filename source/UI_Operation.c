/*
Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
Date : 2015/12/04
License : MIT
*/


#include "includes.h"



// ====== Settings ======

  // Sensibility of operation
  // smaller, more sensitive
#define SENSIBILITY 8

  // Strength to debounce
  // depends on period of UI Refreshing Loop
#define DEBOUNCE_CNT 6 




// ====== Variables ======

// ---- Global ----
u16 ui_operation_shift, ui_operation_cnt;

// ---- Local ----
u8 Key3_down    ,Key1_down      ,Key2_down;   // flag : state of pushed down
u8 Key3_rise    ,Key1_rise      ,Key2_rise;   // flag : transient state of rising
u8 Key3_cnt     ,Key1_cnt       ,Key2_cnt;      // counter to debounce
u8 Key1_risemask,Key2_risemask  ,Key3_risemask;   // flag to mask Rise_Func after DownSpin_Func



// ====== Local Func Declaration ====

  // --- API ---
void Key1_Rise_Func();
void Key2_Rise_Func();
void Key3_Rise_Func();
void Spin_Func();

// --- Baisc Drivers ---
void Key1_Read();
void Key2_Read();
void Key3_Read();

// ====== APIs =======
// write your codes in certain Func you wanna realize.


// --- Keyn_Rise_Func ---
// triggered when Keyn rises after push with no spin of tacho.

void Key1_Rise_Func(){
  ExecuteDebugCommand(CMDVARPLUS,NULL);
}

void Key2_Rise_Func(){
  ExecuteDebugCommand(CMDVARMINUS,NULL);
}

void Key3_Rise_Func(){   
  Bell_Request(3); 
  ExecuteDebugCommand(CMDSAVEPARA,NULL);
}

  // --- Spin_Func ---
  // triggered when spinning tacho with no Key pushed.
void Spin_Func(){
  //Bell_Request(1);
}

// ========= Service ======= 
// Put this in UI refreshing loop (PIT1_ISR)

void UI_Operation_Service(){
  
  Key3_Read();
  Key1_Read();
  Key2_Read();
  
  if(Key1_rise){
    Key1_rise=0;
    Key1_Rise_Func();
  }
  if(Key2_rise){
    Key2_rise=0;
    Key2_Rise_Func();
  }
  if(Key3_rise){
    Key3_rise=0;
    Key3_Rise_Func();
  }
  
}

// ===== Basic Drivers ====

void Key1_Read(){
  if(Key1()==0){
    Key1_down=1;
    Key1_cnt=0;
  }
  else if(Key1_down && Key1_cnt<DEBOUNCE_CNT)
    Key1_cnt++;
  else if(Key1_down){
    Key1_down=0;
    Key1_rise=1;
  }
  else
    Key1_down=0;
}

void Key2_Read(){
  if(Key2()==0){
    Key2_down=1;
    Key2_cnt=0;
  }
  else if(Key2_down && Key2_cnt<DEBOUNCE_CNT)
    Key2_cnt++;
  else if(Key2_down){
    Key2_down=0;
    Key2_rise=1;
  }
  else
    Key2_down=0;
}

void Key3_Read(){
  if(Key3()==0){
    Key3_down=1;
    Key3_cnt=0;
  }
  else if(Key3_down && Key3_cnt<DEBOUNCE_CNT)
    Key3_cnt++;
  else if(Key3_down){
    Key3_down=0;
    if(Key3_risemask==0)
      Key3_rise=1;
    else
      Key3_risemask=0;
  }
  else
    Key3_down=0;
}