	AREA rom_code, CODE, READONLY

	INCLUDE equates.h
	INCLUDE memory.h
	INCLUDE ppu.h
	INCLUDE cart.h

	EXPORT mapper86init

;----------------------------------------------------------------------------
mapper86init	;Jaleco - Moero!! Pro Yakyuu, Urusei Yatsura...
;----------------------------------------------------------------------------
	DCD void,void,void,void
	adr r1,write86
	str r1,writemem_tbl+12
	mov r0,#0
	b map89ABCDEF_
;-------------------------------------------------------
write86
;-------------------------------------------------------
	cmp addy,#0x6000
	movne pc,lr
	stmfd sp!,{r0,lr}
	mov r0,r0,lsr#4
	bl map89ABCDEF_
	ldmfd sp!,{r0,lr}
	and r1,r0,#0x40
	and r0,r0,#0x03
	orr r0,r0,r1,lsr#4
	b chr01234567_


;-------------------------------------------------------
	END
