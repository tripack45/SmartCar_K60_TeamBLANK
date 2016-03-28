#ifndef NEWDETECTBOUNDARY_H
#define NEWDETECTBOUNDARY_H


#define TRUE              1
#define FALSE             0
#define DIS_ROW           4
#define DIS_COL           3
#define MZ                0
#define LBEGIN_SCAN       DIS_COL
#define LEND_SCAN         IMG_COLS / 2
#define WHITE_THRES       60
#define START_LINE_HEIGHT 10
#define BOUNDARY_LENGTH   300
#define DIR_LEFT          0
#define DIR_UP            1
#define DIR_RIGHT         2
#define DIR_DOWN          3

typedef struct NewBoundaryDectectorConf{
    //========INPUTS==========
    //image_buffer
    //=======OUTPUS==========
    u8 boundary[BOUNDARY_LENGTH][2];
    u8 LSectionHead;
    u8 LSectionTail;
    u8 RSectionHead;
    u8 RSectionTail;
}NewBoundaryDetector;

void NewDetectBoundary();
u8 GuideLoc(u8 pointrow,u8 pointcol);

extern NewBoundaryDetector Newboundary_detector;


#endif
