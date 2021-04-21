uint32 comcnt=60001;
unsigned char combit=0;

UART_init()
{	
/*38400bps at 35Mhz*/
	SCON = 0x50;		//8位数据,可变波特率
	AUXR |= 0x01;		//串口1选择定时器2为波特率发生器
	AUXR |= 0x04;		//定时器2时钟为Fosc,即1T
	T2L = 0x1C;		//设定定时初值
	T2H = 0xFF;		//设定定时初值
	AUXR |= 0x10;		//启动定时器2
	ES=1;
	EA=1;	
}




UART_rec() interrupt 4 
{
uint16 cnt1;
if(RI)
{
RI=0;
uart_data[combit]=SBUF;
if(uart_data[combit]>127)
{
if(uart_data[combit]==128)
{
if(combit==55)
{
once();
}
else if(combit==110)
{
twice();
}
//else if(combit==165)
//{
//third();
//}
//else if(combit==220)
//{
//forth();
//}

}

else if((uart_data[0]==129)&&(combit==0)){go1=1;send(2);}
else if((uart_data[0]==130)&&(combit==0)){go1=0;go2=0;send(3);}
else if((uart_data[0]==131)&&(combit==0)){go2=1;send(4);}
else {send(5);}
combit=0;
comcnt=60001;
for(cnt1=0;cnt1<60;cnt1++)
{
uart_data[cnt1]=0;
}
}
else
{
combit++;  
comcnt=0;
if(combit>111){ IAP_CONTR = 0x60;}
}

}
}
