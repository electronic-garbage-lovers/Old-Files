
#ifndef _DISPLAY_EPD_W21_H_
#define _DISPLAY_EPD_W21_H_
#include "stm32f10x.h"

#define EPD_W21_WRITE_DATA 1
#define EPD_W21_WRITE_CMD  0


#define EPD_W21_SPI_SPEED 0x02



#define EPD_W21_MOSI_0	GPIO_ResetBits(GPIOD, GPIO_Pin_10)
#define EPD_W21_MOSI_1	GPIO_SetBits(GPIOD, GPIO_Pin_10)

#define EPD_W21_CLK_0	GPIO_ResetBits(GPIOD, GPIO_Pin_9)
#define EPD_W21_CLK_1	GPIO_SetBits(GPIOD, GPIO_Pin_9)

#define EPD_W21_CS_0	GPIO_ResetBits(GPIOD, GPIO_Pin_8)
#define EPD_W21_CS_1	GPIO_SetBits(GPIOD, GPIO_Pin_8)

#define EPD_W21_DC_0	GPIO_ResetBits(GPIOE, GPIO_Pin_15)
#define EPD_W21_DC_1	GPIO_SetBits(GPIOE, GPIO_Pin_15)

#define EPD_W21_RST_0	GPIO_ResetBits(GPIOE, GPIO_Pin_14)
#define EPD_W21_RST_1	GPIO_SetBits(GPIOE, GPIO_Pin_14)

#define EPD_W21_BS_0	GPIO_ResetBits(GPIOE, GPIO_Pin_11)


#define isEPD_W21_BUSY GPIO_ReadOutputDataBit(GPIOE, GPIO_Pin_13) // for solomen solutions





void EPD_W21_POWERON(void);
void EPD_W21_Update(void);
void EPD_W21_EnableChargepump(void);
void EPD_W21_DisableChargepump(void);
void EPD_W21_WirteLUT(unsigned char *LUTvalue);
void EPD_W21_SetRamPointer(unsigned char addrX,unsigned char addrY,unsigned char addrY1);
void EPD_W21_SetRamArea(unsigned char Xstart,unsigned char Xend,
						unsigned char Ystart,unsigned char Ystart1,unsigned char Yend,unsigned char Yend1);


void EPD_W21_Update1(void);

void EPD_W21_Init(void);

void EPD_W21_UpdataDisplay(unsigned char *imgbuff,unsigned char xram,unsigned int yram);
void  part_display(unsigned char RAM_XST,unsigned char RAM_XEND,unsigned char RAM_YST,unsigned char RAM_YST1,unsigned char RAM_YEND,unsigned char RAM_YEND1);

void EPD_W21_WriteDispRam(unsigned char XSize,unsigned int YSize,
							unsigned char *Dispbuff);

void EPD_W21_WriteDispRamMono(unsigned char XSize,unsigned int YSize,
							unsigned char dispdata);
#endif
/***********************************************************
						end file
***********************************************************/


