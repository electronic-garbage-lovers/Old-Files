/****                                                                 ****/
/****  ˵����  ����IP5328P (with reg) V1.0��д                        ****/
/****          �Ĵ����ֲ�����51�ڵ�����̳ ID��û����                  ****/
/****          �����ܲ�����ȫ����д���ϳ��ù��ܺ�������������չ     ****/
/****  ���ߣ�  ��������                                               ****/
/****  ʱ�䣺  2020-10-04                                             ****/
/****                                                                 ****/

#include "i2c.h"
#include "ip5328p.h"

//д�Ĵ���(8bit)
//reg:�Ĵ�����ַ
//data:��д������
void IP5328P_Write(unsigned char reg,unsigned char data)
{
	I2CStart();		    	//��ʼ�ź�
	I2CSendByte(0xEA);		//д�ӻ���ַ
	I2CWaitAck();			//�ȴ�Ӧ��
	I2CSendByte(reg);	   	//��д�����ݼĴ�����ַ
	I2CWaitAck();			//�ȴ�Ӧ��
	I2CSendByte(data);	   	//д������
	I2CWaitAck();			//�ȴ�Ӧ��
	I2CStop();				//ֹͣ�ź�
}

//���Ĵ���(8bit)
//reg:�Ĵ�����ַ
//data:��д������
unsigned char IP5328P_Read(unsigned char reg)
{
	unsigned char R_dat;
	I2CStart();		    			//��ʼ�ź�
	I2CSendByte(0xEA);				//д�ӻ���ַ
	I2CWaitAck();					//�ȴ�Ӧ��(��δ�յ�Ӧ��ʱ δ������ ���������)

	I2CSendByte(reg);	   			//��д�����ݼĴ�����ַ
	I2CWaitAck();					//�ȴ�Ӧ��(��δ�յ�Ӧ��ʱ δ������ ���������)

	I2CStart();						//���������ź�	

	I2CSendByte(0xEB);	   			//д��ӻ���ַ ����������
	I2CWaitAck();					//�ȴ�Ӧ�� (��δ�յ�Ӧ��ʱ δ������ ���������)
	R_dat=I2CReceiveByte();			//����8bit����
	I2CSendNotAck();				//����mNACK�ź� ֹͣ����
	I2CStop();						//ֹͣ�ź�
	return R_dat;
}


//��ȡ��ص�����ʾ����(ֻ�ܶ�����Ӧ������LED����)
//���أ�0001 1111:4�ε���  0000 1111:3�ε���  0000 0111:2�ε���	0000 0011:1�ε���
//		0000 0001:�ŵ�ʱ�͵����� 0000 0000:�ػ�
unsigned char IP5328P_Electricity(void)
{
	int dat;
	dat=IP5328P_Read(0xDB);	  				//��ȡ����ָʾ����
	return dat;
}

/**************************************************��ȡоƬ�������ܺ���********************************************************/

//��ȡ������˵���ʵ��ѹֵ
//����float�͵ĵ�ѹֵ(С��)
float IP5328P_BatVoltage(void)
{
	int dat;
	float BatVoltage=0.0f;
	dat=IP5328P_Read(0x64);	  				//��ȡ��ص�ѹ��8λ
	BatVoltage += dat;
	dat=IP5328P_Read(0x65);			 		//��ȡ��ص�ѹ��8λ
	BatVoltage = (dat<<8)+BatVoltage;		//�ߵ�λ�ϲ�
	if(BatVoltage==0xffff) return 0;		//�������0xffff����ʱоƬδ���� ��ȡֵ����
	BatVoltage = BatVoltage*0.00026855+2.6;	//����Ϊʵ�ʵ�ѹֵ
	return BatVoltage;
}

//��ȡ���������������
//����float�͵ĵ���ֵ(С��)	 ��λma
float IP5328P_BatCurrent(void)
{
	int dat;
	float Current=0.0f;
	dat=IP5328P_Read(0x66);	  				//��ȡ��ص�����8λ
	Current += dat;
	dat=IP5328P_Read(0x67);			 		//��ȡ��ص�����8λ
	Current = (dat<<8)+Current;				//�ߵ�λ�ϲ�
	if(Current>32767)Current=65535-Current;	//����ֵ����תΪ��ֵ
	Current = Current*0.00127883;			//����Ϊʵ�ʵ���ֵ
	return Current;
}

//��ȡ��ص�ѹ������о����͵�о�������в�����ĵ�ѹ
//����float�͵ĵ�ѹֵ(С��)
float IP5328P_BatOCV(void)
{
	int dat;
	float BatVoltage=0.0f;
	dat=IP5328P_Read(0x7A);	  				//��ȡ��ص�ѹ��8λ
	BatVoltage += dat;
	dat=IP5328P_Read(0x7B);			 		//��ȡ��ص�ѹ��8λ
	BatVoltage = (dat<<8)+BatVoltage;		//�ߵ�λ�ϲ�
	if(BatVoltage==0xffff) return 0;		//�������0xffff����ʱоƬδ���� ��ȡֵ����
	BatVoltage = BatVoltage*0.00026855+2.6;	//����Ϊʵ�ʵ�ѹֵ
	return BatVoltage;
}

//��ȡType-C�ӿ�����״̬
//���أ�0x00δ����
//		0x01�����ֻ����蹩���豸(��籦�ڷŵ�)
//		0x02���ӵ�Դ������(��籦�ڳ��)
unsigned char IP5328P_TypeC_Flag(void)
{
	unsigned char flag=0,dat=0;
    dat=IP5328P_Read(0xB8);
	if(dat==0xff)return 0;					//�������0xff��оƬδ����
	if(dat>>1&0x01)flag=0x01;
	if(dat>>5&0x01)flag=0x02;
	return flag;
}

//��ȡType-C���ӵ��������������
//���أ�0x00 оƬδ����
//		0x01��׼USB
//		0x02�������1.5A
//		0x03�������3.0A
unsigned char IP5328P_TypeC_Ability(void)
{
	unsigned char flag=0,dat=0;
    dat=IP5328P_Read(0xFF);
	if(dat==0xff)return 0;					//�������0xff��оƬδ����
	if(dat>>5&0x01)flag=0x01;
	if(dat>>6&0x01)flag=0x02;
	if(dat>>7&0x01)flag=0x03;
	return flag;
}


/********************���µ�����ȡ����������*********************************/
/*********����������Ϊ���ж���ӿ�ͬʱ����ʱ�ſ��Զ�ȡ********************/
/***************���У�VBUS��TYPE-C�ڣ�VIN�ǰ�׿��***************************/

//��ȡType-C������������
//����float�͵ĵ���ֵ(С��)	 ��λma
//��������Ҫ�ڳ��״̬ VINOK �� VBUSOK ͬʱ��Ч�� VBUS MOS����ʱ��
//      ����VBUS MOS������ͬʱ������MOSҲ����ʱ,��ADC�Ż�����
//		(���Ϸ���״̬�����üĴ�����ȡ)
float IP5328P_TypeC_Current(void)
{
	int dat;
	float Current=0.0f;
	dat=IP5328P_Read(0x6E);	  				//��ȡ������8λ
	Current += dat;
	dat=IP5328P_Read(0x6F);			 		//��ȡ������8λ
	Current = (dat<<8)+Current;				//�ߵ�λ�ϲ�
	if(Current>32767)Current=65535-Current;	//����ֵ����תΪ��ֵ
	Current = Current*0.0006394;			//����Ϊʵ�ʵ���ֵ
	return Current;
}

//��ȡ��׿���������
//����float�͵ĵ���ֵ(С��)	 ��λma
//��������Ҫ�ڳ��״̬ VINOK ��VBUSOK ͬʱ��Ч�� VIN MOS����ʱ�� ADC�Ż�����
//		(���Ϸ���״̬�����üĴ�����ȡ)
float IP5328P_VIN_Current(void)
{
	int dat;
	float Current=0.0f;
	dat=IP5328P_Read(0x6D);	  				//��ȡ������8λ
	Current += dat;
	dat=IP5328P_Read(0x6C);			 		//��ȡ������8λ
	Current = (dat<<8)+Current;				//�ߵ�λ�ϲ�
	if(Current>32767)Current=65535-Current;	//����ֵ����תΪ��ֵ
	Current = Current*0.0006394;			//����Ϊʵ�ʵ���ֵ
	return Current;
}

//��ȡOUT1�������
//����float�͵ĵ���ֵ(С��)	 ��λma
//��������Ҫ�� OUT1 MOS ������ͬʱ������ MOS Ҳ����ʱ���� ADC �Ż�������
//		(���Ϸ���״̬�����üĴ�����ȡ)
float IP5328P_OUT1_Current(void)
{
	int dat;
	float Current=0.0f;
	dat=IP5328P_Read(0x70);	  				//��ȡ������8λ
	Current += dat;
	dat=IP5328P_Read(0x71);			 		//��ȡ������8λ
	Current = (dat<<8)+Current;				//�ߵ�λ�ϲ�
	if(Current>32767)Current=65535-Current;	//����ֵ����תΪ��ֵ
	Current = Current*0.0006394;			//����Ϊʵ�ʵ���ֵ
	return Current;
}

//��ȡOUT2�������
//����float�͵ĵ���ֵ(С��)	 ��λma
//��������Ҫ�� OUT1 MOS ������ͬʱ������ MOS Ҳ����ʱ���� ADC �Ż�������
//		(���Ϸ���״̬�����üĴ�����ȡ)
float IP5328P_OUT2_Current(void)
{
	int dat;
	float Current=0.0f;
	dat=IP5328P_Read(0x72);	  				//��ȡ������8λ
	Current += dat;
	dat=IP5328P_Read(0x73);			 		//��ȡ������8λ
	Current = (dat<<8)+Current;				//�ߵ�λ�ϲ�
	if(Current>32767)Current=65535-Current;	//����ֵ����תΪ��ֵ
	Current = Current*0.0006394;			//����Ϊʵ�ʵ���ֵ
	return Current;
}

/********************���ϵ�����ȡ����������*********************************/

//��ȡ��ǰ��Դ����
//����float�͵Ĺ���ֵ(С��)
float IP5328P_Power(void)
{
	int dat;
	float Power=0.0f;
	dat=IP5328P_Read(0x7C);	  				//��ȡ���ʵ�8λ
	Power += dat;
	dat=IP5328P_Read(0x7D);			 		//��ȡ���ʸ�8λ
	Power = (dat<<8)+Power;					//�ߵ�λ�ϲ�
	if(Power==0xffff) return 0;				//�������0xffff����ʱоƬδ���� ��ȡֵ����
	Power = Power*0.00844;					//����Ϊʵ�ʹ���ֵ
	return Power;
}

//��ȡоƬ��ǰ��Դ״̬
//����λ��0:�ŵ� 1:���
//2:0λ ��000:���� 001:5V��� 010:����ͬ��ͬ�� 011:���ͬ��ͬ��
//		  100:��ѹ����� 101:5V�ŵ� 110:���5V�ŵ� 111:��ѹ���ŵ�
//����λ����Чλ
unsigned char IP5328P_SYS_Status(void)
{
	unsigned char flag=0;
	flag=IP5328P_Read(0xD1);
	if(flag==0xff)return 0;
	return flag;
}


//��ȡ�����ѹ��Ч״̬�Լ������Ƿ񱻰���
//���أ�7:6��Чλ
//		5 VBUSOK: 1 TYPE-C�ӿڵ�ѹ��Ч����ŵ綼����Ч�� 0 �ӿڵ�ѹ��Ч
//		4 VINOK : 1 ��׿�ڽӿڵ�ѹ��Ч	                 0 ��׿�ڽӿڵ�ѹ��Ч
//		3:1��Чλ
//		0 key_in: 0��������    1����δ����
unsigned char IP5328P_KEY_IN(void)
{
	unsigned char flag=0;
	flag=IP5328P_Read(0xD2);
	if(flag==0xff)return 0;
	return flag;
}


//��ȡ��׿�ں�TYPE-C�������ѹ
//���أ�7:6��Чλ
//		5:3  TYPE-C_STATE:000-5V,001-7V,011-9V,111-12V 
//		2:0  VIN_STATE   :000-5V,001-7V,011-9V,111-12V
unsigned char IP5328P_VinTypeC_State(void)
{
	unsigned char flag=0;
	flag=IP5328P_Read(0xD5);
	if(flag==0xff)return 0;
	return flag;
}

//��ȡ���״̬
//���أ�7:	0���ܸպ�����ͣ���⣬Ҳ�����ǳ����ˣ�Ҳ�������쳣������	 1 ���ڳ��
//		6:  0δ����  1���� 
//		5:  0��ѹ�����ܼ�ʱδ��ʱ   1��ѹ�����ܼ�ʱ��ʱ
//		4:  0��ѹ��ʱδ��ʱ         1��ѹ��ʱ��ʱ
//		3:  0�����ʱδ��ʱ         1�����ʱ��ʱ
//		2:0 000����  001������  010�������  011��ѹ��� 100ͣ���� 101��س������� 110��ʱ
unsigned char IP5328P_GHG_State(void)
{
	unsigned char flag=0;
	flag=IP5328P_Read(0xD7);
	return flag;
}


//��ȡMOS״̬
//���أ�7:	0��ǰ��׿���ڳ��	      1��ǰTYPE-C�ڳ��
//		6:  0��׿�ڵ�ѹ��Ч           1��׿�ڵ�ѹ��Ч  
//		5:  0TYPE-C��ѹ��Ч           1TYPE-C��ѹ��Ч 
//		4:  0VIN MOS(��׿)δ����      1VIN MOS(��׿)����
//		3:  ��Чλ
//		2:  0VBUS MOS(TYPE-C)δ����   1VBUS MOS(TYPE-C)����
//		1:  0VOUT2 MOSδ����          1VOUT2 MOS����
//		0:  0VOUT1 MOSδ����          1VOUT1 MOS����
unsigned char IP5328P_MOS_ON(void)
{
	unsigned char flag=0;
	flag=IP5328P_Read(0xE5);
	if(flag==0xff)return 0;
	return flag;
}


//��ȡ��ѹ�����ѹֵ��Χ
//���أ�7:4	��Чλ 
//		3:  0��Ч      1�����ѹ10-12V
//		2:  0��Ч      1�����ѹ8-10V
//		1:  0��Ч      1�����ѹ6-8V
//		0:  0�ǿ��    1���
unsigned char IP5328P_BOOST(void)
{
	unsigned char flag=0;
	flag=IP5328P_Read(0xFB);
	if(flag==0xff)return 0;
	return flag;
}

//��ȡQC����Ƿ�ʹ��(�����Ƿ�����ʹ�ã�����˵������ܿ�����)
//���أ�7:4	��Чλ 
//		3:  0�ǿ��      1TYPE-C���ʹ��
//		2:  0�ǿ��      1��׿�ڿ��ʹ��
//		1:  0�ǿ��      1OUT2��俪ʹ��
//		0:  0�ǿ��      1OUT1��俪ʹ��
unsigned char IP5328P_QC_State(void)
{
	unsigned char flag=0;
	flag=IP5328P_Read(0x3E);
	if(flag==0xff)return 0;
	return flag;
}

//��ȡ����Ƿ���Ա�ʹ��(�����Ƿ�����ʹ�ã�����˵������ܿ�����)
//���أ�7:	MTK PE 1.1 RX ֧�ֵ�����ѹ����       0 12V	       1 9V
//		6:  MTK PE2.0 RX  ʹ��                     0 ʧ��       1 ʹ�� 
//		5:  MTK PE1.1 RX  ʹ��                     0 ʧ��       1 ʹ�� 
//		4:  SFCP SRC(չѶ)ʹ��                     0 ʧ��       1 ʹ��
//		3:  AFC SRC(����) ʹ��                     0 ʧ��       1 ʹ��
//		2:  FCP SRC(��Ϊ) ʹ��                     0 ʧ��       1 ʹ��
//		1:  QC3.0 SRC     ʹ��                     0 ʧ��       1 ʹ��
//		0:  QC2.0 SRC     ʹ��                     0 ʧ��       1 ʹ��
unsigned char IP5328P_DCP_DIG(void)
{
	unsigned char flag=0;
	flag=IP5328P_Read(0xA2);
	if(flag==0xff)return 0;
	return flag;
}

/*----------------------------------------------��ȡоƬ�������ܺ���-end-----------------------------------------------------*/

/**************************************************доƬ�������ܺ���********************************************************/

//���õ�ص͵�ػ���ѹ(�ػ��������³��ſ�����)
//���룺0x30 3.00V-3.10V
//      0x20 2.90V-3.00V
//      0x10 2.81V-2.89V
//      0x00 2.73V-2.81V
void IP5328P_BAT_LOW(unsigned char dat)
{
	if(dat==0x30||dat==0x20||dat==0x10||dat==0x00)//Ϊ��֤����������ȷ��ָ����ȷ����д��
	IP5328P_Write(0x10,dat);
}

//����SYS4(���ԣ�������)
//���룺chg2bst���γ�����Զ�������ѹ���                0������  1����
//      swclk2 ��ʹ��I2C2����ʱ�ӣ�ʹ�ܺ�����ɶ����ݣ�  0������  1����
//      swclk1 ��ʹ��I2C1����ʱ�ӣ�ʹ�ܺ�����ɶ����ݣ�  0������  1����
void IP5328P_SYS_CTL14(unsigned char chg2bst,unsigned char swclk2,unsigned char swclk1)
{
	unsigned char dat=0x00;
	if(chg2bst)dat|=0x40;
	if(swclk2)dat|=0x08;
	if(swclk1)dat|=0x04;
	IP5328P_Write(0x0E,dat);
}




/*------------------------------------------------доƬ�������ܺ���-end----------------------------------------------------*/

/*---------------------------------------------------��ȡ���ò���-----------------------------------------------------------*/

float power;																//�ܹ���
Mos_state mos_state;														//���ӿ�״̬�ṹ��
Voltage   voltage;															//���ӿڵ�ѹ�ṹ��
Current   current;															//���ӿڵ����ṹ��

//��ȡ���ò���
//����:�ܹ��ʡ����ӿڵ�ѹ�����ӿڵ��������ӿڿ���״̬
void read_Parameters(void)
{
	unsigned char mos,Sys_status,Bat_Grade,GHG_State,TypeC_VIN_voltage,boost;	
/*----------------------------------------------��ȡ����----------------------------------------------------------*/	
	mos=IP5328P_MOS_ON();				 									//��ȡ�ӿ�״̬
	power=IP5328P_Power();			     									//��ȡ����
	TypeC_VIN_voltage=IP5328P_VinTypeC_State();	 							//��ȡ��׿�ں�TYPE-C��ѹ
	current.TypeC=IP5328P_TypeC_Current();									//��ȡType-C����ֵ
	current.VIN=IP5328P_VIN_Current();										//��ȡVIN����ֵ
	current.OUT1=IP5328P_OUT1_Current();									//��ȡVOUT1����ֵ
	current.OUT2=IP5328P_OUT2_Current();									//��ȡVOUT2����ֵ
	boost=IP5328P_BOOST();													//��ȡ��ѹֵ
//	Sys_status=IP5328P_SYS_Status();										//��ȡ���״̬
//	Bat_Grade=IP5328P_Electricity();										//��ȡ�����ȼ�
//	GHG_State=IP5328P_GHG_State();											//��ȡ���״̬
/*--------------------------------------------����ӿ�״̬--------------------------------------------------------*/
	mos_state.OUT1=mos&0x01;												//���OUT1����״̬ [��Ϊ���°�������ʱ��OUT1�Ὺ������������ܲ�û������]
	mos_state.OUT2=mos>>1&0x01;												//���OUT2����״̬
	mos_state.TypeC=mos>>2&0x01;											//���TypeC����״̬
	mos_state.VIN=mos>>4&0x01;												//���VIN����״̬
	if(mos_state.OUT1)														//����OUT1����״̬ [��Ϊ���°�������ʱ��OUT1�Ὺ������������ܲ�û������]
	{
		if(power<=0.2)mos_state.OUT1=0;										//�������Ϊ0��δ����
		if(power>0)															//������ʣ�0
			if(mos_state.OUT2||mos_state.TypeC||mos_state.VIN)				//���������ӿڿ���
				if(current.OUT1==0)mos_state.OUT1=0;						//���OUT1��������Ϊ0����֤��OUT1�ӿ�ʵ��δ����
	}
/*--------------------------------------------����ӿڵ�ѹ--------------------------------------------------------*/
	if(mos_state.VIN){														//���VIN�ӿ��ǿ�����
		switch(TypeC_VIN_voltage&0x07)										//VIN��ѹ
		{
			case 0x07:voltage.VIN=12;break;									//12V
			case 0x03:voltage.VIN=9;break;									//9V
			case 0x01:voltage.VIN=7;break;									//7V
			case 0x00:voltage.VIN=5;break;									//5V
		}																	
	}else voltage.VIN=0;													//����
	if(mos_state.TypeC){													//���TYPE-C�ӿ��ǿ�����
		switch(TypeC_VIN_voltage>>3&0x07)									//TYPE-C��ѹ
		{
			case 0x07:voltage.TypeC=12;break;								//12V
			case 0x03:voltage.TypeC=9;break;								//9V
			case 0x01:voltage.TypeC=7;break;								//7V
			case 0x00:voltage.TypeC=5;break;								//5V
		}
	}else voltage.TypeC=0;													//����
	if(mos_state.OUT1){														//����ӿڿ���
		if(current.OUT1)voltage.OUT1=5;										//����ӿ��е���
		else{																//����ӿ��޵���
			 if(boost>1&0x01)voltage.OUT1=5;								//��ѹֵ������ѹֵ
			 if(boost>2&0x01)voltage.OUT1=9;								//��ѹֵ������ѹֵ
			 if(boost>3&0x01)voltage.OUT1=12;								//��ѹֵ������ѹֵ
		}																	
	}else voltage.OUT1=0;													//����ӿ�δ����
	if(mos_state.OUT2){														//����ӿڿ���
		if(current.OUT2)voltage.OUT2=5;										//����ӿ��е���
		else{																//����ӿ��޵���
			 if(boost>1&0x01)voltage.OUT2=5;								//��ѹֵ������ѹֵ
			 if(boost>2&0x01)voltage.OUT2=9;								//��ѹֵ������ѹֵ
			 if(boost>3&0x01)voltage.OUT2=12;								//��ѹֵ������ѹֵ
		}																	
	}else voltage.OUT2=0;													//����ӿ�δ����
/*--------------------------------------------����ӿڵ���--------------------------------------------------------*/
	if(current.OUT1==0&&mos_state.OUT1)current.OUT1=power/voltage.OUT1;		//�������Ϊ0�������ǽ�����һ���ӿڣ���ʱ������Ҫ�ù��ʻ���
	if(current.OUT2==0&&mos_state.OUT2)current.OUT2=power/voltage.OUT2;		//�������Ϊ0�������ǽ�����һ���ӿڣ���ʱ������Ҫ�ù��ʻ���
	if(current.TypeC==0&&mos_state.TypeC)current.TypeC=power/voltage.TypeC;	//�������Ϊ0�������ǽ�����һ���ӿڣ���ʱ������Ҫ�ù��ʻ���
	if(current.VIN==0&&mos_state.VIN)current.VIN=power/voltage.VIN;			//�������Ϊ0�������ǽ�����һ���ӿڣ���ʱ������Ҫ�ù��ʻ���
/*--------------------------------------------����xxxx--------------------------------------------------------*/

}

/*---------------------------------------------------��ȡ���ò���-----------------------------------------------------------*/











