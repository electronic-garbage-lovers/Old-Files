#include "stc15.h"
#include "codetab.h" 

sbit RST=P2^5;
//sbit A0=P1^5;
sbit SCL=P3^1;
sbit SDA=P3^0;



void delay()
{
	unsigned int x=1000;
	while(x--)
		;
}


void delay1()
{
	unsigned int x=50000;
	while(x--)
		;
}


void LCD_RW(bit i,unsigned char j)
{
	unsigned char x;
	if(i==0)	SDA=0;
	else			SDA=1;
	SCL=0;
	SCL=1;
	for(x=0;x<8;x++)
	{
		SDA=(bit)(j&0x80);
		SCL=0;
		j<<=1;
		SCL=1;
	}
}

void LCD_Init()
{
	RST=0;
	delay();
	delay();
	RST=1;
	delay();
	delay();
	LCD_RW(0,0xe2);
	delay();
	LCD_RW(0,0xa0);
	LCD_RW(0,0xc8);
	delay();
	
	LCD_RW(0,0x27);
	LCD_RW(0,0x81);
	LCD_RW(0,0x20);
	delay();
	LCD_RW(0,0x2c);
	LCD_RW(0,0x2e);
	LCD_RW(0,0x2f);
	delay();
	LCD_RW(0,0xaf);
	delay();
}

void LCD_Clear(unsigned char dat)
{
	unsigned char i,j; 
	for(j=0;j<8;j++)
	{ 
		LCD_RW(0,0xb0+j);
		LCD_RW(0,0x10);	
		LCD_RW(0,0x00);	
		for(i=0;i<128;i++)
		{
			LCD_RW(1,dat);
		}
	}
}


void printf_c8(unsigned char x,unsigned char y, unsigned char c)
{
	unsigned char i;
	c-=' ';
	LCD_RW(0,0xb0+y);
	LCD_RW(0,0x10|(x>>4));
	LCD_RW(0,x&0x0f);
	for(i=0;i<6;i++)
		LCD_RW(1,F6x8[c][i]);
}


void printf_8(unsigned char x, unsigned char y, unsigned char *s) 
{
	unsigned int z;
	z=0;
	while(*s) 
	{
    if((x+z)<=122)  
    {
			printf_c8(x+z,y,*s);
			z+=6;
			s++;
    }
	} 
}

void main()
{
	unsigned char k;
	LCD_Init();
	LCD_Clear(0x00);
	printf_8(0, 1, "123456") ;
		printf_8(0, 3,"789456") ;
	while(1)
	{
		printf_c8(0,0,k++);
		delay1();
		delay1();
		printf_c8(0,2,k++);
		delay1();
		delay1();
	}
}
