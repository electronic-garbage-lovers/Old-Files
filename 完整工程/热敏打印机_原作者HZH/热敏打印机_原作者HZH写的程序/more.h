x_m(uint8 dat);
delay(uint32 i);
f();
b();
zt();
relax();
delay(uint32 i);
void delayms(uint8 dat1);
void delay800us();
void delay300us();
void delay100us();
H_go(uint8 dat1);
H_dat(bit dat1);
H_lock();

send(unsigned char dat)
{
TI=0;
SBUF=dat;
while(!TI);
TI=0;
}




x_m(uint8 dat)//置x状态
{
switch(dat)
{
case 0:M_A_=0;M_A=1;M_B=1;M_B_=0;break;
case 1:M_A_=1;M_A=0;M_B=1;M_B_=0;break;
case 2:M_A_=1;M_A=0;M_B=0;M_B_=1;break;
case 3:M_A_=0;M_A=1;M_B=0;M_B_=1;break;
case 4:M_A_=0;M_A=0;M_B=0;M_B_=0;break;
}
}


f()  //前进
{

if(x_sta==3)
{x_sta=0;}
else
{x_sta++;}
x_m(x_sta);
}

b()  //后退
{
if(x_sta==0)
{x_sta=3;}
else
{x_sta--;}
x_m(x_sta);
}
zt()//置状态
{
x_m(x_sta);
}
relax()//解除电流
{
x_m(4);
}
delay(uint32 i)//延时
{
uint32 a;
for(a=0;a<i;a++);
}
void delayms(uint16 dat1)		//@35MHz
{
	unsigned char i, j,cnt1;	
	dat1=(uint16)pow((double)dat1*100,0.5);
	if(dat1>12){dat1=12;}
	dat1=dat1/4;
	for(cnt1=0;cnt1<dat1;cnt1++)
	{

	i = 35;
	j = 8;
	do
	{
		while (--j);
	} while (--i);
	}
}
void delay800us()		//@35MHz
{
	unsigned char i, j;

	i = 28;
	j = 57;
	do
	{
		while (--j);
	} while (--i);
}
void delay300us()		//@35MHz
{
	unsigned char i, j;

	i = 11;
	j = 51;
	do
	{
		while (--j);
	} while (--i);
}
void delay100us()		//@35MHz
{
	unsigned char i, j;

	i = 4;
	j = 100;
	do
	{
		while (--j);
	} while (--i);
}
H_go(uint8 dat1)//第几个组，0开始到5
{
P1&=0XC0;
P1|=(1<<dat1);
delayms(dot[dat1]);
P1&=0XC0;
if(dot[dat1]>55)
{
delayms(dot[dat1]);
}
}

H_dat(bit dat1)//写入一位数据
{
SI=dat1;
CLK=1;
delay(5);
CLK=0;
delay(1);
}

H_lock()//锁存
{
LAT=0;
delay(5);
LAT=1;
delay(1);
}
clean()
{
dot[0]=dot[1]=dot[2]=dot[3]=dot[4]=dot[5]=0;
}
once()
{
uint16 cnt1;
zt();
delay(500);
clean();
for(cnt1=0;cnt1<384;cnt1++)
{
if((bit)(uart_data[cnt1/7]&(0x40>>(cnt1%7))))
{
dot[cnt1/64]++;
H_dat(1);
}
else
{H_dat(0);}
}

H_lock();
delay(10);
for(cnt1=0;cnt1<6;cnt1++)
{
H_go((uint8)cnt1);
}
P1&=0XC0;
f();
for(cnt1=0;cnt1<6;cnt1++)
{H_go(cnt1);}
if((uint16)(dot[0]+dot[1]+dot[2]+dot[3]+dot[4]+dot[5])<2)
{
delay(1000);
}
P1&=0XC0;
f();
delay(1000);
relax();
send(1);
}

//twice()
//{
//uint16 cnt1;
//zt();
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[cnt1/7]&(0x40>>(cnt1%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//f();
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[(cnt1)/7+55]&(0x40>>((cnt1+55)%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//P1&=0XC0;
//f();
//delay(5000);
//relax();
//send(1);
//}

//third()
//{
//uint16 cnt1;
//zt();
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[cnt1/7]&(0x40>>(cnt1%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//P1&=0XC0;
//f();
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[(cnt1)/7+55]&(0x40>>((cnt1+55)%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//P1&=0XC0;
//f();
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[(cnt1)/7+110]&(0x40>>((cnt1+110)%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//P1&=0XC0;
//f();
//delay(5000);
//relax();
//send(1);
//}
//
//forth()
//{
//uint16 cnt1;
//zt();
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[cnt1/7]&(0x40>>(cnt1%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//P1&=0XC0;
//f();
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[(cnt1)/7+55]&(0x40>>((cnt1+55)%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//P1&=0XC0;
//f();
//
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[(cnt1)/7+110]&(0x40>>((cnt1+110)%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//P1&=0XC0;
//f();
//
//clean();
//for(cnt1=0;cnt1<384;cnt1++)
//{
//if((bit)(uart_data[(cnt1)/7+165]&(0x40>>((cnt1+165)%7))))
//{
//dot[cnt1/64]++;
//H_dat(1);
//}
//else
//{H_dat(0);}
//}
//H_lock();
//delay(10);
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go((uint8)cnt1);}
//P1&=0XC0;
//f();
//delay100us();
//for(cnt1=0;cnt1<6;cnt1++)
//{H_go(cnt1);}
//P1&=0XC0;
//f();
//
//delay(5000);
//relax();
//send(1);
//}