/**
  ******************************************************************************
  * @date    2016-10-08
  * @brief   CC1101����H�ļ�
  ******************************************************************************
  */



#ifndef __DRV_CC1101_H__
#define __DRV_CC1101_H__


#include "drv_spi.h"
#include "drv_CC1101_Reg.h"


#define PA_TABLE 						{0xc2,0x00,0x00,0x00,0x00,0x00,0x00,0x00,}

/** CC1101Ӳ���ӿڶ��� */
sbit	CC1101_GDO0					=P1^2;
sbit	CC1101_GDO2					=P1^4;
#define CC1101_CSN					SPI_NSS

//IO�ڶ˿ڶ�Ӧ��Bitλ��
#define CC1101_GDO0_PIN_BIT			2
#define CC1101_GDO2_PIN_BIT			4

//IO���üĴ���
#define CC1101_GDO0_PxM0			P1M0
#define CC1101_GDO0_PxM1			P1M1

#define CC1101_GDO2_PxM0			P1M0
#define CC1101_GDO2_PxM1			P1M1


/** ���߲����������� */
#define CC1101_SET_CSN_HIGH( )			spi_set_nss_high( )
#define CC1101_SET_CSN_LOW( )			spi_set_nss_low( )

#define CC1101_GET_GDO0_STATUS( )		( 0 == CC1101_GDO0 ) ? 0 : 1	//GDO0״̬
#define CC1101_GET_GDO2_STATUS( )		( 0 == CC1101_GDO2 ) ? 0 : 1	//GDO2״̬

/** ö�������� */
typedef enum 
{ 
	TX_MODE, 
	RX_MODE 
}CC1101_ModeType;

typedef enum 
{ 
	BROAD_ALL, 
	BROAD_NO, 
	BROAD_0, 
	BROAD_0AND255 
}CC1101_AddrModeType;

typedef enum 
{ 
	BROADCAST, 
	ADDRESS_CHECK
} CC1101_TxDataModeType;


void CC1101_Write_Cmd( uint8_t Command );
void CC1101_Write_Reg( uint8_t Addr, uint8_t WriteValue );
void CC1101_Write_Multi_Reg( uint8_t Addr, uint8_t *pWriteBuff, uint8_t WriteSize );
uint8_t CC1101_Read_Reg( uint8_t Addr );
void CC1101_Read_Multi_Reg( uint8_t Addr, uint8_t *pReadBuff, uint8_t ReadSize );
uint8_t CC1101_Read_Status( uint8_t Addr );
void CC1101_Set_Mode( CC1101_ModeType Mode );
void CC1101_Set_Idle_Mode( void );
void C1101_WOR_Init( void );
void CC1101_Set_Address( uint8_t Address, CC1101_AddrModeType AddressMode);
void CC1101_Set_Sync( uint16_t Sync );
void CC1101_Clear_TxBuffer( void );
void CC1101_Clear_RxBuffer( void );
void CC1101_Tx_Packet( uint8_t *pTxBuff, uint8_t TxSize, CC1101_TxDataModeType DataMode );
uint8_t CC1101_Get_RxCounter( void );
uint8_t CC1101_Rx_Packet( uint8_t *RxBuff );
void CC1101_Reset( void );
void CC1101_Init( void );


#endif

