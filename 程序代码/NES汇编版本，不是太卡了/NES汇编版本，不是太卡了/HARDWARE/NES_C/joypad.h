 
#ifndef _JOYPAD_H_
#define _JOYPAD_H_


#define JOYPAD_0 	0
#define JOYPAD_1 	1	 


extern u8  JOY_key;   //	保存键值

typedef struct{
	u8 state;   //状态
	u8  index;	//当前读取位
	u32 value;	//JoyPad 当前值	
}JoyPadType;

/* function ------------------------------------------------------------------*/
void NES_JoyPadInit(void);
void NES_JoyPadReset(void);
void NES_JoyPadDisable(void);
u8 NES_GetJoyPadVlaue(int JoyPadNum);


#endif 













