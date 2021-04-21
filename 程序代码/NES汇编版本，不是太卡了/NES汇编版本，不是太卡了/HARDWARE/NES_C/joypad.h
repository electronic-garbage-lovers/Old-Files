 
#ifndef _JOYPAD_H_
#define _JOYPAD_H_


#define JOYPAD_0 	0
#define JOYPAD_1 	1	 


extern u8  JOY_key;   //	�����ֵ

typedef struct{
	u8 state;   //״̬
	u8  index;	//��ǰ��ȡλ
	u32 value;	//JoyPad ��ǰֵ	
}JoyPadType;

/* function ------------------------------------------------------------------*/
void NES_JoyPadInit(void);
void NES_JoyPadReset(void);
void NES_JoyPadDisable(void);
u8 NES_GetJoyPadVlaue(int JoyPadNum);


#endif 













