#ifndef CAM_H
#define CAM_H

// ===== Settings =====
// the camera has about 300 rows and 400 cols ,
// but we can not handle that much ,
// so we get 1 row of image for every IMG_STEP rows of camera ,
// and totally get IMG_ROWS rows.

#define IMG_ROWS 67
#define IMG_COLS 77
#define IMG_STEP 4


// ====== Global Variables ======

extern int processing_frame; //Currently processing frame
extern int loading_frame; //Currently loading frame
extern int sending_frame; //Currently sending frame
extern int last_processed_frame, last_sent_frame;

extern int process_diff,load_diff,send_diff;

extern u8  *sending_buffer;
extern u8  (*loading_buffer)[IMG_COLS];
extern u8  (*img_buffer)[IMG_COLS]; 

extern u8 current_frame_indicator; //Indicates buffer being loaded
extern u8 last_frame_indicator;    //Indicates last loaded buffer
extern u8 processing_frame_indicator;//frame_currently being processed
extern u8 sending_frame_indicator; //sending frame indicator

// ===== APIs ======

  // write your algorithm in this func
void Cam_Algorithm();
extern void cam_usb();
  // Init
void Cam_Init();


#endif