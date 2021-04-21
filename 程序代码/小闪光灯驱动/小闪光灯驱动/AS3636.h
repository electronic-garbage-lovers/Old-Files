#ifndef _AS3636_H_
#define _AS3636_H_

#include "i2c.h"

#define AS3636_SLA 0x50

sbit STROBE = P0^2;  //Flash trigger signal

void Flash_Charge(void);
bit Flash_Ready(void);
void Flash_Test(void);
void Flash(void);
unsigned int Flash_LifeTime(void);
void Flash_SelfTest(void);
void Flash_Reset(void);

#endif
