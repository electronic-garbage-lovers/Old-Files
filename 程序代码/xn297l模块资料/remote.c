#include"stc8.h"
#include"intrins.h"
#include"RF.h"
#define RX//TX or RX
typedef unsigned char u8;
typedef unsigned int u16;
sbit dc=P1^3;//指令0数据1
sbit rst=P1^4;//=0复位
sbit busy=P1^5;//=0在忙，=1空闲
sbit led=P5^4;

unsigned char pl[8]={1,2,3,4,5,6,7,8};
void test()
{
	unsigned char temp[5];
	ucRF_ReadReg(0x05);
	#ifdef TX
	RF_ReadBuf(0x10,temp,5);
	#endif
	#ifdef RX
	RF_ReadBuf(0x0A,temp,5);
	#endif
	ucRF_ReadReg(0x04);
	ucRF_ReadReg(0x01);
	ucRF_ReadReg(0x06);
	ucRF_ReadReg(0x11);
	ucRF_ReadReg(0x00);
	ucRF_ReadReg(0x02);
	ucRF_ReadReg(0x07);
	ucRF_ReadReg(0x17);
}
#ifdef TX
void main()
{
	RF_Init();	//在此函数中，应该确保和接收端的通信模式，RF 地址，Channel，发送速率和Payload长度一致。
	ucRF_ReadReg(STATUS);
	RF_TxMode();//设定tx方式并启动tx
	ucRF_ReadReg(STATUS);
	RF_TxData(pl,8);//本来是txdata用来启动发送，但是发送功能被作者删掉了
	delay_ms(2);
	CE_LOW;
	RF_ClearStatus();
	//while(1);
	
	while(1)
	{	
		switch(ucRF_GetStatus())
		{
		case	TX_DS_FLAG: 		// 普通型发送完成 或 增强型发送成功
			RF_ClearFIFO();
      			RF_ClearStatus ();
		CE_LOW;
			break;
		case	RX_TX_CMP_FLAG:		//发送成功且收到payload
			RF_ClearFIFO();
      			RF_ClearStatus ();
		CE_LOW;
			break;
		case	MAX_RT_FLAG:		// 增强型发送超时失败
			RF_ClearFIFO();
      			RF_ClearStatus ();
		CE_LOW;
			break;
		default:			// rf 处于空闲状态才发送数据
			//RF_TxData(pl,8);
			//RF_TxMode();//设定tx方式并启动tx
			//CE_LOW;
		CE_HIGH;
		delay_ms(1);
			RF_WriteBuf(W_TX_PAYLOAD, pl, 8);
			delay_ms(1);
		//test();
			break;
		}
	}
	
}
#endif
#ifdef RX
void main()
{
	unsigned char ucPayload[8]={0};
	
	RF_Init();//在此函数中，应该确保和发送端的通信模式，RF 地址，Channel，发送速率和Payload长度一致。
	RF_RxMode();

	while(1)
	{
		//test();
		delay_ms(1);
		if(ucRF_DumpRxData(ucPayload, PAYLOAD_WIDTH))
		{
			ucRF_ReadReg(DATAOUT);
			//接收成功
		}
	}
}
#endif