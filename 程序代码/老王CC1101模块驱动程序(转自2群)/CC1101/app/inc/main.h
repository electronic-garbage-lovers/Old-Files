/**
  ******************************************************************************

  * @brief   主配置H文件
  ******************************************************************************
  * @attention

  ******************************************************************************
  */



#ifndef __MAIN_H__
#define __MAIN_H__

#include "drv_CC1101.h"
#include "drv_uart.h"
#include "drv_button.h"
#include "drv_delay.h"
#include "drv_led.h"


#define 	__CC1101_TX_TEST__	//**@@ 如果测试发送功能则需要定义该宏，如果测试接收则需要屏蔽该宏 **@@//


/** 发送模式定义 */
enum
{
	TX_MODE_1 = 0,		//发送模式1，发送固定的字符串
	TX_MODE_2			//发送模式2，发送串口接收到的数据
};


#endif

