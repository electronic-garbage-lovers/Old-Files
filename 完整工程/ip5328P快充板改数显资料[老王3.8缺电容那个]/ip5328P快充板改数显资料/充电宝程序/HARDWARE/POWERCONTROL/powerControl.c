#include "powerControl.h"
#include "delay.h"
#include "ip5328p.h"

void powerControl_init(void)
{
	GPIO_InitTypeDef  GPIO_InitStructure; 
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA|RCC_APB2Periph_GPIOB|RCC_APB2Periph_AFIO,ENABLE);
	
//	//用于检测充电宝芯片是否在工作
//	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
//	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;			//置为下拉输入
//	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	//充电宝启动控制
	GPIO_InitStructure.GPIO_Pin =  GPIO_Pin_11;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	GPIO_SetBits(GPIOB,GPIO_Pin_11);

	//电源按键检测引脚
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;			//置为上拉输入
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	GPIO_SetBits(GPIOB,GPIO_Pin_14);										//检测引脚初始化输出高
	
	//电源控制引脚
	GPIO_InitStructure.GPIO_Pin =  GPIO_Pin_15;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;	//置为开漏，外部上拉。设置为推挽可能会烧坏单片机
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	power_on;																					//打开电源
	
	while(power_read==Bit_RESET);											//等待电源按键释放
	
	if(IP5328P_BatOCV()<=2.6)													//如果充电宝未在工作 按下按键启动一下
	{
		GPIO_ResetBits(GPIOB,GPIO_Pin_11);
		delay_ms(500);
		GPIO_SetBits(GPIOB,GPIO_Pin_11);
	}
}


void power_off(void)
{
	GPIO_InitTypeDef  GPIO_InitStructure; 
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;			//置为开漏输出
	GPIO_Init(GPIOB, &GPIO_InitStructure);								
	GPIO_ResetBits(GPIOB,GPIO_Pin_14);										//检测引脚初始化输出高  防止影响关闭电源
	
	GPIO_SetBits(GPIOB,GPIO_Pin_15);
}



