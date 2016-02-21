///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       21/Feb/2016  03:11:36
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  E:\freescale_racing\SmartCar_K60_TeamBLANK\source\CCD.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\CCD.c -lCN
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
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\CCD.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        PUBLIC AD_Sample_CCD1
        PUBLIC AD_Sample_CCD2
        PUBLIC CCD1_CLK
        PUBLIC CCD1_GetLine
        PUBLIC CCD1_SI
        PUBLIC CCD2_CLK
        PUBLIC CCD2_GetLine
        PUBLIC CCD2_SI
        PUBLIC CCD_Init
        PUBLIC ccd1_line
        PUBLIC ccd2_line

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\CCD.c
//    1 /*
//    2 Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
//    3 Date : 2015/12/01
//    4 License : MIT
//    5 */
//    6 
//    7 #include "includes.h"
//    8 
//    9 
//   10 
//   11 // ===== Variables ======
//   12 //---- GLOBAL ----
//   13 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   14 U8 ccd1_line[128];
ccd1_line:
        DS8 128

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   15 U8 ccd2_line[128];
ccd2_line:
        DS8 128
//   16 
//   17 //---- LOCAL ---
//   18 
//   19 
//   20 
//   21 // ===== Function Declaration ===== ( Local ) ( No need for users to use)
//   22 
//   23   // -- Basic Drivers --
//   24 u32 AD_Sample_CCD1();
//   25 u32 AD_Sample_CCD2();
//   26 
//   27   // --  Hardware Interface --
//   28 void CCD1_SI(u8 x);
//   29 void CCD2_SI(u8 x);
//   30 void CCD1_CLK(u8 x);
//   31 void CCD2_CLK(u8 x);
//   32 
//   33 
//   34 
//   35 // =======  Function Realization ======
//   36 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   37 void CCD1_GetLine(U8 * ccd_line)
//   38 {
CCD1_GetLine:
        PUSH     {R4,LR}
//   39   u8 i;
//   40  	
//   41   //Collect pixels.
//   42   //Sned SI
//   43   CCD1_SI(1);  //SI = 1, t = 0
        MOVS     R0,#+1
        BL       CCD1_SI
//   44   
//   45   asm("nop");asm("nop");
        nop
        nop
//   46   
//   47   CCD1_CLK(1); //CLK = 1, dt = 75ns
        MOVS     R0,#+1
        BL       CCD1_CLK
//   48   CCD1_SI(0);  //SI = 0, dt = 50ns
        MOVS     R0,#+0
        BL       CCD1_SI
//   49   
//   50   //First pixel.
//   51   asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
//   52   asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
//   53   
//   54   ccd1_line[0] = AD_Sample_CCD1();
        BL       AD_Sample_CCD1
        LDR.N    R1,??DataTable8
        STRB     R0,[R1, #+0]
//   55   
//   56   CCD1_CLK(0); //CLK = 0
        MOVS     R0,#+0
        BL       CCD1_CLK
//   57  
//   58   //2~128 CLK
//   59   for(i=1; i<128; i++)
        MOVS     R4,#+1
        B.N      ??CCD1_GetLine_0
//   60   {
//   61     
//   62     asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
??CCD1_GetLine_1:
        nop
        nop
        nop
        nop
        nop
        nop
//   63     
//   64     CCD1_CLK(1);  //CLK = 1, dt = 125ns
        MOVS     R0,#+1
        BL       CCD1_CLK
//   65     
//   66     asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
//   67     asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
//   68     
//   69     ccd1_line[i] = AD_Sample_CCD1();
        BL       AD_Sample_CCD1
        LDR.N    R1,??DataTable8
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        STRB     R0,[R4, R1]
//   70     
//   71     CCD1_CLK(0);  //CLK = 0.
        MOVS     R0,#+0
        BL       CCD1_CLK
//   72   }
        ADDS     R4,R4,#+1
??CCD1_GetLine_0:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+128
        BLT.N    ??CCD1_GetLine_1
//   73  
//   74   //129 CLK
//   75   
//   76   asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
        nop
//   77   
//   78   CCD1_CLK(1);  //CLK = 1.
        MOVS     R0,#+1
        BL       CCD1_CLK
//   79   
//   80   asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
        nop
//   81   
//   82   CCD1_CLK(0);  //CLK = 0.
        MOVS     R0,#+0
        BL       CCD1_CLK
//   83 }
        POP      {R4,PC}          ;; return
//   84 
//   85 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   86 void CCD2_GetLine(U8 * ccd_line)
//   87 {
CCD2_GetLine:
        PUSH     {R4,LR}
//   88   u8 i;
//   89  	
//   90   //Collect pixels.
//   91   //Sned SI
//   92   CCD2_SI(1);  //SI = 1, t = 0
        MOVS     R0,#+1
        BL       CCD2_SI
//   93   
//   94   asm("nop");asm("nop");
        nop
        nop
//   95   
//   96   CCD2_CLK(1); //CLK = 1, dt = 75ns
        MOVS     R0,#+1
        BL       CCD2_CLK
//   97   CCD2_SI(0);  //SI = 0, dt = 50ns
        MOVS     R0,#+0
        BL       CCD2_SI
//   98   
//   99   //First pixel.
//  100   asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
//  101   asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
//  102   
//  103   ccd2_line[0] = AD_Sample_CCD2();
        BL       AD_Sample_CCD2
        LDR.N    R1,??DataTable8_1
        STRB     R0,[R1, #+0]
//  104   
//  105   CCD2_CLK(0); //CLK = 0
        MOVS     R0,#+0
        BL       CCD2_CLK
//  106  
//  107   //2~128 CLK
//  108   for(i=1; i<128; i++)
        MOVS     R4,#+1
        B.N      ??CCD2_GetLine_0
//  109   {
//  110     
//  111     asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
??CCD2_GetLine_1:
        nop
        nop
        nop
        nop
        nop
        nop
//  112     
//  113     CCD2_CLK(1);  //CLK = 1, dt = 125ns
        MOVS     R0,#+1
        BL       CCD2_CLK
//  114     
//  115     asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
//  116     asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
//  117     
//  118     ccd2_line[i] = AD_Sample_CCD2();
        BL       AD_Sample_CCD2
        LDR.N    R1,??DataTable8_1
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        STRB     R0,[R4, R1]
//  119     
//  120     CCD2_CLK(0);  //CLK = 0.
        MOVS     R0,#+0
        BL       CCD2_CLK
//  121   }
        ADDS     R4,R4,#+1
??CCD2_GetLine_0:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+128
        BLT.N    ??CCD2_GetLine_1
//  122  
//  123   //129 CLK
//  124   
//  125   asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
        nop
//  126   
//  127   CCD2_CLK(1);  //CLK = 1.
        MOVS     R0,#+1
        BL       CCD2_CLK
//  128   
//  129   asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");
        nop
        nop
        nop
        nop
        nop
        nop
//  130   
//  131   CCD2_CLK(0);  //CLK = 0.
        MOVS     R0,#+0
        BL       CCD2_CLK
//  132 }
        POP      {R4,PC}          ;; return
//  133 
//  134   //  INIT 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  135 void CCD_Init(){
//  136   
//  137   PORTB->PCR[20] |= PORT_PCR_MUX(1);    // 2 SI
CCD_Init:
        LDR.N    R0,??DataTable8_2  ;; 0x4004a050
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_2  ;; 0x4004a050
        STR      R0,[R1, #+0]
//  138   PORTB->PCR[21] |= PORT_PCR_MUX(1);    // 1 SI
        LDR.N    R0,??DataTable8_3  ;; 0x4004a054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_3  ;; 0x4004a054
        STR      R0,[R1, #+0]
//  139   PORTB->PCR[22] |= PORT_PCR_MUX(1);    // 2 CLK
        LDR.N    R0,??DataTable8_4  ;; 0x4004a058
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_4  ;; 0x4004a058
        STR      R0,[R1, #+0]
//  140   PORTB->PCR[23] |= PORT_PCR_MUX(1);    // 1 CLK
        LDR.N    R0,??DataTable8_5  ;; 0x4004a05c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable8_5  ;; 0x4004a05c
        STR      R0,[R1, #+0]
//  141   PTB->PDDR |= (0xf<<20);
        LDR.N    R0,??DataTable8_6  ;; 0x400ff054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0xF00000
        LDR.N    R1,??DataTable8_6  ;; 0x400ff054
        STR      R0,[R1, #+0]
//  142   
//  143   SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;//ADC0 Clock Enable
        LDR.N    R0,??DataTable8_7  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000000
        LDR.N    R1,??DataTable8_7  ;; 0x4004803c
        STR      R0,[R1, #+0]
//  144   ADC0->CFG1 |= 0
//  145              //|ADC_CFG1_ADLPC_MASK
//  146              | ADC_CFG1_ADICLK(1)
//  147              | ADC_CFG1_MODE(0);
        LDR.N    R0,??DataTable8_8  ;; 0x4003b008
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable8_8  ;; 0x4003b008
        STR      R0,[R1, #+0]
//  148              //| ADC_CFG1_ADIV(0);
//  149   ADC0->CFG2 |= //ADC_CFG2_ADHSC_MASK |
//  150                 ADC_CFG2_ADACKEN_MASK; 
        LDR.N    R0,??DataTable8_9  ;; 0x4003b00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable8_9  ;; 0x4003b00c
        STR      R0,[R1, #+0]
//  151   
//  152   ADC0->SC1[0]&=~ADC_SC1_AIEN_MASK;//disenble interrupt
        LDR.N    R0,??DataTable8_10  ;; 0x4003b000
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x40
        LDR.N    R1,??DataTable8_10  ;; 0x4003b000
        STR      R0,[R1, #+0]
//  153   
//  154   PORTC->PCR[0]|=PORT_PCR_MUX(0);//adc0-14
        LDR.N    R0,??DataTable8_11  ;; 0x4004b000
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable8_11  ;; 0x4004b000
        STR      R0,[R1, #+0]
//  155   PORTC->PCR[1]|=PORT_PCR_MUX(0);//adc0-15
        LDR.N    R0,??DataTable8_12  ;; 0x4004b004
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable8_12  ;; 0x4004b004
        STR      R0,[R1, #+0]
//  156   
//  157   
//  158 }
        BX       LR               ;; return
//  159 
//  160 
//  161 // ======= Basic Drivers ======
//  162 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  163 u32 AD_Sample_CCD1(){
//  164   ADC0->SC1[0] = ADC_SC1_ADCH(15);
AD_Sample_CCD1:
        MOVS     R0,#+15
        LDR.N    R1,??DataTable8_10  ;; 0x4003b000
        STR      R0,[R1, #+0]
//  165   while((ADC0->SC1[0]&ADC_SC1_COCO_MASK)==0);
??AD_Sample_CCD1_0:
        LDR.N    R0,??DataTable8_10  ;; 0x4003b000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??AD_Sample_CCD1_0
//  166   return ADC0->R[0];
        LDR.N    R0,??DataTable8_13  ;; 0x4003b010
        LDR      R0,[R0, #+0]
        BX       LR               ;; return
//  167 }

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  168 u32 AD_Sample_CCD2(){
//  169   ADC0->SC1[0] = ADC_SC1_ADCH(14);
AD_Sample_CCD2:
        MOVS     R0,#+14
        LDR.N    R1,??DataTable8_10  ;; 0x4003b000
        STR      R0,[R1, #+0]
//  170   while((ADC0->SC1[0]&ADC_SC1_COCO_MASK)==0);
??AD_Sample_CCD2_0:
        LDR.N    R0,??DataTable8_10  ;; 0x4003b000
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??AD_Sample_CCD2_0
//  171   return ADC0->R[0];
        LDR.N    R0,??DataTable8_13  ;; 0x4003b010
        LDR      R0,[R0, #+0]
        BX       LR               ;; return
//  172 }
//  173    
//  174 // ===== Hardware Interface =====

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  175 void CCD1_SI(u8 x){
//  176   if(x)
CCD1_SI:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??CCD1_SI_0
//  177     PTB->PSOR |= 1<<21;
        LDR.N    R0,??DataTable8_14  ;; 0x400ff044
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x200000
        LDR.N    R1,??DataTable8_14  ;; 0x400ff044
        STR      R0,[R1, #+0]
        B.N      ??CCD1_SI_1
//  178   else
//  179     PTB->PCOR |= 1<<21;
??CCD1_SI_0:
        LDR.N    R0,??DataTable8_15  ;; 0x400ff048
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x200000
        LDR.N    R1,??DataTable8_15  ;; 0x400ff048
        STR      R0,[R1, #+0]
//  180 }
??CCD1_SI_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  181 void CCD2_SI(u8 x){
//  182   if(x)
CCD2_SI:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??CCD2_SI_0
//  183     PTB->PSOR |= 1<<20;
        LDR.N    R0,??DataTable8_14  ;; 0x400ff044
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100000
        LDR.N    R1,??DataTable8_14  ;; 0x400ff044
        STR      R0,[R1, #+0]
        B.N      ??CCD2_SI_1
//  184   else
//  185     PTB->PCOR |= 1<<20;
??CCD2_SI_0:
        LDR.N    R0,??DataTable8_15  ;; 0x400ff048
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100000
        LDR.N    R1,??DataTable8_15  ;; 0x400ff048
        STR      R0,[R1, #+0]
//  186 }
??CCD2_SI_1:
        BX       LR               ;; return
//  187 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  188 void CCD1_CLK(u8 x){
//  189   if(x)
CCD1_CLK:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??CCD1_CLK_0
//  190     PTB->PSOR |= 1<<23;
        LDR.N    R0,??DataTable8_14  ;; 0x400ff044
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x800000
        LDR.N    R1,??DataTable8_14  ;; 0x400ff044
        STR      R0,[R1, #+0]
        B.N      ??CCD1_CLK_1
//  191   else
//  192     PTB->PCOR |= 1<<23;
??CCD1_CLK_0:
        LDR.N    R0,??DataTable8_15  ;; 0x400ff048
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x800000
        LDR.N    R1,??DataTable8_15  ;; 0x400ff048
        STR      R0,[R1, #+0]
//  193 }
??CCD1_CLK_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  194 void CCD2_CLK(u8 x){
//  195   if(x)
CCD2_CLK:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??CCD2_CLK_0
//  196     PTB->PSOR |= 1<<22;
        LDR.N    R0,??DataTable8_14  ;; 0x400ff044
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x400000
        LDR.N    R1,??DataTable8_14  ;; 0x400ff044
        STR      R0,[R1, #+0]
        B.N      ??CCD2_CLK_1
//  197   else
//  198     PTB->PCOR |= 1<<22;
??CCD2_CLK_0:
        LDR.N    R0,??DataTable8_15  ;; 0x400ff048
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x400000
        LDR.N    R1,??DataTable8_15  ;; 0x400ff048
        STR      R0,[R1, #+0]
//  199 }
??CCD2_CLK_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8:
        DC32     ccd1_line

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_1:
        DC32     ccd2_line

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_2:
        DC32     0x4004a050

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_3:
        DC32     0x4004a054

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_4:
        DC32     0x4004a058

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_5:
        DC32     0x4004a05c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_6:
        DC32     0x400ff054

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_7:
        DC32     0x4004803c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_8:
        DC32     0x4003b008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_9:
        DC32     0x4003b00c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_10:
        DC32     0x4003b000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_11:
        DC32     0x4004b000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_12:
        DC32     0x4004b004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_13:
        DC32     0x4003b010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_14:
        DC32     0x400ff044

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable8_15:
        DC32     0x400ff048

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//  200 
// 
// 256 bytes in section .bss
// 690 bytes in section .text
// 
// 690 bytes of CODE memory
// 256 bytes of DATA memory
//
//Errors: none
//Warnings: none
