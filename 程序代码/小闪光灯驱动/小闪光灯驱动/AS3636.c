#include "AS3636.h"
/**********************************************************************
* Name: AS3636 Xeon Flash Light Test
* Author: Huskie
* Date: 2020-10-25
* Notes:
*   1.Based on STC8 hardware I2C.
*   2.Just for flash test, ignore all interrupts.
*   
***********************************************************************/
/*--------------------------100us--------------------------------*/
void Delay100us(void)	{	//STC8@24.000MHz
	unsigned char i, j;

	i = 4;
	j = 27;
	do
	{
		while (--j);
	} while (--i);
}

/*--------------------------Srart charge--------------------------------*/
void Flash_Charge(void){
	Write_I2C_1Byte(AS3636_SLA, 0x07, 0x01);
}

/*---------------------------Read ready signal-------------------------------*/
bit Flash_Ready(void){
	unsigned char Xeon_Ctrl;
	Read_I2C_1Byte(AS3636_SLA, 0x07, &Xeon_Ctrl);
	return (Xeon_Ctrl & 0x02);
}

/*--------------------------Test flash--------------------------------*/
void Flash_Test(void){
	Write_I2C_1Byte(AS3636_SLA, 0x07, 0x04);
}

/*----------------------------Use STROBE signal to flash------------------------------*/
void Flash(void){
	STROBE = 1;
	Delay100us();
	STROBE = 0;
}

/*------------------------Get flash times----------------------------------*/
unsigned int Flash_LifeTime(void){
	unsigned char LifeTime[2];
	unsigned int LifeTime_SUM;
	Read_I2C_nBytes(AS3636_SLA, 0x0B, LifeTime, 2);
	LifeTime_SUM = (LifeTime[0]<<8) | LifeTime[1];
	return LifeTime_SUM;
}

/*-------------------------Self test---------------------------------*/
void Flash_SelfTest(void){
	Write_I2C_1Byte(AS3636_SLA, 0x04, 0x05);
}

/*--------------------------Reset chip--------------------------------*/
void Flash_Reset(void){
	STROBE = 0;
	Write_I2C_1Byte(AS3636_SLA, 0x04, 0x41);
}
