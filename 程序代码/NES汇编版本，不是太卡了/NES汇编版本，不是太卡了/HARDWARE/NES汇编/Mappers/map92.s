	AREA rom_code, CODE, READONLY

	INCLUDE equates.h
	INCLUDE memory.h
	INCLUDE ppu.h
	INCLUDE cart.h

	EXPORT mapper92init

;----------------------------------------------------------------------------
mapper92init	;Jaleco - Moero!! Pro Soccer, Moero!! Pro Yakyuu '88 Kettei Ban...
;----------------------------------------------------------------------------
	DCD write0,write1,write1,write1

	mov pc,lr
;-------------------------------------------------------
write0		; Moero!! Pro Yakyuu '88
;-------------------------------------------------------
	tst addy,#0x1000
	bne write1
	and r0,addy,#0xff
	mov r1,r0,lsr#4
	cmp r1,#0xB
	beq mapCDEF_
	cmp r1,#0x7
	beq chr01234567_
	mov pc,lr
;-------------------------------------------------------
write1		; Moero!! Pro Soccer
;-------------------------------------------------------
	and r0,addy,#0xff
	mov r1,r0,lsr#4
	cmp r1,#0xD
	beq mapCDEF_
	cmp r1,#0xE
	beq chr01234567_
	mov pc,lr
;-------------------------------------------------------
	END
