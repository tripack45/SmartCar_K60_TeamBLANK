///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       19/Feb/2016  17:23:18
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\framework2016.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\framework2016.c
//        -lCN E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\ -lB
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
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\framework2016.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN Bluetooth_Configure
        EXTERN Cam_Algorithm
        EXTERN Cam_Init
        EXTERN Flash_Init
        EXTERN Flash_Read
        EXTERN Flash_Write
        EXTERN HMI_Init
        EXTERN Motor_Init
        EXTERN Oled_Clear
        EXTERN Oled_Putnum
        EXTERN Oled_Putstr
        EXTERN PIT0_Init
        EXTERN PIT1_Init
        EXTERN PIT2_Init
        EXTERN Servo_Init
        EXTERN Tacho_Init
        EXTERN UART_Configure_DMA
        EXTERN UART_Init
        EXTERN UART_SetMode
        EXTERN `data`

        PUBLIC ADC0_enabled
        PUBLIC ADC1_enabled
        PUBLIC BusFault_Handler
        PUBLIC DefaultISR
        PUBLIC HardFault_Handler
        PUBLIC NMI_Handler
        PUBLIC main

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\framework2016.c
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

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   11 U8 ADC0_enabled = 0;
ADC0_enabled:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   12 U8 ADC1_enabled = 0;
ADC1_enabled:
        DS8 1
//   13 
//   14 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   15 void main (void)
//   16 {
main:
        PUSH     {R7,LR}
//   17   
//   18   // --- System Initiate ---
//   19   
//   20   __disable_irq();
        CPSID    I
//   21   
//   22   HMI_Init();
        BL       HMI_Init
//   23   PIT0_Init(PIT0_PERIOD_US);
        MOVW     R0,#+2500
        BL       PIT0_Init
//   24   PIT1_Init(PIT1_PERIOD_US);
        MOVW     R0,#+20000
        BL       PIT1_Init
//   25   PIT2_Init();
        BL       PIT2_Init
//   26   
//   27   Flash_Init();
        BL       Flash_Init
//   28   
//   29   if(!SW2()){
        LDR.N    R0,??DataTable4  ;; 0x400ff090
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+5,#+1
        CMP      R0,#+0
        BNE.N    ??main_0
//   30       UART_Init(921600);
        MOVS     R0,#+921600
        BL       UART_Init
        B.N      ??main_1
//   31   }else if(!SW3()){
??main_0:
        LDR.N    R0,??DataTable4  ;; 0x400ff090
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+6,#+1
        CMP      R0,#+0
        BNE.N    ??main_2
//   32       UART_Init(460800);
        MOVS     R0,#+460800
        BL       UART_Init
        B.N      ??main_1
//   33   }else{
//   34       UART_Init(115200);
??main_2:
        MOVS     R0,#+115200
        BL       UART_Init
//   35   } 
//   36   UART_Configure_DMA();
??main_1:
        BL       UART_Configure_DMA
//   37   UART_SetMode(UART_MODE_DMA_MANNUAL);
        MOVS     R0,#+1
        BL       UART_SetMode
//   38  
//   39   Motor_Init();
        BL       Motor_Init
//   40   Tacho_Init();
        BL       Tacho_Init
//   41   Servo_Init();
        BL       Servo_Init
//   42   
//   43 #if (CAR_TYPE==0)   // Magnet and Balance
//   44   
//   45   Mag_Init();
//   46   LPLD_MMA8451_Init();
//   47   Gyro_Init();
//   48   
//   49 #elif (CAR_TYPE==1)     // CCD
//   50   
//   51   CCD_Init();
//   52   
//   53 #else               // Camera
//   54   
//   55   Cam_Init();
        BL       Cam_Init
//   56   
//   57 #endif
//   58   
//   59   //-- Press Key 1 to Continue --
//   60   Oled_Putstr(7,1,"Press Key1 to go on");
        LDR.N    R2,??DataTable4_1
        MOVS     R1,#+1
        MOVS     R0,#+7
        BL       Oled_Putstr
//   61   while (Key1());while (!Key1());
??main_3:
        LDR.N    R0,??DataTable4_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BNE.N    ??main_3
??main_4:
        LDR.N    R0,??DataTable4_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BEQ.N    ??main_4
//   62   Oled_Clear();
        BL       Oled_Clear
//   63 /* 
//   64 UART_SetMode(UART_MODE_DMA_MANNUAL);
//   65   
//   66 //const char welcome_msg[]="Team [BLANK], JI-SJTU";
//   67 //Bluetooth_SendDataChunkSync((void*)welcome_msg,sizeof(welcome_msg)-1);
//   68 //UART_SetMode(UART_MODE_DMA_CONTINUOUS);
//   69  
//   70   uint8 tdata[50][100]={0};
//   71   uint8 *p=(uint8*)tdata;
//   72   int t=sizeof(tdata);
//   73   for(int i=1;i<t;i++){
//   74     p[i]=p[i-1]+1;
//   75   }
//   76   //preparing testdata
//   77   //TICK();
//   78   t=1;
//   79   while(t--)
//   80     Bluetooth_SendDataChunkSync((uint8*)tdata,sizeof(tdata));
//   81   //TOCK();*/
//   82 UART_SetMode(UART_MODE_DMA_CONTINUOUS);
        MOVS     R0,#+3
        BL       UART_SetMode
//   83 
//   84   ////// System Initiated ////
//   85   
//   86   // --- Flash test --- 
//   87   // To use this test, turn off Switch 1 first
//   88   if(!SW1()){
        LDR.N    R0,??DataTable4  ;; 0x400ff090
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+4,#+1
        CMP      R0,#+0
        BNE.N    ??main_5
//   89     __disable_irq();
        CPSID    I
//   90     Oled_Clear();
        BL       Oled_Clear
//   91     Oled_Putstr(0,0,"data[1] in flash is:");
        LDR.N    R2,??DataTable4_3
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       Oled_Putstr
//   92     Oled_Putstr(2,0,"data[1] in flash is:");
        LDR.N    R2,??DataTable4_3
        MOVS     R1,#+0
        MOVS     R0,#+2
        BL       Oled_Putstr
//   93     Oled_Putnum(1,11,Flash_Read(0,1));
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       Flash_Read
        MOVS     R2,R0
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+11
        MOVS     R0,#+1
        BL       Oled_Putnum
//   94     data[1] = Flash_Read(0,1)+1;
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       Flash_Read
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable4_4
        STRH     R0,[R1, #+2]
//   95     Flash_Write(0);
        MOVS     R0,#+0
        BL       Flash_Write
//   96     __disable_irq();
        CPSID    I
//   97     Oled_Putnum(3,11,Flash_Read(0,1));
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       Flash_Read
        MOVS     R2,R0
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+11
        MOVS     R0,#+3
        BL       Oled_Putnum
//   98     //-- Press Key 1 to Continue --
//   99     Oled_Putstr(6,1,"Press Key1 to go on");
        LDR.N    R2,??DataTable4_1
        MOVS     R1,#+1
        MOVS     R0,#+6
        BL       Oled_Putstr
//  100     while (Key1());
??main_6:
        LDR.N    R0,??DataTable4_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BNE.N    ??main_6
//  101     Oled_Clear();
        BL       Oled_Clear
//  102     ///// Flash test End///
//  103     __enable_irq(); 
        CPSIE    I
//  104     if(!SW4()){
        LDR.N    R0,??DataTable4  ;; 0x400ff090
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+7,#+1
        CMP      R0,#+0
        BNE.N    ??main_5
//  105       Bluetooth_Configure();
        BL       Bluetooth_Configure
//  106     }
//  107   }
//  108   __enable_irq(); 
??main_5:
        CPSIE    I
//  109 
//  110 
//  111 
//  112   while(1)
//  113   {
//  114     // Don't use oled or sensors' functions here !!!
//  115     
//  116    
//  117 #if (CAR_TYPE==0)
//  118     
//  119   accx = Accx();    // this might be blocked , so put here instead of interrupt
//  120   //accy = Accy();
//  121   //accz = Accz();
//  122     
//  123 #elif (CAR_TYPE==2)
//  124     Cam_Algorithm();    // 
??main_7:
        BL       Cam_Algorithm
        B.N      ??main_7
//  125 #endif
//  126     
//  127   } 
//  128 }
//  129 
//  130 
//  131 
//  132 
//  133 
//  134 
//  135 // ===== System Interrupt Handler  ==== ( No Need to Edit )
//  136 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  137 void BusFault_Handler(){
BusFault_Handler:
        PUSH     {R7,LR}
//  138   Oled_Clear();
        BL       Oled_Clear
//  139   Oled_Putstr(1,5,"Bus Fault");
        LDR.N    R2,??DataTable4_5
        MOVS     R1,#+5
        MOVS     R0,#+1
        BL       Oled_Putstr
//  140   Oled_Putstr(4,1,"press Key1 to goon");
        LDR.N    R2,??DataTable4_6
        MOVS     R1,#+1
        MOVS     R0,#+4
        BL       Oled_Putstr
//  141   while(Key1());
??BusFault_Handler_0:
        LDR.N    R0,??DataTable4_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BNE.N    ??BusFault_Handler_0
//  142   
//  143   return;
        POP      {R0,PC}          ;; return
//  144 }
//  145 
//  146 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  147 void NMI_Handler(){
NMI_Handler:
        PUSH     {R7,LR}
//  148   Oled_Clear();
        BL       Oled_Clear
//  149   Oled_Putstr(1,5,"NMI Fault");
        LDR.N    R2,??DataTable4_7
        MOVS     R1,#+5
        MOVS     R0,#+1
        BL       Oled_Putstr
//  150   Oled_Putstr(4,1,"press Key1 to goon");
        LDR.N    R2,??DataTable4_6
        MOVS     R1,#+1
        MOVS     R0,#+4
        BL       Oled_Putstr
//  151   while(Key1());
??NMI_Handler_0:
        LDR.N    R0,??DataTable4_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BNE.N    ??NMI_Handler_0
//  152   
//  153   return;
        POP      {R0,PC}          ;; return
//  154 }
//  155 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  156 void HardFault_Handler(void)
//  157 {
HardFault_Handler:
        PUSH     {R7,LR}
//  158   //LED1_Tog();
//  159   Oled_Clear();
        BL       Oled_Clear
//  160   Oled_Putstr(1,5,"Hard Fault");
        LDR.N    R2,??DataTable4_8
        MOVS     R1,#+5
        MOVS     R0,#+1
        BL       Oled_Putstr
//  161   Oled_Putstr(4,1,"press Key1 to goon");
        LDR.N    R2,??DataTable4_6
        MOVS     R1,#+1
        MOVS     R0,#+4
        BL       Oled_Putstr
//  162   while(Key1());
??HardFault_Handler_0:
        LDR.N    R0,??DataTable4_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BNE.N    ??HardFault_Handler_0
//  163   
//  164   return;
        POP      {R0,PC}          ;; return
//  165 }
//  166 
//  167 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  168 void DefaultISR(void)
//  169 {
DefaultISR:
        PUSH     {R7,LR}
//  170   Oled_Clear();
        BL       Oled_Clear
//  171   Oled_Putstr(1,5,"Default ISR");
        LDR.N    R2,??DataTable4_9
        MOVS     R1,#+5
        MOVS     R0,#+1
        BL       Oled_Putstr
//  172   Oled_Putstr(4,2,"press Key1 to goon");
        LDR.N    R2,??DataTable4_6
        MOVS     R1,#+2
        MOVS     R0,#+4
        BL       Oled_Putstr
//  173   while(Key1());
??DefaultISR_0:
        LDR.N    R0,??DataTable4_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BNE.N    ??DefaultISR_0
//  174 
//  175   return;
        POP      {R0,PC}          ;; return
//  176 }

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4:
        DC32     0x400ff090

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_1:
        DC32     ?_0

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_2:
        DC32     0x400ff010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_3:
        DC32     ?_1

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_4:
        DC32     `data`

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_5:
        DC32     ?_2

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_6:
        DC32     ?_3

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_7:
        DC32     ?_4

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_8:
        DC32     ?_5

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_9:
        DC32     ?_6

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_0:
        DATA
        DC8 "Press Key1 to go on"

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_1:
        DATA
        DC8 "data[1] in flash is:"
        DC8 0, 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_2:
        DATA
        DC8 "Bus Fault"
        DC8 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_3:
        DATA
        DC8 "press Key1 to goon"
        DC8 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_4:
        DATA
        DC8 "NMI Fault"
        DC8 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_5:
        DATA
        DC8 "Hard Fault"
        DC8 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_6:
        DATA
        DC8 "Default ISR"

        END
// 
//   2 bytes in section .bss
// 112 bytes in section .rodata
// 506 bytes in section .text
// 
// 506 bytes of CODE  memory
// 112 bytes of CONST memory
//   2 bytes of DATA  memory
//
//Errors: none
//Warnings: none
