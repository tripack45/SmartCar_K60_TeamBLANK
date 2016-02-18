#ifndef __OLED_H__
#define __OLED_H__

#include "common.h"
#include "typedef.h"


// ===== APIs =====
// Notation:  this Oled has 8 rows (0-7)  and 21 columns (0-20)

  // put a String at row x and begins at column y
  // x = 0 ~ 7 ; y = 0 ~ (20 - sizeof(ch[]))  ; ch[] is your string
void Oled_Putstr(u8 x,u8 y,u8 ch[]);

  // put a Number at row x and begins at column y
  // x = 0 ~ 7 ; y = 0 ~ 12 ; c is your num of type signed 16-bit integer
void Oled_Putnum(u8 x,u8 y,s16 c);

  // clear 
void Oled_Clear(void);

  // init
void Oled_Init(void);


#endif