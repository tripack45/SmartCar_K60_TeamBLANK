///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       18/Feb/2016  13:23:09
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  E:\freescale_racing\SmartCar_K60_TeamBLANK\source\Flash.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\Flash.c -lCN
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
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\Flash.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        PUBLIC Flash_Data_Reset
        PUBLIC Flash_Data_Update
        PUBLIC Flash_Erase
        PUBLIC Flash_Init
        PUBLIC Flash_Program
        PUBLIC Flash_Read
        PUBLIC Flash_Write
        PUBLIC `data`
        PUBLIC data_initial

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\Flash.c
//    1 /*
//    2 Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
//    3 Date : 2016/01/15
//    4 License : MIT
//    5 */
//    6 #include "includes.h"
//    7 
//    8 
//    9 // ===== Global Variables =====
//   10 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   11 U16 data[DATA_NUM];
`data`:
        DS8 32
//   12 

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   13 U16 data_initial[DATA_NUM]={
data_initial:
        DATA
        DC16 1, 0, 0, 40, 100, 85, 95, 1635, 40, 10, 75, 70, 1, 1, 0, 15
//   14   1,	        //data flag
//   15   0,	        //KF_switch
//   16   0,	        //blance_deform
//   17   40,	        //balance_K
//   18   100,	        //balance P
//   19   85,	        //balance D
//   20   95,	        //balance dt
//   21   1635,	        //acc offset
//   22   40,            //P speed
//   23   10,            //D speed
//   24   75,           //pwm deadzone left
//   25   70,           //pwm deadzone right
//   26   1,            //wheel p
//   27   1,            //wheel i
//   28   0,            //wheel d
//   29   15,           // I speed
//   30 };
//   31 
//   32 
//   33 
//   34 
//   35 // ======= APIs =======
//   36 
//   37 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   38 void Flash_Write(U16 sector){
Flash_Write:
        PUSH     {R0,LR}
        SUB      SP,SP,#+8
//   39   U32 addr = ADDR + sector*SECTOR_SIZE;
        LDRH     R0,[SP, #+8]
        MOV      R1,#+512
        MULS     R0,R1,R0
        ADDS     R0,R0,#+245760
        STR      R0,[SP, #+0]
//   40   __disable_irq();
        CPSID    I
//   41   Flash_Erase(sector);
        LDRH     R0,[SP, #+8]
        BL       Flash_Erase
//   42   Flash_Program(sector,DATA_NUM,data);
        LDR.N    R2,??DataTable6
        MOVS     R1,#+16
        LDRH     R0,[SP, #+8]
        BL       Flash_Program
//   43   __enable_irq();
        CPSIE    I
//   44 }
        POP      {R0-R2,PC}       ;; return
//   45 
//   46 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   47 U16 Flash_Read(U16 sector,U16 data_index){
Flash_Read:
        PUSH     {R0,R1}
//   48   U16* addr = (U16*)(ADDR + sector*SECTOR_SIZE + data_index * 0x02);
        LDRH     R0,[SP, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOV      R1,#+512
        LDRH     R2,[SP, #+4]
        LSLS     R2,R2,#+1
        MLA      R0,R1,R0,R2
        ADDS     R0,R0,#+245760
//   49   return *addr;
        LDRH     R0,[R0, #+0]
        ADD      SP,SP,#+8
        BX       LR               ;; return
//   50 }
//   51 
//   52 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   53 void Flash_Data_Update(U16 sector){
Flash_Data_Update:
        PUSH     {R0,R4,LR}
        SUB      SP,SP,#+4
//   54   U8 i;
//   55   for(i=0;i<DATA_NUM;i++){
        MOVS     R0,#+0
        STRB     R0,[SP, #+0]
        B.N      ??Flash_Data_Update_0
//   56     data[i] = Flash_Read(sector,i);
??Flash_Data_Update_1:
        LDRB     R4,[SP, #+0]
        LDRB     R1,[SP, #+0]
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        LDRH     R0,[SP, #+4]
        BL       Flash_Read
        LDR.N    R1,??DataTable6
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        STRH     R0,[R1, R4, LSL #+1]
//   57   }
        LDRB     R0,[SP, #+0]
        ADDS     R0,R0,#+1
        STRB     R0,[SP, #+0]
??Flash_Data_Update_0:
        LDRB     R0,[SP, #+0]
        CMP      R0,#+16
        BLT.N    ??Flash_Data_Update_1
//   58 }
        POP      {R0,R1,R4,PC}    ;; return
//   59 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   60 void Flash_Data_Reset(void){
Flash_Data_Reset:
        PUSH     {R7,LR}
//   61   U16 i;
//   62   for(i=0;i<DATA_NUM;i++){
        MOVS     R0,#+0
        STRH     R0,[SP, #+0]
        B.N      ??Flash_Data_Reset_0
//   63     data[i] = data_initial[i];
??Flash_Data_Reset_1:
        LDRH     R0,[SP, #+0]
        LDRH     R1,[SP, #+0]
        LDR.N    R2,??DataTable6_1
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        LDRH     R1,[R2, R1, LSL #+1]
        LDR.N    R2,??DataTable6
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        STRH     R1,[R2, R0, LSL #+1]
//   64   }
        LDRH     R0,[SP, #+0]
        ADDS     R0,R0,#+1
        STRH     R0,[SP, #+0]
??Flash_Data_Reset_0:
        LDRH     R0,[SP, #+0]
        CMP      R0,#+16
        BLT.N    ??Flash_Data_Reset_1
//   65   Flash_Write(0);
        MOVS     R0,#+0
        BL       Flash_Write
//   66 }
        POP      {R0,PC}          ;; return
//   67 
//   68   // Init

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   69 void Flash_Init(void){
Flash_Init:
        PUSH     {R7,LR}
//   70   FMC->PFB0CR|=FMC_PFB0CR_S_B_INV_MASK;
        LDR.N    R0,??DataTable6_2  ;; 0x4001f004
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80000
        LDR.N    R1,??DataTable6_2  ;; 0x4001f004
        STR      R0,[R1, #+0]
//   71   FMC->PFB1CR|=FMC_PFB0CR_S_B_INV_MASK;
        LDR.N    R0,??DataTable6_3  ;; 0x4001f008
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80000
        LDR.N    R1,??DataTable6_3  ;; 0x4001f008
        STR      R0,[R1, #+0]
//   72   while(!(FTFL->FSTAT&FTFL_FSTAT_CCIF_MASK));
??Flash_Init_0:
        LDR.N    R0,??DataTable6_4  ;; 0x40020000
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Flash_Init_0
//   73   FTFL->FSTAT=FTFL_FSTAT_ACCERR_MASK|FTFL_FSTAT_FPVIOL_MASK;
        MOVS     R0,#+48
        LDR.N    R1,??DataTable6_4  ;; 0x40020000
        STRB     R0,[R1, #+0]
//   74   
//   75   // check data_flag
//   76   if(Flash_Read(0,0)!=1) Flash_Data_Reset();
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       Flash_Read
        CMP      R0,#+1
        BEQ.N    ??Flash_Init_1
        BL       Flash_Data_Reset
        B.N      ??Flash_Init_2
//   77   else Flash_Data_Update(0);
??Flash_Init_1:
        MOVS     R0,#+0
        BL       Flash_Data_Update
//   78 }
??Flash_Init_2:
        POP      {R0,PC}          ;; return
//   79 
//   80 
//   81 
//   82 // ======= Basic Drivers ======
//   83 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   84 U8 Flash_Erase(U16 num){
Flash_Erase:
        PUSH     {R0,LR}
        SUB      SP,SP,#+8
//   85   union{
//   86     U32 Word;
//   87     U8  Byte[4];
//   88   }FlashDestination;
//   89   FlashDestination.Word=ADDR+num*SECTOR_SIZE;
        LDRH     R0,[SP, #+8]
        MOV      R1,#+512
        MULS     R0,R1,R0
        ADDS     R0,R0,#+245760
        STR      R0,[SP, #+0]
//   90   FTFL->FCCOB0=FTFL_FCCOB0_CCOBn(ERSSCR);
        MOVS     R0,#+9
        LDR.N    R1,??DataTable6_5  ;; 0x40020007
        STRB     R0,[R1, #+0]
//   91   FTFL->FCCOB1=FlashDestination.Byte[2];
        LDRB     R0,[SP, #+2]
        LDR.N    R1,??DataTable6_6  ;; 0x40020006
        STRB     R0,[R1, #+0]
//   92   FTFL->FCCOB2=FlashDestination.Byte[1];
        LDRB     R0,[SP, #+1]
        LDR.N    R1,??DataTable6_7  ;; 0x40020005
        STRB     R0,[R1, #+0]
//   93   FTFL->FCCOB3=FlashDestination.Byte[0];
        LDRB     R0,[SP, #+0]
        LDR.N    R1,??DataTable6_8  ;; 0x40020004
        STRB     R0,[R1, #+0]
//   94   if(FlashCMD()==1){return 1;}//Error
        BL       FlashCMD
        CMP      R0,#+1
        BNE.N    ??Flash_Erase_0
        MOVS     R0,#+1
        B.N      ??Flash_Erase_1
//   95   return 0;//Success
??Flash_Erase_0:
        MOVS     R0,#+0
??Flash_Erase_1:
        POP      {R1-R3,PC}       ;; return
//   96 }
//   97 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   98 U8 Flash_Program(U16 num, U16 WriteCounter, U16 *DataSource){
Flash_Program:
        PUSH     {R0,R1,R4,LR}
        SUB      SP,SP,#+8
        MOVS     R4,R2
//   99   U32 size;
//  100   U32 destaddr;
//  101   union{
//  102     U32 Word;
//  103     U8 Byte[4];
//  104   }FlashDestination; 
//  105   FTFL->FCCOB0=PGM4;
        MOVS     R0,#+6
        LDR.N    R1,??DataTable6_5  ;; 0x40020007
        STRB     R0,[R1, #+0]
//  106   destaddr=(ADDR+num*SECTOR_SIZE);
        LDRH     R0,[SP, #+8]
        MOV      R1,#+512
        MULS     R0,R1,R0
        ADDS     R0,R0,#+245760
        STR      R0,[SP, #+0]
//  107   FlashDestination.Word=destaddr;
        LDR      R0,[SP, #+0]
        STR      R0,[SP, #+4]
//  108   for(size=0;size<WriteCounter;size+=2,FlashDestination.Word+=4,DataSource+=2){
        MOVS     R0,#+0
        STR      R0,[SP, #+0]
        B.N      ??Flash_Program_0
??Flash_Program_1:
        LDR      R0,[SP, #+0]
        ADDS     R0,R0,#+2
        STR      R0,[SP, #+0]
        LDR      R0,[SP, #+4]
        ADDS     R0,R0,#+4
        STR      R0,[SP, #+4]
        ADDS     R4,R4,#+4
??Flash_Program_0:
        LDR      R0,[SP, #+0]
        LDRH     R1,[SP, #+12]
        CMP      R0,R1
        BCS.N    ??Flash_Program_2
//  109     FTFL->FCCOB1=FlashDestination.Byte[2];
        LDRB     R0,[SP, #+6]
        LDR.N    R1,??DataTable6_6  ;; 0x40020006
        STRB     R0,[R1, #+0]
//  110     FTFL->FCCOB2=FlashDestination.Byte[1];
        LDRB     R0,[SP, #+5]
        LDR.N    R1,??DataTable6_7  ;; 0x40020005
        STRB     R0,[R1, #+0]
//  111     FTFL->FCCOB3=FlashDestination.Byte[0];
        LDRB     R0,[SP, #+4]
        LDR.N    R1,??DataTable6_8  ;; 0x40020004
        STRB     R0,[R1, #+0]
//  112     FTFL->FCCOB4=DataSource[1]>>8;
        LDRH     R0,[R4, #+2]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LSRS     R0,R0,#+8
        LDR.N    R1,??DataTable6_9  ;; 0x4002000b
        STRB     R0,[R1, #+0]
//  113     FTFL->FCCOB5=DataSource[1]&0xFF;
        LDRH     R0,[R4, #+2]
        LDR.N    R1,??DataTable6_10  ;; 0x4002000a
        STRB     R0,[R1, #+0]
//  114     FTFL->FCCOB6=DataSource[0]>>8;
        LDRH     R0,[R4, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LSRS     R0,R0,#+8
        LDR.N    R1,??DataTable6_11  ;; 0x40020009
        STRB     R0,[R1, #+0]
//  115     FTFL->FCCOB7=DataSource[0]&0xFF;    
        LDRH     R0,[R4, #+0]
        LDR.N    R1,??DataTable6_12  ;; 0x40020008
        STRB     R0,[R1, #+0]
//  116     if(FlashCMD()==1)return 2;
        BL       FlashCMD
        CMP      R0,#+1
        BNE.N    ??Flash_Program_1
        MOVS     R0,#+2
        B.N      ??Flash_Program_3
//  117   }
//  118   return 0;
??Flash_Program_2:
        MOVS     R0,#+0
??Flash_Program_3:
        ADD      SP,SP,#+16
        POP      {R4,PC}          ;; return
//  119 }
//  120 
//  121 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  122 static U8 FlashCMD(void){
//  123   FTFL->FSTAT=FTFL_FSTAT_ACCERR_MASK|FTFL_FSTAT_FPVIOL_MASK;
FlashCMD:
        MOVS     R0,#+48
        LDR.N    R1,??DataTable6_4  ;; 0x40020000
        STRB     R0,[R1, #+0]
//  124   FTFL->FSTAT=FTFL_FSTAT_CCIF_MASK;
        MOVS     R0,#+128
        LDR.N    R1,??DataTable6_4  ;; 0x40020000
        STRB     R0,[R1, #+0]
//  125   while(!(FTFL->FSTAT&FTFL_FSTAT_CCIF_MASK));
??FlashCMD_0:
        LDR.N    R0,??DataTable6_4  ;; 0x40020000
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??FlashCMD_0
//  126   if(FTFL->FSTAT&(FTFL_FSTAT_ACCERR_MASK|FTFL_FSTAT_FPVIOL_MASK|FTFL_FSTAT_MGSTAT0_MASK)){return 1;}//Failed
        LDR.N    R0,??DataTable6_4  ;; 0x40020000
        LDRB     R0,[R0, #+0]
        MOVS     R1,#+49
        TST      R0,R1
        BEQ.N    ??FlashCMD_1
        MOVS     R0,#+1
        B.N      ??FlashCMD_2
//  127   return 0;//Success
??FlashCMD_1:
        MOVS     R0,#+0
??FlashCMD_2:
        BX       LR               ;; return
//  128 }

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6:
        DC32     `data`

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_1:
        DC32     data_initial

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_2:
        DC32     0x4001f004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_3:
        DC32     0x4001f008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_4:
        DC32     0x40020000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_5:
        DC32     0x40020007

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_6:
        DC32     0x40020006

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_7:
        DC32     0x40020005

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_8:
        DC32     0x40020004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_9:
        DC32     0x4002000b

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_10:
        DC32     0x4002000a

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_11:
        DC32     0x40020009

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_12:
        DC32     0x40020008

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
//  32 bytes in section .bss
//  32 bytes in section .data
// 556 bytes in section .text
// 
// 556 bytes of CODE memory
//  64 bytes of DATA memory
//
//Errors: none
//Warnings: 4
