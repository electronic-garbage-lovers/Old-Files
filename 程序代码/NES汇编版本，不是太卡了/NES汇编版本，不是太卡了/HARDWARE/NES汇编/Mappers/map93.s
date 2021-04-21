	AREA rom_code, CODE, READONLY

	INCLUDE equates.h
	INCLUDE memory.h
	INCLUDE ppu.h
	INCLUDE cart.h

	EXPORT mapper93init

;----------------------------------------------------------------------------
mapper93init	;Fantazy Zone (J)
;----------------------------------------------------------------------------
	DCD write93,write93,write93,write93

	mov pc,lr
;-------------------------------------------------------
write93
;-------------------------------------------------------
	stmfd sp!,{r0,lr}
	tst r0,#1
	bl mirror2V_
	ldmfd sp!,{r0,lr}
	mov r0,r0,lsr#4
	b map89AB_
;-------------------------------------------------------
	END
