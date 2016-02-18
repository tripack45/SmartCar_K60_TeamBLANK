/**
 * @file system_MK60DZ10.c
 * @version 1.2.1[By LPLD]
 * @date 2013-06-18
 * @brief MK60DZ10ϵ�е�Ƭ��ϵͳ�����ļ�
 *
 * ���Ľ���:��ֹ�޸�
 *
 * �ô����ṩϵͳ���ú����Լ�һ������ϵͳ��Ƶ��ȫ�ֱ�����
 * ���ú�����Ҫ������ϵͳ��ģ���ʱ�ӡ�
 * ���뻹ʵ�ֳ�����ϵͳ�жϺ�����
 *
 * ��Ȩ����:�����������µ��Ӽ������޹�˾
 * http://www.lpld.cn
 * mail:support@lpld.cn
 *
 * @par
 * ����������������[LPLD]������ά������������ʹ���߿���Դ���롣
 * �����߿���������ʹ�û��Դ���롣�����μ�����ע��Ӧ���Ա�����
 * ���ø��Ļ�ɾ��ԭ��Ȩ���������������ο����߿��Լ�ע���ΰ�Ȩ�����ߡ�
 * ��Ӧ�����ش�Э��Ļ����ϣ�����Դ���롢���ó��۴��뱾��
 * �������²���������ʹ�ñ��������������κ��¹ʡ��������λ���ز���Ӱ�졣
 * ����������������͡�˵��������ľ���ԭ�����ܡ�ʵ�ַ�����
 * ������������[LPLD]��Ȩ�������߲��ý�������������ҵ��Ʒ��
 *
 *  Modified by Qian Qiyang(KisaragiAyanoo@twitter)
 *  Date : 2015/12/01
 */

#include <stdint.h>
#include "common.h"

#include "OLED.h"
#include "Setting.h"

/*----------------------------------------------------------------------------
  ����ʱ�����ֵ
 *----------------------------------------------------------------------------*/
#define CPU_XTAL_CLK_HZ                 50000000u       //�ⲿ��Դ����Ƶ�ʣ���λHz
#define CPU_XTAL32k_CLK_HZ              32768u          //�ⲿ32kʱ�Ӿ���Ƶ�ʣ���λHz    
#define CPU_INT_SLOW_CLK_HZ             32768u          //�����ڲ�������ֵ����λHz
#define CPU_INT_FAST_CLK_HZ             4000000u        //�����ڲ�������ֵ����λHz
#define DEFAULT_SYSTEM_CLOCK            100000000u      //Ĭ��ϵͳ��Ƶ����λHz

/**
 * @brief ϵͳ��Ƶ����λHz��
 */
uint32_t SystemCoreClock = DEFAULT_SYSTEM_CLOCK;



void SystemInit (void) {
  
  SIM->SCGC5 |= (SIM_SCGC5_PORTA_MASK
              | SIM_SCGC5_PORTB_MASK
              | SIM_SCGC5_PORTC_MASK
              | SIM_SCGC5_PORTD_MASK
              | SIM_SCGC5_PORTE_MASK );
  
  WDOG->UNLOCK = (uint16_t)0xC520u;
  WDOG->UNLOCK  = (uint16_t)0xD928u; 
  /* WDOG_STCTRLH: ??=0,DISTESTWDOG=0,BYTESEL=0,TESTSEL=0,TESTWDOG=0,??=0,STNDBYEN=1,WAITEN=1,STOPEN=1,DBGEN=0,ALLOWUPDATE=1,WINEN=0,IRQRSTEN=0,CLKSRC=1,WDOGEN=0 */
  WDOG->STCTRLH = (uint16_t)0x01D2u;
  
  common_relocate();
  
  LPLD_PLL_Setup(CORE_CLK_MHZ);
  
  SystemCoreClockUpdate();
  
  g_core_clock = SystemCoreClock;
  g_bus_clock = g_core_clock / ((uint32_t)((SIM->CLKDIV1 & SIM_CLKDIV1_OUTDIV2_MASK) >> SIM_CLKDIV1_OUTDIV2_SHIFT)+ 1u);
  g_flexbus_clock =  g_core_clock / ((uint32_t)((SIM->CLKDIV1 & SIM_CLKDIV1_OUTDIV3_MASK) >> SIM_CLKDIV1_OUTDIV3_SHIFT)+ 1u);
  g_flash_clock =  g_core_clock / ((uint32_t)((SIM->CLKDIV1 & SIM_CLKDIV1_OUTDIV4_MASK) >> SIM_CLKDIV1_OUTDIV4_SHIFT)+ 1u);
  
  // ==== Init Oled ===
  
  Oled_Init();
  Oled_Putstr(1,3,"<< Clock Init >>");
  Oled_Putstr(2,1,"Bus Clk");
  Oled_Putnum(2,9,g_bus_clock/1000000);
  Oled_Putstr(2,18,"MHz");
  Oled_Putstr(3,1,"UART Speed");
  Oled_Putstr(4,1,"None:115200");
  Oled_Putstr(5,1,"SW2:921600");
  Oled_Putstr(6,1,"SW3:460800");
  
  
  NVIC_SetPriorityGrouping(NVIC_GROUP);
}

void SystemCoreClockUpdate (void) {
  uint32_t temp;
  temp =  CPU_XTAL_CLK_HZ *((uint32_t)(MCG->C6 & MCG_C6_VDIV_MASK) + 24u );
  temp = (uint32_t)(temp/((uint32_t)(MCG->C5 & MCG_C5_PRDIV_MASK) +1u ));
  SystemCoreClock = temp;
}




