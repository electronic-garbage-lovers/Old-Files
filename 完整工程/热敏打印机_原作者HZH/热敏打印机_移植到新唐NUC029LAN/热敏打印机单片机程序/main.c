
#include <stdio.h>
#include "M051Series.h"


#define M_A    P37
#define M_A_   P36
#define M_B    P35
#define M_B_   P34

#define LAT    P33
#define CLOCK    P32
#define SI     P42
#define CO	   P40

#define EN 	   P43  //步进电机使能

uint8_t speed=3;//速度
uint8_t x_sta=0;//步进电机状态
uint8_t go1=0,go2=0;
uint8_t dot[6];//点数
uint8_t uart_data[111];

uint32_t comcnt=60001;
uint8_t combit=0;


void SYS_Init(void)
{
    /* Unlock protected registers */
    SYS_UnlockReg();

    /* Enable clock source */
    CLK_EnableXtalRC(CLK_PWRCON_OSC22M_EN_Msk);

    /* Waiting for clock source ready */
    CLK_WaitClockReady(CLK_CLKSTATUS_OSC22M_STB_Msk);

    /* If the defines do not exist in your project, please refer to the related clk.h in the Header folder appended to the tool package. */
    /* Set HCLK clock */
    CLK_SetHCLK(CLK_CLKSEL0_HCLK_S_HIRC, CLK_CLKDIV_HCLK(1));

    /* Enable IP clock */
    CLK_EnableModuleClock(UART0_MODULE);

    /* Set IP clock */
    CLK_SetModuleClock(UART0_MODULE, CLK_CLKSEL1_UART_S_HIRC, CLK_CLKDIV_UART(1));

    /* Update System Core Clock */
    /* User can use SystemCoreClockUpdate() to calculate SystemCoreClock. */
    SystemCoreClockUpdate();
		
		
		 /*---------------------------------------------------------------------------------------------------------*/
    /* Init I/O Multi-function                                                                                 */
    /*---------------------------------------------------------------------------------------------------------*/

    /* Set P3 multi-function pins for UART0 RXD and TXD */
    SYS->P3_MFP &= ~(SYS_MFP_P30_Msk | SYS_MFP_P31_Msk);
    SYS->P3_MFP |= (SYS_MFP_P30_RXD0 | SYS_MFP_P31_TXD0);

    /* Lock protected registers */
    SYS_LockReg();

}

void UART0_Init(void)
{

    /* Reset UART0 */
    SYS_ResetModule(UART0_RST);

    /* Configure UART0 and set UART0 Baudrate */
    UART_Open(UART0, 38400);
	
	
   UART_ENABLE_INT(UART0, UART_IER_RDA_IEN_Msk ); //Rx ready interrupt
   NVIC_EnableIRQ(UART0_IRQn);
	
}



void delay(uint32_t i)//延时
{
uint32_t a;
for(a=0;a<i;a++);
}



void Delay_ms(uint16_t ms)		//@24MHz
{
	uint8_t i = 22,j = 128,k;
	
	for(k=0;k<ms;k++)
	{
		i = 22;
		j = 128;
		do
		{
			while (--j);
		} while (--i);
	}
}



void x_m(uint8_t dat)//置步进电机状态
{
  switch(dat)
  {
    case 0:M_A_=0;M_A=1;M_B=1;M_B_=0;break;
    case 1:M_A_=1;M_A=0;M_B=1;M_B_=0;break;
    case 2:M_A_=1;M_A=0;M_B=0;M_B_=1;break;
    case 3:M_A_=0;M_A=1;M_B=0;M_B_=1;break;
   }
}



void forward()  //前进一步
{

  if(x_sta==3)
  {x_sta=0;}
	
  else
  {x_sta++;}
	EN=1;
  x_m(x_sta);
	CLK_SysTickDelay(5000); //延时5ms
	EN=0;
	
}

void back()  //后退一步
{
	
  if(x_sta==0)
  {x_sta=3;}
	
   else
   {x_sta--;}
	 EN=1;
   x_m(x_sta);
	 CLK_SysTickDelay(5000); //延时5ms
	 EN=0;
;
}



void H_go(uint8_t dat1)//第几个组，0开始到5
{
  (P2->DOUT)&=0XC0;
  (P2->DOUT)|=(1<<dat1);
  Delay_ms(dot[dat1]/speed);
  (P2->DOUT)&=0XC0;
  if(dot[dat1]>55)
   {
     Delay_ms(dot[dat1]/speed);
   }
}


void H_dat(uint8_t dat1)//写入一位数据
{
  SI=dat1;
  CLOCK=1;
  delay(5);
  CLOCK=0;
}


void H_lock()//锁存
{
  LAT=0;
  delay(5);
  LAT=1;
}


void clean()
{
  dot[0]=dot[1]=dot[2]=dot[3]=dot[4]=dot[5]=0;
}


void once()
{
  uint16_t cnt1;

  clean();
  for(cnt1=0;cnt1<384;cnt1++)
  {
    if((uint8_t)(uart_data[cnt1/7]&(0x40>>(cnt1%7))))
     {
       dot[cnt1/64]++;
       H_dat(1);
     }
    else
    {H_dat(0);}
   }

  H_lock();

  for(cnt1=0;cnt1<6;cnt1++)
   {
     H_go((uint8_t)cnt1);
   }
	 
  (P2->DOUT)&=0XC0;
  forward();
  for(cnt1=0;cnt1<6;cnt1++)
  {H_go(cnt1);}
  if((uint16_t)(dot[0]+dot[1]+dot[2]+dot[3]+dot[4]+dot[5])<2)
   {
    delay(1000);
   }
  (P2->DOUT)&=0XC0;
  forward();
  UART_WRITE(UART0, 1); //完成一行
}



/*UART0中断处理函数*/
void UART0_IRQHandler(void)
{
	  uint16_t cnt1;

    uint32_t u32IntSts = UART0->ISR;

   if(u32IntSts & UART_ISR_RDA_IF_Msk)
    {
      uart_data[combit]=UART_READ(UART0);
      if(uart_data[combit]>127)
			{ 
       if(uart_data[combit]==128)
        {
          if(combit==55)
            {
              once();
            }

        }

     else if((uart_data[0]==129)&&(combit==0)){go1=1;UART_WRITE(UART0, 2);}
     else if((uart_data[0]==130)&&(combit==0)){go1=0;go2=0;UART_WRITE(UART0, 3);}
     else if((uart_data[0]==131)&&(combit==0)){go2=1;UART_WRITE(UART0, 4);}
		 //else if((uart_data[0]==132)&&(combit==0)){speed=1;}
		 //else if((uart_data[0]==133)&&(combit==0)){speed=2;}
		 //else if((uart_data[0]==134)&&(combit==0)){speed=3;}
		 //else if((uart_data[0]==135)&&(combit==0)){speed=4;}
		 //else if((uart_data[0]==136)&&(combit==0)){speed=5;}
		 
     else {UART_WRITE(UART0, 5);}
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
     if(combit>111){ SYS_ResetModule(UART0_RST);}
    }

	}
		
}



/*---------------------------------------------------------------------------------------------------------*/
/* MAIN function                                                                                           */
/*---------------------------------------------------------------------------------------------------------*/
int main(void)
{
    uint8_t cnt2;
	
    SYS_Init();
    
	  EN=0;
	
    M_A_=0;
    M_A=0;
    M_B=0;
    M_B_=0;
    (P2->DOUT)&=0XC0;
    CLOCK=0;
    LAT=1;
    CO=1;
	
    /* Init UART0 for printf */
    UART0_Init();
	
     
    for(cnt2=0;cnt2<60;cnt2++)
    {
      uart_data[cnt2]=0;
     }
      	
		 
    while(1)
		{
					
			
		  if(comcnt<60000)
       {
         comcnt++;
       }
      else if(comcnt==60000)
       {
        comcnt++; 
        combit=0;
        UART_WRITE(UART0, 5); //通讯出错，请求重复
       }
			 
     if(go1)//前进 
     {
		
       forward();
   
      }
		 
     if(go2)//后退 
     {
			 
       back();
        
      }
		
	
		}	
			
}


