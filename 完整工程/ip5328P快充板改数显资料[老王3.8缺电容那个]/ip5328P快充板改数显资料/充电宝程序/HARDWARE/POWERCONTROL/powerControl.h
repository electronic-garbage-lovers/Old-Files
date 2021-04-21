#ifndef __POWER_CONTROL_H__
#define __POWER_CONTROL_H__

#include "stm32f10x.h"
#include "sys.h"

#define power_on          GPIO_ResetBits(GPIOB,GPIO_Pin_15)
#define power_read        GPIO_ReadInputDataBit(GPIOB,GPIO_Pin_14)

void powerControl_init(void);
void power_off(void);


#endif





