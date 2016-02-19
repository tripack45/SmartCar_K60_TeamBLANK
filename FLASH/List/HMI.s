///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       19/Feb/2016  17:17:23
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  E:\freescale_racing\SmartCar_K60_TeamBLANK\source\HMI.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\HMI.c -lCN
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
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\HMI.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN ADC1_enabled

        PUBLIC BELL
        PUBLIC Battery
        PUBLIC Bell_Request
        PUBLIC Bell_Service
        PUBLIC HMI_Init
        PUBLIC LED1
        PUBLIC LED1_Tog
        PUBLIC LED2
        PUBLIC LED2_Tog
        PUBLIC battery
        PUBLIC bell_request_tick

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\HMI.c
//    1 /*
//    2 Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
//    3 Date : 2015/12/01
//    4 License : MIT
//    5 */
//    6 
//    7 #include "includes.h"
//    8 
//    9 // ===== Global Variables =====
//   10 

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   11 U16 battery;
battery:
        DS8 2
//   12 
//   13 // --- Local Variables ---
//   14 

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   15 u16 bell_request_tick = 0;
bell_request_tick:
        DS8 2
//   16 
//   17 
//   18 
//   19 // ===== BELL SERVICE ====
//   20 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   21 void Bell_Request(u8 tick){
//   22   bell_request_tick = tick;
Bell_Request:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R1,??DataTable8
        STRH     R0,[R1, #+0]
//   23 }
        BX       LR               ;; return
//   24 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   25 void Bell_Service(){
Bell_Service:
        PUSH     {R7,LR}
//   26   if(bell_request_tick>0){
        LDR.N    R0,??DataTable8
        LDRH     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??Bell_Service_0
//   27     bell_request_tick--;
        LDR.N    R0,??DataTable8
        LDRH     R0,[R0, #+0]
        SUBS     R0,R0,#+1
        LDR.N    R1,??DataTable8
        STRH     R0,[R1, #+0]
//   28     BELL(1);
        MOVS     R0,#+1
        BL       BELL
        B.N      ??Bell_Service_1
//   29   }
//   30   else
//   31     BELL(0);
??Bell_Service_0:
        MOVS     R0,#+0
        BL       BELL
//   32 }
??Bell_Service_1:
        POP      {R0,PC}          ;; return
//   33 
//   34 
//   35 
//   36 
//   37 // ===== Basic APIs =====
//   38 
//   39 //----- LED ------
//   40 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   41 void LED2(u8 x){
//   42   if(x)
LED2:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??LED2_0
//   43     PTA->PSOR |= 1<<7;
        LDR.N    R0,??DataTable8_1  ;; 0x400ff004
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable8_1  ;; 0x400ff004
        STR      R0,[R1, #+0]
        B.N      ??LED2_1
//   44   else
//   45     PTA->PCOR |= 1<<7;
??LED2_0:
        LDR.N    R0,??DataTable8_2  ;; 0x400ff008
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable8_2  ;; 0x400ff008
        STR      R0,[R1, #+0]
//   46 }
??LED2_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   47 void LED2_Tog(){
//   48   PTA->PTOR |= 1<<7;
LED2_Tog:
        LDR.N    R0,??DataTable8_3  ;; 0x400ff00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable8_3  ;; 0x400ff00c
        STR      R0,[R1, #+0]
//   49 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   50 void LED1(u8 x){
//   51   if(x)
LED1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??LED1_0
//   52     PTA->PSOR |= 1<<6;
        LDR.N    R0,??DataTable8_1  ;; 0x400ff004
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x40
        LDR.N    R1,??DataTable8_1  ;; 0x400ff004
        STR      R0,[R1, #+0]
        B.N      ??LED1_1
//   53   else
//   54     PTA->PCOR |= 1<<6;
??LED1_0:
        LDR.N    R0,??DataTable8_2  ;; 0x400ff008
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x40
        LDR.N    R1,??DataTable8_2  ;; 0x400ff008
        STR      R0,[R1, #+0]
//   55 }
??LED1_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   56 void LED1_Tog(){
//   57   PTA->PTOR |= 1<<6;
LED1_Tog:
        LDR.N    R0,??DataTable8_3  ;; 0x400ff00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x40
        LDR.N    R1,??DataTable8_3  ;; 0x400ff00c
        STR      R0,[R1, #+0]
//   58 }
        BX       LR               ;; return
//   59 
//   60 //----- Bell ------
//   61 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   62 void BELL(u8 x){
//   63   if(x)
BELL:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??BELL_0
//   64     PTD->PSOR |= 1<<15;
        LDR.N    R0,??DataTable8_4  ;; 0x400ff0c4
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000
        LDR.N    R1,??DataTable8_4  ;; 0x400ff0c4
        STR      R0,[R1, #+0]
        B.N      ??BELL_1
//   65   else
//   66     PTD->PCOR |= 1<<15;
??BELL_0:
        LDR.N    R0,??DataTable8_5  ;; 0x400ff0c8
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000
        LDR.N    R1,??DataTable8_5  ;; 0x400ff0c8
        STR      R0,[R1, #+0]
//   67 }
??BELL_1:
        BX       LR               ;; return
//   68 
//   69 
//   70 // --- battery  ---

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   71 u16 Battery(){
//   72   u16 tmp;
//   73   ADC1->SC1[0] = ADC_SC1_ADCH(0);
Battery:
        MOVS     R0,#+0
        LDR.N    R1,??DataTable8_6  ;; 0x400bb000
        STR      R0,[R1, #+0]
//   74   while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
??Battery_0:
        LDR.N    R0,??DataTable8_6  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Battery_0
//   75   tmp = ADC1->R[0];
        LDR.N    R0,??DataTable8_7  ;; 0x400bb010
        LDR      R0,[R0, #+0]
//   76   //
//   77   return tmp;
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        BX       LR               ;; return
//   78 }
//   79 
//   80 
//   81 // ===== INIT =====
//   82 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   83 void HMI_Init(void){
//   84   
//   85   //===== LED =====
//   86   PORTA->PCR[6] |= PORT_PCR_MUX(1);
HMI_Init:
        LDR.N    R0,??DataTable8_8  ;; 0x40049018
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_8  ;; 0x40049018
        STR      R0,[R1, #+0]
//   87   PORTA->PCR[7] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_9  ;; 0x4004901c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_9  ;; 0x4004901c
        STR      R0,[R1, #+0]
//   88   PTA->PDDR |= (3<<6);
        LDR.N    R0,??DataTable8_10  ;; 0x400ff014
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0xC0
        LDR.N    R1,??DataTable8_10  ;; 0x400ff014
        STR      R0,[R1, #+0]
//   89   PTA->PDOR |= (3<<6);
        LDR.N    R0,??DataTable8_11  ;; 0x400ff000
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0xC0
        LDR.N    R1,??DataTable8_11  ;; 0x400ff000
        STR      R0,[R1, #+0]
//   90 
//   91   //===== KEY =====
//   92   PORTA->PCR[8] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_12  ;; 0x40049020
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_12  ;; 0x40049020
        STR      R0,[R1, #+0]
//   93   PORTA->PCR[9] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_13  ;; 0x40049024
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_13  ;; 0x40049024
        STR      R0,[R1, #+0]
//   94   PORTA->PCR[10] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_14  ;; 0x40049028
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_14  ;; 0x40049028
        STR      R0,[R1, #+0]
//   95   PTA->PDDR &=~(7<<8);
        LDR.N    R0,??DataTable8_10  ;; 0x400ff014
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x700
        LDR.N    R1,??DataTable8_10  ;; 0x400ff014
        STR      R0,[R1, #+0]
//   96   PORTA->PCR[8] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;	//PULLUP
        LDR.N    R0,??DataTable8_12  ;; 0x40049020
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable8_12  ;; 0x40049020
        STR      R0,[R1, #+0]
//   97   PORTA->PCR[9] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;
        LDR.N    R0,??DataTable8_13  ;; 0x40049024
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable8_13  ;; 0x40049024
        STR      R0,[R1, #+0]
//   98   PORTA->PCR[10] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;
        LDR.N    R0,??DataTable8_14  ;; 0x40049028
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable8_14  ;; 0x40049028
        STR      R0,[R1, #+0]
//   99   
//  100   //===== SW =====
//  101   PORTC->PCR[4] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_15  ;; 0x4004b010
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_15  ;; 0x4004b010
        STR      R0,[R1, #+0]
//  102   PORTC->PCR[5] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_16  ;; 0x4004b014
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_16  ;; 0x4004b014
        STR      R0,[R1, #+0]
//  103   PORTC->PCR[6] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_17  ;; 0x4004b018
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_17  ;; 0x4004b018
        STR      R0,[R1, #+0]
//  104   PORTC->PCR[7] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_18  ;; 0x4004b01c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_18  ;; 0x4004b01c
        STR      R0,[R1, #+0]
//  105   PTC->PDDR &=~(0xf<<4);
        LDR.N    R0,??DataTable8_19  ;; 0x400ff094
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0xF0
        LDR.N    R1,??DataTable8_19  ;; 0x400ff094
        STR      R0,[R1, #+0]
//  106   PORTC->PCR[4] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;
        LDR.N    R0,??DataTable8_15  ;; 0x4004b010
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable8_15  ;; 0x4004b010
        STR      R0,[R1, #+0]
//  107   PORTC->PCR[5] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;
        LDR.N    R0,??DataTable8_16  ;; 0x4004b014
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable8_16  ;; 0x4004b014
        STR      R0,[R1, #+0]
//  108   PORTC->PCR[6] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;
        LDR.N    R0,??DataTable8_17  ;; 0x4004b018
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable8_17  ;; 0x4004b018
        STR      R0,[R1, #+0]
//  109   PORTC->PCR[7] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;  
        LDR.N    R0,??DataTable8_18  ;; 0x4004b01c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable8_18  ;; 0x4004b01c
        STR      R0,[R1, #+0]
//  110   
//  111   //===== Bell =====
//  112   PORTD->PCR[15] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable8_20  ;; 0x4004c03c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_20  ;; 0x4004c03c
        STR      R0,[R1, #+0]
//  113   PTD->PDDR |= (1<<15);
        LDR.N    R0,??DataTable8_21  ;; 0x400ff0d4
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000
        LDR.N    R1,??DataTable8_21  ;; 0x400ff0d4
        STR      R0,[R1, #+0]
//  114   PTD->PDOR &=~ (1<<15);
        LDR.N    R0,??DataTable8_22  ;; 0x400ff0c0
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x8000
        LDR.N    R1,??DataTable8_22  ;; 0x400ff0c0
        STR      R0,[R1, #+0]
//  115 
//  116   //==== battery ====
//  117   
//  118   if(!ADC1_enabled){
        LDR.N    R0,??DataTable8_23
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BNE.N    ??HMI_Init_0
//  119     SIM->SCGC3 |= SIM_SCGC3_ADC1_MASK;  //ADC1 Clock Enable
        LDR.N    R0,??DataTable8_24  ;; 0x40048030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000000
        LDR.N    R1,??DataTable8_24  ;; 0x40048030
        STR      R0,[R1, #+0]
//  120     ADC1->CFG1 |= 0
//  121                //|ADC_CFG1_ADLPC_MASK
//  122                | ADC_CFG1_ADICLK(1)
//  123                | ADC_CFG1_MODE(1);
        LDR.N    R0,??DataTable8_25  ;; 0x400bb008
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x5
        LDR.N    R1,??DataTable8_25  ;; 0x400bb008
        STR      R0,[R1, #+0]
//  124                //| ADC_CFG1_ADIV(0);
//  125     ADC1->CFG2 |= //ADC_CFG2_ADHSC_MASK |
//  126                   ADC_CFG2_ADACKEN_MASK; 
        LDR.N    R0,??DataTable8_26  ;; 0x400bb00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable8_26  ;; 0x400bb00c
        STR      R0,[R1, #+0]
//  127     
//  128     ADC1->SC1[0]&=~ADC_SC1_AIEN_MASK;//disenble interrupt
        LDR.N    R0,??DataTable8_6  ;; 0x400bb000
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x40
        LDR.N    R1,??DataTable8_6  ;; 0x400bb000
        STR      R0,[R1, #+0]
//  129     ADC1_enabled = 1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable8_23
        STRB     R0,[R1, #+0]
//  130   }
//  131 }
??HMI_Init_0:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8:
        DC32     bell_request_tick

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_1:
        DC32     0x400ff004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_2:
        DC32     0x400ff008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_3:
        DC32     0x400ff00c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_4:
        DC32     0x400ff0c4

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_5:
        DC32     0x400ff0c8

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_6:
        DC32     0x400bb000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_7:
        DC32     0x400bb010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_8:
        DC32     0x40049018

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_9:
        DC32     0x4004901c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_10:
        DC32     0x400ff014

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_11:
        DC32     0x400ff000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_12:
        DC32     0x40049020

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_13:
        DC32     0x40049024

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_14:
        DC32     0x40049028

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_15:
        DC32     0x4004b010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_16:
        DC32     0x4004b014

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_17:
        DC32     0x4004b018

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_18:
        DC32     0x4004b01c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_19:
        DC32     0x400ff094

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_20:
        DC32     0x4004c03c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_21:
        DC32     0x400ff0d4

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_22:
        DC32     0x400ff0c0

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_23:
        DC32     ADC1_enabled

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_24:
        DC32     0x40048030

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_25:
        DC32     0x400bb008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_26:
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
//  132 
//  133 
//  134 
// 
//   4 bytes in section .bss
// 644 bytes in section .text
// 
// 644 bytes of CODE memory
//   4 bytes of DATA memory
//
//Errors: none
//Warnings: none
