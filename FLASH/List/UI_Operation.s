///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       21/Feb/2016  16:04:29
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\source\UI_Operation.c
//    Command line =  
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\source\UI_Operation.c
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
//        C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\FLASH\List\UI_Operation.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN Bell_Request

        PUBLIC Key1_Downspin_Func
        PUBLIC Key1_Read
        PUBLIC Key1_Rise_Func
        PUBLIC Key1_cnt
        PUBLIC Key1_down
        PUBLIC Key1_rise
        PUBLIC Key1_risemask
        PUBLIC Key2_Downspin_Func
        PUBLIC Key2_Read
        PUBLIC Key2_Rise_Func
        PUBLIC Key2_cnt
        PUBLIC Key2_down
        PUBLIC Key2_rise
        PUBLIC Key2_risemask
        PUBLIC Key3_Downspin_Func
        PUBLIC Key3_Read
        PUBLIC Key3_Rise_Func
        PUBLIC Key3_cnt
        PUBLIC Key3_down
        PUBLIC Key3_rise
        PUBLIC Key3_risemask
        PUBLIC Spin_Func
        PUBLIC UI_Operation_Service
        PUBLIC ui_operation_cnt
        PUBLIC ui_operation_shift

// C:\Users\lichunchao\Documents\GitHub\SmartCar_K60_TeamBLANK\source\UI_Operation.c
//    1 /*
//    2 Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
//    3 Date : 2015/12/04
//    4 License : MIT
//    5 */
//    6 
//    7 
//    8 #include "includes.h"
//    9 
//   10 
//   11 
//   12 // ====== Settings ======
//   13 
//   14   // Sensibility of operation
//   15   // smaller, more sensitive
//   16 #define SENSIBILITY 8
//   17 
//   18   // Strength to debounce
//   19   // depends on period of UI Refreshing Loop
//   20 #define DEBOUNCE_CNT 6 
//   21 
//   22 
//   23 
//   24 
//   25 // ====== Variables ======
//   26 
//   27 // ---- Global ----

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   28 u16 ui_operation_shift, ui_operation_cnt;
ui_operation_shift:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
ui_operation_cnt:
        DS8 2
//   29 
//   30 // ---- Local ----

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   31 u8 Key3_down,Key1_down,Key2_down;   // flag : state of pushed down
Key3_down:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
Key1_down:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
Key2_down:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   32 u8 Key3_rise,Key1_rise,Key2_rise;   // flag : transient state of rising
Key3_rise:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
Key1_rise:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
Key2_rise:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   33 u8 Key3_cnt,Key1_cnt,Key2_cnt;      // counter to debounce
Key3_cnt:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
Key1_cnt:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
Key2_cnt:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   34 u8 Key1_risemask,Key2_risemask,Key3_risemask;   // flag to mask Rise_Func after DownSpin_Func
Key1_risemask:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
Key2_risemask:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
Key3_risemask:
        DS8 1
//   35 
//   36 
//   37 
//   38 // ====== Local Func Declaration ====
//   39 
//   40   // --- API ---
//   41 void Key1_Rise_Func();
//   42 void Key2_Rise_Func();
//   43 void Key3_Rise_Func();
//   44 void Key1_Downspin_Func();
//   45 void Key2_Downspin_Func();
//   46 void Key3_Downspin_Func();
//   47 void Spin_Func();
//   48 
//   49   // --- Baisc Drivers ---
//   50 void Key1_Read();
//   51 void Key2_Read();
//   52 void Key3_Read();
//   53 
//   54 
//   55 
//   56 
//   57 // ====== APIs =======
//   58 // write your codes in certain Func you wanna realize.
//   59 
//   60 
//   61   // --- Keyn_Rise_Func ---
//   62   // triggered when Keyn rises after push with no spin of tacho.
//   63 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   64 void Key1_Rise_Func(){
Key1_Rise_Func:
        PUSH     {R7,LR}
//   65   Bell_Request(3);
        MOVS     R0,#+3
        BL       Bell_Request
//   66 }
        POP      {R0,PC}          ;; return
//   67 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   68 void Key2_Rise_Func(){     
Key2_Rise_Func:
        PUSH     {R7,LR}
//   69   Bell_Request(3);      
        MOVS     R0,#+3
        BL       Bell_Request
//   70   
//   71   /*item_renew_cnt = 8;
//   72   data_renew_cnt = 8;
//   73   if(menu==1)
//   74     menu=10+curse;
//   75   else if(menu>=10 && menu<=20 && selected==0)
//   76     selected=1;
//   77   else if(menu>=11&&menu<=14 && selected==1){
//   78     selected=0;
//   79     Flash_Write(0);
//   80   }
//   81   else if(menu==10 && selected==1)
//   82     selected=0;
//   83   
//   84   curse_display();*/
//   85 }
        POP      {R0,PC}          ;; return
//   86 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   87 void Key3_Rise_Func(){   
Key3_Rise_Func:
        PUSH     {R7,LR}
//   88   Bell_Request(3); 
        MOVS     R0,#+3
        BL       Bell_Request
//   89   
//   90   /*item_renew_cnt = 8;  
//   91   data_renew_cnt = 8;  
//   92   if(menu==1)
//   93     menu=10;
//   94   else if(menu>9 && menu<20 && selected==0)  
//   95     menu=1;  
//   96   else if(menu>9 && menu<20 && selected==1)  
//   97     selected=0;    
//   98     
//   99   curse_display();  */
//  100 }
        POP      {R0,PC}          ;; return
//  101 
//  102 
//  103   // --- Keyn_Downspin_Func ---
//  104   // triggered when Keyn is pushed down and spinning tacho.
//  105   // if triggered , Rise_Func won't be trigger when rises.
//  106 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  107 void Key1_Downspin_Func(){
Key1_Downspin_Func:
        PUSH     {R7,LR}
//  108   
//  109   Spin_Func();
        BL       Spin_Func
//  110 }
        POP      {R0,PC}          ;; return
//  111 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  112 void Key2_Downspin_Func(){
Key2_Downspin_Func:
        PUSH     {R7,LR}
//  113   
//  114   Spin_Func();
        BL       Spin_Func
//  115 }
        POP      {R0,PC}          ;; return
//  116 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  117 void Key3_Downspin_Func(){
Key3_Downspin_Func:
        PUSH     {R7,LR}
//  118   
//  119   Spin_Func();
        BL       Spin_Func
//  120 }
        POP      {R0,PC}          ;; return
//  121 
//  122 
//  123   // --- Spin_Func ---
//  124   // triggered when spinning tacho with no Key pushed.

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  125 void Spin_Func(){
Spin_Func:
        PUSH     {R7,LR}
//  126   Bell_Request(1);
        MOVS     R0,#+1
        BL       Bell_Request
//  127 
//  128 }
        POP      {R0,PC}          ;; return
//  129 
//  130 
//  131 
//  132 
//  133 // ========= Service ======= 
//  134 
//  135   // Put this in UI refreshing loop (PIT1_ISR)
//  136 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  137 void UI_Operation_Service(){
UI_Operation_Service:
        PUSH     {R7,LR}
//  138   Key3_Read();
        BL       Key3_Read
//  139   Key1_Read();
        BL       Key1_Read
//  140   Key2_Read();
        BL       Key2_Read
//  141   
//  142   ui_operation_shift = ui_operation_cnt/SENSIBILITY;
        LDR.N    R0,??DataTable3
        LDRH     R0,[R0, #+0]
        MOVS     R1,#+8
        SDIV     R0,R0,R1
        LDR.N    R1,??DataTable3_1
        STRH     R0,[R1, #+0]
//  143   ui_operation_cnt %= SENSIBILITY;
        LDR.N    R0,??DataTable3
        LDRH     R0,[R0, #+0]
        MOVS     R1,#+8
        SDIV     R2,R0,R1
        MLS      R2,R2,R1,R0
        LDR.N    R0,??DataTable3
        STRH     R2,[R0, #+0]
//  144   
//  145   if(Key1_rise){
        LDR.N    R0,??DataTable3_2
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_0
//  146     Key1_rise=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_2
        STRB     R0,[R1, #+0]
//  147     Key1_Rise_Func();
        BL       Key1_Rise_Func
//  148   }
//  149   if(Key2_rise){
??UI_Operation_Service_0:
        LDR.N    R0,??DataTable3_3
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_1
//  150     Key2_rise=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_3
        STRB     R0,[R1, #+0]
//  151     Key2_Rise_Func();
        BL       Key2_Rise_Func
//  152   }
//  153   if(Key3_rise){
??UI_Operation_Service_1:
        LDR.N    R0,??DataTable3_4
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_2
//  154     Key3_rise=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_4
        STRB     R0,[R1, #+0]
//  155     Key3_Rise_Func();
        BL       Key3_Rise_Func
//  156   }
//  157   if(Key1_down && ui_operation_shift!=0 ){       // 
??UI_Operation_Service_2:
        LDR.N    R0,??DataTable3_5
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_3
        LDR.N    R0,??DataTable3_1
        LDRH     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_3
//  158     Key1_risemask=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_6
        STRB     R0,[R1, #+0]
//  159     Key1_Downspin_Func();
        BL       Key1_Downspin_Func
        B.N      ??UI_Operation_Service_4
//  160   }
//  161   else if(Key2_down && ui_operation_shift!=0 ){       // 
??UI_Operation_Service_3:
        LDR.N    R0,??DataTable3_7
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_5
        LDR.N    R0,??DataTable3_1
        LDRH     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_5
//  162     Key2_risemask=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_8
        STRB     R0,[R1, #+0]
//  163     Key2_Downspin_Func();
        BL       Key2_Downspin_Func
        B.N      ??UI_Operation_Service_4
//  164   }
//  165   else if(Key3_down && ui_operation_shift!=0 ){       // 
??UI_Operation_Service_5:
        LDR.N    R0,??DataTable3_9
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_6
        LDR.N    R0,??DataTable3_1
        LDRH     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_6
//  166     Key3_risemask=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_10
        STRB     R0,[R1, #+0]
//  167     Key3_Downspin_Func();
        BL       Key3_Downspin_Func
        B.N      ??UI_Operation_Service_4
//  168   }
//  169   else if(ui_operation_shift!=0){
??UI_Operation_Service_6:
        LDR.N    R0,??DataTable3_1
        LDRH     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??UI_Operation_Service_4
//  170     Spin_Func();
        BL       Spin_Func
//  171   }
//  172 }
??UI_Operation_Service_4:
        POP      {R0,PC}          ;; return
//  173 
//  174 
//  175 
//  176 
//  177 // ===== Basic Drivers ====
//  178 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  179 void Key1_Read(){
//  180   if(Key1()==0){
Key1_Read:
        LDR.N    R0,??DataTable3_11  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BNE.N    ??Key1_Read_0
//  181     Key1_down=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_5
        STRB     R0,[R1, #+0]
//  182     Key1_cnt=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_12
        STRB     R0,[R1, #+0]
        B.N      ??Key1_Read_1
//  183   }
//  184   else if(Key1_down && Key1_cnt<DEBOUNCE_CNT)
??Key1_Read_0:
        LDR.N    R0,??DataTable3_5
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??Key1_Read_2
        LDR.N    R0,??DataTable3_12
        LDRB     R0,[R0, #+0]
        CMP      R0,#+6
        BGE.N    ??Key1_Read_2
//  185     Key1_cnt++;
        LDR.N    R0,??DataTable3_12
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable3_12
        STRB     R0,[R1, #+0]
        B.N      ??Key1_Read_1
//  186   else if(Key1_down){
??Key1_Read_2:
        LDR.N    R0,??DataTable3_5
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??Key1_Read_3
//  187     Key1_down=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_5
        STRB     R0,[R1, #+0]
//  188     Key1_rise=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_2
        STRB     R0,[R1, #+0]
        B.N      ??Key1_Read_1
//  189   }
//  190   else
//  191     Key1_down=0;
??Key1_Read_3:
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_5
        STRB     R0,[R1, #+0]
//  192 }
??Key1_Read_1:
        BX       LR               ;; return
//  193 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  194 void Key2_Read(){
//  195   if(Key2()==0){
Key2_Read:
        LDR.N    R0,??DataTable3_11  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+9,#+1
        CMP      R0,#+0
        BNE.N    ??Key2_Read_0
//  196     Key2_down=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_7
        STRB     R0,[R1, #+0]
//  197     Key2_cnt=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_13
        STRB     R0,[R1, #+0]
        B.N      ??Key2_Read_1
//  198   }
//  199   else if(Key2_down && Key2_cnt<DEBOUNCE_CNT)
??Key2_Read_0:
        LDR.N    R0,??DataTable3_7
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??Key2_Read_2
        LDR.N    R0,??DataTable3_13
        LDRB     R0,[R0, #+0]
        CMP      R0,#+6
        BGE.N    ??Key2_Read_2
//  200     Key2_cnt++;
        LDR.N    R0,??DataTable3_13
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable3_13
        STRB     R0,[R1, #+0]
        B.N      ??Key2_Read_1
//  201   else if(Key2_down){
??Key2_Read_2:
        LDR.N    R0,??DataTable3_7
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??Key2_Read_3
//  202     Key2_down=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_7
        STRB     R0,[R1, #+0]
//  203     Key2_rise=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_3
        STRB     R0,[R1, #+0]
        B.N      ??Key2_Read_1
//  204   }
//  205   else
//  206     Key2_down=0;
??Key2_Read_3:
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_7
        STRB     R0,[R1, #+0]
//  207 }
??Key2_Read_1:
        BX       LR               ;; return
//  208 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  209 void Key3_Read(){
//  210   if(Key3()==0){
Key3_Read:
        LDR.N    R0,??DataTable3_11  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+10,#+1
        CMP      R0,#+0
        BNE.N    ??Key3_Read_0
//  211     Key3_down=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_9
        STRB     R0,[R1, #+0]
//  212     Key3_cnt=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_14
        STRB     R0,[R1, #+0]
        B.N      ??Key3_Read_1
//  213   }
//  214   else if(Key3_down && Key3_cnt<DEBOUNCE_CNT)
??Key3_Read_0:
        LDR.N    R0,??DataTable3_9
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??Key3_Read_2
        LDR.N    R0,??DataTable3_14
        LDRB     R0,[R0, #+0]
        CMP      R0,#+6
        BGE.N    ??Key3_Read_2
//  215     Key3_cnt++;
        LDR.N    R0,??DataTable3_14
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable3_14
        STRB     R0,[R1, #+0]
        B.N      ??Key3_Read_1
//  216   else if(Key3_down){
??Key3_Read_2:
        LDR.N    R0,??DataTable3_9
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??Key3_Read_3
//  217     Key3_down=0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_9
        STRB     R0,[R1, #+0]
//  218     if(Key3_risemask==0)
        LDR.N    R0,??DataTable3_10
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BNE.N    ??Key3_Read_4
//  219       Key3_rise=1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable3_4
        STRB     R0,[R1, #+0]
        B.N      ??Key3_Read_1
//  220     else
//  221       Key3_risemask=0;
??Key3_Read_4:
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_10
        STRB     R0,[R1, #+0]
        B.N      ??Key3_Read_1
//  222   }
//  223   else
//  224     Key3_down=0;
??Key3_Read_3:
        MOVS     R0,#+0
        LDR.N    R1,??DataTable3_9
        STRB     R0,[R1, #+0]
//  225 }
??Key3_Read_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3:
        DC32     ui_operation_cnt

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_1:
        DC32     ui_operation_shift

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_2:
        DC32     Key1_rise

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_3:
        DC32     Key2_rise

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_4:
        DC32     Key3_rise

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_5:
        DC32     Key1_down

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_6:
        DC32     Key1_risemask

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_7:
        DC32     Key2_down

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_8:
        DC32     Key2_risemask

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_9:
        DC32     Key3_down

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_10:
        DC32     Key3_risemask

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_11:
        DC32     0x400ff010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_12:
        DC32     Key1_cnt

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_13:
        DC32     Key2_cnt

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_14:
        DC32     Key3_cnt

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
//  16 bytes in section .bss
// 590 bytes in section .text
// 
// 590 bytes of CODE memory
//  16 bytes of DATA memory
//
//Errors: none
//Warnings: none
