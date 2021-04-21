uint32 comcnt=60001;
unsigned char combit=0;

UART_init()
{	
/*38400bps at 35Mhz*/
	SCON = 0x50;		//8λ����,�ɱ䲨����
	AUXR |= 0x01;		//����1ѡ��ʱ��2Ϊ�����ʷ�����
	AUXR |= 0x04;		//��ʱ��2ʱ��ΪFosc,��1T
	T2L = 0x1C;		//�趨��ʱ��ֵ
	T2H = 0xFF;		//�趨��ʱ��ֵ
	AUXR |= 0x10;		//������ʱ��2
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
