/*--------------------------------------------
主题：ST7529液晶屏驱动程序 
编写人：龙尽文
程序功能：本程序为ST7529驱动程序 
LCM驱动IC型号为：ST7529  点阵数为193*91，工作于16BIT模式。左下角为坐标原点，COL的第一条为固定
   ICON显示。
MCU型号为：STC89LEXX
晶振频率为11.0592MHz
//本程序在液晶屏上显示各种大小的“字模”及一幅不是很好看的画，呵呵。
;连线图:
  ST7529工作于16bits 8080工作方式。
;*LCM---MCU*    *LCM---MCU*     *LCM----MCU*	  *LCM----MCU*	   LCM----MCU*	 LCM---MCU*
;*DB0---P1.0*   *DB4---P1.4*    ;*DB8---P2.0*   *DB12--P2.4*     *AO-----P3.3*   RESET-P3.5
;*DB1---P1.1*   *DB5---P1.5*    ;*DB9---P2.1*   *DB13--P2.5*     *RD-----P3.7*
;*DB2---P1.2*   *DB6---P1.6*    ;*DB10--P2.2*   *DB14--P2.6*     *WR-----P3.6*
;*DB3---P1.3*   *DB7---P1.7*    ;*DB11--P2.3*   *DB15--P2.7*      CS1----P3.4*
-------------------------------------------------*/
/*#pragma src   /*生成ASM文件开关,必要时打开 */
#include <reg52.h>
#include <stdarg.h>
#include<INTRINS.H>

/***********液晶显示器接口引脚定义***************/
sbit LCM_RES = P3^5;  //LCD复位引脚 
sbit CE_LCM=P3^4;   //LCM的CE控制端口
sbit Alcm = P3^3;  //LCD命令和数据控制口，为1时是读写数据；为0时写入命令
sfr  Data1= 0x90;  //数据口低8位为P1
sfr  Data2= 0xA0;  //数据口高8位为P2 

/***********LCM常用操作命令和参数定义***************/
#define  EXT_IN  0x30 //EXT=0 进入到常规命令输入
#define  EXT_OUT 0x31 //EXT=1 
//LCM EXT=0时常用操作命令和参数定 
#define  DISPON  0xAf //显示on  
#define  DISPOFF 0xAe //显示off 
#define  DISNOR  0xA6 //常规显示 
#define  DISINV  0xA7 //反显 
#define  COMSCN  0xBB // COM扫描方式设定 1条指令。
#define  DISCTRL 0xCA //显示控制指令 3条副加指令 
#define  SLPIN   0x95 //进入到睡眠模式 
#define  SLPOUT  0x94 //退出睡眠模式 
#define  LASET   0x75 //行地址设定 2字节地址 
#define  CASET   0x15 //列地址设定 2字节地址 
#define  DATSDR  0xBC //数据扫描位置设定 3字节 
#define  RAMWR   0x5C //写入数据到RAM中 
#define  RAMRD   0x5D //从RAM中读取数据 
#define  PTLIN   0xA8 //进入到区域显示指令 2字节 
#define  PTLOUT  0xA9 //退出区域显示状态 
#define  RMWIN   0xE0 //进入到读修改写模式指令 
#define  RMWOUT  0xEE //退出读修改写模式指令 
#define  ASCSET  0xAA //区域滚动设定 4字节 
#define  SCSTART 0xAB //滚动初始设定  1字节 
#define  OSCON   0xD1 //打开内部晶振指令 
#define  OSCOFF  0xD2 //关闭内部晶振指令 
#define  PWRCTRL 0x20 //电源控制指令 1字节 
#define  VOLCTRL 0x81 //EC控制指令 2字节 
#define  VOLUP   0xD6 //EC加1指令 
#define  VOLDOWN 0xD7 //EC减1指令 
#define  EPSRRD1 0x7C //读寄存器1 
#define  EPSRRD2 0x7D //读寄存器2 
#define  DISNOP  0x25 //空闲指令 相当于没有操作 
#define  EPINT   0x07 //初始化代码指令 1字节 
//LCM EXT=1时常用操作命令和参数定 
#define  Gray_1set  0x20 //框架1灰度PWM设定 16字节 
#define  Gray_2set  0x21 //框架2灰度PWM设定 16字节 
#define  ANASET     0x32 //Analog电路设定 3字节 
#define  SWINT      0x34 //软件初始化 
#define  EPCTIN     0xCD //控制EEPROM指令 1字节 
#define  EPCTOUT    0xCC //退出EEPROM控制 
#define  EPMWR      0xFC //写入数据到EEPROM
#define  EPMRD      0xFD //从EEPROM读出数据 


#define	freq      6000000	//系统时钟，6MHz
#define us1000H   ((65536 - (freq/1200)*1000/10000) / 256)	//延时1ms的定时H数值
#define us1000L   ((65536 - (freq/1200)*1000/10000) % 256)	//延时1ms的定时L数值

#define START_LINE	 32	  //LCD的起始行 
#define END_LINE	 122  //LCD的结束行    LINE	 32~122 MAX=159
#define START_COL	 20	  //LCD的起始列 
#define END_COL	     84	  //LCD的结束列 	 COLUMN	20~84  MAX=84
#define MAX_ROW      91   //最大的ROW数 
#define MAX_COL      194   //最大的COL数 
#define MAX_COL_BLOCK 65   //最大的COL的块数，一个块含有3个像素点。
/****************全局变量定义*******************/
unsigned char col,row;  /*列x,行(页)y,输出数据 */
bit Reverse;  /*反显控制标志位，=1时反显 */

bit TimeMark;  /*定时响应标志位*/
unsigned char T_TH;
unsigned char T_TL;

unsigned char code two_boy[];
unsigned char code zimo[];

/****************************************************************************/
//	Timer0初始化
/****************************************************************************/
void InitTimer0(void)
{
	TR0 = 0;
	TimeMark=0;
	TMOD = (TMOD&0xf0)|0x01;		//模式1，十六位定时器 
	TH0  = T_TH;
	TL0  = T_TL;
	ET0 = 1;
	TR0 = 1;
	EA  = 1;
}
/****************************************************************************/
//	Timer0  中断程序 定时
/****************************************************************************/
void timer0 (void) interrupt 1
{
	TR0 = 0;		
	TH0 = T_TH;
	TL0 = T_TL;				//reload
	TR0 = 1;
	TimeMark=1;
}
/****************************************************************************/
//	Ms延时程序
/****************************************************************************/
void  Delay(unsigned int ms)
{
    unsigned int i;
	T_TH=us1000H;
	T_TL=us1000L;
    InitTimer0(); //定 时1ms
    TimeMark=0;
   	for (i=0;i<ms;i++)
	{
	   while(!TimeMark);
	   TimeMark=0;
	}
	TR0=0;  //关定时器0
	ET0 = 0;
}



/****************************************/
//LCD复位程序 
/****************************************/
void LCD_Reset(void )
{
   LCM_RES=1;
   Delay(10);
   LCM_RES=0;
   Delay(10);
   LCM_RES=1;
}
/****************************************/
//LCD读数据接初始化函数 
/****************************************/
void LCD_initRead(void)
{
   Data1=0xFF;
   Data2=0xFF;
   LCM_RES=1;
   Alcm = 1;   //读数据操作 
   WR=1;
   RD=1;
   CE_LCM =0;
}
/****************************************/
//LCD读数据 
/****************************************/
void LCD_dummyRead(void)
{
   RD=0;
   RD=1;
}
/****************************************/
//LCD读数据 
//首次调用此函数前，需调LCD_dummyRead()函数一次 
/****************************************/
unsigned int LCD_DataRead(void)
{
   unsigned int Dat_m=0;
   RD=0;
   Dat_m=(Data1|(Data2<<8));
   RD=1;
   return Dat_m;
}
/****************************************/
//LCM忙判断函数   
/****************************************/
void wtcom(void)
{
}
/****************************************/
//LCD写数据接初始化函数 
/****************************************/
void LCD_initWR(void)
{
  //  wtcom();  //等待LCM操作允许，这里暂不用它 
  Alcm = 1;   //写数据操作 
  RD = 1;   //读数据端置1
  CE_LCM = 0;  //选中LCM 
}
/****************************************/
//写入数据函数 
/****************************************/
void Wrcom(unsigned int X)
{
  Data1=(unsigned char)X;   //输出数据	 
  Data2=(unsigned char)(X>>8);   //输出数据	   
  WR = 0;   //写数据端置0
//　NOP();
  WR = 1;       //写入数据  
}
/****************************************/
//对LCM写入数据 
/****************************************/
void Wrdata(unsigned int X)
{
//  wtcom();  //等待LCM操作允许，这里暂不用它 
  if(Reverse)
    {X=~X;}  //取反，以反显
  Alcm = 1;   //写数据操作 
  RD = 1;   //读数据端置1
  CE_LCM = 0;  //选中LCM 
  Wrcom(X);  //调用写数据共享程序 
}
/****************************************/
//对LCM写入命令 
/****************************************/
void Wrcmd(unsigned int X)
{
//  wtcom();  //等待LCM操作允许，这里暂不用它 
  Alcm = 0;   //写命令操作 
  RD = 1;   //读数据端置1
  CE_LCM = 0;  //选中LCM 
  Wrcom(X);  //调用写数据共享程序 
}
/********************************/
//向液晶屏EEPROM中读出数据函数 
/********************************/
void Read_LCM_EEPROM( void )
{
   Wrcmd( 0x0030 ); // Ext = 0
   Wrcmd( 0x0007 ); // Initial code (1)
   Wrdata( 0x0019 );
   Wrcmd( 0x0031 ); // Ext = 1
   Wrcmd( 0x00CD ); // EEPROM ON
   Wrdata( 0x0000 ); // Entry "Read Mode"
   Delay( 100 ); // Waite for EEPROM Operation ( 100ms )
   Wrcmd( 0x00FD ); // Start EEPROM Reading Operation
   Delay( 100 ); // Waite for EEPROM Operation ( 100ms )
   Wrcmd( 0x00CC ); // Exist EEPORM Mode
   Wrcmd( 0x0030 ); // Ext = 0
}
/********************************/
//向液晶屏EEPROM中写入数据函数 
/********************************/
void Write_LCM_EEPROM( void )
{
   Wrcmd( 0x0030 ); // Ext = 0
   Wrcmd( 0x00AE ); // Display OFF
   Wrcmd( 0x0007 ); // Initial code(1)
   Wrdata( 0x0019 );
   Wrcmd( 0x0031 ); // Ext = 1
   Wrcmd( 0x00CD ); // EEPROM ON
   Wrdata( 0x0020 ); // Entry "Write Mode"
   Delay( 100 ); // Waite for EEPROM Operation ( 100ms )
   Wrcmd( 0x00FC ); // Start EEPROM Writing Operation
   Delay( 100 ); // Waite for EEPROM Operation ( 100ms )
   Wrcmd( 0x00CC ); // Exist EEPROM Mode
   Wrcmd( 0x0030 ); // Ext = 0
   Wrcmd( 0x00AF ); // Display ON
}
/****************************************/
//写入地址函数 
//col+end_X最大为194
//row+end_Y最大为91
/****************************************/
void Loadxy(unsigned char end_X,unsigned char end_Y)
{
     unsigned char i;
     Wrcmd(0X30);   //EXT=0

     Wrcmd(0X75);   //THIRD  COMMAND SET LINE ADDRESS 
	 i=START_LINE+row;
     Wrdata(i);    //START LINE
	 i=i+end_Y-1;
     Wrdata(i);  //END   LINE

     i=col/3;
	 i=START_COL+i;
     Wrcmd(0X15);   //THIRD  COMMAND SET COLUMN ADDRESS 
     Wrdata(i);  //START COLUMN  
	 if(end_X>2) i=(i+end_X/3);
	 if((end_X%3)==0)  i--;
     Wrdata(i);  //END   COLUMN
}
/********************************/
//LCD的全显点的测试程序 
//可作为清屏函数调用。
//入口数ucData为点的灰度。 
/********************************/
void WretPointTest(unsigned int ucData)
{
   unsigned char i=0,j=0;
   col=0;row=0;
   Loadxy(194,91); //定义显示的坐标区域 


   Wrcmd(0X5C);  //DATA WRITE 
   LCD_initWR();
   for(i=0;i<MAX_ROW;i++)
   {
      for (j=0;j<MAX_COL_BLOCK;j++)
      { 
		 Wrcom(ucData);
      }
   }
}
/********************************/
//LCD的显示一个点函数 
//在LCD的col、row位置上显示一个点。
//lum为这个点的亮度 	为0时最暗，显示全黑色 
/********************************/
void Write_point(unsigned char lum)
{
   unsigned int ucData;
   unsigned char i;
   unsigned int  temp=0;

   Wrcmd(0X30);   //EXT=0

   Wrcmd(0X75);   //THIRD  COMMAND SET LINE ADDRESS 
   i=START_LINE+row;
   Wrdata(i);    //START LINE
   Wrdata(i);  //END   LINE
   i=col/3;
   i=START_COL+i;
   Wrcmd(0X15);   //THIRD  COMMAND SET COLUMN ADDRESS 
   Wrdata(i);  //START COLUMN  
   Wrdata(i);  //END   COLUMN

   Wrcmd(0XE0);   //进入到读修改写模式 
   LCD_initRead(); //初始化读数据状态 
   LCD_dummyRead(); //假读一次
   ucData=LCD_DataRead();

   i = col%3;
   switch(i)
   {
       case 0:
	      temp=lum<<8;
		  temp=temp<<3;
          ucData=((ucData&0x07FF)|temp);
          break;
       case 1:
	      temp=lum<<6;
          ucData=((ucData&0xF83F)|temp);
          break;
       case 2:
          ucData=((ucData&0xFFE0)|lum);
          break;
   }
   Wrcom(ucData);
   Wrcmd(0XEE);   //退出读修改写模式 
}

/********************************/
//LCD的一个块中三个像素合成显示函数 
//入口数note为图像的地址 
/********************************/
unsigned char show_block(unsigned char code *note,unsigned char col_num)
{
   unsigned int ucData;
   unsigned char i;
   unsigned int  temp=0;

   LCD_dummyRead(); //假读一次
   ucData=LCD_DataRead();

   i = col%3;
   switch(i)
   {
       case 0:
	      temp=*note<<8;
		  temp=temp<<3;
	      switch(col_num)
		  {
		    case 1:
			  i=1;
              ucData=((ucData&0x07FF)|temp);	
			  break;
			case 2:
			  note++; i=2;
	          temp=temp|(*note<<6);
              ucData=((ucData&0x003F)|temp);
			  break;	
			default:
			  note++; i=3;
	          temp=temp|(*note<<6);
			  note++;
			  ucData=temp|*note;
			  break;
		  }
          break;
       case 1:
	      temp=*note<<6;
	      if(col_num<2)
		  {
			  i=1;
              ucData=((ucData&0xF83F)|temp);	
	  	  }
		  else
		  {
			  note++; i=2;
	          temp=temp|*note;
              ucData=((ucData&0xF800)|temp);	
		  }
          break;
       case 2:
	      i=1;
          ucData=((ucData&0xFFE0)|*note);
          break;
	   default: i=0;
	      break;
   }
   if(Reverse)  ucData=~ucData;  //取反，以反显
   RD = 1;   //读数据端置1
   Wrcom(ucData);
   return i;
}

/********************************/
//LCD的显示一个矩阵图像函数 
//点阵数为从左至右、从下至上的模向扫描 
//入口数note为图像的首地址 
//入口数col_num、row_num为图像的宽和高 。
/********************************/
void show_photo(unsigned char code *note,unsigned char col_num,unsigned char row_num)
{
   unsigned char i,j;
   unsigned char bak_col;
   unsigned char a;
   Loadxy(col_num,row_num); //写入图像的显示区域 
   Wrcmd(0XE0);   //进入到读修改写模式 
   LCD_initRead(); //初始化读数据状态 

   bak_col=col;	
   for(i=0;i<row_num;i++)
   {
      col=bak_col; j=col_num;
      while	(j!=0)
	  {
   	     a=show_block(note,j);
		 note=note+a;
		 j=j-a;	col=col+a;   	  
      }
   }
   Wrcmd(0XEE);   //退出读修改写模式 
}
/********************************/
//LCD的显示一个点阵字符函数。
//字模数据为从左至右、从上至下的模向扫描模式 
//字符点阵数为从左至右、从下至上的模向扫描 
//入口数note为字符的首地址 
//入口数col_num、row_num为字符的宽和高 。
//入口数lum为字符显示的亮度 ，为0时，最黑 
/********************************/
void show_note(unsigned char code *note,unsigned char col_num,unsigned char row_num,unsigned char lum)
{
   unsigned char i,j;
   unsigned char bak_col;
   unsigned char a,k;
   unsigned int ucData;
   unsigned int  temp1,temp2;
   temp1=lum<<8;
   temp1=temp1<<3;
   temp2=lum<<6;

   k=col_num/8;
   if((col_num%8)!=0)  k++;
   note=note+(unsigned int)(k*(row_num-1)); //最下一行的首地址 
   k=2*k;
   bak_col=col;	

   Wrcmd(0X30);   //EXT=0

   Wrcmd(0X75);   //THIRD  COMMAND SET LINE ADDRESS 
   i=START_LINE+row;
   Wrdata(i);    //START LINE
   i=i+row_num-1;
   Wrdata(i);  //END   LINE
   i=col/3;
   i=START_COL+i;
   Wrcmd(0X15);   //THIRD  COMMAND SET COLUMN ADDRESS 
   Wrdata(i);  //START COLUMN  
   a=col_num-1;
   i=((col+a)/3);
   i=i+START_COL;
   Wrdata(i);  //END   COLUMN

   Wrcmd(0XE0);   //进入到读修改写模式 
   LCD_initRead(); //初始化读数据状态 
   for(i=0;i<row_num;i++)
   {
      a=0;	col=bak_col; j=col_num;
      while(j!=0)
	  {
	     LCD_dummyRead(); //假读一次
         ucData=LCD_DataRead();
         switch(col%3)
         {
            case 0:
		      j--; col++;
			  if((*note&(1<<a))!=0)  ucData=((ucData&0x07FF)|temp1);
			  else	 ucData=(ucData|0xF800);
	      	  if(a<7)  a++;
			  else  {note++; a=0;}
            case 1:
              if(j!=0)  {j--; col++;}
		      else  break;
			  if((*note&(1<<a))!=0)  ucData=((ucData&0xF83F)|temp2);
			  else	 ucData=(ucData|0x07C0);
	      	  if(a<7)  a++;
			  else {note++; a=0;}
            default:
              if(j!=0)  {j--; col++;}
		      else  break;
			  if((*note&(1<<a))!=0)  ucData=((ucData&0xFFE0)|lum);
			  else	 ucData=(ucData|0x003F);
	      	  if(a<7)  a++;
			  else {note++; a=0;}
         }
         Wrcom(ucData);
      }
	  note=note-k;
	  if(a!=0) note++;
   }
   Wrcmd(0XEE);   //退出读修改写模式 
   col=bak_col;
}
/********************************/
//液晶屏初始化 
/********************************/
void ST7529_init(void)
{
   Wrcmd( 0x0030 ); //Ext = 0
   Wrcmd( 0x0094 ); //Sleep Out
   Wrcmd( 0x00D1 ); //OSC On
   Wrcmd( 0x0020 ); //Power Control Set
   Wrdata( 0x0008 ); //Booster Must Be On First
   Delay( 1 );
   Wrcmd( 0x0020 ); //Power Control Set
   Wrdata( 0x000B ); //Booster, Regulator, Follower ON
   Wrcmd( 0x0081 ); //Electronic Control
   Wrdata( 0x0004 ); //Vop=14.0V
   Wrdata( 0x0004 );
   Wrcmd( 0x00CA ); //Display Control
   Wrdata( 0x0000 ); //CL=X1
   Wrdata( 0x0027 ); //Duty=160
   Wrdata( 0x0000 ); //FR Inverse-Set Value
   Wrcmd( 0x00A6 ); // Normal Display
   Wrcmd( 0x00BB ); //COM Scan Direction
   Wrdata( 0x0002 ); // 79→0 80→159
   Wrcmd( 0x00BC ); //Data Scan Direction
   Wrdata( 0x0000 ); //inverse show
   Wrdata( 0x0000 ); //RGB Arrangement
   Wrdata( 0x0001 ); //2字节3像素模式 
   Wrcmd( 0x0075 ); //Line Address Set
   Wrdata( 0x0000 ); //Start Line=0
   Wrdata( 0x009F ); //End Line =159
   Wrcmd( 0x0015 ); //Column Address Set
   Wrdata( 0x0000 ); //Start Column=0
   Wrdata( 0x0054 ); //End Column =84
   Wrcmd( 0x0031 ); //Ext = 1
   Wrcmd( 0x0032 ); //Analog Circuit Set
   Wrdata( 0x0000 ); //OSC Frequency =000 (Default)
   Wrdata( 0x0001 ); //Booster Efficiency=01(Default)
   Wrdata( 0x0000 ); //Bias=1/14
   Wrcmd( 0x0034 ); //Software Initial
//Read_LCM_EEPROM(); //Read EEPROM Flow
   Wrcmd( 0x0030 ); //Ext = 0
   WretPointTest(0xFFFF);
   Wrcmd( 0x00AF ); //Display On
}

unsigned char code zimo3[]={		 //65*29
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x80,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x01,0x20,0x00,0x80,0x01,0x04,
0x00,0x30,0x80,0x01,0xE0,0xFF,0xFF,0x01,0xFC,0xFF,0x3F,0x80,0x01,0x60,0x00,0x80,
0x00,0x0C,0x00,0x10,0x80,0x01,0x60,0x00,0x80,0x00,0x0C,0x00,0x10,0x00,0x00,0x60,
0x00,0x80,0x00,0x0C,0x00,0x10,0x00,0x00,0xE0,0xFF,0xFF,0x00,0xFC,0xFF,0x1F,0x00,
0x00,0x60,0x00,0x80,0x00,0x0C,0x00,0x10,0x00,0x00,0x60,0x00,0x00,0x00,0x0C,0x00,
0x00,0x00,0x00,0x60,0x02,0x04,0x00,0x4C,0x80,0x00,0x00,0x00,0x60,0x0E,0x0C,0x00,
0xCC,0x81,0x01,0x00,0x00,0x60,0x06,0x04,0x01,0xCC,0x80,0x20,0x00,0x00,0x60,0x06,
0x84,0x03,0xCC,0x80,0x70,0x00,0x00,0x20,0xC6,0xC4,0x00,0xC4,0x98,0x18,0x00,0x00,
0x20,0xFE,0x65,0x00,0xC4,0xBF,0x0C,0x00,0x00,0x20,0x06,0x14,0x00,0xC4,0x80,0x02,
0x00,0x00,0x30,0x06,0x0C,0x00,0xC6,0x80,0x01,0x00,0x00,0x30,0x06,0x04,0x00,0xC6,
0x80,0x00,0x00,0x00,0x10,0x06,0x04,0x00,0xC2,0x80,0x00,0x00,0x00,0x10,0x06,0x04,
0x02,0xC2,0x80,0x40,0x00,0x00,0x18,0x86,0x04,0x02,0xC3,0x90,0x40,0x00,0x00,0x08,
0x66,0x04,0x02,0xC1,0x8C,0x40,0x00,0x00,0x08,0x1E,0x04,0x06,0xC1,0x83,0xC0,0x00,
0x00,0x04,0x0E,0xFC,0x87,0xC0,0x81,0xFF,0x00,0x00,0x02,0x04,0xF8,0x43,0x80,0x00,
0x7F,0x00,0x00,0x02,0x00,0x00,0x40,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,
};
unsigned char code zimo2[]={		 //74*37
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x30,0x00,0x83,0x01,0x00,0x00,0x00,
0x0E,0x00,0x00,0x70,0x00,0x83,0x01,0x00,0x00,0x00,0x0C,0x00,0x00,0x30,0x00,0x83,
0x01,0x00,0x00,0x00,0x0C,0x40,0x00,0x30,0x00,0x83,0x61,0x00,0x40,0x00,0x0C,0xC0,
0x00,0x20,0x00,0x83,0xF1,0x00,0xC0,0xFF,0xFF,0xFF,0x01,0x20,0xF8,0xFF,0x0F,0x00,
0x40,0x00,0x00,0xE0,0x00,0x20,0x00,0x83,0x01,0x00,0x60,0x00,0x00,0x20,0x00,0x20,
0x06,0x83,0x01,0x00,0x70,0x00,0x00,0x10,0x80,0xFF,0x0F,0x81,0x00,0x00,0x70,0x00,
0x00,0x10,0x00,0x30,0x60,0x00,0x0C,0x00,0x00,0x00,0x00,0x06,0x00,0x30,0xE0,0xFF,
0x1F,0x00,0x80,0xFF,0xFF,0x0F,0x00,0x30,0x60,0x00,0x0C,0x00,0x00,0x00,0x00,0x1F,
0x00,0x30,0x60,0x00,0x0C,0x00,0x00,0x00,0x80,0x01,0x00,0xF8,0x60,0x00,0x0C,0x00,
0x00,0x00,0x40,0x00,0x00,0xB8,0xE3,0xFF,0x0F,0x00,0x00,0x00,0x30,0x00,0x00,0x28,
0x67,0x00,0x0C,0x00,0x00,0x00,0x1E,0x00,0x00,0x2C,0x66,0x00,0x0C,0x00,0x00,0x00,
0x0E,0x00,0x01,0x2C,0x66,0x00,0x0C,0x00,0x00,0x00,0x0E,0x80,0x01,0x26,0x64,0x00,
0x0C,0x00,0x00,0x00,0x0E,0xC0,0x03,0x26,0xE0,0xFF,0x0F,0x00,0xFC,0xFF,0xFF,0x3F,
0x00,0x22,0x60,0x18,0x0C,0x00,0x00,0x00,0x0E,0x00,0x00,0x21,0x00,0x18,0x00,0x00,
0x00,0x00,0x0E,0x00,0x00,0x21,0x00,0x18,0x60,0x00,0x00,0x00,0x0E,0x00,0x80,0x30,
0x00,0x18,0xF0,0x00,0x00,0x00,0x0E,0x00,0x40,0x30,0xFC,0xEF,0x0F,0x00,0x00,0x00,
0x0E,0x00,0x00,0x30,0x00,0x2C,0x00,0x00,0x00,0x00,0x0E,0x00,0x00,0x30,0x00,0x4C,
0x00,0x00,0x00,0x00,0x0E,0x00,0x00,0x30,0x00,0x86,0x00,0x00,0x00,0x00,0x0E,0x00,
0x00,0x30,0x00,0x83,0x01,0x00,0x00,0x00,0x0E,0x00,0x00,0x30,0x80,0x01,0x07,0x00,
0x00,0xF0,0x07,0x00,0x00,0x30,0xC0,0x00,0x3E,0x00,0x00,0x80,0x07,0x00,0x00,0x70,
0x70,0x00,0xFC,0x00,0x00,0x00,0x03,0x00,0x00,0x70,0x1C,0x00,0x30,0x00,0x00,0x00,
0x01,0x00,0x00,0x10,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,
};
/****************************************/
/*主函数*/
/****************************************/
void main()
{
    LCD_Reset();
	ST7529_init();

 	col=6;row=3;
	show_note(&zimo[0],32,16,0x00);
 	col=38;row=3;
	show_note(&zimo[0],32,16,0x00);

 	col=80;row=3;
	show_note(&zimo2[0],74,37,0x00);

 	col=80;row=50;
	show_note(&zimo3[0],65,29,0x00);

	col=6;row=20;
	show_note(&two_boy[0],65,70,0x00);

	while(1);
}


unsigned char code zimo[]={		 //32*16
0x40,0x00,0x04,0x09,0x80,0x00,0x04,0x09,0xFC,0x3F,0xE4,0x3F,0x04,0x20,0x04,0x09,
0x02,0x10,0xDF,0x1F,0xF8,0x07,0x44,0x10,0x00,0x02,0xCE,0x1F,0x00,0x01,0x56,0x10,
0x80,0x00,0xC5,0x1F,0xFE,0x7F,0x05,0x02,0x80,0x00,0xE4,0x7F,0x80,0x00,0x04,0x02,
0x80,0x00,0x04,0x05,0x80,0x00,0x04,0x19,0xA0,0x00,0x84,0x70,0x40,0x00,0x64,0x20,
};

															
unsigned char code two_boy[]={		 //65*70
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x06,0x00,0x00,0x00,
0x08,0x00,0x90,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7D,0x00,0x90,0xFF,0xFE,0xFF,0xEF,
0x8F,0xFF,0xE0,0x00,0x90,0xED,0x7F,0xFF,0xFF,0xFF,0xFF,0x01,0x00,0x98,0xCD,0xCF,
0xFF,0xEC,0xFB,0xFF,0x02,0x00,0x98,0xFC,0xF8,0x5D,0x3B,0x17,0xDA,0x06,0x00,0x88,
0xFF,0xCC,0x13,0x27,0x13,0xFE,0x0C,0x00,0x80,0xE7,0xCD,0x7B,0x5B,0x36,0xDE,0x09,
0x00,0xE0,0xCF,0xCC,0x2F,0x9B,0x33,0xDE,0x00,0x00,0xF8,0xDF,0xCD,0x77,0x5B,0x37,
0xD6,0xE1,0x00,0x98,0xCF,0xCC,0x3F,0x1B,0x33,0xCF,0x80,0x00,0x98,0x9F,0xCD,0x1D,
0x53,0x37,0xDE,0x01,0x00,0x88,0xE3,0xBC,0xFF,0x98,0xB3,0x9B,0x03,0x00,0x8C,0x7F,
0xFF,0xFF,0xFF,0xFD,0xFE,0x06,0x00,0x80,0xFF,0xFF,0xEF,0xFF,0xFF,0xFF,0x0D,0x00,
0x81,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x09,0x00,0x21,0x00,0x0F,0x03,0x02,0x4E,0xC0,
0x80,0x00,0x00,0x00,0x08,0x00,0x02,0x1F,0x00,0xC0,0x00,0x00,0xC0,0x18,0x00,0x03,
0x72,0x00,0x00,0x00,0x02,0xE0,0x10,0x00,0x05,0xA3,0x00,0x18,0x00,0xC2,0x30,0x10,
0x80,0x1F,0x99,0x00,0x18,0x00,0x46,0x18,0x00,0xC0,0x78,0x89,0x3F,0x34,0x00,0x4C,
0x06,0x0C,0xC4,0x60,0x88,0xF1,0x64,0x00,0x60,0x1F,0xFC,0xCC,0xDC,0x88,0x01,0x46,
0x00,0x60,0x79,0xC0,0xD8,0x78,0x0A,0x03,0x06,0x00,0x01,0xBD,0x00,0xD0,0xF0,0x0F,
0x02,0x02,0x00,0x01,0xCF,0x70,0x90,0xE0,0x1B,0x62,0x02,0x00,0x7F,0x85,0x61,0x80,
0xC3,0x35,0xC3,0x10,0x00,0xEC,0x8D,0xC3,0x81,0xC2,0xFF,0x43,0xF7,0x00,0x52,0x0F,
0x83,0x03,0xC7,0xC3,0x8F,0xC7,0x01,0x9A,0x0B,0x06,0x1F,0xE2,0x77,0x1B,0x0F,0x00,
0x3C,0xFE,0x0D,0x3F,0xD4,0xFE,0x2F,0x1D,0x00,0xC4,0xC6,0x3D,0x74,0xFC,0xEF,0x3E,
0x1C,0x00,0x8E,0xCE,0x5F,0x7C,0x78,0x3F,0x7F,0x16,0x01,0x0C,0xCF,0x7C,0x78,0x6C,
0xFF,0xEF,0x1E,0x01,0x9C,0xFF,0xF7,0xF8,0x7D,0xCF,0xFD,0xF7,0x01,0x98,0xFF,0xFF,
0xF0,0xEC,0x8D,0xE0,0x91,0x01,0xF8,0xFF,0xFF,0xC6,0xF8,0x89,0x47,0xB3,0x00,0x90,
0xFF,0x8A,0xCF,0xBE,0x8E,0xED,0x33,0x00,0xE0,0x2F,0xC0,0xD5,0x28,0x9F,0x7C,0x33,
0x00,0xE0,0x1F,0x3C,0xCD,0x18,0x09,0x70,0x33,0x00,0xE2,0x1F,0x7C,0xCF,0x30,0x03,
0x6A,0x33,0x00,0xE6,0x0B,0xEC,0xCE,0xF0,0x05,0xA1,0x23,0x00,0xE4,0xF1,0xC8,0x0E,
0xF0,0xF1,0xD1,0x1F,0x00,0x4C,0xB1,0x00,0xCE,0xC6,0xF8,0x38,0xFD,0x00,0xC8,0x31,
0x10,0xCF,0xEC,0x01,0xDE,0xC1,0x01,0xC8,0x31,0x90,0xCF,0xD8,0xFF,0xFF,0x00,0x01,
0x81,0x18,0xFE,0x4F,0xF8,0xFD,0x70,0x82,0x01,0x18,0x19,0xDC,0x67,0x71,0x00,0x60,
0x86,0x01,0x0E,0x06,0xBF,0xEF,0x35,0x00,0x60,0x8C,0x00,0x86,0xF6,0xF7,0x8F,0x33,
0x03,0x60,0x8C,0x00,0x00,0xFC,0xFF,0xFF,0x37,0x03,0x50,0x08,0x00,0xC0,0xEC,0xFF,
0xBF,0x33,0x02,0xF8,0x00,0x00,0xC0,0xFC,0xFF,0x3F,0x63,0xFE,0xFF,0x07,0x00,0x44,
0xEE,0xFF,0x7F,0xE0,0xCF,0xBF,0x76,0x00,0x8C,0x9D,0xFF,0x77,0xC6,0xFF,0xFF,0xF6,
0x01,0x8C,0xB9,0xFB,0x3F,0x0A,0xFD,0xFF,0x02,0x00,0x19,0xD9,0xDF,0x1F,0x1F,0xFF,
0xFF,0x03,0x00,0x19,0xB1,0xFF,0x1F,0x1A,0xFF,0x59,0x22,0x00,0x40,0xE0,0xBB,0x07,
0x0E,0xE3,0xC7,0x60,0x00,0xE0,0xC3,0xDF,0x08,0xBC,0xC3,0xC6,0xC0,0x00,0x02,0xC7,
0xDD,0x38,0xD0,0x63,0xC6,0xC0,0x00,0x06,0xFC,0xC8,0xF8,0xF9,0x62,0xC6,0x07,0x00,
0x06,0xFE,0xF0,0x41,0x1B,0xC0,0x07,0x0E,0x00,0x0C,0x26,0xF8,0x0F,0x0F,0xE0,0x03,
0x18,0x00,0x00,0xF2,0xFF,0xBC,0xFF,0xDF,0xFF,0x7D,0x00,0xC0,0xDE,0xBD,0xC0,0x7B,
0x9F,0xBD,0x7B,0x00,0x60,0x00,0xB7,0x01,0x01,0x87,0x01,0xC4,0x00,0xE0,0x00,0xB2,
0x01,0x80,0x83,0x01,0xC4,0x00,
};


