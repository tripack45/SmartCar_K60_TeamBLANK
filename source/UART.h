#ifndef UART_H
#define UART_H


// ====== APIs ======

// ---- Ayano's Format ----
void UART_SendDataHead();
void UART_SendData(s16 data);


// ---- Basic ----

void UART_Init(u32);
int8 UART_GetChar();
void UART_SendChar(uint8 data);
void UART_Configure_DMA();
void UART_DMASend_Start();
void UART_SendDataChunk(u8* dataptr,uint16 size);

void UART_SetMode(uint8);

#define UART_MODE_DMA_MANNUAL 0x01
#define UART_MODE_MANNUAL 0x02
#define UART_MODE_DMA_CONTINUOUS 0x03

#define IS_UART_DMA_COMPLETE() ((DMA0->TCD[1].CSR) & (DMA_CSR_DONE_MASK)) 
#define IS_UART_SEND_COMPLETE()  ((UART3->S1) & (UART_S1_TC_MASK))

#ifdef UART_CMD
void CMD_Handler(u8);
#endif 

#endif