/**
  ******************************************************************************
  * @date    2016-10-08
  * @brief   BUTTON����C�ļ�
  ******************************************************************************
  */


#include "drv_button.h"
#include "drv_delay.h"



/**
  * @brief :������ʼ��
  * @param :��
  * @note  :��
  * @retval:��
  */ 
void drv_button_init( void )
{
	//�������� ����51��Ƭ������Ҫ
	//BUTTON��������Ϊ����
	BUTTON_PxM0 = IO_IN_PUT_ONLY_M0 << BUTTON_PIN_BIT;
	BUTTON_PxM1 = IO_IN_PUT_ONLY_M1 << BUTTON_PIN_BIT;
	
	BUTTON_PIN = 1;		//Ĭ��״̬�ø�
}

/**
  * @brief :������ѯ
  * @param :��
  * @note  :��
  * @retval:
  *			0:����û�а���
  *			1:��⵽��������
  */
uint8_t drv_button_check( void )
{
	if( 1 != BUTTON_PIN )		//��ⰴ������״̬
	{
		drv_delay_ms( 45 );		//����
		if( 1 != BUTTON_PIN )
		{
			return 1;			//�������£����ذ���״̬
		}
	}
	
	return 0;
}

