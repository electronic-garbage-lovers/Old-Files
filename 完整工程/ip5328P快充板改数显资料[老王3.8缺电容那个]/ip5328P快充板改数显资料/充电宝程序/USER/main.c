#include "delay.h"
#include "sys.h"
#include "usart.h"
#include "usart2.h"
#include "includes.h"
#include "stdio.h"
#include "main.h"
#include "lcd.h"
#include "gui.h"
#include "test.h"
#include "ip5328p.h"
#include "i2c.h"
#include "powerControl.h"

//START ����
#define START_TASK_PRIO      		10
#define START_STK_SIZE  				64
OS_STK START_TASK_STK[START_STK_SIZE];
void start_task(void *pdata);


//������
#define MAIN_TASK_PRIO       		4
#define MAIN_STK_SIZE  					128
OS_STK MAIN_TASK_STK[MAIN_STK_SIZE];
void main_task(void *pdata);

//��Դ��������
#define POWER_TASK_PRIO       		2
#define POWER_STK_SIZE  					256
OS_STK POWER_TASK_STK[POWER_STK_SIZE];
void power_task(void *pdata);

//��ع�������
#define BATTERY_TASK_PRIO       		3
#define BATTERY_STK_SIZE  					256
OS_STK BATTERY_TASK_STK[BATTERY_STK_SIZE];
void battery_task(void *pdata);

OS_TMR   * tmr1;						//�����ʱ��1
OS_TMR   * tmr2;						//�����ʱ��2
OS_TMR   * tmr3;						//�����ʱ��3


//�����ʱ��1�Ļص�����,ÿ100msִ��һ��
void tmr1_callback(OS_TMR *ptmr,void *p_arg) 
{
	   
}

//�����ʱ��2�Ļص�����				  	   
void tmr2_callback(OS_TMR *ptmr,void *p_arg) 
{	
		
}
//�����ʱ��3�Ļص�����				  	   
void tmr3_callback(OS_TMR *ptmr,void *p_arg) 
{	
		
} 

int main(void)
{
 	delay_init();	    	 																			//��ʱ������ʼ��
	NVIC_Configuration();																			//����NVIC�жϷ���2:2λ��ռ���ȼ���2λ��Ӧ���ȼ�
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE); 			//����AFIOʱ��
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE);	//ʹ��JTAGDisable��������JTAG�ӿ�
	powerControl_init();																			//��Դ����
	uart_init(115200);																				//��ʼ������
	uart2_init(9600);																					//��ʼ������2
	LCD_Init();																								//LCD��ʼ��
	i2c_init();
	Show_Str(0,30,BLUE,BLACK," OUT2   TYPE-C    VIN    OUT1",16,0);
	
	OSInit();  	 						//��ʼ��UCOSII
 	OSTaskCreate(start_task,(void *)0,(OS_STK *)&START_TASK_STK[START_STK_SIZE-1],START_TASK_PRIO );//������ʼ����
	OSStart();							//UCOSII��ʼ
}							    

void start_task(void *pdata)//��ʼ����
{
  OS_CPU_SR cpu_sr=0;
	pdata = pdata; 	
	
	OSStatInit();							//��ʼ��ͳ������.�������ʱ1��������	
 	OS_ENTER_CRITICAL();			//�����ٽ���(�޷����жϴ��)
	
 	OSTaskCreate(main_task,(void *)0,(OS_STK*)&MAIN_TASK_STK[MAIN_STK_SIZE-1],MAIN_TASK_PRIO);
	OSTaskCreate(power_task,(void *)0,(OS_STK*)&POWER_TASK_STK[POWER_STK_SIZE-1],POWER_TASK_PRIO);									//������Դ��������
	OSTaskCreate(battery_task,(void *)0,(OS_STK*)&BATTERY_TASK_STK[BATTERY_STK_SIZE-1],BATTERY_TASK_PRIO);					//������ع�������
	
 	OSTaskSuspend(START_TASK_PRIO);	//������ʼ����.
	OS_EXIT_CRITICAL();							//�˳��ٽ���(���Ա��жϴ��)
}


u8 buf[20];
u8 mode;


void main_task(void *pdata)//������
{
 
//	u8 err;
// 	tmr1=OSTmrCreate(10,10,OS_TMR_OPT_PERIODIC,(OS_TMR_CALLBACK)tmr1_callback,0,"tmr1",&err);		//100msִ��һ��
//	tmr2=OSTmrCreate(10,20,OS_TMR_OPT_PERIODIC,(OS_TMR_CALLBACK)tmr2_callback,0,"tmr2",&err);		//200msִ��һ��
//	tmr3=OSTmrCreate(10,10,OS_TMR_OPT_PERIODIC,(OS_TMR_CALLBACK)tmr3_callback,0,"tmr3",&err);		//100msִ��һ��
//	OSTmrStart(tmr1,&err);//���������ʱ��1
//	OSTmrStart(tmr2,&err);//���������ʱ��2
	

//		main_test(); 		//����������
//		menu_test();     //3D�˵���ʾ����
//		Test_Color();  		//��ˢ��������
//		Test_FillRec();		//GUI���λ�ͼ����
//		Test_Circle(); 		//GUI��Բ����
//		Test_Triangle();    //GUI�����λ�ͼ����
//		English_Font_test();//Ӣ������ʾ������
//		Chinese_Font_test();//��������ʾ������
//		Pic_test();			//ͼƬ��ʾʾ������
//		Rotate_Test();   //��ת��ʾ����
	
/*-----------------------------------��ȡ��ص�ѹ����----------------------------------*/
		sprintf(buf, "BAT:%1.2fV  %1.2fA", IP5328P_BatOCV(),IP5328P_BatCurrent());						//������˵ĵ�ѹ�͵���
		Show_Str(0,0,BLUE,BLACK,buf,16,0);
/*-----------------------------------�ӿ�״̬--------------------------------------*/		
		sprintf(buf, "  %1d      %1d        %1d      %1d  ",mos_state.OUT2,mos_state.TypeC,mos_state.VIN,mos_state.OUT1);		
		Show_Str(0,50,BLUE,BLACK,buf,16,0);
/*-----------------------------------��ȡ�ӿڵ�ѹ----------------------------------*/
		sprintf(buf, " %2dV     %2dV     %2dV    %2dV",voltage.OUT2,voltage.TypeC,voltage.VIN,voltage.OUT1);
		Show_Str(0,70,BLUE,BLACK,buf,16,0);
/*-----------------------------------��ȡ��ص�ѹ����----------------------------------*/
		sprintf(buf, " %1.2fA  %1.2fA    %1.2fA  %1.2fA",current.OUT2,current.TypeC,current.VIN,current.OUT1);
		Show_Str(0,90,BLUE,BLACK,buf,16,0);
/*-----------------------------------��ȡ��Դ����----------------------------------*/
		sprintf(buf, "Power:%2.1fW   ",power);
		Show_Str(150,0,BLUE,BLACK,buf,16,0);
	
		while(1)
		{
		read_Parameters();										//��ȡ����

/*-----------------------------------��ȡ��ص�ѹ����----------------------------------*/
		sprintf(buf, "BAT:%1.2fV  %1.2fA", IP5328P_BatVoltage(),IP5328P_BatCurrent());						//������˵ĵ�ѹ�͵���
		Show_Str(0,0,BLUE,BLACK,buf,16,0);
/*-----------------------------------�ӿ�״̬--------------------------------------*/		
		sprintf(buf, "  %1d      %1d        %1d      %1d  ",mos_state.OUT2,mos_state.TypeC,mos_state.VIN,mos_state.OUT1);		
		Show_Str(0,50,BLUE,BLACK,buf,16,0);
/*-----------------------------------��ȡ�ӿڵ�ѹ----------------------------------*/
		sprintf(buf, " %2dV    %2dV      %2dV    %2dV",voltage.OUT2,voltage.TypeC,voltage.VIN,voltage.OUT1);
		Show_Str(0,70,BLUE,BLACK,buf,16,0);
/*-----------------------------------��ȡ��ص�ѹ����----------------------------------*/
		sprintf(buf, " %1.2fA  %1.2fA    %1.2fA  %1.2fA",current.OUT2,current.TypeC,current.VIN,current.OUT1);
		Show_Str(0,90,BLUE,BLACK,buf,16,0);
/*-----------------------------------��ȡ��Դ����----------------------------------*/
		sprintf(buf, "Power:%2.1fW   ",power);
		Show_Str(150,0,BLUE,BLACK,buf,16,0);
			
		delay_ms(100);


		}
}

void power_task(void *pdata)												//��Դ��������
{
	unsigned int Long_press=0;
	delay_ms(500);delay_ms(500);delay_ms(500);delay_ms(500);//���ϵ��ѹ���� ��ʱ�ȴ���ѹ�ȶ�
		while(1)
		{
				if(power_read==Bit_RESET)//���¹ػ��� �ػ�
				{
					Long_press++;
				}
				else
				{
					if(Long_press>30)
					{
						while(power_read==Bit_RESET)delay_ms(10);
						delay_ms(500);delay_ms(500);delay_ms(500);
						power_off();														//�رյ�Դ
					}
				}
				delay_ms(10);

		}
}


void battery_task(void *pdata)											//��ع�������
{
	while(1)
	{
		if(IP5328P_BatOCV()<=2.6)
		{
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			power_off();														//�رյ�Դ
		}
		else
		{
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			delay_ms(500);delay_ms(500);
			power_off();														//�رյ�Դ
		}	
		delay_ms(10);
	}
}


