#include "nes_main.h"
#include "joypad.h"
#include "usart.h"	  //	����
#include "key.h"
//////////////////////////////////////////////////////////////////////////////////	 
//�ҵ� STM32������
//NESģ�����ֱ� ����	   
//�޸�����:2012/10/3
//�汾��V1.0		       								  
////////////////////////////////////////////////////////////////////////////////// 	   

u8  JOY_key=0xFF;
JoyPadType JoyPad[2];

u8 NES_GetJoyPadVlaue(int JoyPadNum) 	 //	 �õ��ֱ�����
{
	u8 retval = 0;
	if(JoyPadNum==0)
	{		 
        retval=(JOY_key>>JoyPad[0].index)&0X01;
        if(JoyPad[0].index==20)retval=1;//20λ��ʾ��������λ.
	//	printf("\r\n ����: %d",retval);	 //��д�Ĵ��� ������	 
		JoyPad[0].index++;
	}
 	return retval;
}
//��ȡ�ֱ�����ֵ.
//FC�ֱ����������ʽ:
//ÿ��һ������,���һλ����,���˳��:
//A->B->SELECT->START->UP->DOWN->LEFT->RIGHT.
//�ܹ�8λ,������C��ť���ֱ�,����C��ʵ�͵���A+Bͬʱ����.
//������0,�ɿ���1.	 
//[0]:��  0--->7
//[1]:��
//[2]:��
//[3]:��
//[4]:Start
//[5]:Select
//[6]:B
//[7]:A
void NES_JoyPadReset(void)
{
	JoyPad[0].state = 1;
    JoyPad[0].index = 0;
 // JOY_key=0xFF-((��  <<7)|(��  <<6)|(��  <<5)|(��  <<4)|Start<<3)|Select<<2)|(B  <<1)|A   );
///	JOY_key=0xFF-((KEY5<<7)|(KEY3<<6)|(0X01<<5)|(0X01<<4)|(KEY1<<3)|(KEY2<<2)|(0X01<<1)|KEY4);
//	JOYPAD_LAT=1;//   ����һ��
// 	JOYPAD_LAT=0;
		
	JoyPad[1].state = 1;
    JoyPad[1].index = 0;
}

void NES_JoyPadInit(void)
{
	JoyPad[0].state = 0;//״̬Ϊ0,��ʾ��ֹ
    JoyPad[0].index = 0;
	JoyPad[0].value = 1 << 20;

	JoyPad[1].state = 0;
    JoyPad[1].index = 0;
	JoyPad[1].value = 1 << 19;
}

void NES_JoyPadDisable(void)
{			  
}












