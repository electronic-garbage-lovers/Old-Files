


;//NES_RAM			EQU 0x20008000	;//����1024�ֽ�6502��ʺ�Ѷ���	
									 

globalptr	RN r10 ;=wram_globals* ptr
;//cpu_zpage	RN r11 ;=CPU_RAM
;----------------------------------------------------------------------------


;//everything in wram_globals* areas:
 MAP 0,globalptr	;6502.s	  ;//MAP ���ڶ���һ���ṹ�����ڴ����׵�ַ
							  ;//�����ڴ����׵�ַΪglobalptr
opz # 256*4					  ;//�����ռ��256*4
readmem_tbl # 8*4			  ;//8*4
writemem_tbl # 8*4			  ;//8*4
memmap_tbl # 8*4			 ;//�洢��ӳ�� ram+rom
cpuregs # 7*4				 ;//1208���6502�Ĵ�������Ŀ�ʼ��ַ
m6502_s # 4					 ;//
lastbank # 4				;//6502PC�� ROM�����ƫ����
nexttimeout # 4

rombase # 4			;//ROM��ʼ��ַ
romnumber # 4		 ;// ROM��С  40976 �ֽ�
rommask # 4		   ;//ROM��Ĥ	rommask=romsize-1

joy0serial # 4	   ;//��������
;// # 2 ;align					 ;//�ܹ�1360/////////////////////////

		END
