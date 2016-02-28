#include "includes.h"
#ifdef ENABLE_USB
U8 usb_valid=0;
U8 is_usr_usb_sending=0;

extern U8 usb_confirmed;
void USB_RecieveCallback(void)
{
  usb_valid=1;
  LPLD_USB_QueueData();
}

void USB_SentCallback(void){
  if(is_usr_usb_sending){
  ITM_EVENT32(4, processing_frame);
  is_usr_usb_sending=0;
  //cam_usb();
  }
}
#endif