/*
Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
Date : 2015/12/01
License : MIT
*/

#include "includes.h"
/*
Adaptation Made By tripack
Implements UART_Buffer, ETC.
*/

#ifdef UART_RECIEVE_BUFFER
#define UART_BUFFER_SIZE 64
#define PREC(ptr) ((ptr + UART_BUFFER_SIZE -1) % UART_BUFFER_SIZE)
#define SUCC(ptr) ((ptr + 1) % UART_BUFFER_SIZE)

uint8 uart_buffer[UART_BUFFER_SIZE]={0}; //FIFO QUEUE
uint8 uart_top_ptr,uart_bot_ptr=0; //UART Buffer Pointer
#endif

#ifdef UART_RECIEVE_BUFFER
void UART_Push(uint8 data){

  if(SUCC(uart_top_ptr)==uart_bot_ptr)
    return;
  //The queue is already full!
  //We Will Start Losing DATA!!
  uart_top_ptr=SUCC(uart_top_ptr);
  uart_buffer[uart_top_ptr]=data;
}

uint8 UART_Pop(uint8 data){//FIFO out the data
  if(uart_top_ptr==uart_bot_ptr)
    return 0;
  uart_bot_ptr=SUCC(uart_bot_ptr);
  return uart_buffer[uart_bot_ptr];
}

uint8 UART_Available(){
  //Check if the queue is empty
  //If not empty, return the number of remaining terms
  return uart_top_ptr-uart_bot_ptr;
}
#endif
  

// === Receive ISR ===
void UART3_IRQHandler(void){
  uint8 tmp = UART_GetChar();
  
#ifdef UART_RECIEVE_BUFFER
  UART_Push(tmp);
#endif
  
#ifdef UART_CMD
  CMD_Handler(tmp);
#endif
  LED2_Tog();
  return;
}

#ifdef UART_CMD
void CMD_Handler(u8 cmd){
#define PKG_LENGTH 5
#define PKG_HEADER 0xAC
#define CMDACK 0xA0
#define CMDSET_SPD 0xB0
#define CMDSET_DIR 0xC0

  static u8 cmdbuf[PKG_LENGTH]={0};
  static u8 curr=0;
  
  if(cmd==PKG_HEADER){
    curr=0;
  }else if(curr==0)
    return;
  
  cmdbuf[curr]=cmd;
  curr++;
  
  if(curr==PKG_LENGTH){
    curr=0;
    u8 sum=0;
    for(u8 i=0;i<PKG_LENGTH-1;i++)
      sum+=cmdbuf[i];
      //validating checksum
    if(sum == cmdbuf[PKG_LENGTH-1]){
      //checksum valid, Executing
      int16 para=(uint16)((uint16)(cmdbuf[3]<<8)+(uint16)(cmdbuf[2]));
      //int16 para= (int16)( ((u16)cmdbuf[2])<<8 + ((u16)cmdbuf[3]));
      switch(cmdbuf[1]){
      case CMDACK:
        //ITM_EVENT16_WITH_PC(1,para);
        return;
        break;
      case CMDSET_SPD:
        //ITM_EVENT16_WITH_PC(2,para);
        return;
        break;
      case CMDSET_DIR:
        //ITM_EVENT16_WITH_PC(3,para);
        return;
        break;
      }
    }
  }
  return;
}
#endif

// ----- Basic Functions -----

// Read 
int8 UART_GetChar(){
  while(!(UART3->S1 & UART_S1_RDRF_MASK));
  return UART3->D;
}

// Send
void UART_SendChar(uint8 data){
  while(!(UART3->S1 & UART_S1_TDRE_MASK));
  UART3->D = data;
}

// Init
void UART_Init(u32 baud){
  //UART3
  
  uint16 sbr;
  uint32 busclock = g_bus_clock;

  SIM->SCGC4 |= SIM_SCGC4_UART3_MASK;
  
  PORTE->PCR[4] = PORT_PCR_MUX(3);
  PORTE->PCR[5] = PORT_PCR_MUX(3);
  UART3->C2 &= ~(UART_C2_TE_MASK | UART_C2_RE_MASK );  // DISABLE UART FIRST
  UART3->C1 = 0;  // NONE PARITY CHECK
  
  //UART baud rate = UART module clock / (16 ¡Á (SBR[12:0] + BRFD))
  // BRFD = BRFA/32; fraction
  sbr = (uint16)(busclock/(16*baud));
  UART3->BDH = (UART3->BDH & 0XC0)|(uint8)((sbr & 0X1F00)>>8);
  UART3->BDL = (uint8)(sbr & 0XFF);
  
  UART3->C4 = (UART3->C4 & 0XE0)|(uint8)((32*busclock)/(16*baud)-sbr*32); 

  UART3->C2 |=  UART_C2_RIE_MASK;
  
  UART3->C2 |= UART_C2_RE_MASK;
  
  UART3->C2 |= UART_C2_TE_MASK; 
  
  UART3->C2 &= ~UART_C2_TCIE_MASK; //Disable IRQ request
   
  NVIC_EnableIRQ(UART3_RX_TX_IRQn); 
  NVIC_SetPriority(UART3_RX_TX_IRQn, NVIC_EncodePriority(NVIC_GROUP, 2, 2));
}
  
void UART_DMASend_Start(){
  DMA0->TCD[1].CSR &= ~DMA_CSR_DONE_MASK; //Clear
  //DMA0->TCD[1].CSR = DMA_CSR_DREQ_MASK | DMA_CSR_INTMAJOR_MASK;//Auto Clear
  //DMA0->TCD[1].CSR |= DMA_CSR_START_MASK; //Start
  DMA0->ERQ |= DMA_ERQ_ERQ1_MASK ; //Sets off the transmission
}

void UART_SendDataChunk(u8* dataptr,uint16 size){
  DMA0->TCD[1].SADDR = (uint32_t)dataptr;
  DMA0->TCD[1].CITER_ELINKNO = DMA_CITER_ELINKNO_CITER(size);
  DMA0->TCD[1].BITER_ELINKNO = DMA_BITER_ELINKNO_BITER(size);
  UART_DMASend_Start();
}


void UART_Configure_DMA(){
  SIM->SCGC6 |= SIM_SCGC6_DMAMUX_MASK; //DMAMUX Clock Enable
  SIM->SCGC7 |= SIM_SCGC7_DMA_MASK; //DMA Clock Enable
  
  DMAMUX->CHCFG[1] |= DMAMUX_CHCFG_SOURCE(9); //RAM->UART3_Transmitting, request UART3
  
  DMA0->DCHPRI1 = DMA_DCHPRI1_CHPRI(0) | DMA_DCHPRI1_ECP_MASK; //This DMA Can be suspended by other DMAs
  
  DMA0->TCD[1].CSR = 0x00000000; //Clear
  DMA0->TCD[1].CSR = DMA_CSR_DREQ_MASK | DMA_CSR_INTMAJOR_MASK; //Auto Clear
  //DMA0->TCD[1].CSR &= ~DMA_CSR_INTMAJOR_MASK; //Disable Major Loop Int
  
  DMA0->TCD[1].ATTR = DMA_ATTR_SSIZE(0) | DMA_ATTR_DSIZE(0); //Source 8 bits, Aim 8 bits
  DMA0->TCD[1].NBYTES_MLNO = DMA_NBYTES_MLNO_NBYTES(1); //one byte each
  
  //DMA0->TCD[0].SADDR = (uint32_t)0; //Source Remains to Be put in!
  DMA0->TCD[1].SOFF = 1; //Source moving
  DMA0->TCD[1].SLAST = 0; //Last Source fixed
  
  DMA0->TCD[1].DADDR = (uint32_t)&UART3->D; //Destination 
  DMA0->TCD[1].DOFF = 0;
  DMA0->TCD[1].DLAST_SGA = 0;
  
  NVIC_EnableIRQ(DMA1_IRQn);
  NVIC_SetPriority(DMA1_IRQn, NVIC_EncodePriority(NVIC_GROUP, 2, 1));
  DMA0->INT |= DMA_INT_INT1_MASK; //Open Interrupt
  //DMA0->TCD[0].CITER_ELINKNO = DMA_CITER_ELINKNO_CITER(1);
  //DMA0->TCD[0].BITER_ELINKNO = DMA_BITER_ELINKNO_BITER(1);
  
  //DMA->ERQ&=~DMA_ERQ_ERQ0_MASK;//Clear Disable
  DMAMUX->CHCFG[1] |= DMAMUX_CHCFG_ENBL_MASK; //Enable
  
}

void UART_SetMode(uint8 mode){
  switch(mode){
  case UART_MODE_DMA_MANNUAL:
    UART3->C2 &= ~UART_C2_TE_MASK; //Disable Transmission
      UART3->C2 &= ~UART_C2_TCIE_MASK; //Disable IRQ request
      UART3->C5 |= UART_C5_TDMAS_MASK; //Enable DMA request
      UART3->C2 |= UART_C2_TIE_MASK; //Enable UART to send IRQ or DMA request
      DMA0->TCD[1].CSR = DMA_CSR_DREQ_MASK; //Reset DMA_Control-Status-Register
    UART3->C2 |= UART_C2_TE_MASK; //Enables Transmission
    break;
  case UART_MODE_DMA_CONTINUOUS:
    UART3->C2 &= ~UART_C2_TE_MASK; //Disable Transmission
      UART3->C2 &= ~UART_C2_TCIE_MASK; //Disable IRQ request
      UART3->C5 |= UART_C5_TDMAS_MASK; //Enable DMA request
      UART3->C2 |= UART_C2_TIE_MASK; //Enable UART to send IRQ or DMA request
      DMA0->TCD[1].CSR = DMA_CSR_DREQ_MASK | DMA_CSR_INTMAJOR_MASK;
      //Reset DMA_Control-Status-Register, Enable Major-Loop-Interupt
    UART3->C2 |= UART_C2_TE_MASK; //Enables Transmission
    DMA1_IRQHandler();
    break;
  case UART_MODE_MANNUAL:
    UART3->C2 &= ~UART_C2_TE_MASK; //Disable Transmission
      UART3->C2 &= ~UART_C2_TCIE_MASK; //Disable IRQ request
      UART3->C2 &= ~UART_C2_TIE_MASK; //Disable UART to send IRQ or DMA request
      UART3->C5 &= ~UART_C5_TDMAS_MASK; //Enable DMA request
      //Reset DMA_Control-Status-Register, Enable Major-Loop-Interupt
    UART3->C2 |= UART_C2_TE_MASK; //Enables Transmission
    break;    
  }
}
    
