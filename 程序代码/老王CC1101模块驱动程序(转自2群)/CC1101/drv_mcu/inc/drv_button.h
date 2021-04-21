/**
  ******************************************************************************

  * @date    2016-10-08
  * @brief   BUTTON����H�ļ�
  ******************************************************************************
  */


#ifndef __DRV_BUTTON_H__
#define __DRV_BUTTON_H__


#include <reg52.h>
#include "typedef.h"



//�����ӿڶ���
sbit		BUTTON_PIN				=P3^2;

//BUTTON�����ڶ˿ڵ�Bitλ��
#define		BUTTON_PIN_BIT			2							

#define		BUTTON_PxM0				P3M0
#define		BUTTON_PxM1				P3M1


/** ����״̬���� */
enum
{
	BUTOTN_UP = 0,		//����δ����
	BUTOTN_PRESS_DOWN	//��������
};



void drv_button_init( void );
uint8_t drv_button_check( void );

#endif


