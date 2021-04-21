#include"stc8.h"
#include"intrins.h"
#include"RF.h"
#define RX//TX or RX
typedef unsigned char u8;
typedef unsigned int u16;
sbit dc=P1^3;//ָ��0����1
sbit rst=P1^4;//=0��λ
sbit busy=P1^5;//=0��æ��=1����
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
	RF_Init();	//�ڴ˺����У�Ӧ��ȷ���ͽ��ն˵�ͨ��ģʽ��RF ��ַ��Channel���������ʺ�Payload����һ�¡�
	ucRF_ReadReg(STATUS);
	RF_TxMode();//�趨tx��ʽ������tx
	ucRF_ReadReg(STATUS);
	RF_TxData(pl,8);//������txdata�����������ͣ����Ƿ��͹��ܱ�����ɾ����
	delay_ms(2);
	CE_LOW;
	RF_ClearStatus();
	//while(1);
	
	while(1)
	{	
		switch(ucRF_GetStatus())
		{
		case	TX_DS_FLAG: 		// ��ͨ�ͷ������ �� ��ǿ�ͷ��ͳɹ�
			RF_ClearFIFO();
      			RF_ClearStatus ();
		CE_LOW;
			break;
		case	RX_TX_CMP_FLAG:		//���ͳɹ����յ�payload
			RF_ClearFIFO();
      			RF_ClearStatus ();
		CE_LOW;
			break;
		case	MAX_RT_FLAG:		// ��ǿ�ͷ��ͳ�ʱʧ��
			RF_ClearFIFO();
      			RF_ClearStatus ();
		CE_LOW;
			break;
		default:			// rf ���ڿ���״̬�ŷ�������
			//RF_TxData(pl,8);
			//RF_TxMode();//�趨tx��ʽ������tx
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
	
	RF_Init();//�ڴ˺����У�Ӧ��ȷ���ͷ��Ͷ˵�ͨ��ģʽ��RF ��ַ��Channel���������ʺ�Payload����һ�¡�
	RF_RxMode();

	while(1)
	{
		//test();
		delay_ms(1);
		if(ucRF_DumpRxData(ucPayload, PAYLOAD_WIDTH))
		{
			ucRF_ReadReg(DATAOUT);
			//���ճɹ�
		}
	}
}
#endif