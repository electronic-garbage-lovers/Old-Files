	INCLUDE equates.h

	IMPORT CPU_reset
	IMPORT romfile ;from main.c
	IMPORT op_table	   ;������ת���ַ 6502.s
	IMPORT NES_RAM

	EXPORT loadcart
	
;----------------------------------------------------------------------------
 AREA rom_code, CODE, READONLY

;	THUMB
;   PRESERVE8

;----------------------------------------------------------------------------
loadcart PROC
;----------------------------------------------------------------------------
	stmfd sp!,{r4-r11,lr}
	ldr r10,=op_table	;��ȡ������ת���ַ
	ldr r11,=NES_RAM	;r11=cpu_zpage

			
	ldr r0,=romfile		 
	ldr r0,[r0]			 ;R0����ָ��ROMӳ�񣨰���ͷ��
	add r3,r0,#16		;r3����ָ��rom����(������ͷ��
	str r3,rombase		;����rom����ַ
						;r3=rombase til end of loadcart so DON'T FUCK IT UP


	mov r2,#1
	ldrb r1,[r3,#-12]	; 16kB ROM����Ŀ  	 2
	rsb r0,r2,r1,lsl#14	 ;romsize=X*16KB	 <<14 �������ָ��	 r0=0x7fff
	str r0,rommask		;rommask=romsize-1	 32768-1


	mov r9,#0		;(�����κ�encodePC��ӳ����*��ʼ�������еĴ���)
	str r9,lastbank		;6502PC�� ROM�����ƫ����д0

	mov r0,#0			;Ĭ��romӳ��
	bl map89AB_			;89AB=1st 16k
	mov r0,#-1
	bl mapCDEF_			;CDEF=last 16k
	

;	mov r0,#0xFFFFFFFF		;��� nes ram
;	mov r0,#0
;	mov r1,cpu_zpage
;	mov r2,#0x800/4
;	bl filler_

;	bl PPU_reset
;	bl IO_reset
;	bl Sound_reset
	bl CPU_reset		;reset everything else
	ldmfd sp!,{r4-r11,lr}
	bx lr
	ENDP

;----------------------------------------------------------------------------
map67_	;rom paging.. r0=page#
;----------------------------------------------------------------------------
	ldr r1,rommask
	and r0,r1,r0,lsl#13
	ldr r1,rombase
	add r0,r1,r0
	sub r0,r0,#0x6000
	str r0,memmap_tbl+12
	b flush
;----------------------------------------------------------------------------
map89_	;rom paging.. r0=page#
;----------------------------------------------------------------------------
	ldr r1,rombase			 ;rom��ʼ��ַ
	sub r1,r1,#0x8000
	ldr r2,rommask
	and r0,r2,r0,lsl#13
	add r0,r1,r0
	str r0,memmap_tbl+16
	b flush
;----------------------------------------------------------------------------
mapAB_
;----------------------------------------------------------------------------
	ldr r1,rombase
	sub r1,r1,#0xa000
	ldr r2,rommask
	and r0,r2,r0,lsl#13
	add r0,r1,r0
	str r0,memmap_tbl+20
	b flush
;----------------------------------------------------------------------------
mapCD_
;----------------------------------------------------------------------------
	ldr r1,rombase
	sub r1,r1,#0xc000
	ldr r2,rommask
	and r0,r2,r0,lsl#13
	add r0,r1,r0
	str r0,memmap_tbl+24
	b flush
;----------------------------------------------------------------------------
mapEF_
;----------------------------------------------------------------------------
	ldr r1,rombase
	sub r1,r1,#0xe000
	ldr r2,rommask
	and r0,r2,r0,lsl#13
	add r0,r1,r0
	str r0,memmap_tbl+28
	b flush
;----------------------------------------------------------------------------
map89AB_
;----------------------------------------------------------------------------
	ldr r1,rombase		   ;rom����ַ��������ͷ��
	sub r1,r1,#0x8000
	ldr r2,rommask
	and r0,r2,r0,lsl#14
	add r0,r1,r0
	str r0,memmap_tbl+16
	str r0,memmap_tbl+20
flush		;update m6502_pc & lastbank
	ldr r1,lastbank
	sub r9,r9,r1
	and r1,r9,#0xE000	   ;//r9��0xe000��λ������
	adr r2,memmap_tbl		   ;//�Ѵ洢��ӳ���ַ���ص�r2
;//	ldr r0,[r2,r1,lsr#11]	   ;//�Ĺ�����2�� 
	lsr r1,r1,#11				;//>>11λ	  r1/2048
	ldr r0,[r2,r1]				;//��ȡr2��ַ+r1ƫ�Ƶ����ݵ�r0
;//	lsl r1,r1,#11				;//<<11λ	  r1*2048

	str r0,lastbank				;//����6502PC�� ROM�����ƫ���� 
	add r9,r9,r0	;//m6502_pc+r0
	bx lr
;----------------------------------------------------------------------------
mapCDEF_
;----------------------------------------------------------------------------
	ldr r1,rombase
	sub r1,r1,#0xc000
	ldr r2,rommask
	and r0,r2,r0,lsl#14
	add r0,r1,r0
	str r0,memmap_tbl+24
	str r0,memmap_tbl+28
	b flush
;----------------------------------------------------------------------------
map89ABCDEF_
;----------------------------------------------------------------------------
	ldr r1,rombase
	sub r1,r1,#0x8000
	ldr r2,rommask
	and r0,r2,r0,lsl#15
	add r0,r1,r0
	str r0,memmap_tbl+16
	str r0,memmap_tbl+20
	str r0,memmap_tbl+24
	str r0,memmap_tbl+28
	b flush

  

	nop
;----------------------------------------------------------------------------
	END
