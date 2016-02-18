

#ifndef _COMMON_H_
#define _COMMON_H_


typedef unsigned char	uint8;  /*  8 bits */
typedef unsigned short int	uint16; /* 16 bits */
typedef unsigned long int	uint32; /* 32 bits */

typedef signed char		int8;   /*  8 bits */
typedef short int	        int16;  /* 16 bits */
typedef int		        int32;  /* 32 bits */

typedef volatile int8		vint8;  /*  8 bits */
typedef volatile int16	vint16; /* 16 bits */
typedef volatile int32	vint32; /* 32 bits */

typedef volatile uint8	vuint8;  /*  8 bits */
typedef volatile uint16	vuint16; /* 16 bits */
typedef volatile uint32	vuint32; /* 32 bits */

typedef float   		float32; /*  32 bits */
typedef double   		float64; /*  64 bits */

typedef unsigned char   boolean;      /* 8-bit*/

#ifdef	FALSE
#undef	FALSE
#endif
#define FALSE	0

#ifdef	TRUE
#undef	TRUE
#endif
#define	TRUE	1

#ifndef NULL
#define NULL    0
#endif

/********************************************************************/


#include "k60_card.h"

#include "MK60DZ10.h"

#include "relocate.h"

#if (defined(__IAR_SYSTEMS_ICC__))
	#include "intrinsics.h"
#endif

#include "LPLD_Drivers.h"


/***********************************************************************/
/* 
 * �ж���غ�������
 */
//ʹ��ȫ���жϺ궨��
#define EnableInterrupts __enable_irq()
//����ȫ���жϺ궨��
#define DisableInterrupts  __disable_irq()
//ʹ��ָ���ж������ŵ��ж�
#define enable_irq(IRQn)    NVIC_EnableIRQ(IRQn)
//����ָ���ж������ŵ��ж�
#define disable_irq(IRQn)    NVIC_DisableIRQ(IRQn)
//�����ж��������ַ��дVTOR�Ĵ���
#define write_vtor(vector_addr) SCB->VTOR = (uint32_t)vector_addr;
/***********************************************************************/

void main(void);


/********************************************************************/

#endif /* _COMMON_H_ */
