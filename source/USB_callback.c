#include "includes.h"
#ifdef ENABLE_USB
U8 usb_valid=0;
U8 is_usr_usb_sending=0;

extern U8 usb_confirmed;
void USB_RecieveCallback(void)
{
  usb_valid=1;
  LPLD_USB_QueueData();
#ifdef UART_CMD
  static u8 rxbuf[32];
  u8 len=LPLD_USB_VirtualCom_Rx(rxbuf);
  for(u8 i=0;i<len;i++)
    CMD_Handler(rxbuf[i]);
#endif 
}

void USB_SentCallback(void){
  //if(is_usr_usb_sending)ITM_EVENT32(4, processing_frame);
  is_usr_usb_sending=0;
  
}
#endif