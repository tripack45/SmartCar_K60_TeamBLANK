#ifndef USB_CALLBACK_H
#define USB_CALLBACK_H
#include "typedef.h"

extern U8 is_usr_usb_sending;
extern U8 usb_valid;
extern void USB_RecieveCallback(void);
extern void USB_SentCallback(void);

#endif