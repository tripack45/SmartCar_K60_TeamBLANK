#include "includes.h"

void Bluetooth_Configure(){
  Oled_Clear();
  Oled_Putstr(1,0,"Bluetooth Configure!");
  Oled_Putstr(6,0,"Press Key1 to Cont.");
  while(Key1());while(!Key1());
  Oled_Clear();
  Oled_Putstr(1,0,"Sending T");
  //for(;;)Bluetooth_WriteStr("Test");
  Oled_Clear();
}

void Bluetooth_SendDataChunkSync(uint8* chunk_ptr, uint16 size){
    UART_SendDataChunk(chunk_ptr,size);
    while(!(IS_UART_DMA_COMPLETE() && IS_UART_SEND_COMPLETE()));
    
}

void Bluetooth_SendDataChunkAsync(uint8* chunk_ptr, uint16 size){
    UART_SendDataChunk(chunk_ptr, (uint16)size);
}

int Bluetooth_IsSendDataChunkComplete(){
  return IS_UART_DMA_COMPLETE() && IS_UART_SEND_COMPLETE();
}

void Bluetooth_SendDataChunkObselete(u8* chunk_ptr,uint16 size){
  for(int i=0;i<size;i++){
    while(!(UART3->S1 & UART_S1_TDRE_MASK));
    UART3->D = *chunk_ptr;
    chunk_ptr++;
  }
}

void Bluetooth_SendStr(char* str){
  char* p=str;
  while(*p!='\0'){
    UART_SendChar(*p);
    p++;
  }
  UART_SendChar('\r');
  UART_SendChar('\n');
}
  
