#ifndef FLASH_H
#define FLASH_H

#include "typedef.h"


// ===== Settings =====

  // ADDR : the address to save data
#define ADDR 0x0003C000

  // SECTOR_SIZE : sector is the minimal unit of flash to be writen.
#define SECTOR_SIZE 0x200

  // DATA_NUM : the num of datas(U16 or S16) you need.
#define DATA_NUM 16


// ===== Global Variables =====

extern U16 flashData[DATA_NUM];

  // data[0] is reserved. 
  // Every time writting to the Flash, data_flag is set to 1.
  // So when it's not 1, it means the Flash lose its datas.
#define data_flag                   (flashData[ 0])

  // define aliases for your datas ( Here's mine for example)
#define NONE1                       (flashData[ 1])
#define F_RADIUS_MIN                (flashData[ 2])
#define F_RADIUS_MAX                (flashData[ 3])
#define F_OFFSET_THRES              (flashData[ 4])
#define F_OFFSET_DIR_RATIO          (flashData[ 5])
#define F_LINE_LOWSPD               (flashData[ 6])
#define F_LINE_HIGHSPD              (flashData[ 7])
#define F_STRAIGHT_MSE_CRIT         (flashData[ 8])
#define DBG_PTR                     (flashData[ 9])
#define F_SPDPID_I                  (flashData[10])
#define F_SPDEXP_SEN                (flashData[11])
#define F_SPDPID_P                  (flashData[12])
#define F_SPDPID_D                  (flashData[13])
#define SAVE_VAR                    (flashData[14])
#define STEPLENGTH                  (flashData[15])


// ======= APIs =======

  // Write data[] to certain sector of flash.
void Flash_Write(U16 sector);

  // Read certain data of certain sector in flash.
U16 Flash_Read(U16 sector,U16 data_index);

  // Load data_initial[] to data[], then write to flash in sector 0.
void Flash_Data_Reset(void);

  // Load datas in sector 0 of flash to data[]
void Flash_Data_Update(U16 sector);

  // Init
void Flash_Init(void);



// ======= Basic Drivers ======

  // Erase certain sector
U8 Flash_Erase(U16);

U8 Flash_Program(U16, U16 WriteCounter, U16 *DataSource);

static U8 FlashCMD(void);


  //Flash命令宏定义
#define RD1BLK    0x00   // 读整块Flash
#define RD1SEC    0x01   // 读整个扇区
#define PGMCHK    0x02   // 写入检查
#define RDRSRC    0x03   // 读目标数据
#define PGM4      0x06   // 写入长字
#define ERSBLK    0x08   // 擦除整块Flash
#define ERSSCR    0x09   // 擦除Flash扇区
#define PGMSEC    0x0B   // 写入扇区
#define RD1ALL    0x40   // 读所有的块
#define RDONCE    0x41   // 只读一次
#define PGMONCE   0x43   // 只写一次
#define ERSALL    0x44   // 擦除所有块
#define VFYKEY    0x45   // 验证后门访问钥匙
#define PGMPART   0x80   // 写入分区
#define SETRAM    0x81   // 设定FlexRAM功能


#endif
