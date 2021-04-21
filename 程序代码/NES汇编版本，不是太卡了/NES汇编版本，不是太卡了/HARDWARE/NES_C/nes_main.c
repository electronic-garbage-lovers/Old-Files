#include "nes_main.h"
#include "led.h"
#include "mario.h"
#include "PPU.h"

#include "lcd.h"
//#include "key.h"
//////////////////////////////////////////////////////////////////////////////////	 
//我的 STM32开发板
//NES模拟器 代码	   
//修改日期:2012/10/3
//版本：V1.0		       								  
////////////////////////////////////////////////////////////////////////////////// 	   
void loadcart(void);	//在 cart.s
void run(u32);		    //在 6502.s
void line242NMI(void);	 //在 6502.s

extern u8* romfile;//ROM指针

extern u8 NES_RAM[];
__align(4) u8 NES_RAM[2048] __attribute__((at(0x20000800)));// 保持1024字节对齐

//extern u8* prg_rombank0;		// prg-rom lower bank 
//extern u8* prg_rombank1;		// prg-rom upper bank 


u8* romfile;//ROM指针  NES游戏rom的存储地址
//u8* prg_rombank0;		// prg-rom lower bank 
//u8* prg_rombank1;		// prg-rom upper bank 

//u8 FPS1=0;
u8 FPS=0;			//统计每秒帧数
u8 frame_cnt=0;  //帧计数器

//NES 帧周期循环 
void NesFrameCycle(void)
{
 	int	clocks;	//CPU执行时间	 
	//启动模拟器循环，检查VROM设置，若卡带为0，初始化VROM
	//if ( NesHeader.byVRomSize == 0)
	//设置VROM存储区位置。
//	u8 frame_cnt=0;  //帧计数器	
	while(1)
	{
 		//scanline: 0~19 VBANK 段，若PPU使能NMI，将产生NMI 中断
		frame_cnt++;//帧计数器
		FPS++;			//统计每秒帧数			    
		SpriteHitFlag=0;

//		FPS1++;					//下断点用的
//		if(FPS1==100)
//
//
//		{
//		  FPS1=0;
//		}


		run(113*21*256);//CLOCKS_PER_SCANLINE=113 每一行扫描线,CPU时钟113.66

		PPU_scanline=21;			   //先执行21线
		PPU_Reg.NES_R2 &= ~R2_SPR0_HIT;
		//scanline: 21~261 				
		for(; PPU_scanline < 261; PPU_scanline++)
		{
			if((SpriteHitFlag == 1) && ((PPU_Reg.NES_R2 & R2_SPR0_HIT) == 0))
			{//			水平x轴坐标					 
				clocks = sprite[0].x * 113 / 256;	//	 256每一行扫描像素宽度
				run(clocks*256);  //需重点优化

				PPU_Reg.NES_R2 |= R2_SPR0_HIT;
				run((113 - clocks)*256);

			}
			else run(113*256);  //耗时大户
			if(PPU_Reg.NES_R1 & (R1_BG_VISIBLE | R1_SPR_VISIBLE))//若为假，关闭显示
			{
				if(SpriteHitFlag == 0)
				NES_GetSpr0HitFlag(PPU_scanline - SCAN_LINE_DISPALY_START_NUM);//查找Sprite #0 碰撞标志
			}
			if(frame_cnt==3)//每3帧显示一次	   //耗时大户
			{				
				NES_RenderLine(PPU_scanline - 21);//水平同步与显示一行			
			}	
		}
		//scanline: 262 完成一帧 
		run(113*256); //解释执行113个6502时钟周期指令

		PPU_Reg.NES_R2 |= R2_VBlank_Flag;//设置VBANK 标志
		//若使能PPU VBANK中断，则设置VBANK 
		if(PPU_Reg.NES_R0 & R0_VB_NMI_EN)
		{
//			NMI_Flag = SET1;//完成一帧扫描，产生NMI中断
			line242NMI();

		}
		if(frame_cnt==3)frame_cnt=0;  //帧计数器//每3帧显示一次  
	   	//设置帧IRQ标志，同步计数器，APU等 		   
		//A mapper function in V-Sync 存储器切换垂直VBANK同步 
		//MapperVSync();  
		//读取控制器JoyPad状态,更新JoyPad控制器值*/
		//NES_JoyPadUpdateValue();	 //systick 中断读取按键值 
//		LED=!LED;
	}
} 
//	  其他,错误代码
void nes_main(void)
{	
	 //初始化6502存储器镜像
//	prg_rombank0= (u8*)&nes_rom[16];					//16kb程序rom地址	
//	prg_rombank1= (u8*)&nes_rom[16] +(0x4000*(2-1));	//16kb程序rom地址
	romfile=(u8*)&nes_rom[0];
	loadcart();					
 
				
//		reset6502();//复位
	//	PPU_Init(((u8*)&rom_file[offset+0x10] + (neshreader->romnum * 0x4000)), (neshreader->romfeature & 0x01));//PPU_初始化
//		PPU_Init((romfile+16 + (2 * 0x4000)), (0x01 & 0x01));//PPU_初始化 	
		PPU_Init(((u8*)&nes_rom[0x10] + (2 * 0x4000)), (1 & 0x01));//PPU_初始化 
//        NES_JoyPadInit();  
		NesFrameCycle();//模拟器循环执行
}


