///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       21/Feb/2016  03:11:38
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  E:\freescale_racing\SmartCar_K60_TeamBLANK\source\UART.c
//    Command line =  
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\source\UART.c -lCN
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
//        E:\freescale_racing\SmartCar_K60_TeamBLANK\FLASH\List\UART.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN DMA1_IRQHandler
        EXTERN LED2_Tog
        EXTERN g_bus_clock

        PUBLIC UART3_IRQHandler
        PUBLIC UART_Available
        PUBLIC UART_Configure_DMA
        PUBLIC UART_DMASend_Start
        PUBLIC UART_GetChar
        PUBLIC UART_Init
        PUBLIC UART_Pop
        PUBLIC UART_Push
        PUBLIC UART_SendChar
        PUBLIC UART_SendDataChunk
        PUBLIC UART_SetMode
        PUBLIC uart_bot_ptr
        PUBLIC uart_buffer
        PUBLIC uart_top_ptr

// E:\freescale_racing\SmartCar_K60_TeamBLANK\source\UART.c
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
        LDR.W    R2,??DataTable11  ;; 0xe000e100
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
        LDR.W    R2,??DataTable11_1  ;; 0xe000ed18
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        ANDS     R0,R0,#0xF
        ADDS     R0,R0,R2
        STRB     R1,[R0, #-4]
        B.N      ??NVIC_SetPriority_1
??NVIC_SetPriority_0:
        LSLS     R1,R1,#+4
        LDR.W    R2,??DataTable11_2  ;; 0xe000e400
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
//    8 /*
//    9 Adaptation Made By tripack
//   10 Implements UART_Buffer, ETC.
//   11 */
//   12 
//   13 #define UART_BUFFER_SIZE 64
//   14 #define PREC(ptr) ((ptr + UART_BUFFER_SIZE -1) % UART_BUFFER_SIZE)
//   15 #define SUCC(ptr) ((ptr + 1) % UART_BUFFER_SIZE)
//   16 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   17 uint8 uart_buffer[UART_BUFFER_SIZE]={0}; //FIFO QUEUE
uart_buffer:
        DS8 64

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   18 uint8 uart_top_ptr,uart_bot_ptr=0; //UART Buffer Pointer
uart_top_ptr:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
uart_bot_ptr:
        DS8 1
//   19 
//   20 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   21 void UART_Push(uint8 data){
//   22 
//   23   if(SUCC(uart_top_ptr)==uart_bot_ptr)
UART_Push:
        LDR.W    R1,??DataTable11_3
        LDRB     R1,[R1, #+0]
        ADDS     R1,R1,#+1
        MOVS     R2,#+64
        SDIV     R3,R1,R2
        MLS      R3,R3,R2,R1
        LDR.W    R1,??DataTable11_4
        LDRB     R1,[R1, #+0]
        CMP      R3,R1
        BEQ.N    ??UART_Push_0
//   24     return;
//   25   //The queue is already full!
//   26   //We Will Start Losing DATA!!
//   27   uart_top_ptr=SUCC(uart_top_ptr);
??UART_Push_1:
        LDR.N    R1,??DataTable11_3
        LDRB     R1,[R1, #+0]
        ADDS     R1,R1,#+1
        MOVS     R2,#+64
        SDIV     R3,R1,R2
        MLS      R3,R3,R2,R1
        LDR.N    R1,??DataTable11_3
        STRB     R3,[R1, #+0]
//   28   uart_buffer[uart_top_ptr]=data;
        LDR.N    R1,??DataTable11_5
        LDR.N    R2,??DataTable11_3
        LDRB     R2,[R2, #+0]
        STRB     R0,[R2, R1]
//   29 }
??UART_Push_0:
        BX       LR               ;; return
//   30 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   31 uint8 UART_Pop(uint8 data){//FIFO out the data
//   32   if(uart_top_ptr==uart_bot_ptr)
UART_Pop:
        LDR.N    R0,??DataTable11_3
        LDRB     R0,[R0, #+0]
        LDR.N    R1,??DataTable11_4
        LDRB     R1,[R1, #+0]
        CMP      R0,R1
        BNE.N    ??UART_Pop_0
//   33     return 0;
        MOVS     R0,#+0
        B.N      ??UART_Pop_1
//   34   uart_bot_ptr=SUCC(uart_bot_ptr);
??UART_Pop_0:
        LDR.N    R0,??DataTable11_4
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        MOVS     R1,#+64
        SDIV     R2,R0,R1
        MLS      R2,R2,R1,R0
        LDR.N    R0,??DataTable11_4
        STRB     R2,[R0, #+0]
//   35   return uart_buffer[uart_bot_ptr];
        LDR.N    R0,??DataTable11_5
        LDR.N    R1,??DataTable11_4
        LDRB     R1,[R1, #+0]
        LDRB     R0,[R1, R0]
??UART_Pop_1:
        BX       LR               ;; return
//   36 }
//   37 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   38 uint8 UART_Available(){
//   39   //Check if the queue is empty
//   40   //If not empty, return the number of remaining terms
//   41   return uart_top_ptr-uart_bot_ptr;
UART_Available:
        LDR.N    R0,??DataTable11_3
        LDRB     R0,[R0, #+0]
        LDR.N    R1,??DataTable11_4
        LDRB     R1,[R1, #+0]
        SUBS     R0,R0,R1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BX       LR               ;; return
//   42 }
//   43   
//   44   
//   45 
//   46 // === Receive ISR ===

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   47 void UART3_IRQHandler(void){
UART3_IRQHandler:
        PUSH     {R7,LR}
//   48   uint8 tmp = UART_GetChar();
        BL       UART_GetChar
//   49   UART_Push(tmp);
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       UART_Push
//   50   LED2_Tog();
        BL       LED2_Tog
//   51   return;
        POP      {R0,PC}          ;; return
//   52 }
//   53 
//   54 
//   55 // ----- Basic Functions -----
//   56 
//   57 // Read 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   58 int8 UART_GetChar(){
//   59   while(!(UART3->S1 & UART_S1_RDRF_MASK));
UART_GetChar:
??UART_GetChar_0:
        LDR.N    R0,??DataTable11_6  ;; 0x4006d004
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+26
        BPL.N    ??UART_GetChar_0
//   60   return UART3->D;
        LDR.N    R0,??DataTable11_7  ;; 0x4006d007
        LDRSB    R0,[R0, #+0]
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        BX       LR               ;; return
//   61 }
//   62 
//   63 // Send

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   64 void UART_SendChar(uint8 data){
//   65   while(!(UART3->S1 & UART_S1_TDRE_MASK));
UART_SendChar:
??UART_SendChar_0:
        LDR.N    R1,??DataTable11_6  ;; 0x4006d004
        LDRB     R1,[R1, #+0]
        LSLS     R1,R1,#+24
        BPL.N    ??UART_SendChar_0
//   66   UART3->D = data;
        LDR.N    R1,??DataTable11_7  ;; 0x4006d007
        STRB     R0,[R1, #+0]
//   67 }
        BX       LR               ;; return
//   68 
//   69 // Init

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   70 void UART_Init(u32 baud){
UART_Init:
        PUSH     {R4,LR}
//   71   //UART3
//   72   
//   73   uint16 sbr;
//   74   uint32 busclock = g_bus_clock;
        LDR.N    R1,??DataTable11_8
        LDR      R1,[R1, #+0]
//   75 
//   76   SIM->SCGC4 |= SIM_SCGC4_UART3_MASK;
        LDR.N    R2,??DataTable11_9  ;; 0x40048034
        LDR      R2,[R2, #+0]
        ORRS     R2,R2,#0x2000
        LDR.N    R3,??DataTable11_9  ;; 0x40048034
        STR      R2,[R3, #+0]
//   77   
//   78   PORTE->PCR[4] = PORT_PCR_MUX(3);
        MOV      R2,#+768
        LDR.N    R3,??DataTable11_10  ;; 0x4004d010
        STR      R2,[R3, #+0]
//   79   PORTE->PCR[5] = PORT_PCR_MUX(3);
        MOV      R2,#+768
        LDR.N    R3,??DataTable11_11  ;; 0x4004d014
        STR      R2,[R3, #+0]
//   80   UART3->C2 &= ~(UART_C2_TE_MASK | UART_C2_RE_MASK );  // DISABLE UART FIRST
        LDR.N    R2,??DataTable11_12  ;; 0x4006d003
        LDRB     R2,[R2, #+0]
        ANDS     R2,R2,#0xF3
        LDR.N    R3,??DataTable11_12  ;; 0x4006d003
        STRB     R2,[R3, #+0]
//   81   UART3->C1 = 0;  // NONE PARITY CHECK
        MOVS     R2,#+0
        LDR.N    R3,??DataTable11_13  ;; 0x4006d002
        STRB     R2,[R3, #+0]
//   82   
//   83   //UART baud rate = UART module clock / (16 ¡Á (SBR[12:0] + BRFD))
//   84   // BRFD = BRFA/32; fraction
//   85   sbr = (uint16)(busclock/(16*baud));
        LSLS     R2,R0,#+4
        UDIV     R2,R1,R2
//   86   UART3->BDH = (UART3->BDH & 0XC0)|(uint8)((sbr & 0X1F00)>>8);
        LDR.N    R3,??DataTable11_14  ;; 0x4006d000
        LDRB     R3,[R3, #+0]
        ANDS     R3,R3,#0xC0
        UXTH     R2,R2            ;; ZeroExt  R2,R2,#+16,#+16
        ASRS     R4,R2,#+8
        ANDS     R4,R4,#0x1F
        ORRS     R3,R4,R3
        LDR.N    R4,??DataTable11_14  ;; 0x4006d000
        STRB     R3,[R4, #+0]
//   87   UART3->BDL = (uint8)(sbr & 0XFF);
        LDR.N    R3,??DataTable11_15  ;; 0x4006d001
        STRB     R2,[R3, #+0]
//   88   
//   89   UART3->C4 = (UART3->C4 & 0XE0)|(uint8)((32*busclock)/(16*baud)-sbr*32); 
        LDR.N    R3,??DataTable11_16  ;; 0x4006d00a
        LDRB     R3,[R3, #+0]
        ANDS     R3,R3,#0xE0
        LSLS     R1,R1,#+5
        LSLS     R0,R0,#+4
        UDIV     R0,R1,R0
        UXTH     R2,R2            ;; ZeroExt  R2,R2,#+16,#+16
        LSLS     R1,R2,#+5
        SUBS     R0,R0,R1
        ORRS     R0,R0,R3
        LDR.N    R1,??DataTable11_16  ;; 0x4006d00a
        STRB     R0,[R1, #+0]
//   90 
//   91   UART3->C2 |=  UART_C2_RIE_MASK;
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x20
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//   92   
//   93   UART3->C2 |= UART_C2_RE_MASK;
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//   94   
//   95   UART3->C2 |= UART_C2_TE_MASK; 
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//   96   
//   97   UART3->C2 &= ~UART_C2_TCIE_MASK; //Disable IRQ request
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xBF
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//   98    
//   99   NVIC_EnableIRQ(UART3_RX_TX_IRQn); 
        MOVS     R0,#+51
        BL       NVIC_EnableIRQ
//  100   NVIC_SetPriority(UART3_RX_TX_IRQn, NVIC_EncodePriority(NVIC_GROUP, 2, 2));
        MOVS     R2,#+2
        MOVS     R1,#+2
        MOVS     R0,#+5
        BL       NVIC_EncodePriority
        MOVS     R1,R0
        MOVS     R0,#+51
        BL       NVIC_SetPriority
//  101 }
        POP      {R4,PC}          ;; return
//  102   

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  103 void UART_DMASend_Start(){
//  104   DMA0->TCD[1].CSR &= ~DMA_CSR_DONE_MASK; //Clear
UART_DMASend_Start:
        LDR.N    R0,??DataTable11_17  ;; 0x4000903c
        LDRH     R0,[R0, #+0]
        MOVW     R1,#+65407
        ANDS     R0,R1,R0
        LDR.N    R1,??DataTable11_17  ;; 0x4000903c
        STRH     R0,[R1, #+0]
//  105   //DMA0->TCD[1].CSR = DMA_CSR_DREQ_MASK | DMA_CSR_INTMAJOR_MASK;//Auto Clear
//  106   //DMA0->TCD[1].CSR |= DMA_CSR_START_MASK; //Start
//  107   DMA0->ERQ |= DMA_ERQ_ERQ1_MASK ; //Sets off the transmission
        LDR.N    R0,??DataTable11_18  ;; 0x4000800c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable11_18  ;; 0x4000800c
        STR      R0,[R1, #+0]
//  108 }
        BX       LR               ;; return
//  109 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  110 void UART_SendDataChunk(u8* dataptr,uint16 size){
UART_SendDataChunk:
        PUSH     {R7,LR}
//  111   DMA0->TCD[1].SADDR = (uint32_t)dataptr;
        LDR.N    R2,??DataTable11_19  ;; 0x40009020
        STR      R0,[R2, #+0]
//  112   DMA0->TCD[1].CITER_ELINKNO = DMA_CITER_ELINKNO_CITER(size);
        LSLS     R0,R1,#+17       ;; ZeroExtS R0,R1,#+17,#+17
        LSRS     R0,R0,#+17
        LDR.N    R2,??DataTable11_20  ;; 0x40009036
        STRH     R0,[R2, #+0]
//  113   DMA0->TCD[1].BITER_ELINKNO = DMA_BITER_ELINKNO_BITER(size);
        LSLS     R0,R1,#+17       ;; ZeroExtS R0,R1,#+17,#+17
        LSRS     R0,R0,#+17
        LDR.N    R1,??DataTable11_21  ;; 0x4000903e
        STRH     R0,[R1, #+0]
//  114   UART_DMASend_Start();
        BL       UART_DMASend_Start
//  115 }
        POP      {R0,PC}          ;; return
//  116 
//  117 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  118 void UART_Configure_DMA(){
UART_Configure_DMA:
        PUSH     {R7,LR}
//  119   SIM->SCGC6 |= SIM_SCGC6_DMAMUX_MASK; //DMAMUX Clock Enable
        LDR.N    R0,??DataTable11_22  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable11_22  ;; 0x4004803c
        STR      R0,[R1, #+0]
//  120   SIM->SCGC7 |= SIM_SCGC7_DMA_MASK; //DMA Clock Enable
        LDR.N    R0,??DataTable11_23  ;; 0x40048040
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable11_23  ;; 0x40048040
        STR      R0,[R1, #+0]
//  121   
//  122   DMAMUX->CHCFG[1] |= DMAMUX_CHCFG_SOURCE(9); //RAM->UART3_Transmitting, request UART3
        LDR.N    R0,??DataTable11_24  ;; 0x40021001
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x9
        LDR.N    R1,??DataTable11_24  ;; 0x40021001
        STRB     R0,[R1, #+0]
//  123   
//  124   DMA0->DCHPRI1 = DMA_DCHPRI1_CHPRI(0) | DMA_DCHPRI1_ECP_MASK; //This DMA Can be suspended by other DMAs
        MOVS     R0,#+128
        LDR.N    R1,??DataTable11_25  ;; 0x40008102
        STRB     R0,[R1, #+0]
//  125   
//  126   DMA0->TCD[1].CSR = 0x00000000; //Clear
        MOVS     R0,#+0
        LDR.N    R1,??DataTable11_17  ;; 0x4000903c
        STRH     R0,[R1, #+0]
//  127   DMA0->TCD[1].CSR = DMA_CSR_DREQ_MASK | DMA_CSR_INTMAJOR_MASK; //Auto Clear
        MOVS     R0,#+10
        LDR.N    R1,??DataTable11_17  ;; 0x4000903c
        STRH     R0,[R1, #+0]
//  128   //DMA0->TCD[1].CSR &= ~DMA_CSR_INTMAJOR_MASK; //Disable Major Loop Int
//  129   
//  130   DMA0->TCD[1].ATTR = DMA_ATTR_SSIZE(0) | DMA_ATTR_DSIZE(0); //Source 8 bits, Aim 8 bits
        MOVS     R0,#+0
        LDR.N    R1,??DataTable11_26  ;; 0x40009026
        STRH     R0,[R1, #+0]
//  131   DMA0->TCD[1].NBYTES_MLNO = DMA_NBYTES_MLNO_NBYTES(1); //one byte each
        MOVS     R0,#+1
        LDR.N    R1,??DataTable11_27  ;; 0x40009028
        STR      R0,[R1, #+0]
//  132   
//  133   //DMA0->TCD[0].SADDR = (uint32_t)0; //Source Remains to Be put in!
//  134   DMA0->TCD[1].SOFF = 1; //Source moving
        MOVS     R0,#+1
        LDR.N    R1,??DataTable11_28  ;; 0x40009024
        STRH     R0,[R1, #+0]
//  135   DMA0->TCD[1].SLAST = 0; //Last Source fixed
        MOVS     R0,#+0
        LDR.N    R1,??DataTable11_29  ;; 0x4000902c
        STR      R0,[R1, #+0]
//  136   
//  137   DMA0->TCD[1].DADDR = (uint32_t)&UART3->D; //Destination 
        LDR.N    R0,??DataTable11_7  ;; 0x4006d007
        LDR.N    R1,??DataTable11_30  ;; 0x40009030
        STR      R0,[R1, #+0]
//  138   DMA0->TCD[1].DOFF = 0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable11_31  ;; 0x40009034
        STRH     R0,[R1, #+0]
//  139   DMA0->TCD[1].DLAST_SGA = 0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable11_32  ;; 0x40009038
        STR      R0,[R1, #+0]
//  140   
//  141   NVIC_EnableIRQ(DMA1_IRQn);
        MOVS     R0,#+1
        BL       NVIC_EnableIRQ
//  142   NVIC_SetPriority(DMA1_IRQn, NVIC_EncodePriority(NVIC_GROUP, 2, 1));
        MOVS     R2,#+1
        MOVS     R1,#+2
        MOVS     R0,#+5
        BL       NVIC_EncodePriority
        MOVS     R1,R0
        MOVS     R0,#+1
        BL       NVIC_SetPriority
//  143   DMA0->INT |= DMA_INT_INT1_MASK; //Open Interrupt
        LDR.N    R0,??DataTable11_33  ;; 0x40008024
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable11_33  ;; 0x40008024
        STR      R0,[R1, #+0]
//  144   //DMA0->TCD[0].CITER_ELINKNO = DMA_CITER_ELINKNO_CITER(1);
//  145   //DMA0->TCD[0].BITER_ELINKNO = DMA_BITER_ELINKNO_BITER(1);
//  146   
//  147   //DMA->ERQ&=~DMA_ERQ_ERQ0_MASK;//Clear Disable
//  148   DMAMUX->CHCFG[1] |= DMAMUX_CHCFG_ENBL_MASK; //Enable
        LDR.N    R0,??DataTable11_24  ;; 0x40021001
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable11_24  ;; 0x40021001
        STRB     R0,[R1, #+0]
//  149   
//  150 }
        POP      {R0,PC}          ;; return
//  151 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  152 void UART_SetMode(uint8 mode){
UART_SetMode:
        PUSH     {R7,LR}
//  153   switch(mode){
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+1
        BEQ.N    ??UART_SetMode_0
        BCC.N    ??UART_SetMode_1
        CMP      R0,#+3
        BEQ.N    ??UART_SetMode_2
        BCC.N    ??UART_SetMode_3
        B.N      ??UART_SetMode_1
//  154   case UART_MODE_DMA_MANNUAL:
//  155     UART3->C2 &= ~UART_C2_TE_MASK; //Disable Transmission
??UART_SetMode_0:
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xF7
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  156       UART3->C2 &= ~UART_C2_TCIE_MASK; //Disable IRQ request
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xBF
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  157       UART3->C5 |= UART_C5_TDMAS_MASK; //Enable DMA request
        LDR.N    R0,??DataTable11_34  ;; 0x4006d00b
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable11_34  ;; 0x4006d00b
        STRB     R0,[R1, #+0]
//  158       UART3->C2 |= UART_C2_TIE_MASK; //Enable UART to send IRQ or DMA request
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  159       DMA0->TCD[1].CSR = DMA_CSR_DREQ_MASK; //Reset DMA_Control-Status-Register
        MOVS     R0,#+8
        LDR.N    R1,??DataTable11_17  ;; 0x4000903c
        STRH     R0,[R1, #+0]
//  160     UART3->C2 |= UART_C2_TE_MASK; //Enables Transmission
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  161     break;
        B.N      ??UART_SetMode_1
//  162   case UART_MODE_DMA_CONTINUOUS:
//  163     UART3->C2 &= ~UART_C2_TE_MASK; //Disable Transmission
??UART_SetMode_2:
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xF7
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  164       UART3->C2 &= ~UART_C2_TCIE_MASK; //Disable IRQ request
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xBF
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  165       UART3->C5 |= UART_C5_TDMAS_MASK; //Enable DMA request
        LDR.N    R0,??DataTable11_34  ;; 0x4006d00b
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable11_34  ;; 0x4006d00b
        STRB     R0,[R1, #+0]
//  166       UART3->C2 |= UART_C2_TIE_MASK; //Enable UART to send IRQ or DMA request
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  167       DMA0->TCD[1].CSR = DMA_CSR_DREQ_MASK | DMA_CSR_INTMAJOR_MASK;
        MOVS     R0,#+10
        LDR.N    R1,??DataTable11_17  ;; 0x4000903c
        STRH     R0,[R1, #+0]
//  168       //Reset DMA_Control-Status-Register, Enable Major-Loop-Interupt
//  169     UART3->C2 |= UART_C2_TE_MASK; //Enables Transmission
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  170     DMA1_IRQHandler();
        BL       DMA1_IRQHandler
//  171     break;
        B.N      ??UART_SetMode_1
//  172   case UART_MODE_MANNUAL:
//  173     UART3->C2 &= ~UART_C2_TE_MASK; //Disable Transmission
??UART_SetMode_3:
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xF7
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  174       UART3->C2 &= ~UART_C2_TCIE_MASK; //Disable IRQ request
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xBF
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  175       UART3->C2 &= ~UART_C2_TIE_MASK; //Disable UART to send IRQ or DMA request
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0x7F
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  176       UART3->C5 &= ~UART_C5_TDMAS_MASK; //Enable DMA request
        LDR.N    R0,??DataTable11_34  ;; 0x4006d00b
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0x7F
        LDR.N    R1,??DataTable11_34  ;; 0x4006d00b
        STRB     R0,[R1, #+0]
//  177       //Reset DMA_Control-Status-Register, Enable Major-Loop-Interupt
//  178     UART3->C2 |= UART_C2_TE_MASK; //Enables Transmission
        LDR.N    R0,??DataTable11_12  ;; 0x4006d003
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable11_12  ;; 0x4006d003
        STRB     R0,[R1, #+0]
//  179     break;    
//  180   }
//  181 }
??UART_SetMode_1:
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11:
        DC32     0xe000e100

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_1:
        DC32     0xe000ed18

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_2:
        DC32     0xe000e400

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_3:
        DC32     uart_top_ptr

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_4:
        DC32     uart_bot_ptr

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_5:
        DC32     uart_buffer

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_6:
        DC32     0x4006d004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_7:
        DC32     0x4006d007

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_8:
        DC32     g_bus_clock

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_9:
        DC32     0x40048034

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_10:
        DC32     0x4004d010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_11:
        DC32     0x4004d014

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_12:
        DC32     0x4006d003

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_13:
        DC32     0x4006d002

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_14:
        DC32     0x4006d000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_15:
        DC32     0x4006d001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_16:
        DC32     0x4006d00a

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_17:
        DC32     0x4000903c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_18:
        DC32     0x4000800c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_19:
        DC32     0x40009020

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_20:
        DC32     0x40009036

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_21:
        DC32     0x4000903e

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_22:
        DC32     0x4004803c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_23:
        DC32     0x40048040

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_24:
        DC32     0x40021001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_25:
        DC32     0x40008102

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_26:
        DC32     0x40009026

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_27:
        DC32     0x40009028

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_28:
        DC32     0x40009024

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_29:
        DC32     0x4000902c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_30:
        DC32     0x40009030

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_31:
        DC32     0x40009034

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_32:
        DC32     0x40009038

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_33:
        DC32     0x40008024

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_34:
        DC32     0x4006d00b

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//  182     
// 
//    66 bytes in section .bss
// 1 040 bytes in section .text
// 
// 1 040 bytes of CODE memory
//    66 bytes of DATA memory
//
//Errors: none
//Warnings: 1
