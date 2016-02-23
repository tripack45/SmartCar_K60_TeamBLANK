///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       21/Feb/2016  16:04:27
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\source\Mag.c
//    Command line =  
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\source\Mag.c
//        -lCN
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\FLASH\List\
//        -lB
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\FLASH\List\
//        -o
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\FLASH\Obj\
//        --no_cse --no_unroll --no_inline --no_code_motion --no_tbaa
//        --no_clustering --no_scheduling --debug --endian=little
//        --cpu=Cortex-M4 -e --char_is_signed --fpu=None --dlib_config
//        "C:\Program Files (x86)\IAR Systems\Embedded Workbench
//        7.0\arm\INC\c\DLib_Config_Normal.h" -I
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\source\
//        -I
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\common\
//        -I C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\LPLD\
//        -I
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\LPLD\HW\
//        -I
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\LPLD\DEV\
//        -Ol -I "C:\Program Files (x86)\IAR Systems\Embedded Workbench
//        7.0\arm\CMSIS\Include\" -D ARM_MATH_CM4
//    List file    =  
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\FLASH\List\Mag.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN ADC1_enabled

        PUBLIC Mag1
        PUBLIC Mag2
        PUBLIC Mag3
        PUBLIC Mag4
        PUBLIC Mag5
        PUBLIC Mag6
        PUBLIC Mag_Init
        PUBLIC Mag_Sample
        PUBLIC mag_val

// C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\source\Mag.c
//    1 /*
//    2 Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
//    3 Date : 2015/12/01
//    4 License : MIT
//    5 */
//    6 
//    7 #include "includes.h"
//    8 
//    9 
//   10 // ===== Global Variables =====

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   11 U16 mag_val[6];
mag_val:
        DS8 12
//   12 
//   13 
//   14 // ===== Function Realization =====
//   15 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   16 void Mag_Sample(){
Mag_Sample:
        PUSH     {R4,LR}
//   17   mag_val[0] = Mag1();
        BL       Mag1
        LDR.N    R1,??DataTable7
        STRH     R0,[R1, #+0]
//   18   mag_val[1] = Mag2();
        BL       Mag2
        LDR.N    R1,??DataTable7
        STRH     R0,[R1, #+2]
//   19   mag_val[2] = Mag3();
        BL       Mag3
        LDR.N    R1,??DataTable7
        STRH     R0,[R1, #+4]
//   20   mag_val[3] = Mag4();
        BL       Mag4
        LDR.N    R1,??DataTable7
        STRH     R0,[R1, #+6]
//   21   mag_val[5] = Mag6();
        BL       Mag6
        LDR.N    R1,??DataTable7
        STRH     R0,[R1, #+10]
//   22   mag_val[4] = mag_val[5] - Mag5();
        LDR.N    R0,??DataTable7
        LDRH     R4,[R0, #+10]
        BL       Mag5
        SUBS     R0,R4,R0
        LDR.N    R1,??DataTable7
        STRH     R0,[R1, #+8]
//   23 }
        POP      {R4,PC}          ;; return
//   24 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   25 u16 Mag1(){
//   26   ADC1->SC1[0] = ADC_SC1_ADCH(4);
Mag1:
        MOVS     R0,#+4
        LDR.N    R1,??DataTable7_1  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   27   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Mag1_0:
        LDR.N    R0,??DataTable7_1  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Mag1_0
//   28   return ADC1->R[0];
        LDR.N    R0,??DataTable7_2  ;; 0x400bb010
        LDR      R0,[R0, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   29 }

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   30 u16 Mag2(){
//   31   ADC1->SC1[0] = ADC_SC1_ADCH(5);
Mag2:
        MOVS     R0,#+5
        LDR.N    R1,??DataTable7_1  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   32   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Mag2_0:
        LDR.N    R0,??DataTable7_1  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Mag2_0
//   33   return ADC1->R[0];
        LDR.N    R0,??DataTable7_2  ;; 0x400bb010
        LDR      R0,[R0, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   34 }

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   35 u16 Mag3(){
//   36   ADC1->SC1[0] = ADC_SC1_ADCH(6);
Mag3:
        MOVS     R0,#+6
        LDR.N    R1,??DataTable7_1  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   37   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Mag3_0:
        LDR.N    R0,??DataTable7_1  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Mag3_0
//   38   return ADC1->R[0];
        LDR.N    R0,??DataTable7_2  ;; 0x400bb010
        LDR      R0,[R0, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   39 }

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   40 u16 Mag4(){
//   41   ADC1->SC1[0] = ADC_SC1_ADCH(7);
Mag4:
        MOVS     R0,#+7
        LDR.N    R1,??DataTable7_1  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   42   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Mag4_0:
        LDR.N    R0,??DataTable7_1  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Mag4_0
//   43   return ADC1->R[0];
        LDR.N    R0,??DataTable7_2  ;; 0x400bb010
        LDR      R0,[R0, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   44 }

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   45 s16 Mag5(){
//   46   ADC1->SC1[0] = ADC_SC1_DIFF_MASK | ADC_SC1_ADCH(3);
Mag5:
        MOVS     R0,#+35
        LDR.N    R1,??DataTable7_1  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   47   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Mag5_0:
        LDR.N    R0,??DataTable7_1  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Mag5_0
//   48   return ADC1->R[0];
        LDR.N    R0,??DataTable7_2  ;; 0x400bb010
        LDR      R0,[R0, #+0]
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   49   //ADC1->SC1[0] &= ~ADC_SC1_DIFF_MASK;
//   50 }

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   51 u16 Mag6(){
//   52   ADC1->SC1[0] = ADC_SC1_ADCH(3);
Mag6:
        MOVS     R0,#+3
        LDR.N    R1,??DataTable7_1  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   53   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Mag6_0:
        LDR.N    R0,??DataTable7_1  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Mag6_0
//   54   return ADC1->R[0];
        LDR.N    R0,??DataTable7_2  ;; 0x400bb010
        LDR      R0,[R0, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   55 }
//   56 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   57 void Mag_Init(){
//   58   
//   59   if(!ADC1_enabled){
Mag_Init:
        LDR.N    R0,??DataTable7_3
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BNE.N    ??Mag_Init_0
//   60     SIM->SCGC3 |= SIM_SCGC3_ADC1_MASK;  //ADC1 Clock Enable
        LDR.N    R0,??DataTable7_4  ;; 0x40048030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000000
        LDR.N    R1,??DataTable7_4  ;; 0x40048030
        STR      R0,[R1, #+0]
//   61     ADC1->CFG1 |= 0
//   62                //|ADC_CFG1_ADLPC_MASK
//   63                | ADC_CFG1_ADICLK(1)
//   64                | ADC_CFG1_MODE(1)
//   65                | ADC_CFG1_ADIV(0);
        LDR.N    R0,??DataTable7_5  ;; 0x400bb008
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x5
        LDR.N    R1,??DataTable7_5  ;; 0x400bb008
        STR      R0,[R1, #+0]
//   66     ADC1->CFG2 |= //ADC_CFG2_ADHSC_MASK |
//   67                   ADC_CFG2_ADACKEN_MASK;
        LDR.N    R0,??DataTable7_6  ;; 0x400bb00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable7_6  ;; 0x400bb00c
        STR      R0,[R1, #+0]
//   68     
//   69     ADC1->SC1[0]&=~ADC_SC1_AIEN_MASK;//disenble interrupt
        LDR.N    R0,??DataTable7_1  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x40
        LDR.N    R1,??DataTable7_1  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   70     ADC1_enabled = 1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable7_3
        STRB     R0,[R1, #+0]
//   71   }
//   72   
//   73   PORTE->PCR[0]|=PORT_PCR_MUX(0);//adc1-4a
??Mag_Init_0:
        LDR.N    R0,??DataTable7_7  ;; 0x4004d000
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable7_7  ;; 0x4004d000
        STR      R0,[R1, #+0]
//   74   PORTE->PCR[1]|=PORT_PCR_MUX(0);//adc1-5a
        LDR.N    R0,??DataTable7_8  ;; 0x4004d004
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable7_8  ;; 0x4004d004
        STR      R0,[R1, #+0]
//   75   PORTE->PCR[2]|=PORT_PCR_MUX(0);//adc1-6a
        LDR.N    R0,??DataTable7_9  ;; 0x4004d008
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable7_9  ;; 0x4004d008
        STR      R0,[R1, #+0]
//   76   PORTE->PCR[3]|=PORT_PCR_MUX(0);//adc1-7a
        LDR.N    R0,??DataTable7_10  ;; 0x4004d00c
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable7_10  ;; 0x4004d00c
        STR      R0,[R1, #+0]
//   77 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7:
        DC32     mag_val

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_1:
        DC32     0x400bb000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_2:
        DC32     0x400bb010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_3:
        DC32     ADC1_enabled

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_4:
        DC32     0x40048030

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_5:
        DC32     0x400bb008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_6:
        DC32     0x400bb00c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_7:
        DC32     0x4004d000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_8:
        DC32     0x4004d004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_9:
        DC32     0x4004d008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable7_10:
        DC32     0x4004d00c

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
//  12 bytes in section .bss
// 330 bytes in section .text
// 
// 330 bytes of CODE memory
//  12 bytes of DATA memory
//
//Errors: none
//Warnings: none
