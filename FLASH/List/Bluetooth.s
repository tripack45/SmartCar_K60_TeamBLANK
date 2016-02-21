///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       21/Feb/2016  03:11:36
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\Bluetooth.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\Bluetooth.c -lCN
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
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\Bluetooth.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN Oled_Clear
        EXTERN Oled_Putstr
        EXTERN UART_SendChar
        EXTERN UART_SendDataChunk

        PUBLIC Bluetooth_Configure
        PUBLIC Bluetooth_IsSendDataChunkComplete
        PUBLIC Bluetooth_SendDataChunkAsync
        PUBLIC Bluetooth_SendDataChunkObselete
        PUBLIC Bluetooth_SendDataChunkSync
        PUBLIC Bluetooth_SendStr

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\Bluetooth.c
//    1 #include "includes.h"
//    2 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//    3 void Bluetooth_Configure(){
Bluetooth_Configure:
        PUSH     {R7,LR}
//    4   Oled_Clear();
        BL       Oled_Clear
//    5   Oled_Putstr(1,0,"Bluetooth Configure!");
        LDR.N    R2,??DataTable3
        MOVS     R1,#+0
        MOVS     R0,#+1
        BL       Oled_Putstr
//    6   Oled_Putstr(6,0,"Press Key1 to Cont.");
        LDR.N    R2,??DataTable3_1
        MOVS     R1,#+0
        MOVS     R0,#+6
        BL       Oled_Putstr
//    7   while(Key1());while(!Key1());
??Bluetooth_Configure_0:
        LDR.N    R0,??DataTable3_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BNE.N    ??Bluetooth_Configure_0
??Bluetooth_Configure_1:
        LDR.N    R0,??DataTable3_2  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+1
        CMP      R0,#+0
        BEQ.N    ??Bluetooth_Configure_1
//    8   Oled_Clear();
        BL       Oled_Clear
//    9   Oled_Putstr(1,0,"Sending T");
        LDR.N    R2,??DataTable3_3
        MOVS     R1,#+0
        MOVS     R0,#+1
        BL       Oled_Putstr
//   10   //for(;;)Bluetooth_WriteStr("Test");
//   11   Oled_Clear();
        BL       Oled_Clear
//   12 }
        POP      {R0,PC}          ;; return
//   13 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   14 void Bluetooth_SendDataChunkSync(uint8* chunk_ptr, uint16 size){
Bluetooth_SendDataChunkSync:
        PUSH     {R7,LR}
//   15     UART_SendDataChunk(chunk_ptr,size);
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        BL       UART_SendDataChunk
//   16     while(!(IS_UART_DMA_COMPLETE() && IS_UART_SEND_COMPLETE()));
??Bluetooth_SendDataChunkSync_0:
        LDR.N    R0,??DataTable3_4  ;; 0x4000903c
        LDRH     R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Bluetooth_SendDataChunkSync_0
        LDR.N    R0,??DataTable3_5  ;; 0x4006d004
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+25
        BPL.N    ??Bluetooth_SendDataChunkSync_0
//   17     
//   18 }
        POP      {R0,PC}          ;; return
//   19 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   20 void Bluetooth_SendDataChunkAsync(uint8* chunk_ptr, uint16 size){
Bluetooth_SendDataChunkAsync:
        PUSH     {R7,LR}
//   21     UART_SendDataChunk(chunk_ptr, (uint16)size);
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        BL       UART_SendDataChunk
//   22 }
        POP      {R0,PC}          ;; return
//   23 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   24 int Bluetooth_IsSendDataChunkComplete(){
//   25   return IS_UART_DMA_COMPLETE() && IS_UART_SEND_COMPLETE();
Bluetooth_IsSendDataChunkComplete:
        LDR.N    R0,??DataTable3_4  ;; 0x4000903c
        LDRH     R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??Bluetooth_IsSendDataChunkComplete_0
        LDR.N    R0,??DataTable3_5  ;; 0x4006d004
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0x40
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LSRS     R0,R0,#+6
        B.N      ??Bluetooth_IsSendDataChunkComplete_1
??Bluetooth_IsSendDataChunkComplete_0:
        MOVS     R0,#+0
??Bluetooth_IsSendDataChunkComplete_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BX       LR               ;; return
//   26 }
//   27 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   28 void Bluetooth_SendDataChunkObselete(u8* chunk_ptr,uint16 size){
Bluetooth_SendDataChunkObselete:
        PUSH     {R4}
//   29   for(int i=0;i<size;i++){
        MOVS     R2,#+0
        B.N      ??Bluetooth_SendDataChunkObselete_0
//   30     while(!(UART3->S1 & UART_S1_TDRE_MASK));
??Bluetooth_SendDataChunkObselete_1:
        LDR.N    R3,??DataTable3_5  ;; 0x4006d004
        LDRB     R3,[R3, #+0]
        LSLS     R3,R3,#+24
        BPL.N    ??Bluetooth_SendDataChunkObselete_1
//   31     UART3->D = *chunk_ptr;
        LDRB     R3,[R0, #+0]
        LDR.N    R4,??DataTable3_6  ;; 0x4006d007
        STRB     R3,[R4, #+0]
//   32     chunk_ptr++;
        ADDS     R0,R0,#+1
//   33   }
        ADDS     R2,R2,#+1
??Bluetooth_SendDataChunkObselete_0:
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R2,R1
        BLT.N    ??Bluetooth_SendDataChunkObselete_1
//   34 }
        POP      {R4}
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3:
        DC32     ?_0

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_1:
        DC32     ?_1

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_2:
        DC32     0x400ff010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_3:
        DC32     ?_2

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_4:
        DC32     0x4000903c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_5:
        DC32     0x4006d004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_6:
        DC32     0x4006d007
//   35 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   36 void Bluetooth_SendStr(char* str){
Bluetooth_SendStr:
        PUSH     {R4,LR}
        MOVS     R4,R0
//   37   char* p=str;
        B.N      ??Bluetooth_SendStr_0
//   38   while(*p!='\0'){
//   39     UART_SendChar(*p);
??Bluetooth_SendStr_1:
        LDRB     R0,[R4, #+0]
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       UART_SendChar
//   40     p++;
        ADDS     R4,R4,#+1
//   41   }
??Bluetooth_SendStr_0:
        LDRSB    R0,[R4, #+0]
        CMP      R0,#+0
        BNE.N    ??Bluetooth_SendStr_1
//   42   UART_SendChar('\r');
        MOVS     R0,#+13
        BL       UART_SendChar
//   43   UART_SendChar('\n');
        MOVS     R0,#+10
        BL       UART_SendChar
//   44 }
        POP      {R4,PC}          ;; return

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
        DC8 "Bluetooth Configure!"
        DC8 0, 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_1:
        DATA
        DC8 "Press Key1 to Cont."

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
?_2:
        DATA
        DC8 "Sending T"
        DC8 0, 0

        END
//   45   
// 
//  56 bytes in section .rodata
// 234 bytes in section .text
// 
// 234 bytes of CODE  memory
//  56 bytes of CONST memory
//
//Errors: none
//Warnings: none
