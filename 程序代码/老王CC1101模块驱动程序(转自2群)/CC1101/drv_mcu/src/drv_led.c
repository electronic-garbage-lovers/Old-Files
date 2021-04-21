/**
  ******************************************************************************
  * @date    2016-10-08
  * @brief   LED����C�ļ�
  ******************************************************************************
  */



#include "drv_led.h"



/**
  * @brief :LED��ʼ��
  * @param :��
  * @note  :��
  * @retval:��
  */ 
void drv_led_init( void )
{
	//�������� ����51��Ƭ������Ҫ
	//LED��������Ϊ�������
	LED_RED_PxM0 |= IO_OUT_PUT_PP_M0 << LED_RED_PIN_BIT;
	LED_RED_PxM1 |= IO_OUT_PUT_PP_M1 << LED_RED_PIN_BIT;
	
	LED_RED_PIN = 1;			//IO��ʼ��״̬�øߣ�LED��
	LED_GREEN_PIN = 1;
}

/**
  * @brief :LED��
  * @param :
  *			@LedPort:LEDѡ��
  * @note  :��
  * @retval:��
  */
void drv_led_on( LedPortType LedPort )
{
	//IO��ƽ�õͣ�LED��
	if( LED_RED == LedPort )
	{
		LED_RED_PIN = 0;		
	}
	else
	{
		LED_GREEN_PIN = 0;
	}
}

/**
  * @brief :LED��
  * @param :
  *			@LedPort:LEDѡ��
  * @note  :��
  * @retval:��
  */
void drv_led_off( LedPortType LedPort )
{
	//IO��ƽ�øߣ�LED��
	if( LED_RED == LedPort )
	{
		LED_RED_PIN = 1;		
	}
	else
	{
		LED_GREEN_PIN = 1;
	}
}

/**
  * @brief :LED��˸
  * @param :
  *			@LedPort:LEDѡ��
  * @note  :��
  * @retval:��
  */
void drv_led_flashing( LedPortType LedPort )
{
	if( LED_RED == LedPort )
	{
		if( 1 == LED_RED_PIN )	
		{
			LED_RED_PIN = 0;
		}
		else
		{
			LED_RED_PIN = 1;
		}
	}
	else
	{
		if( 1 == LED_GREEN_PIN )	
		{
			LED_GREEN_PIN = 0;
		}
		else
		{
			LED_GREEN_PIN = 1;
		}
	}
}



