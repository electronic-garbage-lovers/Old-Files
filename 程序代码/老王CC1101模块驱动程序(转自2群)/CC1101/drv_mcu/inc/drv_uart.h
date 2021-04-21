/**
  ******************************************************************************
  * @date    2016-10-08
  * @brief   UART����H�ļ�
  ******************************************************************************
  */


#ifndef __DRV_UART_H__
#define __DRV_UART_H__



#include <reg52.h>
#include "typedef.h"


#define SYSTEM_CLK_HZ				((uint32_t)11059200)	//ϵͳʱ��11.0592M


//���ڽӿڶ���
sbit	UART_TX						=P3^1;
sbit	UART_RX						=P3^0;

//IO�ڶ˿ڶ�Ӧ��Bitλ��
#define UART_TX_PIN_BIT				1
#define UART_RX_PIN_BIT				0

//IO���üĴ���
#define UART_TX_PxM0				P3M0
#define UART_TX_PxM1				P3M1

#define UART_RX_PxM0				P3M0
#define UART_RX_PxM1				P3M1

//���ڹ���ģʽ
#define UART_MODE					((uint8_t)0xC0)
#define UART_SHITT_REGSISTER		((uint8_t)0x00)		//��λ�Ĵ���
#define UART_8BAUDRATE_VOLATILE		((uint8_t)0x40)		//8λ�����ʿɱ�	
#define UART_9BAUDRATE				((uint8_t)0x80)		//9λ������	
#define UART_9BAUDRATE_VOLATILE		((uint8_t)0xC0)		//9λ�����ʿɱ�	
#define UART_RX						((uint8_t)0x10)		//���չ���

//��ʱ��1���ƶ���
#define TIM1_MODE					((uint8_t)0x30)
#define TIM1_MODE_0					((uint8_t)0x00)		//TIM1ģʽ0	13λ������/��ʱ��
#define TIM1_MODE_1					((uint8_t)0x10)		//TIM1ģʽ1	16λ������/��ʱ��
#define TIM1_MODE_2					((uint8_t)0x20)		//TIM1ģʽ2 8λ�Զ���װ
#define TIM1_MODE_3					((uint8_t)0x30)		//TIM1ģʽ3 2��8λ��ʱ��







void drv_uart_init( );
void drv_uart_tx_bytes( uint8_t* TxBuffer, uint8_t Length );
uint8_t drv_uart_rx_bytes( uint8_t* RxBuffer );



#endif




