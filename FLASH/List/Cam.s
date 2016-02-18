///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       18/Feb/2016  00:48:05
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  E:\freescale_racing\framework2016\source\Cam.c
//    Command line =  
//        E:\freescale_racing\framework2016\source\Cam.c -lCN
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
//    List file    =  E:\freescale_racing\framework2016\FLASH\List\Cam.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN Bluetooth_SendDataChunkAsync
        EXTERN LED1_Tog
        EXTERN LED2_Tog
        EXTERN debug_num
        EXTERN e_debug_num
        EXTERN g_bus_clock
        EXTERN tclk

        PUBLIC Cam_Algorithm
        PUBLIC Cam_Init
        PUBLIC DMA0_IRQHandler
        PUBLIC DMA1_IRQHandler
        PUBLIC LockState
        PUBLIC PORTC_IRQHandler
        PUBLIC buffer_ptr
        PUBLIC cam_buffer0
        PUBLIC cam_buffer1
        PUBLIC cam_buffer2
        PUBLIC cam_buffer3
        PUBLIC cam_row
        PUBLIC current_frame_indicator
        PUBLIC img_buffer
        PUBLIC img_row
        PUBLIC last_frame_indicator
        PUBLIC last_processed_frame
        PUBLIC last_sent_frame
        PUBLIC load_diff
        PUBLIC loading_buffer
        PUBLIC loading_frame
        PUBLIC process_diff
        PUBLIC processing_frame
        PUBLIC processing_frame_indicator
        PUBLIC send_diff
        PUBLIC sending_buffer
        PUBLIC sending_frame
        PUBLIC sending_frame_indicator

// E:\freescale_racing\framework2016\source\Cam.c
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
        LDR.W    R2,??DataTable6  ;; 0xe000e100
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
        LDR.W    R2,??DataTable6_1  ;; 0xe000ed18
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        ANDS     R0,R0,#0xF
        ADDS     R0,R0,R2
        STRB     R1,[R0, #-4]
        B.N      ??NVIC_SetPriority_1
??NVIC_SetPriority_0:
        LSLS     R1,R1,#+4
        LDR.W    R2,??DataTable6_2  ;; 0xe000e400
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
//    8 #define SIG_SIZE 3
//    9 
//   10 #define VALID_COLS IMG_COLS
//   11 
//   12 // ====== Variables ======
//   13 
//   14 // ---- Local ----

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   15 u8 cam_row = 0, img_row = 0;
cam_row:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
img_row:
        DS8 1
//   16 
//   17 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   18 u8 cam_buffer0[ IMG_ROWS * IMG_COLS + 2 * SIG_SIZE ];
cam_buffer0:
        DS8 7508

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   19 u8 cam_buffer1[ IMG_ROWS * IMG_COLS + 2 * SIG_SIZE ];
cam_buffer1:
        DS8 7508

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   20 u8 cam_buffer2[ IMG_ROWS * IMG_COLS + 2 * SIG_SIZE ];
cam_buffer2:
        DS8 7508

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   21 u8 cam_buffer3[ IMG_ROWS * IMG_COLS + 2 * SIG_SIZE ];
cam_buffer3:
        DS8 7508
//   22 

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   23 u8* buffer_ptr[4]={ cam_buffer0+SIG_SIZE, cam_buffer1+SIG_SIZE,
buffer_ptr:
        DATA
        DC32 cam_buffer0 + 3H, cam_buffer1 + 3H, cam_buffer2 + 3H
        DC32 cam_buffer3 + 3H
//   24                     cam_buffer2+SIG_SIZE, cam_buffer3+SIG_SIZE };
//   25 
//   26 // ---- Global ----

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   27 int processing_frame; //Currently processing frame
processing_frame:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   28 int loading_frame; //Currently loading frame
loading_frame:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   29 int sending_frame; //Currently sending frame
sending_frame:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   30 int last_processed_frame, last_sent_frame;
last_processed_frame:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
last_sent_frame:
        DS8 4
//   31 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   32 int process_diff,load_diff,send_diff;
process_diff:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
load_diff:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
send_diff:
        DS8 4
//   33 

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   34 u8  *sending_buffer=(void*)(cam_buffer3+SIG_SIZE);
sending_buffer:
        DATA
        DC32 cam_buffer3 + 3H

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   35 u8  (*loading_buffer)[IMG_COLS]=(void*)(cam_buffer0+SIG_SIZE);
loading_buffer:
        DATA
        DC32 cam_buffer0 + 3H

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   36 u8  (*img_buffer)[IMG_COLS]=(void*)(cam_buffer0+SIG_SIZE); 
img_buffer:
        DATA
        DC32 cam_buffer0 + 3H
//   37 

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   38 u8 current_frame_indicator=0; //Indicates buffer being loaded
current_frame_indicator:
        DS8 1

        SECTION `.data`:DATA:REORDER:NOROOT(0)
//   39 u8 last_frame_indicator=3;    //Indicates last loaded buffer
last_frame_indicator:
        DATA
        DC8 3

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   40 u8 processing_frame_indicator=0;//frame_currently being processed
processing_frame_indicator:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   41 u8 sending_frame_indicator=0;//frame_currently being processed
sending_frame_indicator:
        DS8 1
//   42 
//   43 
//   44 //===========================LOCKING MACHANISM=================
//   45 /*Here implements locking mechanism.
//   46 There are 3 types of locks:
//   47 ProcessLock, SendLock, LastFrameLock
//   48 They are implemented in a bit wise number LockState:
//   49 LockState: 0000  0000   0000   0000
//   50 NONE   PLock  SLock LFLock
//   51 WARNING: 
//   52 No access(Read/Write) is allowed after releasing the lock!
//   53 Illegal access will not be stopped but will result in 
//   54 undefined behavior! 
//   55 */
//   56 
//   57 #define PLOCK_BASE 8
//   58 #define SLOCK_BASE 4
//   59 #define LFLOCK_BASE 0
//   60 #define LOCK_MASK(base,x) (1 << (base + x) )
//   61 #define IS_LOCK_TYPE(base,x) (LockState & LOCK_MASK(base,x) )
//   62 #define IS_LOCK(x) (LockState &(  LOCK_MASK(PLOCK_BASE, x) \ 
//   63                                 | LOCK_MASK(SLOCK_BASE, x) \ 
//   64                                 | LOCK_MASK(LFLOCK_BASE,x) ))
//   65 #define GET_FREE_LOCK() (IS_LOCK(0) ? ( \ 
//   66                             IS_LOCK(1) ? (\ 
//   67                               ( IS_LOCK(2) ?  3 : 2 ) \ 
//   68                             ) : 1 \ 
//   69                        ) : 0 )
//   70 #define SET_LOCK(base, x) LockState |= LOCK_MASK(base, x)
//   71 #define CLEAR_LOCK(base) LockState &= ~( 0x0f <<base );
//   72 #define CLEAR_ALL_LOCK() LockState = 0;

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   73 U32 LockState=LOCK_MASK(PLOCK_BASE,0)| 
LockState:
        DATA
        DC32 392
//   74               LOCK_MASK(SLOCK_BASE,3) |
//   75                 LOCK_MASK(LFLOCK_BASE,3); 
//   76 // =========================LOCKING MACHANISM OVER==============
//   77 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   78 void Cam_Algorithm(){
Cam_Algorithm:
        PUSH     {R7,LR}
//   79   
//   80   
//   81   //This pointer points to corresponding frame buffer
//   82   
//   83   u32 img_row_used;
//   84   for(img_row_used = 0; img_row_used < IMG_ROWS; img_row_used++){
        MOVS     R0,#+0
        B.N      ??Cam_Algorithm_0
//   85     // For every row:
//   86     while( (img_row_used >= img_row % IMG_ROWS) 
//   87         && (processing_frame == loading_frame)  );
??Cam_Algorithm_1:
        LDR.W    R1,??DataTable6_3
        LDRB     R1,[R1, #+0]
        MOVS     R2,#+50
        SDIV     R3,R1,R2
        MLS      R1,R2,R3,R1
        CMP      R0,R1
        BCC.N    ??Cam_Algorithm_2
        LDR.W    R1,??DataTable6_4
        LDR      R1,[R1, #+0]
        LDR.W    R2,??DataTable6_5
        LDR      R2,[R2, #+0]
        CMP      R1,R2
        BEQ.N    ??Cam_Algorithm_1
//   88     //Cannot process on going row, wait until img_row over img_row_used
//   89     //The current processing row must be the row just recieved
//   90     
//   91     if( img_row_used == 0 ){
??Cam_Algorithm_2:
        CMP      R0,#+0
        BNE.N    ??Cam_Algorithm_3
//   92       //If this is the first row, tag the current processing frame
//   93       processing_frame=loading_frame;
        LDR.W    R1,??DataTable6_5
        LDR      R1,[R1, #+0]
        LDR.W    R2,??DataTable6_4
        STR      R1,[R2, #+0]
//   94       processing_frame_indicator=current_frame_indicator;
        LDR.W    R1,??DataTable6_6
        LDRB     R1,[R1, #+0]
        LDR.W    R2,??DataTable6_7
        STRB     R1,[R2, #+0]
//   95       //Locking the buffer
//   96       SET_LOCK(PLOCK_BASE,processing_frame_indicator);
        LDR.W    R1,??DataTable6_8
        LDR      R1,[R1, #+0]
        MOVS     R2,#+1
        LDR.W    R3,??DataTable6_7
        LDRB     R3,[R3, #+0]
        ADDS     R3,R3,#+8
        LSLS     R2,R2,R3
        ORRS     R1,R2,R1
        LDR.W    R2,??DataTable6_8
        STR      R1,[R2, #+0]
//   97       //Prepare the read/write pointer
//   98       img_buffer=(void*)(buffer_ptr[processing_frame_indicator]);
        LDR.W    R1,??DataTable6_9
        LDR.W    R2,??DataTable6_7
        LDRB     R2,[R2, #+0]
        LDR      R1,[R1, R2, LSL #+2]
        LDR.W    R2,??DataTable6_10
        STR      R1,[R2, #+0]
//   99     }
//  100 
//  101      //for(int i=0;i<50000;i++);
//  102   }
??Cam_Algorithm_3:
        ADDS     R0,R0,#+1
??Cam_Algorithm_0:
        CMP      R0,#+50
        BCC.N    ??Cam_Algorithm_1
//  103   //HERE WE SUCESSFULLY LOADED ONE FRAME:
//  104   //Due to locking this will always be a consistent frame:
//  105   //Post Frame Processing
//  106   LED1_Tog();
        BL       LED1_Tog
//  107   CLEAR_LOCK(PLOCK_BASE); //Release the processing lock
        LDR.W    R0,??DataTable6_8
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0xF00
        LDR.W    R1,??DataTable6_8
        STR      R0,[R1, #+0]
//  108   process_diff=processing_frame - last_processed_frame;
        LDR.W    R0,??DataTable6_4
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable6_11
        LDR      R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable6_12
        STR      R0,[R1, #+0]
//  109   last_processed_frame=processing_frame;
        LDR.W    R0,??DataTable6_4
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable6_11
        STR      R0,[R1, #+0]
//  110 
//  111 }
        POP      {R0,PC}          ;; return
//  112 
//  113 // ====== Basic Drivers ======
//  114 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  115 void PORTC_IRQHandler(){
//  116   if((PORTC->ISFR)&PORT_ISFR_ISF(1 << 8)){  //CS
PORTC_IRQHandler:
        LDR.W    R0,??DataTable6_13  ;; 0x4004b0a0
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+23
        BPL.N    ??PORTC_IRQHandler_0
//  117     PORTC->ISFR |= PORT_ISFR_ISF(1 << 8);
        LDR.W    R0,??DataTable6_13  ;; 0x4004b0a0
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.W    R1,??DataTable6_13  ;; 0x4004b0a0
        STR      R0,[R1, #+0]
//  118     
//  119     if(img_row < IMG_ROWS && cam_row % IMG_STEP == 0 ){
        LDR.W    R0,??DataTable6_3
        LDRB     R0,[R0, #+0]
        CMP      R0,#+50
        BGE.N    ??PORTC_IRQHandler_1
        LDR.W    R0,??DataTable6_14
        LDRB     R0,[R0, #+0]
        MOVS     R1,#+4
        SDIV     R2,R0,R1
        MLS      R2,R2,R1,R0
        CMP      R2,#+0
        BNE.N    ??PORTC_IRQHandler_1
//  120       DMA0->TCD[0].DADDR = (u32)&loading_buffer[img_row][0];
        LDR.W    R0,??DataTable6_15
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable6_3
        LDRB     R1,[R1, #+0]
        MOVS     R2,#+150
        MLA      R0,R2,R1,R0
        LDR.W    R1,??DataTable6_16  ;; 0x40009010
        STR      R0,[R1, #+0]
//  121       ADC0->SC1[0] |= ADC_SC1_ADCH(4); //Restart ADC
        LDR.W    R0,??DataTable6_17  ;; 0x4003b000
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.W    R1,??DataTable6_17  ;; 0x4003b000
        STR      R0,[R1, #+0]
//  122       DMA0->TCD[0].CSR = DMA_CSR_DREQ_MASK | DMA_CSR_INTMAJOR_MASK; //Enable Major Loop Int
        MOVS     R0,#+10
        LDR.W    R1,??DataTable6_18  ;; 0x4000901c
        STRH     R0,[R1, #+0]
//  123       DMA0->ERQ |= DMA_ERQ_ERQ0_MASK; //Enable DMA0
        LDR.W    R0,??DataTable6_19  ;; 0x4000800c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.W    R1,??DataTable6_19  ;; 0x4000800c
        STR      R0,[R1, #+0]
//  124     }
//  125     cam_row++;
??PORTC_IRQHandler_1:
        LDR.W    R0,??DataTable6_14
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.W    R1,??DataTable6_14
        STRB     R0,[R1, #+0]
        B.N      ??PORTC_IRQHandler_2
//  126   }
//  127   else if(PORTC->ISFR&PORT_ISFR_ISF(1 << 9)){   //VS
??PORTC_IRQHandler_0:
        LDR.W    R0,??DataTable6_13  ;; 0x4004b0a0
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+22
        BPL.N    ??PORTC_IRQHandler_2
//  128     PORTC->ISFR |= PORT_ISFR_ISF(1 << 9);
        LDR.W    R0,??DataTable6_13  ;; 0x4004b0a0
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x200
        LDR.W    R1,??DataTable6_13  ;; 0x4004b0a0
        STR      R0,[R1, #+0]
//  129     cam_row = img_row = 0;
        MOVS     R0,#+0
        LDR.W    R1,??DataTable6_3
        STRB     R0,[R1, #+0]
        LDR.W    R0,??DataTable6_3
        LDRB     R0,[R0, #+0]
        LDR.W    R1,??DataTable6_14
        STRB     R0,[R1, #+0]
//  130     
//  131     //update the loading frame counter
//  132     loading_frame++;
        LDR.W    R0,??DataTable6_5
        LDR      R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.W    R1,??DataTable6_5
        STR      R0,[R1, #+0]
//  133     //set current buffer==>last frame buffer
//  134     last_frame_indicator=current_frame_indicator;
        LDR.W    R0,??DataTable6_6
        LDRB     R0,[R0, #+0]
        LDR.W    R1,??DataTable6_20
        STRB     R0,[R1, #+0]
//  135     CLEAR_LOCK(LFLOCK_BASE);
        LDR.W    R0,??DataTable6_8
        LDR      R0,[R0, #+0]
        LSRS     R0,R0,#+4
        LSLS     R0,R0,#+4
        LDR.W    R1,??DataTable6_8
        STR      R0,[R1, #+0]
//  136     SET_LOCK(LFLOCK_BASE,last_frame_indicator);
        LDR.W    R0,??DataTable6_8
        LDR      R0,[R0, #+0]
        MOVS     R1,#+1
        LDR.W    R2,??DataTable6_20
        LDRSB    R2,[R2, #+0]
        LSLS     R1,R1,R2
        ORRS     R0,R1,R0
        LDR.W    R1,??DataTable6_8
        STR      R0,[R1, #+0]
//  137     current_frame_indicator=GET_FREE_LOCK();
        LDR.W    R0,??DataTable6_8
        LDR      R0,[R0, #+0]
        MOVW     R1,#+273
        TST      R0,R1
        BEQ.N    ??PORTC_IRQHandler_3
        LDR.W    R0,??DataTable6_8
        LDR      R0,[R0, #+0]
        MOVW     R1,#+546
        TST      R0,R1
        BEQ.N    ??PORTC_IRQHandler_4
        LDR.W    R0,??DataTable6_8
        LDR      R0,[R0, #+0]
        MOVW     R1,#+1092
        TST      R0,R1
        BEQ.N    ??PORTC_IRQHandler_5
        MOVS     R0,#+3
        B.N      ??PORTC_IRQHandler_6
??PORTC_IRQHandler_5:
        MOVS     R0,#+2
        B.N      ??PORTC_IRQHandler_6
??PORTC_IRQHandler_4:
        MOVS     R0,#+1
??PORTC_IRQHandler_6:
        LDR.W    R1,??DataTable6_6
        STRB     R0,[R1, #+0]
        B.N      ??PORTC_IRQHandler_7
??PORTC_IRQHandler_3:
        MOVS     R0,#+0
        LDR.W    R1,??DataTable6_6
        STRB     R0,[R1, #+0]
//  138     loading_buffer=(void*)buffer_ptr[current_frame_indicator];
??PORTC_IRQHandler_7:
        LDR.W    R0,??DataTable6_9
        LDR.W    R1,??DataTable6_6
        LDRB     R1,[R1, #+0]
        LDR      R0,[R0, R1, LSL #+2]
        LDR.W    R1,??DataTable6_15
        STR      R0,[R1, #+0]
//  139     static u32 t=0;
//  140     debug_num=-PIT2_VAL() /(g_bus_clock/10000)+t;
        LDR.W    R0,??DataTable6_21
        LDR      R0,[R0, #+0]
        MOVW     R1,#+10000
        UDIV     R0,R0,R1
        LDR.W    R1,??DataTable6_22  ;; 0x40037124
        LDR      R1,[R1, #+0]
        RSBS     R1,R1,#+0
        UDIV     R0,R1,R0
        LDR.W    R1,??DataTable6_23
        LDR      R1,[R1, #+0]
        ADDS     R0,R1,R0
        LDR.W    R1,??DataTable6_24
        STRH     R0,[R1, #+0]
//  141     t-=debug_num;
        LDR.W    R0,??DataTable6_23
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable6_24
        LDRH     R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable6_23
        STR      R0,[R1, #+0]
//  142   }
//  143 }
??PORTC_IRQHandler_2:
        BX       LR               ;; return

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
??t:
        DS8 4
//  144 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  145 void DMA0_IRQHandler(){
//  146   img_row++; 
DMA0_IRQHandler:
        LDR.W    R0,??DataTable6_3
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.W    R1,??DataTable6_3
        STRB     R0,[R1, #+0]
//  147   DMA0->INT=DMA_INT_INT0_MASK;
        MOVS     R0,#+1
        LDR.W    R1,??DataTable6_25  ;; 0x40008024
        STR      R0,[R1, #+0]
//  148 }
        BX       LR               ;; return
//  149 
//  150 
//  151 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  152 void Cam_Init(){
Cam_Init:
        PUSH     {R4,LR}
//  153   
//  154   // --- IO ---
//  155   
//  156   PORTC->PCR[8] |= PORT_PCR_MUX(1); //cs
        LDR.W    R0,??DataTable6_26  ;; 0x4004b020
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.W    R1,??DataTable6_26  ;; 0x4004b020
        STR      R0,[R1, #+0]
//  157   PORTC->PCR[9] |= PORT_PCR_MUX(1); //vs
        LDR.W    R0,??DataTable6_27  ;; 0x4004b024
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.W    R1,??DataTable6_27  ;; 0x4004b024
        STR      R0,[R1, #+0]
//  158   PORTC->PCR[11] |= PORT_PCR_MUX(1);    //oe
        LDR.W    R0,??DataTable6_28  ;; 0x4004b02c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.W    R1,??DataTable6_28  ;; 0x4004b02c
        STR      R0,[R1, #+0]
//  159   PTC->PDDR &=~(3<<8);
        LDR.W    R0,??DataTable6_29  ;; 0x400ff094
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x300
        LDR.W    R1,??DataTable6_29  ;; 0x400ff094
        STR      R0,[R1, #+0]
//  160   PTC->PDDR &=~(1<<11);
        LDR.W    R0,??DataTable6_29  ;; 0x400ff094
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x800
        LDR.W    R1,??DataTable6_29  ;; 0x400ff094
        STR      R0,[R1, #+0]
//  161   PORTC->PCR[8] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK | PORT_PCR_IRQC(10);	//PULLUP | falling edge
        LDR.W    R0,??DataTable6_26  ;; 0x4004b020
        LDR      R0,[R0, #+0]
        ORR      R0,R0,#0xA0000
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable6_26  ;; 0x4004b020
        STR      R0,[R1, #+0]
//  162   PORTC->PCR[9] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK | PORT_PCR_IRQC(9);  // rising edge
        LDR.N    R0,??DataTable6_27  ;; 0x4004b024
        LDR      R0,[R0, #+0]
        ORR      R0,R0,#0x90000
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable6_27  ;; 0x4004b024
        STR      R0,[R1, #+0]
//  163   PORTC->PCR[11] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;
        LDR.N    R0,??DataTable6_28  ;; 0x4004b02c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable6_28  ;; 0x4004b02c
        STR      R0,[R1, #+0]
//  164   
//  165   NVIC_EnableIRQ(PORTC_IRQn);
        MOVS     R0,#+89
        BL       NVIC_EnableIRQ
//  166   NVIC_SetPriority(PORTC_IRQn, NVIC_EncodePriority(NVIC_GROUP, 1, 2));
        MOVS     R2,#+2
        MOVS     R1,#+1
        MOVS     R0,#+5
        BL       NVIC_EncodePriority
        MOVS     R1,R0
        MOVS     R0,#+89
        BL       NVIC_SetPriority
//  167   
//  168   // --- AD ---
//  169   
//  170   /*
//  171   SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;  //ADC1 Clock Enable
//  172   ADC0->CFG1 |= 0
//  173              //|ADC_CFG1_ADLPC_MASK
//  174              | ADC_CFG1_ADICLK(1)
//  175              | ADC_CFG1_MODE(0);     // 8 bits
//  176              //| ADC_CFG1_ADIV(0);
//  177   ADC0->CFG2 |= //ADC_CFG2_ADHSC_MASK |
//  178                 ADC_CFG2_MUXSEL_MASK |  // b
//  179                 ADC_CFG2_ADACKEN_MASK; 
//  180   
//  181   ADC0->SC1[0]&=~ADC_SC1_AIEN_MASK;//disenble interrupt
//  182   
//  183   ADC0->SC2 |= ADC_SC2_DMAEN_MASK; //DMA
//  184   
//  185   ADC0->SC3 |= ADC_SC3_ADCO_MASK; // continuous
//  186   
//  187   //PORTC->PCR[2]|=PORT_PCR_MUX(0);//adc1-4a
//  188   
//  189   ADC0->SC1[0] |= ADC_SC1_ADCH(4);
//  190   */
//  191   
//  192   SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK; //ADC1 Clock Enable
        LDR.N    R0,??DataTable6_30  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000000
        LDR.N    R1,??DataTable6_30  ;; 0x4004803c
        STR      R0,[R1, #+0]
//  193   ADC0->SC1[0] &= ~ADC_SC1_AIEN_MASK; //ADC1A
        LDR.N    R0,??DataTable6_17  ;; 0x4003b000
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x40
        LDR.N    R1,??DataTable6_17  ;; 0x4003b000
        STR      R0,[R1, #+0]
//  194   ADC0->SC1[0] = 0x00000000; //Clear
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_17  ;; 0x4003b000
        STR      R0,[R1, #+0]
//  195   ADC0->SC1[0] |= ADC_SC1_ADCH(4); //ADC1_5->Input, Single Pin, No interrupt
        LDR.N    R0,??DataTable6_17  ;; 0x4003b000
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??DataTable6_17  ;; 0x4003b000
        STR      R0,[R1, #+0]
//  196   ADC0->SC1[1] &= ~ADC_SC1_AIEN_MASK; //ADC1B
        LDR.N    R0,??DataTable6_31  ;; 0x4003b004
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x40
        LDR.N    R1,??DataTable6_31  ;; 0x4003b004
        STR      R0,[R1, #+0]
//  197   ADC0->SC1[1] |= ADC_SC1_ADCH(4); //ADC1_5b
        LDR.N    R0,??DataTable6_31  ;; 0x4003b004
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??DataTable6_31  ;; 0x4003b004
        STR      R0,[R1, #+0]
//  198   ADC0->SC2 &= 0x00000000; //Clear all.
        LDR.N    R0,??DataTable6_32  ;; 0x4003b020
        LDR      R4,[R0, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_32  ;; 0x4003b020
        STR      R0,[R1, #+0]
//  199   ADC0->SC2 |= ADC_SC2_DMAEN_MASK; //DMA, SoftWare
        LDR.N    R0,??DataTable6_32  ;; 0x4003b020
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??DataTable6_32  ;; 0x4003b020
        STR      R0,[R1, #+0]
//  200   ADC0->SC3 &= (~ADC_SC3_AVGE_MASK&~ADC_SC3_AVGS_MASK); //hardware average disabled
        LDR.N    R0,??DataTable6_33  ;; 0x4003b024
        LDR      R0,[R0, #+0]
        LSRS     R0,R0,#+3
        LSLS     R0,R0,#+3
        LDR.N    R1,??DataTable6_33  ;; 0x4003b024
        STR      R0,[R1, #+0]
//  201   ADC0->SC3 |= ADC_SC3_ADCO_MASK; //Continuous conversion enable
        LDR.N    R0,??DataTable6_33  ;; 0x4003b024
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable6_33  ;; 0x4003b024
        STR      R0,[R1, #+0]
//  202   ADC0->CFG1|=ADC_CFG1_ADICLK(1)|ADC_CFG1_MODE(0)|ADC_CFG1_ADIV(0);//InputClk, ShortTime, 8bits, Bus
        LDR.N    R0,??DataTable6_34  ;; 0x4003b008
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable6_34  ;; 0x4003b008
        STR      R0,[R1, #+0]
//  203   ADC0->CFG2 |= ADC_CFG2_MUXSEL_MASK; //ADC1  b
        LDR.N    R0,??DataTable6_35  ;; 0x4003b00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x10
        LDR.N    R1,??DataTable6_35  ;; 0x4003b00c
        STR      R0,[R1, #+0]
//  204   ADC0->CFG2 |= ADC_CFG2_ADACKEN_MASK; //OutputClock
        LDR.N    R0,??DataTable6_35  ;; 0x4003b00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable6_35  ;; 0x4003b00c
        STR      R0,[R1, #+0]
//  205     
//  206   // --- DMA ---
//  207   
//  208   SIM->SCGC6 |= SIM_SCGC6_DMAMUX_MASK; //DMAMUX Clock Enable
        LDR.N    R0,??DataTable6_30  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable6_30  ;; 0x4004803c
        STR      R0,[R1, #+0]
//  209   SIM->SCGC7 |= SIM_SCGC7_DMA_MASK; //DMA Clock Enable
        LDR.N    R0,??DataTable6_36  ;; 0x40048040
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable6_36  ;; 0x40048040
        STR      R0,[R1, #+0]
//  210   DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_SOURCE(40); //DMA0->No.40 request, ADC0
        LDR.N    R0,??DataTable6_37  ;; 0x40021000
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x28
        LDR.N    R1,??DataTable6_37  ;; 0x40021000
        STRB     R0,[R1, #+0]
//  211   DMA0->TCD[0].SADDR = (uint32_t) & (ADC0->R[0]); //Source Address 0x400B_B010h
        LDR.N    R0,??DataTable6_38  ;; 0x4003b010
        LDR.N    R1,??DataTable6_39  ;; 0x40009000
        STR      R0,[R1, #+0]
//  212   DMA0->TCD[0].SOFF = 0; //Source Fixed
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_40  ;; 0x40009004
        STRH     R0,[R1, #+0]
//  213   DMA0->TCD[0].ATTR = DMA_ATTR_SSIZE(0) | DMA_ATTR_DSIZE(0); //Source 8 bits, Aim 8 bits
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_41  ;; 0x40009006
        STRH     R0,[R1, #+0]
//  214   DMA0->TCD[0].NBYTES_MLNO = DMA_NBYTES_MLNO_NBYTES(1); //one byte each
        MOVS     R0,#+1
        LDR.N    R1,??DataTable6_42  ;; 0x40009008
        STR      R0,[R1, #+0]
//  215   DMA0->TCD[0].SLAST = 0; //Last Source fixed
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_43  ;; 0x4000900c
        STR      R0,[R1, #+0]
//  216   DMA0->TCD[0].DADDR = (u32)loading_buffer;
        LDR.N    R0,??DataTable6_15
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_16  ;; 0x40009010
        STR      R0,[R1, #+0]
//  217   DMA0->TCD[0].DOFF = 1;
        MOVS     R0,#+1
        LDR.N    R1,??DataTable6_44  ;; 0x40009014
        STRH     R0,[R1, #+0]
//  218   DMA0->TCD[0].CITER_ELINKNO = DMA_CITER_ELINKNO_CITER(IMG_COLS);
        MOVS     R0,#+150
        LDR.N    R1,??DataTable6_45  ;; 0x40009016
        STRH     R0,[R1, #+0]
//  219   DMA0->TCD[0].DLAST_SGA = 0;
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_46  ;; 0x40009018
        STR      R0,[R1, #+0]
//  220   DMA0->TCD[0].BITER_ELINKNO = DMA_BITER_ELINKNO_BITER(IMG_COLS);
        MOVS     R0,#+150
        LDR.N    R1,??DataTable6_47  ;; 0x4000901e
        STRH     R0,[R1, #+0]
//  221   DMA0->TCD[0].CSR = 0x00000000; //Clear
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_18  ;; 0x4000901c
        STRH     R0,[R1, #+0]
//  222   DMA0->TCD[0].CSR |= DMA_CSR_DREQ_MASK; //Auto Clear
        LDR.N    R0,??DataTable6_18  ;; 0x4000901c
        LDRH     R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable6_18  ;; 0x4000901c
        STRH     R0,[R1, #+0]
//  223   DMA0->TCD[0].CSR |= DMA_CSR_INTMAJOR_MASK; //Enable Major Loop Int
        LDR.N    R0,??DataTable6_18  ;; 0x4000901c
        LDRH     R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable6_18  ;; 0x4000901c
        STRH     R0,[R1, #+0]
//  224   DMA0->DCHPRI0 = DMA_DCHPRI1_CHPRI(1);
        MOVS     R0,#+1
        LDR.N    R1,??DataTable6_48  ;; 0x40008103
        STRB     R0,[R1, #+0]
//  225   DMA0->DCHPRI1 = DMA_DCHPRI1_CHPRI(0); //Exchange the DMA Priority of CH0 and CH1
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_49  ;; 0x40008102
        STRB     R0,[R1, #+0]
//  226   DMA0->INT |= DMA_INT_INT0_MASK; //Open Interrupt
        LDR.N    R0,??DataTable6_25  ;; 0x40008024
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable6_25  ;; 0x40008024
        STR      R0,[R1, #+0]
//  227   //DMA->ERQ&=~DMA_ERQ_ERQ0_MASK;//Clear Disable
//  228   DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_ENBL_MASK; //Enable
        LDR.N    R0,??DataTable6_37  ;; 0x40021000
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable6_37  ;; 0x40021000
        STRB     R0,[R1, #+0]
//  229   
//  230   NVIC_EnableIRQ(DMA0_IRQn);
        MOVS     R0,#+0
        BL       NVIC_EnableIRQ
//  231   NVIC_SetPriority(DMA0_IRQn, NVIC_EncodePriority(NVIC_GROUP, 1, 2));
        MOVS     R2,#+2
        MOVS     R1,#+1
        MOVS     R0,#+5
        BL       NVIC_EncodePriority
        MOVS     R1,R0
        MOVS     R0,#+0
        BL       NVIC_SetPriority
//  232   
//  233 #define BUFFER(n) cam_buffer##n
//  234 #define INIT_BUFFER(n) \ 
//  235   BUFFER(n)[0]=0xff; BUFFER(n)[1]=0x00; BUFFER(n)[2]=0xff; \ 
//  236   BUFFER(n)[sizeof(BUFFER(n))-1]=0xff; \ 
//  237   BUFFER(n)[sizeof(BUFFER(n))-2]=0x00; \ 
//  238   BUFFER(n)[sizeof(BUFFER(n))-3]=0xff; 
//  239   
//  240   INIT_BUFFER(0);
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_50
        STRB     R0,[R1, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_50
        STRB     R0,[R1, #+1]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_50
        STRB     R0,[R1, #+2]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_51
        STRB     R0,[R1, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_52
        STRB     R0,[R1, #+0]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_53
        STRB     R0,[R1, #+0]
//  241   INIT_BUFFER(1);
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_54
        STRB     R0,[R1, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_54
        STRB     R0,[R1, #+1]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_54
        STRB     R0,[R1, #+2]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_55
        STRB     R0,[R1, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_56
        STRB     R0,[R1, #+0]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_57
        STRB     R0,[R1, #+0]
//  242   INIT_BUFFER(2);
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_58
        STRB     R0,[R1, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_58
        STRB     R0,[R1, #+1]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_58
        STRB     R0,[R1, #+2]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_59
        STRB     R0,[R1, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_60
        STRB     R0,[R1, #+0]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_61
        STRB     R0,[R1, #+0]
//  243   INIT_BUFFER(3);
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_62
        STRB     R0,[R1, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_62
        STRB     R0,[R1, #+1]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_62
        STRB     R0,[R1, #+2]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_63
        STRB     R0,[R1, #+0]
        MOVS     R0,#+0
        LDR.N    R1,??DataTable6_64
        STRB     R0,[R1, #+0]
        MOVS     R0,#+255
        LDR.N    R1,??DataTable6_65
        STRB     R0,[R1, #+0]
//  244 
//  245 #undef BUFFER
//  246 #undef INIT_BUFFER
//  247 }
        POP      {R4,PC}          ;; return
//  248 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  249 void DMA1_IRQHandler(){
DMA1_IRQHandler:
        PUSH     {R7,LR}
//  250   //One frame is sent!
//  251   TOCK();
        LDR.N    R0,??DataTable6_66
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_21
        LDR      R1,[R1, #+0]
        MOVW     R2,#+10000
        UDIV     R1,R1,R2
        LDR.N    R2,??DataTable6_22  ;; 0x40037124
        LDR      R2,[R2, #+0]
        SUBS     R0,R0,R2
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable6_67
        STRH     R0,[R1, #+0]
//  252   send_diff=sending_frame-last_sent_frame;
        LDR.N    R0,??DataTable6_68
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_69
        LDR      R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable6_70
        STR      R0,[R1, #+0]
//  253   last_sent_frame=sending_frame;
        LDR.N    R0,??DataTable6_68
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_69
        STR      R0,[R1, #+0]
//  254   sending_frame=loading_frame-1;
        LDR.N    R0,??DataTable6_5
        LDR      R0,[R0, #+0]
        SUBS     R0,R0,#+1
        LDR.N    R1,??DataTable6_68
        STR      R0,[R1, #+0]
//  255   
//  256   uint8 t=last_frame_indicator;//This Ensures atomic operation
        LDR.N    R0,??DataTable6_20
        LDRB     R0,[R0, #+0]
//  257   CLEAR_LOCK(SLOCK_BASE);
        LDR.N    R1,??DataTable6_8
        LDR      R1,[R1, #+0]
        BICS     R1,R1,#0xF0
        LDR.N    R2,??DataTable6_8
        STR      R1,[R2, #+0]
//  258   SET_LOCK(SLOCK_BASE, t);
        LDR.N    R1,??DataTable6_8
        LDR      R1,[R1, #+0]
        MOVS     R2,#+1
        ADDS     R3,R0,#+4
        LSLS     R2,R2,R3
        ORRS     R1,R2,R1
        LDR.N    R2,??DataTable6_8
        STR      R1,[R2, #+0]
//  259   sending_buffer=buffer_ptr[t]-SIG_SIZE;
        LDR.N    R1,??DataTable6_9
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR      R1,[R1, R0, LSL #+2]
        SUBS     R1,R1,#+3
        LDR.N    R2,??DataTable6_71
        STR      R1,[R2, #+0]
//  260   
//  261   sending_frame_indicator=t;
        LDR.N    R1,??DataTable6_72
        STRB     R0,[R1, #+0]
//  262   
//  263   DMA0->INT=DMA_INT_INT1_MASK;
        MOVS     R0,#+2
        LDR.N    R1,??DataTable6_25  ;; 0x40008024
        STR      R0,[R1, #+0]
//  264   
//  265   Bluetooth_SendDataChunkAsync( sending_buffer , IMG_ROWS * VALID_COLS + 2 * SIG_SIZE );
        MOVW     R1,#+7506
        LDR.N    R0,??DataTable6_71
        LDR      R0,[R0, #+0]
        BL       Bluetooth_SendDataChunkAsync
//  266   LED2_Tog();
        BL       LED2_Tog
//  267   TICK();
        LDR.N    R0,??DataTable6_22  ;; 0x40037124
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable6_66
        STR      R0,[R1, #+0]
//  268 }
        POP      {R0,PC}          ;; return

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
        DC32     img_row

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_4:
        DC32     processing_frame

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_5:
        DC32     loading_frame

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_6:
        DC32     current_frame_indicator

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_7:
        DC32     processing_frame_indicator

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_8:
        DC32     LockState

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_9:
        DC32     buffer_ptr

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_10:
        DC32     img_buffer

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_11:
        DC32     last_processed_frame

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_12:
        DC32     process_diff

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_13:
        DC32     0x4004b0a0

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_14:
        DC32     cam_row

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_15:
        DC32     loading_buffer

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_16:
        DC32     0x40009010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_17:
        DC32     0x4003b000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_18:
        DC32     0x4000901c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_19:
        DC32     0x4000800c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_20:
        DC32     last_frame_indicator

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_21:
        DC32     g_bus_clock

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_22:
        DC32     0x40037124

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_23:
        DC32     ??t

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_24:
        DC32     debug_num

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_25:
        DC32     0x40008024

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_26:
        DC32     0x4004b020

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_27:
        DC32     0x4004b024

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_28:
        DC32     0x4004b02c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_29:
        DC32     0x400ff094

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_30:
        DC32     0x4004803c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_31:
        DC32     0x4003b004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_32:
        DC32     0x4003b020

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_33:
        DC32     0x4003b024

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_34:
        DC32     0x4003b008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_35:
        DC32     0x4003b00c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_36:
        DC32     0x40048040

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_37:
        DC32     0x40021000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_38:
        DC32     0x4003b010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_39:
        DC32     0x40009000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_40:
        DC32     0x40009004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_41:
        DC32     0x40009006

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_42:
        DC32     0x40009008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_43:
        DC32     0x4000900c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_44:
        DC32     0x40009014

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_45:
        DC32     0x40009016

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_46:
        DC32     0x40009018

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_47:
        DC32     0x4000901e

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_48:
        DC32     0x40008103

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_49:
        DC32     0x40008102

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_50:
        DC32     cam_buffer0

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_51:
        DC32     cam_buffer0+0x1D51

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_52:
        DC32     cam_buffer0+0x1D50

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_53:
        DC32     cam_buffer0+0x1D4F

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_54:
        DC32     cam_buffer1

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_55:
        DC32     cam_buffer1+0x1D51

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_56:
        DC32     cam_buffer1+0x1D50

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_57:
        DC32     cam_buffer1+0x1D4F

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_58:
        DC32     cam_buffer2

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_59:
        DC32     cam_buffer2+0x1D51

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_60:
        DC32     cam_buffer2+0x1D50

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_61:
        DC32     cam_buffer2+0x1D4F

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_62:
        DC32     cam_buffer3

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_63:
        DC32     cam_buffer3+0x1D51

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_64:
        DC32     cam_buffer3+0x1D50

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_65:
        DC32     cam_buffer3+0x1D4F

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_66:
        DC32     tclk

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_67:
        DC32     e_debug_num

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_68:
        DC32     sending_frame

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_69:
        DC32     last_sent_frame

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_70:
        DC32     send_diff

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_71:
        DC32     sending_buffer

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable6_72:
        DC32     sending_frame_indicator

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
// 30 073 bytes in section .bss
//     33 bytes in section .data
//  1 794 bytes in section .text
// 
//  1 794 bytes of CODE memory
// 30 106 bytes of DATA memory
//
//Errors: none
//Warnings: 1
