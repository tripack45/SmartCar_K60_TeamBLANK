///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       21/Feb/2016  03:11:38
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  E:\freescale_racing\SmartCar_K60_TeamBLANK\source\PIT.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\PIT.c -lCN
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
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\PIT.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN Battery
        EXTERN Bell_Service
        EXTERN Tacho0_Get
        EXTERN Tacho1_Get
        EXTERN UI_Operation_Service
        EXTERN UI_SystemInfo
        EXTERN battery
        EXTERN current_frame_indicator
        EXTERN debug_msg
        EXTERN g_bus_clock
        EXTERN last_frame_indicator
        EXTERN processing_frame_indicator
        EXTERN sending_frame_indicator
        EXTERN tacho0
        EXTERN ui_operation_cnt

        PUBLIC PIT0_IRQHandler
        PUBLIC PIT0_Init
        PUBLIC PIT1_IRQHandler
        PUBLIC PIT1_Init
        PUBLIC PIT2_Init
        PUBLIC pit0_time
        PUBLIC pit1_time
        PUBLIC pit1_time_tmp
        PUBLIC time_us

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\PIT.c
//    1 /*
//    2 Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
//    3 Date : 2015/12/01
//    4 License : MIT
//    5 */
//    6 
//    7 #include "includes.h"

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// static __interwork __softfp void NVIC_EnableIRQ(IRQn_Type)
NVIC_EnableIRQ:
        MOVS     R1,#+1
        ANDS     R2,R0,#0x1F
        LSLS     R1,R1,R2
        LDR.N    R2,??DataTable6  ;; 0xe000e100
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        LSRS     R0,R0,#+5
        STR      R1,[R2, R0, LSL #+2]
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// static __interwork __softfp void NVIC_SetPriority(IRQn_Type, uint32_t)
NVIC_SetPriority:
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BPL.N    ??NVIC_SetPriority_0
        LSLS     R1,R1,#+4
        LDR.N    R2,??DataTable6_1  ;; 0xe000ed18
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        ANDS     R0,R0,#0xF
        ADDS     R0,R0,R2
        STRB     R1,[R0, #-4]
        B.N      ??NVIC_SetPriority_1
??NVIC_SetPriority_0:
        LSLS     R1,R1,#+4
        LDR.N    R2,??DataTable6_2  ;; 0xe000e400
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        STRB     R1,[R0, R2]
??NVIC_SetPriority_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// static __interwork __softfp uint32_t NVIC_EncodePriority(uint32_t, uint32_t, uint32_t)
NVIC_EncodePriority:
        PUSH     {R4}
        ANDS     R0,R0,#0x7
        RSBS     R3,R0,#+7
        CMP      R3,#+5
        BCC.N    ??NVIC_EncodePriority_0
        MOVS     R3,#+4
        B.N      ??NVIC_EncodePriority_1
??NVIC_EncodePriority_0:
        RSBS     R3,R0,#+7
??NVIC_EncodePriority_1:
        ADDS     R4,R0,#+4
        CMP      R4,#+7
        BCS.N    ??NVIC_EncodePriority_2
        MOVS     R0,#+0
        B.N      ??NVIC_EncodePriority_3
??NVIC_EncodePriority_2:
        SUBS     R0,R0,#+3
??NVIC_EncodePriority_3:
        MOVS     R4,#+1
        LSLS     R3,R4,R3
        SUBS     R3,R3,#+1
        ANDS     R1,R3,R1
        LSLS     R1,R1,R0
        MOVS     R3,#+1
        LSLS     R0,R3,R0
        SUBS     R0,R0,#+1
        ANDS     R0,R0,R2
        ORRS     R0,R0,R1
        POP      {R4}
        BX       LR               ;; return
//    8 
//    9 
//   10 // ========= Variables =========
//   11 
//   12 //--- global ---

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   13 U32 time_us = 0;
time_us:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   14 U32 pit0_time;
pit0_time:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   15 U32 pit1_time; 
pit1_time:
        DS8 4
//   16 
//   17 //--- local ---

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   18 U32 pit1_time_tmp;
pit1_time_tmp:
        DS8 4
//   19 
//   20 // =========== PIT 1 ISR =========== 
//   21 // ====  UI Refreshing Loop  ==== ( Low priority ) 
//   22 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   23 void PIT1_IRQHandler(){
PIT1_IRQHandler:
        PUSH     {R7,LR}
//   24   PIT->CHANNEL[1].TFLG |= PIT_TFLG_TIF_MASK;
        LDR.N    R0,??DataTable6_3  ;; 0x4003711c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable6_3  ;; 0x4003711c
        STR      R0,[R1, #+0]
//   25   
//   26   pit1_time_tmp = PIT2_VAL();
        LDR.N    R0,??DataTable6_4  ;; 0x40037124
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_5
        STR      R0,[R1, #+0]
//   27   
//   28   //------------------------
//   29   
//   30   //LED1_Tog();
//   31   
//   32   UI_Operation_Service();
        BL       UI_Operation_Service
//   33   
//   34   Bell_Service();
        BL       Bell_Service
//   35     
//   36   if(SW1())
        LDR.N    R0,??DataTable6_6  ;; 0x400ff090
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+4,#+1
        CMP      R0,#+0
        BEQ.N    ??PIT1_IRQHandler_0
//   37     UI_SystemInfo();
        BL       UI_SystemInfo
//   38     
//   39   //------------ Other -------------
//   40   
//   41   pit1_time_tmp = pit1_time_tmp - PIT2_VAL();
??PIT1_IRQHandler_0:
        LDR.N    R0,??DataTable6_5
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_4  ;; 0x40037124
        LDR      R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable6_5
        STR      R0,[R1, #+0]
//   42   pit1_time_tmp = pit1_time_tmp / (g_bus_clock/10000); //100us
        LDR.N    R0,??DataTable6_7
        LDR      R0,[R0, #+0]
        MOVW     R1,#+10000
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable6_5
        LDR      R1,[R1, #+0]
        UDIV     R0,R1,R0
        LDR.N    R1,??DataTable6_5
        STR      R0,[R1, #+0]
//   43   pit1_time = pit1_time_tmp;
        LDR.N    R0,??DataTable6_5
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_8
        STR      R0,[R1, #+0]
//   44   
//   45 }
        POP      {R0,PC}          ;; return
//   46 
//   47 
//   48 
//   49 //============ PIT 0 ISR  ==========
//   50 // ====  Control  ==== ( High priority )
//   51 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   52 void PIT0_IRQHandler(){
PIT0_IRQHandler:
        PUSH     {R7,LR}
//   53   PIT->CHANNEL[0].TFLG |= PIT_TFLG_TIF_MASK;
        LDR.N    R0,??DataTable6_9  ;; 0x4003710c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable6_9  ;; 0x4003710c
        STR      R0,[R1, #+0]
//   54   
//   55   time_us += PIT0_PERIOD_US;
        LDR.N    R0,??DataTable6_10
        LDR      R0,[R0, #+0]
        ADDW     R0,R0,#+2500
        LDR.N    R1,??DataTable6_10
        STR      R0,[R1, #+0]
//   56 
//   57   //LED2_Tog();
//   58   
//   59   
//   60   //-------- System info -----
//   61   
//   62   pit0_time = PIT2_VAL();
        LDR.N    R0,??DataTable6_4  ;; 0x40037124
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_11
        STR      R0,[R1, #+0]
//   63     
//   64   battery = Battery();
        BL       Battery
        LDR.N    R1,??DataTable6_12
        STRH     R0,[R1, #+0]
//   65   
//   66   debug_msg[2]=current_frame_indicator+'0';
        LDR.N    R0,??DataTable6_13
        LDRSB    R0,[R0, #+0]
        ADDS     R0,R0,#+48
        LDR.N    R1,??DataTable6_14
        STRB     R0,[R1, #+2]
//   67   debug_msg[6]=last_frame_indicator+'0';
        LDR.N    R0,??DataTable6_15
        LDRSB    R0,[R0, #+0]
        ADDS     R0,R0,#+48
        LDR.N    R1,??DataTable6_14
        STRB     R0,[R1, #+6]
//   68   debug_msg[10]=processing_frame_indicator+'0';
        LDR.N    R0,??DataTable6_16
        LDRSB    R0,[R0, #+0]
        ADDS     R0,R0,#+48
        LDR.N    R1,??DataTable6_14
        STRB     R0,[R1, #+10]
//   69   debug_msg[14]=sending_frame_indicator+'0';
        LDR.N    R0,??DataTable6_17
        LDRSB    R0,[R0, #+0]
        ADDS     R0,R0,#+48
        LDR.N    R1,??DataTable6_14
        STRB     R0,[R1, #+14]
//   70   //-------- Get Sensers -----
//   71   
//   72   
//   73   // Tacho
//   74   Tacho0_Get();
        BL       Tacho0_Get
//   75   Tacho1_Get();
        BL       Tacho1_Get
//   76   
//   77   
//   78   // UI operation input
//   79   ui_operation_cnt += tacho0;  // use tacho0 or tacho1
        LDR.N    R0,??DataTable6_18
        LDRH     R0,[R0, #+0]
        LDR.N    R1,??DataTable6_19
        LDRSH    R1,[R1, #+0]
        ADDS     R0,R1,R0
        LDR.N    R1,??DataTable6_18
        STRH     R0,[R1, #+0]
//   80     
//   81     
//   82   
//   83 #if (CAR_TYPE==0)   // Magnet and Balance
//   84   
//   85   Mag_Sample();
//   86   
//   87   gyro1 = Gyro1();
//   88   gyro2 = Gyro2();
//   89   
//   90   
//   91   
//   92 #elif (CAR_TYPE==1)     // CCD
//   93   
//   94   CCD1_GetLine();
//   95   CCD2_GetLine();
//   96   
//   97   
//   98   
//   99   
//  100 #else               // Camera
//  101   
//  102   // Results of camera are automatically put in cam_buffer[].
//  103   
//  104   
//  105 #endif
//  106   
//  107   
//  108   
//  109   // -------- Sensor Algorithm --------- ( Users need to realize this )
//  110   
//  111   // mag example : dir_error = Mag_Algorithm(mag_val);
//  112   // ccd example : dir_error = CCD_Algorithm(ccd1_line,ccd2_line);
//  113   // cam is complex. realize it in Cam_Algorithm() in Cam.c
//  114   
//  115   //-------- Controller --------
//  116   
//  117   
//  118   // not balance example : dir_output = Dir_PIDController(dir_error);
//  119   // example : get 'motorL_output' and  'motorR_output'
//  120   
//  121   
//  122   // ------- Output -----
//  123   
//  124   
//  125   // not balance example : Servo_Output(dir_output);  
//  126   // example : MotorL_Output(motorL_output); MotorR_Output(motorR_output);
//  127   
//  128   
//  129   
//  130   // ------- UART ---------
//  131   
//  132   
//  133   //UART_SendDataHead();
//  134   //UART_SendData(battery);
//  135   
//  136   
//  137   
//  138   // ------- other --------
//  139   
//  140   pit0_time = pit0_time - PIT2_VAL();
        LDR.N    R0,??DataTable6_11
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_4  ;; 0x40037124
        LDR      R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable6_11
        STR      R0,[R1, #+0]
//  141   pit0_time = pit0_time / (g_bus_clock/1000000); //us
        LDR.N    R0,??DataTable6_7
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_20  ;; 0xf4240
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable6_11
        LDR      R1,[R1, #+0]
        UDIV     R0,R1,R0
        LDR.N    R1,??DataTable6_11
        STR      R0,[R1, #+0]
//  142   
//  143 }
        POP      {R0,PC}          ;; return
//  144 
//  145 
//  146 
//  147 
//  148 // ======= INIT ========
//  149 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  150 void PIT0_Init(u32 period_us)
//  151 { 
PIT0_Init:
        PUSH     {R4,LR}
        MOVS     R4,R0
//  152                    
//  153   SIM->SCGC6 |= SIM_SCGC6_PIT_MASK;
        LDR.N    R0,??DataTable6_21  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x800000
        LDR.N    R1,??DataTable6_21  ;; 0x4004803c
        STR      R0,[R1, #+0]
//  154   
//  155   PIT->MCR = 0x00;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_22  ;; 0x40037000
        STR      R0,[R1, #+0]
//  156  
//  157   NVIC_EnableIRQ(PIT0_IRQn); 
        MOVS     R0,#+68
        BL       NVIC_EnableIRQ
//  158   NVIC_SetPriority(PIT0_IRQn, NVIC_EncodePriority(NVIC_GROUP, 1, 2));
        MOVS     R2,#+2
        MOVS     R1,#+1
        MOVS     R0,#+5
        BL       NVIC_EncodePriority
        MOVS     R1,R0
        MOVS     R0,#+68
        BL       NVIC_SetPriority
//  159 
//  160   //period = (period_ns/bus_period_ns)-1
//  161   PIT->CHANNEL[0].LDVAL |= period_us/100*(g_bus_clock/1000)/10-1; 
        LDR.N    R0,??DataTable6_23  ;; 0x40037100
        LDR      R0,[R0, #+0]
        MOVS     R1,#+100
        UDIV     R1,R4,R1
        LDR.N    R2,??DataTable6_7
        LDR      R2,[R2, #+0]
        MOV      R3,#+1000
        UDIV     R2,R2,R3
        MULS     R1,R2,R1
        MOVS     R2,#+10
        UDIV     R1,R1,R2
        SUBS     R1,R1,#+1
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable6_23  ;; 0x40037100
        STR      R0,[R1, #+0]
//  162   
//  163   PIT->CHANNEL[0].TCTRL |= PIT_TCTRL_TIE_MASK |PIT_TCTRL_TEN_MASK;
        LDR.N    R0,??DataTable6_24  ;; 0x40037108
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable6_24  ;; 0x40037108
        STR      R0,[R1, #+0]
//  164 
//  165 };
        POP      {R4,PC}          ;; return
//  166 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  167 void PIT1_Init(u32 period_us)
//  168 { 
PIT1_Init:
        PUSH     {R4,LR}
        MOVS     R4,R0
//  169                    
//  170   SIM->SCGC6 |= SIM_SCGC6_PIT_MASK;
        LDR.N    R0,??DataTable6_21  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x800000
        LDR.N    R1,??DataTable6_21  ;; 0x4004803c
        STR      R0,[R1, #+0]
//  171   
//  172   PIT->MCR = 0x00;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_22  ;; 0x40037000
        STR      R0,[R1, #+0]
//  173  
//  174   NVIC_EnableIRQ(PIT1_IRQn); 
        MOVS     R0,#+69
        BL       NVIC_EnableIRQ
//  175   NVIC_SetPriority(PIT1_IRQn, NVIC_EncodePriority(NVIC_GROUP, 3, 0));
        MOVS     R2,#+0
        MOVS     R1,#+3
        MOVS     R0,#+5
        BL       NVIC_EncodePriority
        MOVS     R1,R0
        MOVS     R0,#+69
        BL       NVIC_SetPriority
//  176 
//  177   //period = (period_ns/bus_period_ns)-1
//  178   PIT->CHANNEL[1].LDVAL |= period_us/100*(g_bus_clock/1000)/10-1; 
        LDR.N    R0,??DataTable6_25  ;; 0x40037110
        LDR      R0,[R0, #+0]
        MOVS     R1,#+100
        UDIV     R1,R4,R1
        LDR.N    R2,??DataTable6_7
        LDR      R2,[R2, #+0]
        MOV      R3,#+1000
        UDIV     R2,R2,R3
        MULS     R1,R2,R1
        MOVS     R2,#+10
        UDIV     R1,R1,R2
        SUBS     R1,R1,#+1
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable6_25  ;; 0x40037110
        STR      R0,[R1, #+0]
//  179   
//  180   PIT->CHANNEL[1].TCTRL |= PIT_TCTRL_TIE_MASK |PIT_TCTRL_TEN_MASK;
        LDR.N    R0,??DataTable6_26  ;; 0x40037118
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable6_26  ;; 0x40037118
        STR      R0,[R1, #+0]
//  181 
//  182 }
        POP      {R4,PC}          ;; return
//  183 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  184 void PIT2_Init()
//  185 { 
//  186                    
//  187   SIM->SCGC6 |= SIM_SCGC6_PIT_MASK;
PIT2_Init:
        LDR.N    R0,??DataTable6_21  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x800000
        LDR.N    R1,??DataTable6_21  ;; 0x4004803c
        STR      R0,[R1, #+0]
//  188   
//  189   PIT->MCR = 0x00;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_22  ;; 0x40037000
        STR      R0,[R1, #+0]
//  190 
//  191   //period = (period_ns/bus_period_ns)-1
//  192   PIT->CHANNEL[2].LDVAL = 0xffffffff; 
        MOVS     R0,#-1
        LDR.N    R1,??DataTable6_27  ;; 0x40037120
        STR      R0,[R1, #+0]
//  193   
//  194   PIT->CHANNEL[2].TCTRL |= PIT_TCTRL_TEN_MASK;
        LDR.N    R0,??DataTable6_28  ;; 0x40037128
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable6_28  ;; 0x40037128
        STR      R0,[R1, #+0]
//  195 
//  196 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6:
        DC32     0xe000e100

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_1:
        DC32     0xe000ed18

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_2:
        DC32     0xe000e400

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_3:
        DC32     0x4003711c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_4:
        DC32     0x40037124

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_5:
        DC32     pit1_time_tmp

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_6:
        DC32     0x400ff090

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_7:
        DC32     g_bus_clock

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_8:
        DC32     pit1_time

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_9:
        DC32     0x4003710c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_10:
        DC32     time_us

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_11:
        DC32     pit0_time

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_12:
        DC32     battery

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_13:
        DC32     current_frame_indicator

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_14:
        DC32     debug_msg

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_15:
        DC32     last_frame_indicator

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_16:
        DC32     processing_frame_indicator

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_17:
        DC32     sending_frame_indicator

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_18:
        DC32     ui_operation_cnt

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_19:
        DC32     tacho0

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_20:
        DC32     0xf4240

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_21:
        DC32     0x4004803c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_22:
        DC32     0x40037000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_23:
        DC32     0x40037100

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_24:
        DC32     0x40037108

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_25:
        DC32     0x40037110

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_26:
        DC32     0x40037118

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_27:
        DC32     0x40037120

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_28:
        DC32     0x40037128

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
// 714 bytes in section .text
// 
// 714 bytes of CODE memory
//  16 bytes of DATA memory
//
//Errors: none
//Warnings: 2
