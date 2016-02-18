///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       16/Feb/2016  22:34:43
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  
//        E:\freescale_racing\framework2016\common\system_MK60DZ10.c
//    Command line =  
//        E:\freescale_racing\framework2016\common\system_MK60DZ10.c -lCN
//        E:\freescale_racing\framework2016\FLASH\List\ -lB
//        E:\freescale_racing\framework2016\FLASH\List\ -o
//        E:\freescale_racing\framework2016\FLASH\Obj\ --no_cse --no_unroll
//        --no_inline --no_code_motion --no_tbaa --no_clustering
//        --no_scheduling --debug --endian=little --cpu=Cortex-M4 -e
//        --char_is_signed --fpu=None --dlib_config "C:\Program Files (x86)\IAR
//        Systems\Embedded Workbench 7.0\arm\INC\c\DLib_Config_Normal.h" -I
//        E:\freescale_racing\framework2016\source\ -I
//        E:\freescale_racing\framework2016\common\ -I
//        E:\freescale_racing\framework2016\LPLD\ -I
//        E:\freescale_racing\framework2016\LPLD\HW\ -I
//        E:\freescale_racing\framework2016\LPLD\DEV\ -Ol -I "C:\Program Files
//        (x86)\IAR Systems\Embedded Workbench 7.0\arm\CMSIS\Include\" -D
//        ARM_MATH_CM4
//    List file    =  
//        E:\freescale_racing\framework2016\FLASH\List\system_MK60DZ10.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN LPLD_PLL_Setup
        EXTERN Oled_Init
        EXTERN Oled_Putnum
        EXTERN Oled_Putstr
        EXTERN common_relocate
        EXTERN g_bus_clock
        EXTERN g_core_clock
        EXTERN g_flash_clock
        EXTERN g_flexbus_clock

        PUBLIC SystemCoreClock
        PUBLIC SystemCoreClockUpdate
        PUBLIC SystemInit

// E:\freescale_racing\framework2016\common\system_MK60DZ10.c
//    1 /**
//    2  * @file system_MK60DZ10.c
//    3  * @version 1.2.1[By LPLD]
//    4  * @date 2013-06-18
//    5  * @brief MK60DZ10系列单片机系统配置文件
//    6  *
//    7  * 更改建议:禁止修改
//    8  *
//    9  * 该代码提供系统配置函数以及一个储存系统主频的全局变量。
//   10  * 配置函数主要负责建立系统各模块的时钟。
//   11  * 代码还实现常见的系统中断函数。
//   12  *
//   13  * 版权所有:北京拉普兰德电子技术有限公司
//   14  * http://www.lpld.cn
//   15  * mail:support@lpld.cn
//   16  *
//   17  * @par
//   18  * 本代码由拉普兰德[LPLD]开发并维护，并向所有使用者开放源代码。
//   19  * 开发者可以随意修使用或改源代码。但本段及以上注释应予以保留。
//   20  * 不得更改或删除原版权所有者姓名，二次开发者可以加注二次版权所有者。
//   21  * 但应在遵守此协议的基础上，开放源代码、不得出售代码本身。
//   22  * 拉普兰德不负责由于使用本代码所带来的任何事故、法律责任或相关不良影响。
//   23  * 拉普兰德无义务解释、说明本代码的具体原理、功能、实现方法。
//   24  * 除非拉普兰德[LPLD]授权，开发者不得将本代码用于商业产品。
//   25  *
//   26  *  Modified by Qian Qiyang(KisaragiAyanoo@twitter)
//   27  *  Date : 2015/12/01
//   28  */
//   29 
//   30 #include <stdint.h>
//   31 #include "common.h"

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// static __interwork __softfp void NVIC_SetPriorityGrouping(uint32_t)
NVIC_SetPriorityGrouping:
        ANDS     R1,R0,#0x7
        LDR.N    R0,??DataTable2_1  ;; 0xe000ed0c
        LDR      R0,[R0, #+0]
        MOVW     R2,#+63743
        ANDS     R0,R2,R0
        LDR.N    R2,??DataTable2_2  ;; 0x5fa0000
        ORRS     R1,R2,R1, LSL #+8
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable2_1  ;; 0xe000ed0c
        STR      R0,[R1, #+0]
        BX       LR               ;; return
//   32 
//   33 #include "OLED.h"
//   34 #include "Setting.h"
//   35 
//   36 /*----------------------------------------------------------------------------
//   37   定义时钟相关值
//   38  *----------------------------------------------------------------------------*/
//   39 #define CPU_XTAL_CLK_HZ                 50000000u       //外部有源晶振频率，单位Hz
//   40 #define CPU_XTAL32k_CLK_HZ              32768u          //外部32k时钟晶振频率，单位Hz    
//   41 #define CPU_INT_SLOW_CLK_HZ             32768u          //慢速内部振荡器的值，单位Hz
//   42 #define CPU_INT_FAST_CLK_HZ             4000000u        //快速内部振荡器的值，单位Hz
//   43 #define DEFAULT_SYSTEM_CLOCK            100000000u      //默认系统主频，单位Hz
//   44 
//   45 /**
//   46  * @brief 系统主频（单位Hz）
//   47  */

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   48 uint32_t SystemCoreClock = DEFAULT_SYSTEM_CLOCK;
SystemCoreClock:
        DATA
        DC32 100000000
//   49 
//   50 
//   51 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   52 void SystemInit (void) {
SystemInit:
        PUSH     {R7,LR}
//   53   
//   54   SIM->SCGC5 |= (SIM_SCGC5_PORTA_MASK
//   55               | SIM_SCGC5_PORTB_MASK
//   56               | SIM_SCGC5_PORTC_MASK
//   57               | SIM_SCGC5_PORTD_MASK
//   58               | SIM_SCGC5_PORTE_MASK );
        LDR.N    R0,??DataTable2_3  ;; 0x40048038
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3E00
        LDR.N    R1,??DataTable2_3  ;; 0x40048038
        STR      R0,[R1, #+0]
//   59   
//   60   WDOG->UNLOCK = (uint16_t)0xC520u;
        MOVW     R0,#+50464
        LDR.N    R1,??DataTable2_4  ;; 0x4005200e
        STRH     R0,[R1, #+0]
//   61   WDOG->UNLOCK  = (uint16_t)0xD928u; 
        MOVW     R0,#+55592
        LDR.N    R1,??DataTable2_4  ;; 0x4005200e
        STRH     R0,[R1, #+0]
//   62   /* WDOG_STCTRLH: ??=0,DISTESTWDOG=0,BYTESEL=0,TESTSEL=0,TESTWDOG=0,??=0,STNDBYEN=1,WAITEN=1,STOPEN=1,DBGEN=0,ALLOWUPDATE=1,WINEN=0,IRQRSTEN=0,CLKSRC=1,WDOGEN=0 */
//   63   WDOG->STCTRLH = (uint16_t)0x01D2u;
        MOV      R0,#+466
        LDR.N    R1,??DataTable2_5  ;; 0x40052000
        STRH     R0,[R1, #+0]
//   64   
//   65   common_relocate();
        BL       common_relocate
//   66   
//   67   LPLD_PLL_Setup(CORE_CLK_MHZ);
        MOVS     R0,#+100
        BL       LPLD_PLL_Setup
//   68   
//   69   SystemCoreClockUpdate();
        BL       SystemCoreClockUpdate
//   70   
//   71   g_core_clock = SystemCoreClock;
        LDR.N    R0,??DataTable2_6
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_7
        STR      R0,[R1, #+0]
//   72   g_bus_clock = g_core_clock / ((uint32_t)((SIM->CLKDIV1 & SIM_CLKDIV1_OUTDIV2_MASK) >> SIM_CLKDIV1_OUTDIV2_SHIFT)+ 1u);
        LDR.N    R0,??DataTable2_7
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_8  ;; 0x40048044
        LDR      R1,[R1, #+0]
        UBFX     R1,R1,#+24,#+4
        ADDS     R1,R1,#+1
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable2_9
        STR      R0,[R1, #+0]
//   73   g_flexbus_clock =  g_core_clock / ((uint32_t)((SIM->CLKDIV1 & SIM_CLKDIV1_OUTDIV3_MASK) >> SIM_CLKDIV1_OUTDIV3_SHIFT)+ 1u);
        LDR.N    R0,??DataTable2_7
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_8  ;; 0x40048044
        LDR      R1,[R1, #+0]
        UBFX     R1,R1,#+20,#+4
        ADDS     R1,R1,#+1
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable2_10
        STR      R0,[R1, #+0]
//   74   g_flash_clock =  g_core_clock / ((uint32_t)((SIM->CLKDIV1 & SIM_CLKDIV1_OUTDIV4_MASK) >> SIM_CLKDIV1_OUTDIV4_SHIFT)+ 1u);
        LDR.N    R0,??DataTable2_7
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_8  ;; 0x40048044
        LDR      R1,[R1, #+0]
        UBFX     R1,R1,#+16,#+4
        ADDS     R1,R1,#+1
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable2_11
        STR      R0,[R1, #+0]
//   75   
//   76   // ==== Init Oled ===
//   77   
//   78   Oled_Init();
        BL       Oled_Init
//   79   Oled_Putstr(1,3,"<< Clock Init >>");
        LDR.N    R2,??DataTable2_12
        MOVS     R1,#+3
        MOVS     R0,#+1
        BL       Oled_Putstr
//   80   Oled_Putstr(2,1,"Bus Clk");
        LDR.N    R2,??DataTable2_13
        MOVS     R1,#+1
        MOVS     R0,#+2
        BL       Oled_Putstr
//   81   Oled_Putnum(2,9,g_bus_clock/1000000);
        LDR.N    R0,??DataTable2_9
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_14  ;; 0xf4240
        UDIV     R2,R0,R1
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+9
        MOVS     R0,#+2
        BL       Oled_Putnum
//   82   Oled_Putstr(2,18,"MHz");
        ADR.N    R2,??DataTable2  ;; "MHz"
        MOVS     R1,#+18
        MOVS     R0,#+2
        BL       Oled_Putstr
//   83   Oled_Putstr(3,1,"UART Speed");
        LDR.N    R2,??DataTable2_15
        MOVS     R1,#+1
        MOVS     R0,#+3
        BL       Oled_Putstr
//   84   Oled_Putstr(4,1,"None:115200");
        LDR.N    R2,??DataTable2_16
        MOVS     R1,#+1
        MOVS     R0,#+4
        BL       Oled_Putstr
//   85   Oled_Putstr(5,1,"SW2:1382400");
        LDR.N    R2,??DataTable2_17
        MOVS     R1,#+1
        MOVS     R0,#+5
        BL       Oled_Putstr
//   86   Oled_Putstr(6,1,"SW3:460800");
        LDR.N    R2,??DataTable2_18
        MOVS     R1,#+1
        MOVS     R0,#+6
        BL       Oled_Putstr
//   87   
//   88   
//   89   NVIC_SetPriorityGrouping(NVIC_GROUP);
        MOVS     R0,#+5
        BL       NVIC_SetPriorityGrouping
//   90 }
        POP      {R0,PC}          ;; return
//   91 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   92 void SystemCoreClockUpdate (void) {
//   93   uint32_t temp;
//   94   temp =  CPU_XTAL_CLK_HZ *((uint32_t)(MCG->C6 & MCG_C6_VDIV_MASK) + 24u );
SystemCoreClockUpdate:
        LDR.N    R0,??DataTable2_19  ;; 0x40064005
        LDRB     R0,[R0, #+0]
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        ANDS     R0,R0,#0x1F
        ADDS     R0,R0,#+24
        LDR.N    R1,??DataTable2_20  ;; 0x2faf080
        MULS     R0,R1,R0
//   95   temp = (uint32_t)(temp/((uint32_t)(MCG->C5 & MCG_C5_PRDIV_MASK) +1u ));
        LDR.N    R1,??DataTable2_21  ;; 0x40064004
        LDRB     R1,[R1, #+0]
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        ANDS     R1,R1,#0x1F
        ADDS     R1,R1,#+1
        UDIV     R0,R0,R1
//   96   SystemCoreClock = temp;
        LDR.N    R1,??DataTable2_6
        STR      R0,[R1, #+0]
//   97 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2:
        DC8      "MHz"

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_1:
        DC32     0xe000ed0c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_2:
        DC32     0x5fa0000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_3:
        DC32     0x40048038

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_4:
        DC32     0x4005200e

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_5:
        DC32     0x40052000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_6:
        DC32     SystemCoreClock

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_7:
        DC32     g_core_clock

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_8:
        DC32     0x40048044

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_9:
        DC32     g_bus_clock

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_10:
        DC32     g_flexbus_clock

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_11:
        DC32     g_flash_clock

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_12:
        DC32     ?_0

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_13:
        DC32     ?_1

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_14:
        DC32     0xf4240

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_15:
        DC32     ?_3

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_16:
        DC32     ?_4

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_17:
        DC32     ?_5

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_18:
        DC32     ?_6

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_19:
        DC32     0x40064005

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_20:
        DC32     0x2faf080

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_21:
        DC32     0x40064004

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
        DC8 "<< Clock Init >>"
        DC8 0, 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_1:
        DATA
        DC8 "Bus Clk"

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
        DATA
        DC8 "MHz"

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_3:
        DATA
        DC8 "UART Speed"
        DC8 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_4:
        DATA
        DC8 "None:115200"

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_5:
        DATA
        DC8 "SW2:1382400"

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_6:
        DATA
        DC8 "SW3:460800"
        DC8 0

        END
//   98 
//   99 
//  100 
//  101 
// 
//   4 bytes in section .data
//  80 bytes in section .rodata
// 382 bytes in section .text
// 
// 382 bytes of CODE  memory
//  80 bytes of CONST memory
//   4 bytes of DATA  memory
//
//Errors: none
//Warnings: none
