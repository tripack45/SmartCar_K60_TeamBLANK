///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       21/Feb/2016  03:11:37
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  E:\freescale_racing\SmartCar_K60_TeamBLANK\source\IMU.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\IMU.c -lCN
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
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\IMU.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN ADC1_enabled

        PUBLIC Gyro1
        PUBLIC Gyro2
        PUBLIC Gyro_Init
        PUBLIC accx
        PUBLIC accy
        PUBLIC accz
        PUBLIC gyro1
        PUBLIC gyro2

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\IMU.c
//    1 /*
//    2 Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
//    3 Date : 2015/12/01
//    4 License : MIT
//    5 */
//    6 
//    7 
//    8 #include "includes.h"
//    9 
//   10 
//   11 // ===== Global Variables =====
//   12 

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   13 S16 accx, accy, accz;
accx:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
accy:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
accz:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   14 S16 gyro1, gyro2;
gyro1:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
gyro2:
        DS8 2
//   15 
//   16 
//   17 
//   18 // ===== API Realization =====
//   19 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   20 s16 Gyro1(){
//   21 #if GYRO_ADCx
//   22   ADC1->SC1[0] = ADC_SC1_ADCH(8);
Gyro1:
        MOVS     R0,#+8
        LDR.N    R1,??DataTable2  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   23   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Gyro1_0:
        LDR.N    R0,??DataTable2  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Gyro1_0
//   24   return ADC1->R[0];
        LDR.N    R0,??DataTable2_1  ;; 0x400bb010
        LDR      R0,[R0, #+0]
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   25 #else
//   26   ADC0->SC1[0] = ADC_SC1_ADCH(8);
//   27   while((ADC0->SC1[0]&ADC_SC1_COCO_MASK)==0);
//   28   return ADC0->R[0];
//   29 #endif
//   30 }
//   31 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   32 s16 Gyro2(){
//   33 #if GYRO_ADCx
//   34   ADC1->SC1[0] = ADC_SC1_ADCH(9);
Gyro2:
        MOVS     R0,#+9
        LDR.N    R1,??DataTable2  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   35   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Gyro2_0:
        LDR.N    R0,??DataTable2  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Gyro2_0
//   36   return ADC1->R[0];
        LDR.N    R0,??DataTable2_1  ;; 0x400bb010
        LDR      R0,[R0, #+0]
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   37 #else
//   38   ADC0->SC1[0] = ADC_SC1_ADCH(9);
//   39   while((ADC0->SC1[0]&ADC_SC1_COCO_MASK)==0);
//   40   return ADC0->R[0];
//   41 #endif
//   42 }
//   43 
//   44 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   45 void Gyro_Init(){
//   46   
//   47   if(!ADC1_enabled){
Gyro_Init:
        LDR.N    R0,??DataTable2_2
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BNE.N    ??Gyro_Init_0
//   48     SIM->SCGC3 |= SIM_SCGC3_ADC1_MASK;  //ADC1 Clock Enable
        LDR.N    R0,??DataTable2_3  ;; 0x40048030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000000
        LDR.N    R1,??DataTable2_3  ;; 0x40048030
        STR      R0,[R1, #+0]
//   49     ADC1->CFG1 |= 0
//   50                //|ADC_CFG1_ADLPC_MASK
//   51                | ADC_CFG1_ADICLK(1)
//   52                | ADC_CFG1_MODE(1)
//   53                | ADC_CFG1_ADIV(0);
        LDR.N    R0,??DataTable2_4  ;; 0x400bb008
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x5
        LDR.N    R1,??DataTable2_4  ;; 0x400bb008
        STR      R0,[R1, #+0]
//   54     ADC1->CFG2 |= //ADC_CFG2_ADHSC_MASK |
//   55                   ADC_CFG2_ADACKEN_MASK;
        LDR.N    R0,??DataTable2_5  ;; 0x400bb00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable2_5  ;; 0x400bb00c
        STR      R0,[R1, #+0]
//   56     ADC1_enabled = 1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable2_2
        STRB     R0,[R1, #+0]
//   57   }
//   58 }
??Gyro_Init_0:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2:
        DC32     0x400bb000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_1:
        DC32     0x400bb010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_2:
        DC32     ADC1_enabled

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_3:
        DC32     0x40048030

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_4:
        DC32     0x400bb008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_5:
        DC32     0x400bb00c

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
// 
//  10 bytes in section .bss
// 120 bytes in section .text
// 
// 120 bytes of CODE memory
//  10 bytes of DATA memory
//
//Errors: none
//Warnings: none
