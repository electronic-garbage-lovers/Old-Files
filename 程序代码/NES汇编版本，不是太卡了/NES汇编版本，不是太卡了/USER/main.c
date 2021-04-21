#include "led.h"
#include "delay.h"
#include "key.h"
#include "sys.h"
#include "lcd.h"
#include "usart.h"	 
#include "sram.h" 
#include "nes_main.h"
//ALIENTEK战舰STM32开发板实验37
//外部SRAM 实验  
//技术支持：www.openedv.com
//广州市星翼电子科技有限公司 

u32 testsram[250000] __attribute__((at(0X60000000)));//测试用数组
//外部内存测试(最大支持1M字节内存测试)	    
void fsmc_sram_test(u16 x,u16 y)
{  
	u32 i=0;  	  
	u8 temp=0;	   
	u8 sval=0;	//在地址0读到的数据	  				   
  	LCD_ShowString(x,y,239,y+16,16,"Ex Memory Test:   0KB"); 
	//每隔4K字节,写入一个数据,总共写入256个数据,刚好是1M字节
	for(i=0;i<1024*1024;i+=4096)
	{
		FSMC_SRAM_WriteBuffer(&temp,i,1);
		temp++;
	}
	//依次读出之前写入的数据,进行校验		  
 	for(i=0;i<1024*1024;i+=4096) 
	{
  		FSMC_SRAM_ReadBuffer(&temp,i,1);
		if(i==0)sval=temp;
 		else if(temp<=sval)break;//后面读出的数据一定要比第一次读到的数据大.	   		   
		LCD_ShowxNum(x+15*8,y,(u16)(temp-sval+1)*4,4,16,0);//显示内存容量  
 	}					 
}

 int main(void)
 {	 
	u8 key;		 
 	u8 i=0;	     
	u32 ts=0;
	 SystemInit();
	 
	delay_init();	    	 //延时函数初始化	  
	NVIC_Configuration(); 	 //设置NVIC中断分组2:2位抢占优先级，2位响应优先级
	uart_init(9600);	 	//串口初始化为9600
 	LED_Init();			     //LED端口初始化
	LCD_Init();	
	KEY_Init();	 	
 
  	FSMC_SRAM_Init();		//初始化外部SRAM  
	 
  if (SysTick_Config(SystemCoreClock / 6))	  //60Hz
  { 
    /* Capture error */ 
    while (1);
  }
	
	
 nes_main();
	 
}




