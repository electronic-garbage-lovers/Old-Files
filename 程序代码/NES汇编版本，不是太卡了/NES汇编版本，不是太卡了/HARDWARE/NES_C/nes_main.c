#include "nes_main.h"
#include "led.h"
#include "mario.h"
#include "PPU.h"

#include "lcd.h"
//#include "key.h"
//////////////////////////////////////////////////////////////////////////////////	 
//�ҵ� STM32������
//NESģ���� ����	   
//�޸�����:2012/10/3
//�汾��V1.0		       								  
////////////////////////////////////////////////////////////////////////////////// 	   
void loadcart(void);	//�� cart.s
void run(u32);		    //�� 6502.s
void line242NMI(void);	 //�� 6502.s

extern u8* romfile;//ROMָ��

extern u8 NES_RAM[];
__align(4) u8 NES_RAM[2048] __attribute__((at(0x20000800)));// ����1024�ֽڶ���

//extern u8* prg_rombank0;		// prg-rom lower bank 
//extern u8* prg_rombank1;		// prg-rom upper bank 


u8* romfile;//ROMָ��  NES��Ϸrom�Ĵ洢��ַ
//u8* prg_rombank0;		// prg-rom lower bank 
//u8* prg_rombank1;		// prg-rom upper bank 

//u8 FPS1=0;
u8 FPS=0;			//ͳ��ÿ��֡��
u8 frame_cnt=0;  //֡������

//NES ֡����ѭ�� 
void NesFrameCycle(void)
{
 	int	clocks;	//CPUִ��ʱ��	 
	//����ģ����ѭ�������VROM���ã�������Ϊ0����ʼ��VROM
	//if ( NesHeader.byVRomSize == 0)
	//����VROM�洢��λ�á�
//	u8 frame_cnt=0;  //֡������	
	while(1)
	{
 		//scanline: 0~19 VBANK �Σ���PPUʹ��NMI��������NMI �ж�
		frame_cnt++;//֡������
		FPS++;			//ͳ��ÿ��֡��			    
		SpriteHitFlag=0;

//		FPS1++;					//�¶ϵ��õ�
//		if(FPS1==100)
//
//
//		{
//		  FPS1=0;
//		}


		run(113*21*256);//CLOCKS_PER_SCANLINE=113 ÿһ��ɨ����,CPUʱ��113.66

		PPU_scanline=21;			   //��ִ��21��
		PPU_Reg.NES_R2 &= ~R2_SPR0_HIT;
		//scanline: 21~261 				
		for(; PPU_scanline < 261; PPU_scanline++)
		{
			if((SpriteHitFlag == 1) && ((PPU_Reg.NES_R2 & R2_SPR0_HIT) == 0))
			{//			ˮƽx������					 
				clocks = sprite[0].x * 113 / 256;	//	 256ÿһ��ɨ�����ؿ��
				run(clocks*256);  //���ص��Ż�

				PPU_Reg.NES_R2 |= R2_SPR0_HIT;
				run((113 - clocks)*256);

			}
			else run(113*256);  //��ʱ��
			if(PPU_Reg.NES_R1 & (R1_BG_VISIBLE | R1_SPR_VISIBLE))//��Ϊ�٣��ر���ʾ
			{
				if(SpriteHitFlag == 0)
				NES_GetSpr0HitFlag(PPU_scanline - SCAN_LINE_DISPALY_START_NUM);//����Sprite #0 ��ײ��־
			}
			if(frame_cnt==3)//ÿ3֡��ʾһ��	   //��ʱ��
			{				
				NES_RenderLine(PPU_scanline - 21);//ˮƽͬ������ʾһ��			
			}	
		}
		//scanline: 262 ���һ֡ 
		run(113*256); //����ִ��113��6502ʱ������ָ��

		PPU_Reg.NES_R2 |= R2_VBlank_Flag;//����VBANK ��־
		//��ʹ��PPU VBANK�жϣ�������VBANK 
		if(PPU_Reg.NES_R0 & R0_VB_NMI_EN)
		{
//			NMI_Flag = SET1;//���һ֡ɨ�裬����NMI�ж�
			line242NMI();

		}
		if(frame_cnt==3)frame_cnt=0;  //֡������//ÿ3֡��ʾһ��  
	   	//����֡IRQ��־��ͬ����������APU�� 		   
		//A mapper function in V-Sync �洢���л���ֱVBANKͬ�� 
		//MapperVSync();  
		//��ȡ������JoyPad״̬,����JoyPad������ֵ*/
		//NES_JoyPadUpdateValue();	 //systick �ж϶�ȡ����ֵ 
//		LED=!LED;
	}
} 
//	  ����,�������
void nes_main(void)
{	
	 //��ʼ��6502�洢������
//	prg_rombank0= (u8*)&nes_rom[16];					//16kb����rom��ַ	
//	prg_rombank1= (u8*)&nes_rom[16] +(0x4000*(2-1));	//16kb����rom��ַ
	romfile=(u8*)&nes_rom[0];
	loadcart();					
 
				
//		reset6502();//��λ
	//	PPU_Init(((u8*)&rom_file[offset+0x10] + (neshreader->romnum * 0x4000)), (neshreader->romfeature & 0x01));//PPU_��ʼ��
//		PPU_Init((romfile+16 + (2 * 0x4000)), (0x01 & 0x01));//PPU_��ʼ�� 	
		PPU_Init(((u8*)&nes_rom[0x10] + (2 * 0x4000)), (1 & 0x01));//PPU_��ʼ�� 
//        NES_JoyPadInit();  
		NesFrameCycle();//ģ����ѭ��ִ��
}


