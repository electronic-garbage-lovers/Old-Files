/**
  ******************************************************************************

  * @date    2016-10-08
  * @brief   BUTTON配置H文件
  ******************************************************************************
  */


#ifndef __DRV_BUTTON_H__
#define __DRV_BUTTON_H__


#include <reg52.h>
#include "typedef.h"



//按键接口定义
sbit		BUTTON_PIN				=P3^2;

//BUTTON引脚在端口的Bit位置
#define		BUTTON_PIN_BIT			2							

#define		BUTTON_PxM0				P3M0
#define		BUTTON_PxM1				P3M1


/** 按键状态定义 */
enum
{
	BUTOTN_UP = 0,		//按键未按下
	BUTOTN_PRESS_DOWN	//按键按下
};



void drv_button_init( void );
uint8_t drv_button_check( void );

#endif


