#include "lowpower.h"
#include "lcd.h"


/*******************************************************************************
* 函数名    	   : Enter_Stop_Mode
* 函数功能	   :进入停机模式
* 输入 		       : 无
*输出	  		   : 无
*******************************************************************************/
void Enter_Stop_Mode(void)	
{
	EXTI_InitTypeDef EXTI_InitStructure;
	
	My_EXTI_Init();
	
	/**************************************1*********************************/
	EXTI_ClearITPendingBit(EXTI_Line14);                                  
	EXTI_InitStructure.EXTI_Line = EXTI_Line14;
	EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
	EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising_Falling;
	EXTI_InitStructure.EXTI_LineCmd = ENABLE;
	EXTI_Init(&EXTI_InitStructure);

	PWR_EnterSTOPMode(PWR_Regulator_LowPower,PWR_STOPEntry_WFI);//PWR_Regulator_ON

	/*停机模式回来后会回到刚才停止的地方，也就是这个位置，因为停机模式关闭了所有的时钟，在此处需要使能需要用到的时钟*/	
	SystemInit();
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB,ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC,ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOD,ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOE,ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOF,ENABLE);
	LCD_LED=1;
}

/*******************************************************************************
* 函数名          : My_EXTI_Init
* 函数功能	   : í外部中断初始化
* 输入      	   :无
* 输出			   : 无
*******************************************************************************/
void My_EXTI_Init(void)
{
	NVIC_InitTypeDef NVIC_InitStructure;
	EXTI_InitTypeDef  EXTI_InitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO,ENABLE);
	
	GPIO_EXTILineConfig(GPIO_PortSourceGPIOB, GPIO_PinSource14);//选择GPIO管脚用作外部中断线路	
	
	//EXTI0 NVIC 配置
	NVIC_InitStructure.NVIC_IRQChannel = EXTI15_10_IRQn;//EXTI14中断通道
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority=2;//抢占优先级
	NVIC_InitStructure.NVIC_IRQChannelSubPriority =3;		//子优先级
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;			//IRQ通道使能
	NVIC_Init(&NVIC_InitStructure);	//?初始化VIC寄存器
	
	EXTI_InitStructure.EXTI_Line=EXTI_Line14;
	EXTI_InitStructure.EXTI_Mode=EXTI_Mode_Interrupt;
	EXTI_InitStructure.EXTI_Trigger=EXTI_Trigger_Rising;
	EXTI_InitStructure.EXTI_LineCmd=ENABLE;
	EXTI_Init(&EXTI_InitStructure);	
}


/*******************************************************************************
* 函数名       : My_EXTI_Init
* 函数功能	   : 外部中断15-10函数
* 输入      	 :无
* 输出			   : 无
*******************************************************************************/
void EXTI15_10_IRQHandler(void)
{
	if(EXTI_GetITStatus(EXTI_Line14)==1)
	{
	}
	EXTI_ClearITPendingBit(EXTI_Line14);
}


