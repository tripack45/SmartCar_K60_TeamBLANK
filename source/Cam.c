/*
Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
Date : 2015/12/01
License : MIT
*/

#include "includes.h"

#define VALID_COLS IMG_COLS

#define SIG_SIZE 3
#define EXTRA_INFO_SIZE 6 


// ====== Variables ======

// ---- Local ----
u8 cam_row = 0, img_row = 0;


u8 cam_buffer0[ IMG_ROWS * IMG_COLS + EXTRA_INFO_SIZE + 2 * SIG_SIZE ];
u8 cam_buffer1[ IMG_ROWS * IMG_COLS + EXTRA_INFO_SIZE + 2 * SIG_SIZE ];
u8 cam_buffer2[ IMG_ROWS * IMG_COLS + EXTRA_INFO_SIZE + 2 * SIG_SIZE ];
u8 cam_buffer3[ IMG_ROWS * IMG_COLS + EXTRA_INFO_SIZE + 2 * SIG_SIZE ];

u8* buffer_ptr[4]={ cam_buffer0+SIG_SIZE, cam_buffer1+SIG_SIZE,
                    cam_buffer2+SIG_SIZE, cam_buffer3+SIG_SIZE };

// ---- Global ----
int processing_frame; //Currently processing frame
int loading_frame; //Currently loading frame
int sending_frame; //Currently sending frame
int last_processed_frame, last_sent_frame;

int process_diff,load_diff,send_diff;

u8  *sending_buffer=(void*)(cam_buffer3+SIG_SIZE);
u8  (*loading_buffer)[IMG_COLS]=(void*)(cam_buffer0+SIG_SIZE);
u8  (*img_buffer)[IMG_COLS]=(void*)(cam_buffer0+SIG_SIZE); 

u8 current_frame_indicator=0; //Indicates buffer being loaded
u8 last_frame_indicator=3;    //Indicates last loaded buffer
u8 processing_frame_indicator=0;//frame_currently being processed
u8 sending_frame_indicator=0;//frame_currently being processed


//===========================LOCKING MACHANISM=================
/*Here implements locking mechanism.
There are 3 types of locks:
ProcessLock, SendLock, LastFrameLock
They are implemented in a bit wise number LockState:
LockState: 0000  0000   0000   0000
NONE   PLock  SLock LFLock
WARNING: 
No access(Read/Write) is allowed after releasing the lock!
Illegal access will not be stopped but will result in 
undefined behavior! 
*/

#define PLOCK_BASE 8
#define SLOCK_BASE 4
#define LFLOCK_BASE 0
#define LOCK_MASK(base,x) (1 << (base + x) )
#define IS_LOCK_TYPE(base,x) (LockState & LOCK_MASK(base,x) )
#define IS_LOCK(x) (LockState &(  LOCK_MASK(PLOCK_BASE, x) \
                                | LOCK_MASK(SLOCK_BASE, x) \
                                | LOCK_MASK(LFLOCK_BASE,x) ))
#define GET_FREE_LOCK() (IS_LOCK(0) ? ( \
                            IS_LOCK(1) ? (\
                              ( IS_LOCK(2) ?  3 : 2 ) \
                            ) : 1 \
                       ) : 0 )
#define SET_LOCK(base, x) LockState |= LOCK_MASK(base, x)
#define CLEAR_LOCK(base) LockState &= ~( 0x0f <<base );
#define CLEAR_ALL_LOCK() LockState = 0;
U32 LockState=LOCK_MASK(PLOCK_BASE,0)| 
              LOCK_MASK(SLOCK_BASE,3) |
                LOCK_MASK(LFLOCK_BASE,3); 
// =========================LOCKING MACHANISM OVER==============

void Cam_Algorithm(){
  
  //This pointer points to corresponding frame buffer
  //u8 header[SIG_SIZE]={0xFF,0x00,0xFF};
  //u8 tail[SIG_SIZE]={0xA0,0x00,0xA0};
  u32 img_row_used;
  for(img_row_used = 0; img_row_used < IMG_ROWS; img_row_used++){
    // For every row:
    while( (img_row_used >= img_row % IMG_ROWS) 
        && (processing_frame == loading_frame)  );
    //Cannot process on going row, wait until img_row over img_row_used
    //The current processing row must be the row just recieved
    
    if( img_row_used == 0 ){
      //If this is the first row, tag the current processing frame
      processing_frame=loading_frame;
      processing_frame_indicator=current_frame_indicator;
      //Locking the buffer
      SET_LOCK(PLOCK_BASE,processing_frame_indicator);
      //Prepare the read/write pointer
      img_buffer=(void*)(buffer_ptr[processing_frame_indicator]);
    }
    // Line processing here
    //===========End============
  }
  //HERE WE SUCESSFULLY LOADED ONE FRAME:
  //Due to locking this will always be a consistent frame:
  //Post Frame Processing
  
  //Writing Current Extra Infomation into the buffer
  ((u8*)img_buffer)[IMG_ROWS*IMG_COLS]=((uint16)currspd)&0xff;
  ((u8*)img_buffer)[IMG_ROWS*IMG_COLS+1]=((uint16)currspd)>>8;
  ((u8*)img_buffer)[IMG_ROWS*IMG_COLS+2]=((uint16)currdir)&0xff;
  ((u8*)img_buffer)[IMG_ROWS*IMG_COLS+3]=((uint16)currdir)>>8;
  ((u8*)img_buffer)[IMG_ROWS*IMG_COLS+4]=((uint16)tacho0)&0xff;
  ((u8*)img_buffer)[IMG_ROWS*IMG_COLS+5]=((uint16)tacho0)>>8;
  DetectBoundary();
  DirCtrl(); 
  CLEAR_LOCK(PLOCK_BASE); //Release the processing lock
  process_diff=processing_frame - last_processed_frame;
  last_processed_frame=processing_frame;
}

// ====== Basic Drivers ======

void PORTC_IRQHandler(){
  if((PORTC->ISFR)&PORT_ISFR_ISF(1 << 8)){  //CS
    PORTC->ISFR |= PORT_ISFR_ISF(1 << 8);
    
    if(   (img_row < IMG_ROWS) 
       && (cam_row % IMG_STEP == 0)
       && (cam_row > 12) 
         ){
           //ITM_EVENT32(1, img_row);
           u8 errorFlag=0;
           if(img_row>1){ 
             for(int i=IMG_COLS-1;i>IMG_COLS-15;i--){
               if(loading_buffer[img_row-1][i]<10u){
                 errorFlag=1;
               }
             }       
           }
           for(int i=1;i<170;i++)asm("NOP");
           if(errorFlag==0)
             img_row++;          
           //ITM_EVENT8_WITH_PC(4,24);
           DMA0->TCD[0].DADDR = (u32)&loading_buffer[img_row][0];
           DMA0->ERQ |= DMA_ERQ_ERQ0_MASK; //Enable DMA0
           ADC0->SC1[0] |= ADC_SC1_ADCH(4); //Restart ADC
           DMA0->TCD[0].CSR |= DMA_CSR_START_MASK; //Start
         }
    cam_row++;
  }
  else if(PORTC->ISFR&PORT_ISFR_ISF(1 << 9)){   //VS
    
    PORTC->ISFR |= PORT_ISFR_ISF(1 << 9);
    e_debug_num= cam_row;
    cam_row = img_row = 0;

    //update the loading frame counter
    loading_frame++;
    //set current buffer==>last frame buffer
    last_frame_indicator=current_frame_indicator;
    CLEAR_LOCK(LFLOCK_BASE);
    SET_LOCK(LFLOCK_BASE,last_frame_indicator);
    current_frame_indicator=GET_FREE_LOCK();
    loading_buffer=(void*)buffer_ptr[current_frame_indicator];
    static u32 t=0;
    debug_num=-PIT2_VAL() /(g_bus_clock/10000)+t;
    t-=debug_num;
    //ITM_EVENT32(1, loading_frame);
  }
}

void DMA0_IRQHandler(){
  //if(e_debug_num==1)
  //{e_debug_num=2;
  DMA0->CINT &= ~DMA_CINT_CINT(7);
  //ITM_EVENT32(1, 0);
 //}
}



void Cam_Init(){
  
  // --- IO ---
  PORTC->PCR[8] |= PORT_PCR_MUX(1); //cs
  PORTC->PCR[9] |= PORT_PCR_MUX(1); //vs
  PORTC->PCR[11] |= PORT_PCR_MUX(1);    //oe
  PTC->PDDR &=~(3<<8);
  PTC->PDDR &=~(1<<11);
  PORTC->PCR[8] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK | PORT_PCR_IRQC(10);	//PULLUP | falling edge
  PORTC->PCR[9] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK | PORT_PCR_IRQC(9);  // rising edge
  PORTC->PCR[11] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK ;
  
  NVIC_EnableIRQ(PORTC_IRQn);
  NVIC_SetPriority(PORTC_IRQn, NVIC_EncodePriority(NVIC_GROUP, 1, 2));
  
  // --- AD ---
  
  /*
  SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;  //ADC1 Clock Enable
  ADC0->CFG1 |= 0
             //|ADC_CFG1_ADLPC_MASK
             | ADC_CFG1_ADICLK(1)
             | ADC_CFG1_MODE(0);     // 8 bits
             //| ADC_CFG1_ADIV(0);
  ADC0->CFG2 |= //ADC_CFG2_ADHSC_MASK |
                ADC_CFG2_MUXSEL_MASK |  // b
                ADC_CFG2_ADACKEN_MASK; 
  
  ADC0->SC1[0]&=~ADC_SC1_AIEN_MASK;//disenble interrupt
  
  ADC0->SC2 |= ADC_SC2_DMAEN_MASK; //DMA
  
  ADC0->SC3 |= ADC_SC3_ADCO_MASK; // continuous
  
  //PORTC->PCR[2]|=PORT_PCR_MUX(0);//adc1-4a
  
  ADC0->SC1[0] |= ADC_SC1_ADCH(4);
  */
  
  SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK; //ADC1 Clock Enable
  ADC0->SC1[0] &= ~ADC_SC1_AIEN_MASK; //ADC1A
  ADC0->SC1[0] = 0x00000000; //Clear
  ADC0->SC1[0] |= ADC_SC1_ADCH(4); //ADC1_5->Input, Single Pin, No interrupt
  ADC0->SC1[1] &= ~ADC_SC1_AIEN_MASK; //ADC1B
  ADC0->SC1[1] |= ADC_SC1_ADCH(4); //ADC1_5b
  ADC0->SC2 &= 0x00000000; //Clear all.
  ADC0->SC2 |= ADC_SC2_DMAEN_MASK; //DMA, SoftWare
  ADC0->SC3 &= (~ADC_SC3_AVGE_MASK&~ADC_SC3_AVGS_MASK); //hardware average disabled
  ADC0->SC3 |= ADC_SC3_ADCO_MASK; //Continuous conversion enable
  ADC0->CFG1|=ADC_CFG1_ADICLK(1)|ADC_CFG1_MODE(0)|ADC_CFG1_ADIV(0);//InputClk, ShortTime, 8bits, Bus
  ADC0->CFG2 |= ADC_CFG2_MUXSEL_MASK; //ADC1  b
  ADC0->CFG2 |= ADC_CFG2_ADACKEN_MASK; //OutputClock
    
  // --- DMA ---
  
  SIM->SCGC6 |= SIM_SCGC6_DMAMUX_MASK; //DMAMUX Clock Enable
  SIM->SCGC7 |= SIM_SCGC7_DMA_MASK; //DMA Clock Enable
  DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_SOURCE(40); //DMA0->No.40 request, ADC0
  DMA0->TCD[0].SADDR = (uint32_t) & (ADC0->R[0]); //Source Address 0x400B_B010h
  DMA0->TCD[0].SOFF = 0; //Source Fixed
  DMA0->TCD[0].ATTR = DMA_ATTR_SSIZE(0) | DMA_ATTR_DSIZE(0); //Source 8 bits, Aim 8 bits
  DMA0->TCD[0].NBYTES_MLNO = DMA_NBYTES_MLNO_NBYTES(1); //one byte each
  DMA0->TCD[0].SLAST = 0; //Last Source fixed
  DMA0->TCD[0].DADDR = (u32)loading_buffer;
  DMA0->TCD[0].DOFF = 1;
  DMA0->TCD[0].CITER_ELINKNO = DMA_CITER_ELINKNO_CITER(IMG_COLS);
  DMA0->TCD[0].DLAST_SGA = 0;
  DMA0->TCD[0].BITER_ELINKNO = DMA_BITER_ELINKNO_BITER(IMG_COLS);
  DMA0->TCD[0].CSR = 0x00000000; //Clear
  DMA0->TCD[0].CSR |= DMA_CSR_DREQ_MASK; //Auto Clear
  DMA0->TCD[0].CSR |= DMA_CSR_INTMAJOR_MASK; //Enable Major Loop Int
  DMA0->DCHPRI0 = DMA_DCHPRI1_CHPRI(1);
  DMA0->DCHPRI1 = DMA_DCHPRI1_CHPRI(0); //Exchange the DMA Priority of CH0 and CH1
  DMA0->INT |= DMA_INT_INT0_MASK; //Open Interrupt
  //DMA->ERQ&=~DMA_ERQ_ERQ0_MASK;//Clear Disable
  DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_ENBL_MASK; //Enable
  
  NVIC_EnableIRQ(DMA0_IRQn);
  NVIC_SetPriority(DMA0_IRQn, NVIC_EncodePriority(NVIC_GROUP, 1, 2));
  
#define BUFFER(n) cam_buffer##n
#define INIT_BUFFER(n) \
  for(int i=1;i<sizeof(BUFFER(n));i++) BUFFER(n)[i]=0;\
  BUFFER(n)[0]=0xff; BUFFER(n)[1]=0x00; BUFFER(n)[2]=0xff; \
  BUFFER(n)[sizeof(BUFFER(n))-1]=0xA0; \
  BUFFER(n)[sizeof(BUFFER(n))-2]=0x00; \
  BUFFER(n)[sizeof(BUFFER(n))-3]=0xA0; 
  
  INIT_BUFFER(0);
  INIT_BUFFER(1);
  INIT_BUFFER(2);
  INIT_BUFFER(3);

#undef BUFFER
#undef INIT_BUFFER
}

#ifndef ENABLE_USB
void DMA1_IRQHandler(){
  //One frame is sent!
  //TOCK();
  send_diff=sending_frame-last_sent_frame;
  last_sent_frame=sending_frame;
  sending_frame=loading_frame-1;
  
  uint8 t=last_frame_indicator; //This Ensures atomic operation
  CLEAR_LOCK(SLOCK_BASE);
  SET_LOCK(SLOCK_BASE, t);
  sending_buffer=buffer_ptr[t]-SIG_SIZE;
  
  sending_frame_indicator=t;
  
  DMA0->INT=DMA_INT_INT1_MASK;
  
  Bluetooth_SendDataChunkAsync( sending_buffer,
                               IMG_ROWS * VALID_COLS 
                               + EXTRA_INFO_SIZE
                               + 2 * SIG_SIZE );
}
#endif

#ifdef ENABLE_USB

void cam_usb(){
  //One frame is sent!
  //TOCK();
  if(!is_usr_usb_sending){
    //if the system is not currently sending.
    //current sending frame is complete
    last_sent_frame=sending_frame;
    if(last_sent_frame < loading_frame - 1){
      //if there is an unsent frame
      sending_frame=loading_frame-1;
      send_diff=sending_frame-last_sent_frame; 
      uint8 t=last_frame_indicator;//This Ensures atomic operation
      CLEAR_LOCK(SLOCK_BASE);
      SET_LOCK(SLOCK_BASE, t);
      sending_buffer=buffer_ptr[t]-SIG_SIZE;
      
      sending_frame_indicator=t;
      LPLD_USB_VirtualCom_Tx( sending_buffer,
                             IMG_ROWS * VALID_COLS
                               + EXTRA_INFO_SIZE 
                                 + 2 * SIG_SIZE );
      //LED2_Tog();
      //TICK();
    }
  }
}
#endif