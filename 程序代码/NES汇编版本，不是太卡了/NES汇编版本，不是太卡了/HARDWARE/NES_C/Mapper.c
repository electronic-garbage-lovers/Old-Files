#include "Mapper.h"
#include "Waves'NES.h"
#include "Mapper000.h"
#include "Mapper002.h"

MAPPER NES_Mapper;
void Mapper_Init(void)
{
	NES_Mapper.Reset         = Mapper_Reset;
	NES_Mapper.Write         = Mapper_Write;
	NES_Mapper.Read          = Mapper_Read;
	NES_Mapper.WriteLow      = Mapper_WriteLow;
	NES_Mapper.ReadLow       = Mapper_ReadLow;	
	NES_Mapper.ExWrite       = Mapper_ExWrite;
	NES_Mapper.ExRead        = Mapper_ExRead;
	NES_Mapper.ExCmdRead     = Mapper_ExCmdRead;
}

BOOL CreateMapper(int no)
{
	Mapper_Init();
	switch (no)
	{
		case 0:Mapper000_Init();break;
		case 2:Mapper002_Init();break;
		default:break;
	}
	return TRUE;
}

void Mapper_Reset(void){}

BYTE Mapper_ReadLow(WORD addr)
{
	if(addr>=0x6000&&addr<=0x7FFF)return CPU_MEM_BANK[addr>>13][addr&0x1FFF];
	return (BYTE)(addr>>8);
}

void Mapper_WriteLow(WORD addr,BYTE data)
{
	if(addr>=0x6000&&addr<=0x7FFF)CPU_MEM_BANK[addr>>13][addr&0x1FFF]=data;
}

void Mapper_Write( WORD addr, BYTE data ){}

void Mapper_Read( WORD addr, BYTE data ){}

BYTE Mapper_ExRead( WORD addr )	
{ 
	return 0x00; 
}

void Mapper_ExWrite( WORD addr, BYTE data ){}

BYTE Mapper_ExCmdRead ()	
{ 
	return 0x00; 
}


