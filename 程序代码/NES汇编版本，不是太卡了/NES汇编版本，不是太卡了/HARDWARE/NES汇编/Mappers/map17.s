;	AREA wram_code3, CODE, READWRITE
	AREA rom_code, CODE, READONLY

	INCLUDE equates.h
	INCLUDE memory.h
	INCLUDE cart.h
	INCLUDE 6502.h
	INCLUDE 6502mac.h
	INCLUDE io.h

	EXPORT mapper17init

counter EQU mapperdata+0
enable EQU mapperdata+4
;----------------------------------------------------------------------------
mapper17init
;----------------------------------------------------------------------------
	DCD void,void,void,void

	adr r1,write0
	str r1,writemem_tbl+8

	adr r0,hook
	str r0,scanlinehook

	mov pc,lr
;-------------------------------------------------------
write0
;-------------------------------------------------------
	cmp addy,#0x4100
	blo IO_W

	and r2,addy,#0xff
	cmp r2,#0xfe
	beq _fe
	cmp r2,#0xff
	beq _ff

	and r2,r2,#0x17
	tst r2,#0x10
	subne r2,r2,#8

	adr r1,jmptbl
	ldr pc,[r1,r2,lsl#2]

jmptbl	DCD void,_1,_2,_3,map89_,mapAB_,mapCD_,mapEF_
	DCD chr0_,chr1_,chr2_,chr3_,chr4_,chr5_,chr6_,chr7_

_fe
	tst r0,#0x10
	b mirror1_
_ff
	tst r0,#0x10
	b mirror2V_
_1
	and r0,r0,#1
	strb r0,enable
	mov pc,lr
_2
	strb r0,counter+2
	mov pc,lr
_3
	strb r0,counter+3
	mov r1,#1
	strb r1,enable
	mov pc,lr
;-------------------------------------------------------
hook
;------------------------------------------------------
	ldrb r0,enable
	cmp r0,#0
	beq h1

	ldr r0,counter
	adds r0,r0,#0x10000
	str r0,counter
;	bcs irq6502
	bcs CheckI
h1
	fetch 0
;-------------------------------------------------------
	END
