#ifndef OLED_UI_H
#define OLED_UI_H


extern uint16 debug_num;
extern uint16 e_debug_num;
extern char debug_msg[];
extern U32 tclk;

#define TICK() (tclk=(PIT->CHANNEL[2].CVAL))
#define TOCK() (e_debug_num=(tclk-(PIT->CHANNEL[2].CVAL)) \
                        / (g_bus_clock/10000))

void UI_SystemInfo();


#endif