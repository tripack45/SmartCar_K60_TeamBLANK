/*
Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
Date : 2015/12/01
License : MIT
*/


#include "includes.h"


// ===== Global Variables =====

S16 accx, accy, accz;
S16 gyro1, gyro2;



// ===== API Realization =====

s16 Gyro1(){
#if GYRO_ADCx
  ADC1->SC1[0] = ADC_SC1_ADCH(8);
  while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
  return ADC1->R[0];
#else
  ADC0->SC1[0] = ADC_SC1_ADCH(8);
  while((ADC0->SC1[0]&ADC_SC1_COCO_MASK)==0);
  return ADC0->R[0];
#endif
}

s16 Gyro2(){
#if GYRO_ADCx
  ADC1->SC1[0] = ADC_SC1_ADCH(9);
  while((ADC1->SC1[0]&ADC_SC1_COCO_MASK)==0);
  return ADC1->R[0];
#else
  ADC0->SC1[0] = ADC_SC1_ADCH(9);
  while((ADC0->SC1[0]&ADC_SC1_COCO_MASK)==0);
  return ADC0->R[0];
#endif
}


void Gyro_Init(){
  
  if(!ADC1_enabled){
    SIM->SCGC3 |= SIM_SCGC3_ADC1_MASK;  //ADC1 Clock Enable
    ADC1->CFG1 |= 0
               //|ADC_CFG1_ADLPC_MASK
               | ADC_CFG1_ADICLK(1)
               | ADC_CFG1_MODE(1)
               | ADC_CFG1_ADIV(0);
    ADC1->CFG2 |= //ADC_CFG2_ADHSC_MASK |
                  ADC_CFG2_ADACKEN_MASK;
    ADC1_enabled = 1;
  }
}