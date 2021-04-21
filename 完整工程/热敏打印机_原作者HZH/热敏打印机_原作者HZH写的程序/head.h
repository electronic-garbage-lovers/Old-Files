#include<STC15.h>
#include<intrins.h>
#include<math.h>
typedef unsigned char uint8;
typedef unsigned int uint16;
typedef unsigned long uint32;
//sbit M_A  = P3^7;
//sbit M_B  = P3^6;
//sbit M_A_ = P3^5;
//sbit M_B_ = P3^4;
sbit M_A  = P3^7;
sbit M_A_ = P3^6;
sbit M_B  = P3^5;
sbit M_B_ = P3^4;

sbit LAT  = P3^3;
sbit CLK  = P3^2;
sbit SI   = P5^4;
sbit CO	  = P1^7;
sbit L    = P5^5;
uint16 xp=500;//速度
uint8 x_sta=0;//状态
bit go1=0,go2=1;
uint8 dot[6];//点数
xdata unsigned char uart_data[111];
#include"more.h"
#include"uart.h"




