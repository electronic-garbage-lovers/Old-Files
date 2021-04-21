#ifndef  __IP5328P_H__
#define  __IP5328P_H__


extern float power;				//�ܹ���

typedef struct{
	float OUT1;					//OUT1�ӿڵ���
	float OUT2;					//OUT2�ӿڵ���
	float TypeC;				//TypeC�ӿڵ���
	float VIN;					//VIN(��׿��)�ӿڵ���
}Current;

extern Current current;			//���ӿڵ����ṹ��

typedef struct{
	unsigned char OUT1;			//OUT1�ӿڵ�ѹ
	unsigned char OUT2;			//OUT2�ӿڵ�ѹ
	unsigned char TypeC;		//TypeC�ӿڵ�ѹ
	unsigned char VIN;			//VIN(��׿��)�ӿڵ�ѹ
}Voltage;

extern Voltage voltage;			//���ӿڵ�ѹ�ṹ��

typedef struct{
	unsigned char OUT1;		   	//OUT1�ӿڿ���״̬
	unsigned char OUT2;		   	//OUT2�ӿڿ���״̬
	unsigned char TypeC;	   	//TypeC�ӿڿ���״̬
	unsigned char VIN;		   	//VIN(��׿��)����״̬
}Mos_state;

extern Mos_state mos_state;	    //���ӿڿ���״̬�ṹ��





//������������
void IP5328P_Write(unsigned char reg,unsigned char data);	 //дIP5328P�Ĵ�������
unsigned char IP5328P_Read(unsigned char reg);				 //��IP5328P�Ĵ�������

//���ܺ���
/**************************************������*****************************************************************/
float IP5328P_BatVoltage(void);		 						 //��������˵�ѹֵ
float IP5328P_BatOCV(void);									 //��ص�ѹ������о����͵�о�������в�����ĵ�ѹ
float IP5328P_BatCurrent(void);								 //��ȡ��ص���
float IP5328P_TypeC_Current(void);							 //��ȡTYPE-C�����������
float IP5328P_VIN_Current(void);							 //��ȡ��׿�ڵ��������
float IP5328P_OUT1_Current(void);							 //��ȡOUT1�������
float IP5328P_OUT2_Current(void);							 //��ȡOUT2�������
float IP5328P_Power(void);									 //��ȡ����
unsigned char IP5328P_TypeC_Flag(void);						 //��ȡType-C�ӿ�����״̬
unsigned char IP5328P_TypeC_Ability(void);					 //��ȡType-C���ӵ��������������
unsigned char IP5328P_Electricity(void);					 //��ȡ����ָʾ����
unsigned char IP5328P_SYS_Status(void);						 //��ȡ��Դ״̬
unsigned char IP5328P_VinTypeC_State(void);				 	 //��ȡ��׿�ں�TYPE-C�������ѹ
unsigned char IP5328P_GHG_State(void);						 //��ȡ���״̬
unsigned char IP5328P_MOS_ON(void);							 //��ȡMOS����״̬
unsigned char IP5328P_BOOST(void);							 //��ȡ��ѹ�����ѹֵ��Χ
unsigned char IP5328P_QC_State(void);						 //��ȡQC����Ƿ�ʹ��(�����Ƿ�����ʹ�ã�����˵��������Ƿ������)
unsigned char IP5328P_DCP_DIG(void);						 //��ȡ��ȡ����Ƿ�ʹ��(�����Ƿ�����ʹ�ã�����˵��������Ƿ������)

/**************************************д����*****************************************************************/
void IP5328P_BAT_LOW(unsigned char dat);	 				 //���õ�ص͵�ػ���ѹ
void IP5328P_SYS_CTL14(unsigned char chg2bst,unsigned char swclk2,unsigned char swclk1);//����SYS4

/***********************************��ȡ���ò���***************************************************************/
void read_Parameters(void);															 

#endif






