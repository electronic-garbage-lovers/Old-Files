#ifndef _NES_MAIN_H_
#define _NES_MAIN_H_
#include "sys.h"    
#include <stdio.h>
#include <string.h>   


//////////////////////////////////////////////////////////////////////////////////	 
//�ҵ� STM32������
//NESģ���� ����	   
//�޸�����:2012/10/3
//�汾��V1.0		       								  
////////////////////////////////////////////////////////////////////////////////// 	   
extern u8 FPS;			//ͳ��ÿ��֡��		 
							 										  
//typedef struct
//{
//	char filetype[4]; 	//�ַ�����NES^Z������ʶ��.NES�ļ� 		 
//	u8 romnum;			//16kB ROM����Ŀ 						 
//	u8 vromnum;			//8kB VROM����Ŀ				 
//	u8 romfeature;		//D0��1����ֱ����0��ˮƽ���� 
//						// D1��1���е�ؼ��䣬SRAM��ַ$6000-$7FFF
//						// D2��1����$7000-$71FF��һ��512�ֽڵ�trainer 
//						// D3��1��4��ĻVRAM���� 
//						//  D4��D7��ROM Mapper���4� 	  
//	u8 rommappernum;	// D0��D3��������������0��׼����Ϊ��Mapper��^_^��
//						// D4��D7��ROM Mapper�ĸ�4λ 		    
//	//u8 reserve[8];	// ������������0 					    
//	//OM���������У��������trainer������512�ֽڰ���ROM��֮ǰ 
//	//VROM��, �������� 
//}NesHeader;																		 

void nes_main(void);
void NesFrameCycle(void);

//void NES_ReadJoyPad(u8 JoyPadNum);
//
//
////PPUʹ��
//extern u8 *NameTable;			//2K�ı���
//extern u16	*Buffer_scanline;	//����ʾ����,���±�Խ�����Ϊ7����ʾ�� 7 ~ 263  0~7 263~270 Ϊ��ֹ�����
////CPUʹ��
//extern u8 *ram6502;  			//RAM  2K�ֽ�,��malloc����


										 
#endif











