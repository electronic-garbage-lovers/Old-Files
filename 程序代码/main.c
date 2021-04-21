#include "main.h"

//定义变量
unsigned char temp = 0xfe;
unsigned char KEY_NUM = 0;

//****************************************************
//主函数
//****************************************************
void main()
{
	while(1)
	{
		LED1 = 0;
		LED2 = 1;
		Delay_ms(1500);
		LED1 = 1;
		LED2 = 0;
		Delay_ms(1500);

		
	}
}
//****************************************************
//MS延时函数(12M晶振下测试)
//****************************************************
void Delay_ms(unsigned int n)
{
	unsigned int  i,j;
	for(i=0;i<n;i++)
		for(j=0;j<123;j++);
}

