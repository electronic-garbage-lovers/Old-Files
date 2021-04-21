#include "lowpower.h"
#include "lcd.h"


/*******************************************************************************
* ������    	   : Enter_Stop_Mode
* ��������	   :����ͣ��ģʽ
* ���� 		       : ��
*���	  		   : ��
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

	/*ͣ��ģʽ�������ص��ղ�ֹͣ�ĵط���Ҳ�������λ�ã���Ϊͣ��ģʽ�ر������е�ʱ�ӣ��ڴ˴���Ҫʹ����Ҫ�õ���ʱ��*/	
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
* ������          : My_EXTI_Init
* ��������	   : ���ⲿ�жϳ�ʼ��
* ����      	   :��
* ���			   : ��
*******************************************************************************/
void My_EXTI_Init(void)
{
	NVIC_InitTypeDef NVIC_InitStructure;
	EXTI_InitTypeDef  EXTI_InitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO,ENABLE);
	
	GPIO_EXTILineConfig(GPIO_PortSourceGPIOB, GPIO_PinSource14);//ѡ��GPIO�ܽ������ⲿ�ж���·	
	
	//EXTI0 NVIC ����
	NVIC_InitStructure.NVIC_IRQChannel = EXTI15_10_IRQn;//EXTI14�ж�ͨ��
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority=2;//��ռ���ȼ�
	NVIC_InitStructure.NVIC_IRQChannelSubPriority =3;		//�����ȼ�
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;			//IRQͨ��ʹ��
	NVIC_Init(&NVIC_InitStructure);	//?��ʼ��VIC�Ĵ���
	
	EXTI_InitStructure.EXTI_Line=EXTI_Line14;
	EXTI_InitStructure.EXTI_Mode=EXTI_Mode_Interrupt;
	EXTI_InitStructure.EXTI_Trigger=EXTI_Trigger_Rising;
	EXTI_InitStructure.EXTI_LineCmd=ENABLE;
	EXTI_Init(&EXTI_InitStructure);	
}


/*******************************************************************************
* ������       : My_EXTI_Init
* ��������	   : �ⲿ�ж�15-10����
* ����      	 :��
* ���			   : ��
*******************************************************************************/
void EXTI15_10_IRQHandler(void)
{
	if(EXTI_GetITStatus(EXTI_Line14)==1)
	{
	}
	EXTI_ClearITPendingBit(EXTI_Line14);
}


