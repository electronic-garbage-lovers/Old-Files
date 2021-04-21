#include "RF.H"
#include"stc8.h"

sbit sck=P1^0;
sbit sda=P1^1;
sbit cs=P1^2;
unsigned char  RF_cal_data[]    = {0x06,0x37,0x5D};
const unsigned char TX_ADDRESS_DEF[5] = {0xcc,0xCC,0xCC,0xCC,0xCC};    		//RF ��ַ�����ն˺ͷ��Ͷ���һ��
//const unsigned char TX_ADDRESS_DEF[5] = {0x4B,0x4E,0x44,0x5A,0x4B};    		//RF ��ַ�����ն˺ͷ��Ͷ���һ��
void delay_ms(unsigned char a)		//@11.0592MHz
{
	unsigned char i, j;

	i = 15;
	j = 90;
	do{
	do
	{
		while (--j);
	} while (--i);
}while(--a);
}

/******************************************************************************/
//            SPI_init
//               init spi pin  input/out mode
/******************************************************************************/
void SPI_init(void)
{
	sck=0;
	cs=1;
	SPI_DATA_OUTPUT_MODE;
}

/******************************************************************************/
//           SPI_WW
//                SPI Write a byte for write regiest
/******************************************************************************/
void SPI_WW(unsigned char R_REG)
{
   unsigned char  i;
	SPI_DATA_OUTPUT_MODE;
	//R_REG=R_REG|0x20;//每个需要的地方都加了20
   for(i = 0; i < 8; i++)
    {
        //sck=0;
        if(R_REG & 0x80)
        {
            sda=1;
        }
        else
        {
            sda=0;
        }
        
        sck=1;
				R_REG = R_REG << 1;
				sck=0;
    }
   //sck=0;
}

/******************************************************************************/
//            RF_WriteReg
//                Write Data(1 Byte Address ,1 byte data)
/******************************************************************************/
void RF_WriteReg( unsigned char reg,  unsigned char wdata)
{
    cs=0;
    SPI_WW(reg);
    SPI_WW(wdata);
    cs=1;
}

/******************************************************************************/
//            RF_WriteBuf
//                Write Buffer 
/******************************************************************************/
void RF_WriteBuf( unsigned char reg, unsigned char *pBuf, unsigned char length)
{
    unsigned char j;
    cs=0;
    SPI_WW(reg);
    for(j=0;j < length; j++)
    {
        SPI_WW(pBuf[j]);
    }
    cs=1;
}



/******************************************************************************/
//            SPI_WR
//                SPI Write a byte for read regiset
/******************************************************************************/
void SPI_WR(unsigned char R_REG)
{
   unsigned char  i;
	SPI_DATA_OUTPUT_MODE;
   for(i = 0; i < 8; i++)
    {
        
        if(R_REG & 0x80)
        {
            sda=1;
        }
        else
        {
            sda=0;
        }
				sck=1;
        R_REG = R_REG << 1;
        sck=0;
    }
   SPI_DATA_INPUT_MODE;
   sck=0;
}


/******************************************************************************/
//            ucSPI_Read
//                SPI Read BYTE
/******************************************************************************/
unsigned char ucSPI_Read(void)
{
    unsigned char i,dat;  
    dat = 0; 
    for(i = 0; i < 8; i++)
    {
        sck=0;
        dat = dat << 1;
          
        sck=1;
        if(sda)//读取
        {
          dat |= 0x01;
        
        }
    }
    sck=0;
    return dat;
}

/******************************************************************************/
//            ucRF_ReadReg
//                Read Data(1 Byte Address ,1 byte data return)
/******************************************************************************/
 unsigned char ucRF_ReadReg(unsigned char reg)
{
    unsigned char dat;
    
    cs=0;
    SPI_WR(reg);
    dat = ucSPI_Read();
    SPI_DATA_OUTPUT_MODE;
    cs=1;
    
    return dat;
}



/******************************************************************************/
//            RF_ReadBuf
//                Read Data(1 Byte Address ,length byte data read)
/******************************************************************************/
void RF_ReadBuf( unsigned char reg, unsigned char *pBuf,  unsigned char length)
{
    unsigned char byte_ctr;

    cs=0;                    		                               			
    SPI_WR(reg);       		                                                		
    for(byte_ctr=0;byte_ctr<length;byte_ctr++)
    	pBuf[byte_ctr] = ucSPI_Read();
    SPI_DATA_OUTPUT_MODE;
    cs=1;                                                                   		
}


/******************************************************************************/
//            RF_TxMode
//                Set RF into TX mode
/******************************************************************************/
void RF_TxMode(void)
{
    CE_LOW;
    RF_WriteReg(W_REGISTER + CONFIG,  0X8E);							// ��RF���ó�TXģʽ
    delay_ms(1);
    CE_HIGH;											// Set CE pin high ��ʼ��������
    delay_ms(1);
}


/******************************************************************************/
//            RF_RxMode
//            ��RF���ó�RXģʽ��׼����������
/******************************************************************************/
void RF_RxMode(void)
{
    CE_LOW;
    RF_WriteReg(W_REGISTER + CONFIG,  0X8F );							// ��RF���ó�RXģʽ
#if (RF_MODE == RxMode_RTTE)
    RF_WriteBuf(W_REGISTER + RF_CAL,    RF_cal_data,  3);
#endif
    delay_ms(10);
    CE_HIGH;											// Set CE pin high ��ʼ��������
    delay_ms(10);
}

/******************************************************************************/
//            RF_GetStatus
//            read RF IRQ status,3bits return
/******************************************************************************/
unsigned char ucRF_GetStatus(void)
{
    return ucRF_ReadReg(STATUS)&0x70;								//��ȡRF��״̬ 
}
/******************************************************************************/
//            ucRF_GetRSSI
//              �ȡrssi ֵ
/******************************************************************************/
unsigned char ucRF_GetRSSI(void)
{
    return (ucRF_ReadReg(DATAOUT));								//��ȡRF RSSI
}
/******************************************************************************/
//            RF_ClearStatus
//                clear RF IRQ
/******************************************************************************/
void RF_ClearStatus(void)
{
    RF_WriteReg(W_REGISTER + STATUS,0x70);							//���RF��IRQ��־ 
}

/******************************************************************************/
//            RF_ClearFIFO
//                clear RF TX/RX FIFO
/******************************************************************************/
void RF_ClearFIFO(void)
{
    //SPI_WW(FLUSH_TX);
	//SPI_WW(FLUSH_RX);
	RF_WriteReg(FLUSH_TX, 0);			                                		//���RF �� TX FIFO		
  RF_WriteReg(FLUSH_RX, 0);                                                   		//���RF �� RX FIFO	
}

/******************************************************************************/
//            RF_SetChannel
//                Set RF TX/RX channel:Channel
/******************************************************************************/
void RF_SetChannel( unsigned char Channel)
{    
   // CE_LOW;
    RF_WriteReg(W_REGISTER + RF_CH, Channel);
}

/******************************************************************************/
//            �������ݣ�
//            ������
//              1. ucPayload����Ҫ���͵������׵�ַ
//              2. length:  ��Ҫ���͵����ݳ���     
//              length ͨ������ PAYLOAD_WIDTH
/******************************************************************************/
void RF_TxData( unsigned char *ucPayload,  unsigned char length)
{
	if(0==ucRF_GetStatus())                                                                        // rf free status                                                                                                                                                                   
	{
		
		RF_WriteBuf(W_TX_PAYLOAD, ucPayload, length); 
		/*																																			//rf entery tx mode start send data 
		CE_HIGH;
		delay_ms(1);                                                              		//keep ce high at least 600us
		CE_LOW;                                                                                     //rf entery stb3                                                        			
		delay_ms(1);  
		ucRF_ReadReg(CONFIG);
    */
		delay_ms(1);  
		
   }
}

/******************************************************************************/
//            ucRF_DumpRxData
//            �������յ������ݣ�
//            ������
//              1. ucPayload���洢��ȡ�������ݵ�Buffer
//              2. length:    ��ȡ�����ݳ���
//              Return:
//              1. 0: û�н��յ�����
//              2. 1: ��ȡ���յ������ݳɹ�
//              note: Only use in Rx Mode
//              length ͨ������ PAYLOAD_WIDTH
/******************************************************************************/
unsigned char ucRF_DumpRxData( unsigned char *ucPayload,  unsigned char length)
{ 
   if(ucRF_GetStatus()&RX_DR_FLAG)
   {
   
       // CE_LOW;
        RF_ReadBuf(R_RX_PAYLOAD, ucPayload, length);                                		//�����յ������ݶ�����ucPayload�������rxfifo
        RF_ClearFIFO();
        RF_ClearStatus();                              		                        //���Status     
       // CE_HIGH;                                                                    		//������ʼ��        
        return 1;
    }
     return 0;
}



////////////////////////////////////////////////////////////////////////////////

//          ���²�����RFͨ����أ��������޸�
////////////////////////////////////////////////////////////////////////////////
/******************************************************************************/
//            PN006_Initial
//                Initial RF
/******************************************************************************/
void RF_Init()//按照发送程序，先发低字节再发高字节，先发高位再发低位。写在左边的是低字节，位序不变。
{
	/*
 #if(DATA_RATE == DR_1M) 
    unsigned char  BB_cal_data[]    = {0x0A,0x6D,0x67,0x9C,0x46};                               //1M��������
    unsigned char  RF_cal_data[]    = {0xF6,0x37,0x5D};
    unsigned char  RF_cal2_data[]   = {0x45,0x21,0xef,0x2C,0x5A,0x52};//最后一位不应该是50应为52 要下拉ce
    unsigned char  Dem_cal_data[]   = {0x01};  
    unsigned char  Dem_cal2_data[]  = {0x0b,0xDF,0x02};  
#elif(DATA_RATE == DR_250K) 
  
    //  unsigned char  BB_cal_data[]    = {0x0A,0x6D,0x67,0x9C,0x46};                                 //250K��������
    unsigned char  BB_cal_data[]    = {0x0A,0xeD,0x7F,0x9C,0x46}; 
    unsigned char  RF_cal_data[]    = {0xF6,0x37,0x5D};
    unsigned char  RF_cal2_data[]   = {0xD5,0x21,0xeb,0x2C,0x5A,0x40};
    unsigned char  Dem_cal_data[]   = {0x1e};  
    unsigned char  Dem_cal2_data[]  = {0x0b,0xDF,0x02}; 
    
  unsigned char   BB_cal_data[]    = { 0x12,0xec,0x6f,0xa1,0x46}; 
   unsigned char    RF_cal_data[]    = {0xF6,0x37,0x5d};
   unsigned char   RF_cal2_data[]   = {0xd5,0x21,0xeb,0x2c,0x5a,0x42};
   unsigned char    Dem_cal_data[]   = {0x1f};  
   unsigned char    Dem_cal2_data[]  = {0x0b,0xdf,0x02};
    
#endif
      */
#if(DATA_RATE == DR_1M)   
    unsigned char  BB_cal_data[]    = {0x12,0xED,0x67,0x9C,0x46};                               //1M速率配置
    unsigned char  RF_cal_data[]    = {0xF6,0x3F,0x5D};
    unsigned char  RF_cal2_data[]   = {0x45,0x21,0xef,0x2C,0x5A,0x42};                      //RF的CE没IO连接，CE需配置弱下拉使能
    unsigned char  Dem_cal_data[]   = {0x01};  
    unsigned char  Dem_cal2_data[]  = {0x0b,0xDF,0x02};  
#elif(DATA_RATE == DR_250K)
   unsigned char   BB_cal_data[]    = { 0x12,0xec,0x6f,0xa1,0x46};                          //250K速率配置
   unsigned char    RF_cal_data[]    = {0xF6,0x3F,0x5D};
   unsigned char   RF_cal2_data[]   = {0xd5,0x21,0xeb,0x2c,0x5a,0x42};                  //RF的CE没IO连接，CE需配置弱下拉使能
   unsigned char    Dem_cal_data[]   = {0x1F};  
   unsigned char    Dem_cal2_data[]  = {0x0b,0xdf,0x02};
#endif
    
    SPI_init();
    RF_WriteReg(RST_FSPI, 0x5A);								//Software Reset    			
    RF_WriteReg(RST_FSPI, 0XA5);  
		delay_ms(7);
		RF_WriteReg(W_REGISTER + FEATURE, 0x20);                                                    // enable Software control ce 
   
    if(PAYLOAD_WIDTH <33)											
		{
			RF_WriteReg(W_REGISTER +FEATURE, 0x27);							//�л���32byteģʽ   ʹ��CE
		}
		else
		{
			RF_WriteReg(W_REGISTER +FEATURE, 0x38);							//�л���64byteģʽ	   
		}
    CE_LOW;                    
    RF_WriteReg(FLUSH_TX, 0);									// CLEAR TXFIFO		    			 
    RF_WriteReg(FLUSH_RX, 0);									// CLEAR  RXFIFO
    RF_WriteReg(W_REGISTER + STATUS, 0x70);							// CLEAR  STATUS	
    RF_WriteReg(W_REGISTER + EN_RXADDR, 0x01);							// Enable Pipe0
    RF_WriteReg(W_REGISTER + SETUP_AW,  0x03);							// address witdth is 5 bytes
    RF_WriteReg(W_REGISTER + RF_CH,     DEFAULT_CHANNEL);                                       // 2478M HZ
    RF_WriteReg(W_REGISTER + RX_PW_P0,  PAYLOAD_WIDTH);						// 8 bytes
    RF_WriteBuf(W_REGISTER + TX_ADDR,   ( unsigned char*)TX_ADDRESS_DEF, sizeof(TX_ADDRESS_DEF));	// Writes TX_Address to PN006
    RF_WriteBuf(W_REGISTER + RX_ADDR_P0,( unsigned char*)TX_ADDRESS_DEF, sizeof(TX_ADDRESS_DEF));	// RX_Addr0 same as TX_Adr for Auto.Ack   
    RF_WriteBuf(W_REGISTER + BB_CAL,    BB_cal_data,  sizeof(BB_cal_data));
    RF_WriteBuf(W_REGISTER + RF_CAL2,   RF_cal2_data, sizeof(RF_cal2_data));
    RF_WriteBuf(W_REGISTER + DEM_CAL,   Dem_cal_data, sizeof(Dem_cal_data));
    RF_WriteBuf(W_REGISTER + RF_CAL,    RF_cal_data,  sizeof(RF_cal_data));
    RF_WriteBuf(W_REGISTER + DEM_CAL2,  Dem_cal2_data,sizeof(Dem_cal2_data));
    RF_WriteReg(W_REGISTER + DYNPD, 0x00);					
    RF_WriteReg(W_REGISTER + RF_SETUP,  RF_POWER);						// 13DBM  		
     
#if(TRANSMIT_TYPE == TRANS_ENHANCE_MODE)      
    RF_WriteReg(W_REGISTER + SETUP_RETR,0x03);							//  3 retrans... 	
    RF_WriteReg(W_REGISTER + EN_AA,     0x01);							// Enable Auto.Ack:Pipe0  	
#elif(TRANSMIT_TYPE == TRANS_BURST_MODE)                                                                
    RF_WriteReg(W_REGISTER + SETUP_RETR,0x00);							// Disable retrans... 	
    RF_WriteReg(W_REGISTER + EN_AA,     0x00);							// Disable AutoAck 
#endif

}


/******************************************************************************/
//            		�����ز�ģʽ
/******************************************************************************/
void RF_Carrier( unsigned char ucChannel_Set)
{
    unsigned char BB_cal_data[]    = {0x0A,0x6D,0x67,0x9C,0x46}; 
    unsigned char RF_cal_data[]    = {0xF6,0x3B,0x5D};
    unsigned char RF_cal2_data[]   = {0x45,0x21,0xEF,0x2C,0x5A,0x52};
    unsigned char Dem_cal_data[]   = {0xE1}; 								
    unsigned char Dem_cal2_data[]  = {0x0B,0xDF,0x02};  

    RF_WriteReg(RST_FSPI, 0x5A);								//Software Reset    			
    RF_WriteReg(RST_FSPI, 0XA5);
    RF_WriteReg(W_REGISTER + FEATURE, 0x20);
    CE_LOW;
    delay_ms(200);
    RF_WriteReg(W_REGISTER + CONFIG, 0X8e); 
    RF_WriteReg(W_REGISTER + RF_CH, ucChannel_Set);						//���ز�Ƶ��	   
    RF_WriteReg(W_REGISTER + RF_SETUP, RF_POWER);      						//13dbm
    RF_WriteBuf(W_REGISTER + BB_CAL,    BB_cal_data,  sizeof(BB_cal_data));
    RF_WriteBuf(W_REGISTER + RF_CAL2,   RF_cal2_data, sizeof(RF_cal2_data));
    RF_WriteBuf(W_REGISTER + DEM_CAL,   Dem_cal_data, sizeof(Dem_cal_data));
    RF_WriteBuf(W_REGISTER + RF_CAL,    RF_cal_data,  sizeof(RF_cal_data));
    RF_WriteBuf(W_REGISTER + DEM_CAL2,  Dem_cal2_data,sizeof(Dem_cal2_data));
    delay_ms(200);
}

/***************************************end of file ************************************/
