/*
Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
Date : 2015/12/01
License : MIT
*/

#include "includes.h"


// ===== Setting =====
#define SERVO_MID 6900 // (g_bus_clock/64*15/10000)  Adjust it according to your mech


// ===== Variables =====

// --- Global ----

S16 tachoAccu;
S16 tacho0, tacho1;
S16 currdir=SERVO_MAX;
S16 currspd=10;

// --- Local ---
U16 tacho1_tmp,tacho0_tmp,ftm1cnt_last;
U16 tacho1_last,tacho0_last;
U8 tacho0_dir;


// ===== Local Function Decelaration =====

u8 Tacho0_Dir();
u8 Tacho1_Dir();


// ===== APIs Realization =====


void Servo_Output(s16 x){
  //x=-x;
  if(x>SERVO_MAX) x = SERVO_MAX;
  if(x<-SERVO_MAX) x = -SERVO_MAX;
  x = x * 22 / 60;
  FTM2->CONTROLS[0].CnV=SERVO_MID + x;
}

void MotorL_Output(s16 x){
  x=-x;
  if(x>MOTOR_MAX) x=MOTOR_MAX;
  if(x<-MOTOR_MAX) x=-MOTOR_MAX;
  if(x<0){
    FTM0->CONTROLS[5].CnV = -x;
    FTM0->CONTROLS[4].CnV = 0;
  }
  else if(x>0){
    FTM0->CONTROLS[5].CnV = 0;
    FTM0->CONTROLS[4].CnV = x;
  }
  else{
    FTM0->CONTROLS[4].CnV = 0;
    FTM0->CONTROLS[5].CnV = 0;
  }
}

void MotorR_Output(s16 x){
  if(x>MOTOR_MAX) x=MOTOR_MAX;
  if(x<-MOTOR_MAX) x=-MOTOR_MAX;
  if(x>0){
    FTM0->CONTROLS[6].CnV = x;
    FTM0->CONTROLS[7].CnV = 0;
  }
  else if(x<0){
    FTM0->CONTROLS[6].CnV = 0;
    FTM0->CONTROLS[7].CnV = -x;
  }
  else{
    FTM0->CONTROLS[6].CnV = 0;
    FTM0->CONTROLS[7].CnV = 0;
  }
}

void MotorL_Enable(u8 x){
  if(x)
    PTD->PSOR |= 1<<2;
  else
    PTD->PCOR |= 1<<2;
}
void MotorR_Enable(u8 x){
  if(x)
    PTD->PSOR |= 1<<3;
  else
    PTD->PCOR |= 1<<3;
}

// ------- Tacho -----

void Tacho0_Get(){
  static u16 tachoLast = 0;
  tacho0 = tachoAccu - tachoLast;
  tachoLast = tachoAccu;
}

u16 Tacho0_Renew(){
  if(tacho0_dir){
    tacho0_tmp -= FTM1->CNT-ftm1cnt_last;
    ftm1cnt_last = FTM1->CNT;
  }
  else{
    tacho0_tmp += FTM1->CNT-ftm1cnt_last;
    ftm1cnt_last = FTM1->CNT;
  }
  return tacho0_tmp;
}

//void Tacho1_Get(){
//  u16 tmp = tacho1_tmp;
//  tacho1 = tmp - tacho1_last;
//  tacho1_last = tmp;
//}



// --- INIT ---

void Motor_Init(){
  
  // Motor FTM 
  SIM->SCGC6|=SIM_SCGC6_FTM0_MASK;
  FTM0->SC|=FTM_SC_CLKS(1)|FTM_SC_PS(0);//PS16,System Clock
  FTM0->MOD=1000;//Max Value
  FTM0->CONTROLS[4].CnSC|=FTM_CnSC_MSB_MASK|FTM_CnSC_ELSB_MASK;
  FTM0->CONTROLS[5].CnSC|=FTM_CnSC_MSB_MASK|FTM_CnSC_ELSB_MASK;
  FTM0->CONTROLS[6].CnSC|=FTM_CnSC_MSB_MASK|FTM_CnSC_ELSB_MASK;
  FTM0->CONTROLS[7].CnSC|=FTM_CnSC_MSB_MASK|FTM_CnSC_ELSB_MASK;
  FTM0->CONTROLS[4].CnV=0;
  FTM0->CONTROLS[5].CnV=0;
  FTM0->CONTROLS[6].CnV=0;
  FTM0->CONTROLS[7].CnV=0;
  FTM0->POL = 0xff;
  
  PORTD->PCR[4]|=PORT_PCR_MUX(4);
  PORTD->PCR[5]|=PORT_PCR_MUX(4);
  PORTD->PCR[6]|=PORT_PCR_MUX(4);
  PORTD->PCR[7]|=PORT_PCR_MUX(4);
  
  // Motor enable
  PORTD->PCR[2] |= PORT_PCR_MUX(1);
  PORTD->PCR[3] |= PORT_PCR_MUX(1);
  PTD->PDDR |= (3<<2);
  PTD->PDOR |= (3<<2);
  
  
  // enable
  MotorL_Enable(1);
  MotorR_Enable(1);
}

void Tacho_Init(){
  SIM->SCGC6 |= SIM_SCGC6_FTM1_MASK;
  /* // Input Cap
  FTM1->SC|=FTM_SC_CLKS(1)|FTM_SC_PS(7);//PS16,System Clock /128
  FTM1->SC &= (~FTM_SC_CPWMS_MASK);
  FTM1->CONTROLS[0].CnSC=1<<2;
  FTM1->CONTROLS[1].CnSC=1<<2;
  PORTA->PCR[12] |= PORT_PCR_MUX(3);
  PORTA->PCR[13] |= PORT_PCR_MUX(3);
  */
  
  // QD for phase0
//  PORTA->PCR[12]|=PORT_PCR_MUX(7);
//  FTM1->MODE|=FTM_MODE_WPDIS_MASK;//Write protection disable
//  FTM1->QDCTRL|=FTM_QDCTRL_QUADMODE_MASK;
//  FTM1->CNTIN=0;
//  FTM1->MOD=0XFFFF;
//  FTM1->QDCTRL|=FTM_QDCTRL_QUADEN_MASK;
//  FTM1->MODE|=FTM_MODE_FTMEN_MASK;//let all registers available for use
//  FTM1->CNT=0;
  
  // IO interrupt for phase1
  PORTA->PCR[12]|=PORT_PCR_MUX(1);
  PTA->PDDR &=~(1<<12);
  PORTA->PCR[12] |= PORT_PCR_PE_MASK | PORT_PCR_PS_MASK | PORT_PCR_IRQC(10);	//PULLUP | falling edge
  NVIC_EnableIRQ(PORTA_IRQn);
  NVIC_SetPriority(PORTA_IRQn, NVIC_EncodePriority(NVIC_GROUP, 0, 2));
  
  //==== Tacho DIR ===
  PORTA->PCR[13] |= PORT_PCR_MUX(1);
  PTA->PDDR &=~(1<<13);
  PORTA->PCR[13] |= PORT_PCR_PE_MASK 
                  | PORT_PCR_PS_MASK;	//PULLUP | either edge
//  
  tacho0_dir = Tacho0_Dir();
  
  /*1
  SIM->SCGC5|=SIM_SCGC5_LPTIMER_MASK;
  PORTC->PCR[5] = PORT_PCR_MUX(4);
  //PORTA->PCR[19] = PORT_PCR_MUX(6);
  LPTMR0->PSR = LPTMR_PSR_PCS(0x1)|LPTMR_PSR_PBYP_MASK; 
  LPTMR0->CSR = LPTMR_CSR_TPS(2);
  LPTMR0->CSR = LPTMR_CSR_TMS_MASK;
  LPTMR0->CSR |= LPTMR_CSR_TFC_MASK;
  
  LPTMR0->CSR |= LPTMR_CSR_TEN_MASK;*/
}

void Servo_Init(){
  SIM->SCGC3|=SIM_SCGC3_FTM2_MASK;
  FTM2->SC|=FTM_SC_CLKS(1)|FTM_SC_PS(6);//PS16,System Clock /64
  FTM2->MOD=8000;//Max Value
  FTM2->CONTROLS[0].CnSC|=FTM_CnSC_MSB_MASK|FTM_CnSC_ELSB_MASK;
  FTM2->CONTROLS[0].CnV=SERVO_MID;
  FTM2->POL = 0xff;
  PORTB->PCR[18]|=PORT_PCR_MUX(3);
}


// ======== Basic Drivers ========

//---- Tacho dir ----
u8 Tacho0_Dir(void){
  return (PTA->PDIR>>13)&1;
}

u8 Tacho1_Dir(void){
  return (PTA->PDIR>>15)&1;
}


void PORTA_IRQHandler(){
if((PORTA->ISFR)&PORT_ISFR_ISF(1 << 12)){     // phase 1 
    PORTA->ISFR |= PORT_ISFR_ISF(1 << 12);
    if(Tacho0_Dir()) {
      tachoAccu++;
    } else {
      tachoAccu--;
    }
  }
}
