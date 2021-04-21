


;//NES_RAM			EQU 0x20008000	;//保持1024字节6502狗屎堆对齐	
									 

globalptr	RN r10 ;=wram_globals* ptr
;//cpu_zpage	RN r11 ;=CPU_RAM
;----------------------------------------------------------------------------


;//everything in wram_globals* areas:
 MAP 0,globalptr	;6502.s	  ;//MAP 用于定义一个结构化的内存表的首地址
							  ;//定义内存表的首地址为globalptr
opz # 256*4					  ;//代码表占用256*4
readmem_tbl # 8*4			  ;//8*4
writemem_tbl # 8*4			  ;//8*4
memmap_tbl # 8*4			 ;//存储器映象 ram+rom
cpuregs # 7*4				 ;//1208存放6502寄存器保存的开始地址
m6502_s # 4					 ;//
lastbank # 4				;//6502PC从 ROM的最后偏移量
nexttimeout # 4

rombase # 4			;//ROM开始地址
romnumber # 4		 ;// ROM大小  40976 字节
rommask # 4		   ;//ROM掩膜	rommask=romsize-1

joy0serial # 4	   ;//串行数据
;// # 2 ;align					 ;//总共1360/////////////////////////

		END
