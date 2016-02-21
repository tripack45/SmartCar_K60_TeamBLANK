///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       21/Feb/2016  03:11:37
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\OLED_UI.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\OLED_UI.c -lCN
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\ -lB
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\ -o
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\Obj\ --no_cse
//        --no_unroll --no_inline --no_code_motion --no_tbaa --no_clustering
//        --no_scheduling --debug --endian=little --cpu=Cortex-M4 -e
//        --char_is_signed --fpu=None --dlib_config "C:\Program Files (x86)\IAR
//        Systems\Embedded Workbench 7.0\arm\INC\c\DLib_Config_Normal.h" -I
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\ -I
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\common\ -I
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\LPLD\ -I
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\LPLD\HW\ -I
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\LPLD\DEV\ -Ol -I
//        "C:\Program Files (x86)\IAR Systems\Embedded Workbench
//        7.0\arm\CMSIS\Include\" -D ARM_MATH_CM4
//    List file    =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\OLED_UI.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN Oled_Putnum
        EXTERN Oled_Putstr
        EXTERN last_processed_frame
        EXTERN last_sent_frame
        EXTERN pit0_time
        EXTERN pit1_time
        EXTERN process_diff
        EXTERN send_diff

        PUBLIC UI_Graph
        PUBLIC UI_SystemInfo
        PUBLIC debug_msg
        PUBLIC debug_num
        PUBLIC e_debug_num
        PUBLIC tclk

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\OLED_UI.c
//    1 
//    2 #include "includes.h"
//    3 

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//    4 uint16 debug_num=0;
debug_num:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//    5 uint16 e_debug_num=0;
e_debug_num:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    6 U32 tclk=0;
tclk:
        DS8 4

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//    7 char debug_msg[]="CF= LF= PF= SF=";
debug_msg:
        DATA
        DC8 "CF= LF= PF= SF="
//    8   /*
//    9   UI_Page homepage;
//   10   UI_Page subpage0;
//   11   homepage.sub_type = (enum Item_Type *) malloc (4*2);
//   12   homepage.sub_type[0] = Item_Type_Menu;
//   13   homepage.sub = (void **)malloc (4*2); // (void **)(UI_Page **)
//   14   *((UI_Page **)(homepage.sub)+0) = (UI_Page *) &subpage0;
//   15   subpage0.parent = (void *) &homepage;
//   16   
//   17   subpage0.sub = (void **)123;
//   18   Oled_Putnum(0,0,(s16)((*((UI_Page **)homepage.sub+0))->sub));
//   19   */
//   20   //free(homepage.sub);
//   21   //free(homepage.sub_type);
//   22 
//   23 
//   24 enum Item_Type{
//   25     Item_Type_Menu,
//   26     Item_Type_Para,
//   27     Item_Type_Show,
//   28     Item_Type_Func,
//   29 };
//   30 
//   31 typedef struct {
//   32   void * parent;   // UI_Page *
//   33   enum Item_Type * sub_type; 
//   34   void ** sub;  // UI_Page **
//   35 }UI_Page;
//   36 
//   37 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   38 void UI_SystemInfo(){
UI_SystemInfo:
        PUSH     {R7,LR}
//   39   //Oled_Putstr(0,0,"Car Type"); Oled_Putnum(0,11,CAR_TYPE);
//   40   //Oled_Putstr(1,0,"battery"); Oled_Putnum(1,11,battery);
//   41   Oled_Putstr(2,0,"Dbg"); Oled_Putnum(2,5,debug_num);
        ADR.N    R2,??DataTable0  ;; "Dbg"
        MOVS     R1,#+0
        MOVS     R0,#+2
        BL       Oled_Putstr
        LDR.N    R0,??DataTable0_2
        LDRSH    R2,[R0, #+0]
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+5
        MOVS     R0,#+2
        BL       Oled_Putnum
//   42                           Oled_Putnum(2,11,e_debug_num);
        LDR.N    R0,??DataTable0_3
        LDRSH    R2,[R0, #+0]
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+11
        MOVS     R0,#+2
        BL       Oled_Putnum
//   43   Oled_Putstr(3,0,"pit0/1"); Oled_Putnum(3,5,(s16)pit0_time);
        LDR.N    R2,??DataTable0_4
        MOVS     R1,#+0
        MOVS     R0,#+3
        BL       Oled_Putstr
        LDR.N    R0,??DataTable0_5
        LDR      R2,[R0, #+0]
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+5
        MOVS     R0,#+3
        BL       Oled_Putnum
//   44                               Oled_Putnum(3,11,(s16)pit1_time);
        LDR.N    R0,??DataTable0_6
        LDR      R2,[R0, #+0]
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+11
        MOVS     R0,#+3
        BL       Oled_Putnum
//   45   //Oled_Putstr(4,0,"tac0/1"); Oled_Putnum(4,5,tacho0);
//   46   //                            Oled_Putnum(4,11,tacho1);
//   47   Oled_Putstr(5,0,(void*)debug_msg);
        LDR.N    R2,??DataTable0_7
        MOVS     R1,#+0
        MOVS     R0,#+5
        BL       Oled_Putstr
//   48 #if (CAR_TYPE==0)   // Magnet and Balance
//   49   
//   50   Oled_Putstr(7,0,"accx"); Oled_Putnum(7,11,accx);
//   51   
//   52 #elif (CAR_TYPE==1)     // CCD
//   53   
//   54   
//   55 #else               // Camera
//   56   Oled_Putstr(6,0,"Send"); 
        LDR.N    R2,??DataTable0_8
        MOVS     R1,#+0
        MOVS     R0,#+6
        BL       Oled_Putstr
//   57   Oled_Putnum(6,5,last_sent_frame);
        LDR.N    R0,??DataTable0_9
        LDR      R2,[R0, #+0]
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+5
        MOVS     R0,#+6
        BL       Oled_Putnum
//   58   Oled_Putnum(6,11,send_diff);
        LDR.N    R0,??DataTable0_10
        LDR      R2,[R0, #+0]
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+11
        MOVS     R0,#+6
        BL       Oled_Putnum
//   59   Oled_Putstr(7,0,"cam"); 
        ADR.N    R2,??DataTable0_1  ;; "cam"
        MOVS     R1,#+0
        MOVS     R0,#+7
        BL       Oled_Putstr
//   60   Oled_Putnum(7,5,last_processed_frame);
        LDR.N    R0,??DataTable0_11
        LDR      R2,[R0, #+0]
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+5
        MOVS     R0,#+7
        BL       Oled_Putnum
//   61   Oled_Putnum(7,11,process_diff);
        LDR.N    R0,??DataTable0_12
        LDR      R2,[R0, #+0]
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+11
        MOVS     R0,#+7
        BL       Oled_Putnum
//   62   //cam_acquired_frames=0;
//   63 #endif
//   64 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0:
        DC8      "Dbg"

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_1:
        DC8      "cam"

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_2:
        DC32     debug_num

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_3:
        DC32     e_debug_num

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_4:
        DC32     ?_1

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_5:
        DC32     pit0_time

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_6:
        DC32     pit1_time

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_7:
        DC32     debug_msg

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_8:
        DC32     ?_2

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_9:
        DC32     last_sent_frame

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_10:
        DC32     send_diff

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_11:
        DC32     last_processed_frame

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable0_12:
        DC32     process_diff
//   65 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   66 void UI_Graph(u8* data){
//   67   
//   68 }
UI_Graph:
        BX       LR               ;; return

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
        DATA
        DC8 "Dbg"

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_1:
        DATA
        DC8 "pit0/1"
        DC8 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_2:
        DATA
        DC8 "Send"
        DC8 0, 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
        DATA
        DC8 "cam"

        END
//   69 
//   70 
//   71 
//   72 
//   73 
//   74 
//   75 
//   76 
//   77 
//   78 
//   79 
//   80 
//   81 
//   82 
//   83 
//   84 
// 
//   8 bytes in section .bss
//  16 bytes in section .data
//  24 bytes in section .rodata
// 224 bytes in section .text
// 
// 224 bytes of CODE  memory
//  24 bytes of CONST memory
//  24 bytes of DATA  memory
//
//Errors: none
//Warnings: none
