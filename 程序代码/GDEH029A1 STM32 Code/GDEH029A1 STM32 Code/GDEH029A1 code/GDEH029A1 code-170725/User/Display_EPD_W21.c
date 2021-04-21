/***********************************************************
Copyright(C), Yk Technology
FileName	: 
Author		: Yukewantong, Zhongxiaodong
Date		  	: 2011/12/22
Description	: 
Version		: V1.0
History		: 
--------------------------------
2011/12/22: created
2012/02/29: update the pvi's waveform(20C) as default
2012/03/18: update the EPD initinal step, add function-->
			void EPD_W21_PowerOnInit(void)
***********************************************************/
#include "Display_EPD_W21.h"

unsigned char GDOControl[]={0x01,0x27,0x01,0x00}; //for 2.9inch
unsigned char softstart[]={0x0c,0xd7,0xd6,0x9d};
unsigned char Rambypass[] = {0x21,0x8f};		// Display update
unsigned char MAsequency[] = {0x22,0xf0};		// clock 
unsigned char GDVol[] = {0x03,0x00};	// Gate voltage +15V/-15V
unsigned char SDVol[] = {0x04,0x0a};	// Source voltage +15V/-15V
unsigned char VCOMVol[] = {0x2c,0xa8};	// VCOM 7c
unsigned char BOOSTERFB[] = {0xf0,0x1f};	// Source voltage +15V/-15V
unsigned char DummyLine[] = {0x3a,0x1a};	// 4 dummy line per gate
unsigned char Gatetime[] = {0x3b,0x08};	// 2us per line
unsigned char BorderWavefrom[] = {0x3c,0x33};	// Border
unsigned char RamDataEntryMode[] = {0x11,0x01};	// Ram data entry mode

static void driver_delay_us(unsigned int xus)
{
	for(;xus>1;xus--);
}

static void driver_delay_xms(unsigned long xms)	
{	
    unsigned long i = 0 , j=0;

    for(j=0;j<xms;j++)
	{
        for(i=0; i<256; i++);
    }
}
//-------------------------------------------------------
//Func	: EPD_W21_UpdataDisplay
//Desc	: updata the display 
//Input	:
//Output: 
//Return: 
//Author: 
//Date	: 2012/3/13
//-------------------------------------------------------
void SPI_Delay(unsigned char xrate)
{
	unsigned char i;
	while(xrate)
	{
		for(i=0;i<EPD_W21_SPI_SPEED;i++);
		xrate--;
	}
}


void SPI_Write(unsigned char value)                                    
{                                                           
    unsigned char i;

	
	SPI_Delay(1);
    for(i=0; i<8; i++)   
    {
        EPD_W21_CLK_0;
		SPI_Delay(1);
        if(value & 0x80)
        	EPD_W21_MOSI_1;
        else
        	EPD_W21_MOSI_0;		
        value = (value << 1); 
		SPI_Delay(1);
		driver_delay_us(1);
        EPD_W21_CLK_1; 
        SPI_Delay(1);
    }
}

void EPD_W21_WriteCMD(unsigned char command)
{
    SPI_Delay(1);
    EPD_W21_CS_0;                   
	EPD_W21_DC_0;		// command write
	SPI_Write(command);
	EPD_W21_CS_1;
}
void EPD_W21_WriteDATA(unsigned char command)
{
    SPI_Delay(1);
    EPD_W21_CS_0;                   
	EPD_W21_DC_1;		// command write
	SPI_Write(command);
	EPD_W21_CS_1;
}
	
void EPD_W21_WriteCMD_p1(unsigned char command,unsigned char para)
{
	while(isEPD_W21_BUSY == 1);	// wait	

    EPD_W21_CS_0;                   
	EPD_W21_DC_0;		// command write
	SPI_Write(command);
	EPD_W21_DC_1;		// command write
	SPI_Write(para);
	EPD_W21_CS_1;
}

void EPD_W21_WriteCMD_p2(unsigned char command,unsigned char para1,unsigned char para2)
{
	while(isEPD_W21_BUSY == 1);	// wait	

    EPD_W21_CS_0;                   
	EPD_W21_DC_0;		// command write
	SPI_Write(command);
	EPD_W21_DC_1;		// command write
	SPI_Write(para1);
	SPI_Write(para2);
	EPD_W21_CS_1;
} 
void EPD_W21_Write(unsigned char *value, unsigned char datalen)
{
	unsigned char i = 0;
	unsigned char *ptemp;
	
	ptemp = value;
	//DebugInfo("write data or command\n");	

    EPD_W21_CS_0;                   	
	EPD_W21_DC_0;		// command write
	
	SPI_Write(*ptemp);
	ptemp++;

	EPD_W21_DC_1;		// data write
	
	for(i= 0;i<datalen-1;i++)	// sub the command
	{
		SPI_Write(*ptemp);
		ptemp++;
	}

	EPD_W21_CS_1;

}
void EPD_W21_WriteDispRam(unsigned char XSize,unsigned int YSize,
							unsigned char *Dispbuff)
{
	int i = 0,j = 0;

	if(XSize%8 != 0)
	{
		XSize = XSize+(8-XSize%8);
	}
	XSize = XSize/8;

	while(isEPD_W21_BUSY == 1);	// wait	
	
    EPD_W21_CS_0;                   
	EPD_W21_DC_0;		// command write
	SPI_Write(0x24);
	
	EPD_W21_DC_1;		// data write
	for(i=0;i<YSize;i++)
	{
		for(j=0;j<XSize;j++)
		{
			SPI_Write(*Dispbuff);
			Dispbuff++;
		}
	}
	
	EPD_W21_CS_1;
}

void EPD_W21_WriteDispRamMono(unsigned char XSize,unsigned int YSize,
							unsigned char dispdata)
{
	int i = 0,j = 0;

	if(XSize%8 != 0)
	{
		XSize = XSize+(8-XSize%8);
	}
	XSize = XSize/8;
	while(isEPD_W21_BUSY == 1);	// wait	

    EPD_W21_CS_0;                   
	EPD_W21_DC_0;		// command write
	SPI_Write(0x24);
	
	EPD_W21_DC_1;		// data write
	for(i=0;i<YSize;i++)
	{
		for(j=0;j<XSize;j++)
		{
		 SPI_Write(dispdata);
		}
	}
	
	EPD_W21_CS_1;
}
/*
void EPD_W21_UpdataDisplay(unsigned char *imgbuff)
{
	EPD_W21_WriteDispRam(128, 296, imgbuff);
	//EPD_W21_WriteRAM();	
	EPD_W21_Update();
}
*/
 void EPD_W21_POWERON(void)
{
	EPD_W21_WriteCMD_p1(0x22,0xc0);
	EPD_W21_WriteCMD(0x20);
	//EPD_W21_WriteCMD(0xff);
}
void EPD_W21_POWEROFF(void)
{  	EPD_W21_WriteCMD_p1(0x22,0xc3);
	EPD_W21_WriteCMD(0x20);
//	EPD_W21_WriteCMD(0xff);
}
void part_display(unsigned char RAM_XST,unsigned char RAM_XEND,unsigned char RAM_YST,unsigned char RAM_YST1,unsigned char RAM_YEND,unsigned char RAM_YEND1)
 {    EPD_W21_SetRamArea(RAM_XST,RAM_XEND,RAM_YST,RAM_YST1,RAM_YEND,RAM_YEND1);  	/*set w h*/
      EPD_W21_SetRamPointer (RAM_XST,RAM_YST,RAM_YST1);		 /*set orginal*/
 }
void EPD_W21_UpdataDisplay(unsigned char *imgbuff,unsigned char xram,unsigned int yram)
{
	EPD_W21_WriteDispRam(xram, yram, imgbuff);
//	EPD_W21_Update();
}
void EPD_W21_SetRamArea(unsigned char Xstart,unsigned char Xend,
						unsigned char Ystart,unsigned char Ystart1,unsigned char Yend,unsigned char Yend1)
{
    unsigned char RamAreaX[3];	// X start and end
	unsigned char RamAreaY[5]; 	// Y start and end
	RamAreaX[0] = 0x44;	// command
	RamAreaX[1] = Xstart;
	RamAreaX[2] = Xend;
	RamAreaY[0] = 0x45;	// command
	RamAreaY[1] = Ystart;
	RamAreaY[2] = Ystart1;
	RamAreaY[3] = Yend;
    RamAreaY[4] = Yend1;
	EPD_W21_Write(RamAreaX, sizeof(RamAreaX));
	EPD_W21_Write(RamAreaY, sizeof(RamAreaY));
}
void EPD_W21_SetRamPointer(unsigned char addrX,unsigned char addrY,unsigned char addrY1)
{
    unsigned char RamPointerX[2];	// default (0,0)
	unsigned char RamPointerY[3]; 	
	RamPointerX[0] = 0x4e;
	RamPointerX[1] = addrX;
	RamPointerY[0] = 0x4f;
	RamPointerY[1] = addrY;
	RamPointerY[2] = addrY1;
	
	EPD_W21_Write(RamPointerX, sizeof(RamPointerX));
	EPD_W21_Write(RamPointerY, sizeof(RamPointerY));
}
//=========================functions============================

//-------------------------------------------------------
//Func	: void EPD_W21_DispInit(void)
//Desc	: display parameters initinal
//Input	: none
//Output: none
//Return: none
//Author: 
//Date	: 2011/12/24
//-------------------------------------------------------
void EPD_W21_DispInit(void)
{
//	unsigned char Testvalue1[2] = {0x0c,0x13};
//	unsigned char Testvalue2[2] = {0x3f,0x00};
	
	#ifdef DEBUG
	DebugInfo("EPD_W21_DispInit()\n");	
	#endif

//	EPD_W21_Write(Testvalue1, sizeof(Testvalue1));	// Power saving,20121116
//	EPD_W21_Write(Testvalue2, sizeof(Testvalue2));
	
	EPD_W21_Write(GDOControl, sizeof(GDOControl));	// Pannel configuration, Gate selection
	//DebugInfo("###0\n");	
       EPD_W21_Write(softstart, sizeof(softstart));	// X decrease, Y decrease
	//DebugInfo("###1\n");	

	//EPD_W21_Write(Rambypass, sizeof(Rambypass));	// RAM bypass setting
//	EPD_W21_Write(MAsequency, sizeof(MAsequency));	// clock enable
	//EPD_W21_Write(GDVol, sizeof(GDVol));			// Gate voltage setting
	//EPD_W21_Write(SDVol, sizeof(SDVol));			// Source voltage setting
	EPD_W21_Write(VCOMVol, sizeof(VCOMVol));		// VCOM setting
	//DebugInfo("###2\n");	

	//EPD_W21_Write(BOOSTERFB, sizeof(BOOSTERFB));	// Hi-V feedback selection
	EPD_W21_Write(DummyLine, sizeof(DummyLine));	// dummy line per gate
	//DebugInfo("###3\n");	

	EPD_W21_Write(Gatetime, sizeof(Gatetime));		// Gage time setting
	//EPD_W21_Write(BorderWavefrom, sizeof(BorderWavefrom));	// Border setting

//	EPD_W21_WriteCMD_p1(0x0f,0x00);		// gate scan start

	EPD_W21_Write(RamDataEntryMode, sizeof(RamDataEntryMode));	// X increase, Y decrease
	//DebugInfo("###4\n");	

//	EPD_W21_SetRamArea(0x00, 0x11,0xab, 0x00);	// X-source area,Y-gage area
//	EPD_W21_SetRamArea(0x00,0x0f,0x27,0x01,0x00,0x00);	// X-source area,Y-gage area
	//EPD_W21_SetRamArea(0x00,0x18,0xC7,0x00,0x00,0x00);	// X-source area,Y-gage area
	EPD_W21_SetRamArea(0x00,0x0f,0x27,0x01,0x00,0x00);	// X-source area,Y-gage area

	//DebugInfo("###5\n");	

//	EPD_W21_SetRamPointer(0x00,0xab);		// set ram
    EPD_W21_SetRamPointer(0x00,0xC7,0x00);	// set ram
	//DebugInfo("###6\n");	

}

void EPD_W21_Init(void)
{
	EPD_W21_BS_0;		// 4 wire spi mode selected

	EPD_W21_RST_0;		// Module reset
	driver_delay_xms(10000);
	EPD_W21_RST_1;
	driver_delay_xms(10000);
	
//	EPD_W21_DispInit();		// pannel configure

//	EPD_W21_WirteLUT(LUTDefault);	// update wavefrom
    
	
	EPD_W21_DispInit();		// pannel configure
   	


}



//-------------------------------------------------------
//Func	: EPD_W21_EnableChargepump
//Desc	: 
//Input	:
//Output: 
//Return: 
//Author: 
//Date	: 2011/12/24
//-------------------------------------------------------
void EPD_W21_EnableChargepump(void)
{
	EPD_W21_WriteCMD_p1(0xf0,0x8f);
	EPD_W21_WriteCMD_p1(0x22,0xc0);
	EPD_W21_WriteCMD(0x20);
	EPD_W21_WriteCMD(0xff);
}

//-------------------------------------------------------
//Func	: EPD_W21_DisableChargepump
//Desc	: 
//Input	:
//Output: 
//Return: 
//Author: 
//Date	: 2011/12/24
//-------------------------------------------------------
void EPD_W21_DisableChargepump(void)
{
	EPD_W21_WriteCMD_p1(0x22,0xf0);
	EPD_W21_WriteCMD(0x20);
	EPD_W21_WriteCMD(0xff);
}
//-------------------------------------------------------
//Func	: EPD_W21_Update
//Desc	: 
//Input	:
//Output: 
//Return: 
//Author: 
//Date	: 2011/12/24
//-------------------------------------------------------
void EPD_W21_Update(void)
{
	EPD_W21_WriteCMD_p1(0x22,0xc4);
	EPD_W21_WriteCMD(0x20);
	EPD_W21_WriteCMD(0xff);
}

 void EPD_W21_Update1(void)
{
	EPD_W21_WriteCMD_p1(0x22,0x04);
	//EPD_W21_WriteCMD_p1(0x22,0x08);
	EPD_W21_WriteCMD(0x20);
	EPD_W21_WriteCMD(0xff);
}

void EPD_W21_WriteRAM(void)
{
	EPD_W21_WriteCMD(0x24);
}




//-------------------------------------------------------
//Func	: EPD_W21_WirteLUT(unsigned char *LUTvalue)
//Desc	: write the waveform to the dirver's ram 
//Input	: *LUTvalue, the wavefrom tabe address
//Output: none
//Return: none
//Author: 
//Date	: 2011/12/24
//-------------------------------------------------------
void EPD_W21_WirteLUT(unsigned char *LUTvalue)
{	
	EPD_W21_Write(LUTvalue, 31);
}


/***********************************************************
						end file
***********************************************************/

