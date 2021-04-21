#include "powerControl.h"
#include "delay.h"
#include "ip5328p.h"

void powerControl_init(void)
{
	GPIO_InitTypeDef  GPIO_InitStructure; 
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA|RCC_APB2Periph_GPIOB|RCC_APB2Periph_AFIO,ENABLE);
	
//	//���ڼ���籦оƬ�Ƿ��ڹ���
//	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
//	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;			//��Ϊ��������
//	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	//��籦��������
	GPIO_InitStructure.GPIO_Pin =  GPIO_Pin_11;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	GPIO_SetBits(GPIOB,GPIO_Pin_11);

	//��Դ�����������
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;			//��Ϊ��������
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	GPIO_SetBits(GPIOB,GPIO_Pin_14);										//������ų�ʼ�������
	
	//��Դ��������
	GPIO_InitStructure.GPIO_Pin =  GPIO_Pin_15;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;	//��Ϊ��©���ⲿ����������Ϊ������ܻ��ջ���Ƭ��
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	power_on;																					//�򿪵�Դ
	
	while(power_read==Bit_RESET);											//�ȴ���Դ�����ͷ�
	
	if(IP5328P_BatOCV()<=2.6)													//�����籦δ�ڹ��� ���°�������һ��
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
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;			//��Ϊ��©���
	GPIO_Init(GPIOB, &GPIO_InitStructure);								
	GPIO_ResetBits(GPIOB,GPIO_Pin_14);										//������ų�ʼ�������  ��ֹӰ��رյ�Դ
	
	GPIO_SetBits(GPIOB,GPIO_Pin_15);
}



