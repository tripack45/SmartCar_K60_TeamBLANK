#ifndef IMU_H
#define IMU_H

// ===== Module Setting =====
  
  // set this module to use ADC0 or ADC1
  // No need to change usually
#define GYRO_ADCx 1  // 0 : use ADC0 ; 1 : use ADC1


// ===== Global  Variables =====

extern S16 accx, accy, accz;
extern S16 gyro1, gyro2;



// ======== APIs ========

  //  Return  accelerators'  values 
#define Accx() LPLD_MMA8451_GetResult(MMA8451_STATUS_X_READY, MMA8451_REG_OUTX_MSB)
#define Accy() LPLD_MMA8451_GetResult(MMA8451_STATUS_Y_READY, MMA8451_REG_OUTX_MSB)
#define Accz() LPLD_MMA8451_GetResult(MMA8451_STATUS_Z_READY, MMA8451_REG_OUTX_MSB)

  //  Return Gyroscopes' values
s16 Gyro1();
s16 Gyro2();

  // Init
void Gyro_Init();

#endif