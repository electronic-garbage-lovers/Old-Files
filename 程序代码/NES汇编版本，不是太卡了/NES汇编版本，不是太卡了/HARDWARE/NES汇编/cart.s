	INCLUDE equates.h
	INCLUDE mappers.h
	INCLUDE memory.h
	INCLUDE 6502mac.h
	INCLUDE 6502.h
	INCLUDE ppu.h
	INCLUDE io.h
	INCLUDE sound.h

	IMPORT findrom ;from main.c

	EXPORT loadcart
	EXPORT map67_
	EXPORT map89_
	EXPORT mapAB_
	EXPORT mapCD_
	EXPORT mapEF_
	EXPORT map89AB_
	EXPORT mapCDEF_
	EXPORT map89ABCDEF_
	EXPORT chr0_
	EXPORT chr1_
	EXPORT chr2_
	EXPORT chr3_
	EXPORT chr4_
	EXPORT chr5_
	EXPORT chr6_
	EXPORT chr7_
	EXPORT chr01_
	EXPORT chr23_
	EXPORT chr45_
	EXPORT chr67_
	EXPORT chr0123_
	EXPORT chr4567_
	EXPORT chr01234567_
	EXPORT writeCHRTBL
	EXPORT updateBGCHR_
	EXPORT updateOBJCHR
	EXPORT mirror1_
	EXPORT mirror2V_
	EXPORT mirror2H_
	EXPORT mirror4_
	EXPORT mirrorKonami_
	EXPORT chrfinish
	EXPORT savestate
	EXPORT loadstate
	EXPORT g_emuflags
	EXPORT romstart
	EXPORT romnum
	EXPORT g_scaling
	EXPORT g_cartflags
	EXPORT g_hackflags
;----------------------------------------------------------------------------
 AREA rom_code, CODE, READONLY
;----------------------------------------------------------------------------

mappertbl
	DCD 0,mapper0init
	DCD 1,mapper1init
	DCD 2,mapper2init
	DCD 3,mapper3init
	DCD 4,mapper4init
	DCD 5,mapper5init
	DCD 7,mapper7init
	DCD 9,mapper9init
	DCD 10,mapper10init
	DCD 11,mapper11init
	DCD 15,mapper15init
	DCD 16,mapper16init
	DCD 17,mapper17init
	DCD 18,mapper18init
	DCD 19,mapper19init
	DCD 21,mapper21init
	DCD 22,mapper22init
	DCD 23,mapper23init
	DCD 24,mapper24init
	DCD 25,mapper25init
	DCD 26,mapper26init
	DCD 32,mapper32init
	DCD 33,mapper33init
	DCD 34,mapper34init
	DCD 40,mapper40init
	DCD 64,mapper64init
	DCD 65,mapper65init
	DCD 66,mapper66init
	DCD 67,mapper67init
	DCD 68,mapper68init
	DCD 69,mapper69init
	DCD 70,mapper70init
	DCD 71,mapper71init
	DCD 72,mapper72init
	DCD 73,mapper73init
	DCD 75,mapper75init
	DCD 76,mapper76init
	DCD 77,mapper77init
	DCD 78,mapper78init
	DCD 79,mapper79init
	DCD 80,mapper80init
	DCD 85,mapper85init
	DCD 86,mapper86init
	DCD 87,mapper87init
	DCD 92,mapper92init
	DCD 93,mapper93init
	DCD 94,mapper94init
	DCD 97,mapper97init
	DCD 99,mapper99init
	DCD 105,mapper105init
	DCD 118,mapper4init
	DCD 119,mapper4init
	DCD 151,mapper151init
	DCD 152,mapper152init
	DCD 158,mapper64init
	DCD 180,mapper180init
	DCD 184,mapper184init
	DCD 228,mapper228init
	DCD 232,mapper232init
	DCD -1,mapper0init

;----------------------------------------------------------------------------
loadcart ;called from C:  r0=rom number, r1=emuflags
;----------------------------------------------------------------------------
	stmfd sp!,{r0-r1,r4-r11,lr}

	ldr r1,=findrom
	bl thumbcall_r1

	ldr globalptr,=|wram_globals0$$Base|	;need ptr regs init'd
	ldr cpu_zpage,=NES_RAM

;	add r0,r0,#48		;r0 now points to rom image (including header)
	add r3,r0,#64		;r3 now points to rom image
	str r3,rombase		;set rom base
						;r3=rombase til end of loadcart so DON'T FUCK IT UP
	ldmfd sp!,{r0-r1}
	str r0,romnumber
	str r1,emuflags

	mov r1,#0			;This should probably fetched from the header��Ҳ��Ӧ�ôӱ�ͷ����ȡ.
	strb r1,hackflags

	mov r2,#1
	ldrb r1,[r3,#-12]
	rsb r0,r2,r1,lsl#14
	str r0,rommask		;rommask=romsize-1

	add r0,r3,r1,lsl#14
	str r0,vrombase		;set vrom base

	ldrb r4,[r3,#-11]
	mov r1,r4			;r1=vrom size
	cmp r4,#2
	movhi r1,#4			;needs to be power of 2 (stupid zelda2)
	cmp r4,#4
	movhi r1,#8
	cmp r4,#8
	movhi r1,#16
	cmp r4,#16
	movhi r1,#32
	cmp r4,#32
	movhi r1,#64
	cmp r4,#64
	movhi r1,#128
	rsbs r0,r2,r1,lsl#13
	str r0,vrommask		;vrommask=vromsize-1
	ldrmi r0,=NES_VRAM
	strmi r0,vrombase	;vrombase=NES VRAM if vromsize=0

	ldr r0,=void
	ldrmi r0,=VRAM_chr	;enable/disable chr write ����/�����ַ�д
	ldr r1,=vram_write_tbl
	mov r2,#8
	bl filler_

	mov r0,#-1			;reset all CHR
	adrl r1,agb_bg_map
	mov r2,#6			;agb_bg_map,agb_obj_map
	bl filler_
	ldr r0,=0x0004080c
	str r0,bg_recent
	mov r0,#0			;default CHR mapping
	ldr r2,=chrold
	ldr r1,=0x03020100
	str r1,[r2],#4
	str r0,[r2] ;chrline
	bl chr01234567_

	ldr r4,nes_chr_map
	ldr r5,nes_chr_map+4
	str r4,old_chr_map
	str r4,new_chr_map
	str r5,old_chr_map+4
	str r5,new_chr_map+4

	ldr r2,vrommask		;if vromsize=0
	tst r2,#0x80000000
	bpl lc2
	str r4,agb_bg_map		;setup BG map so it won't change
	str r5,agb_bg_map+4
lc2
	mov m6502_pc,#0		;(�����κ�encodePC��ӳ����*��ʼ�������еĴ���)
	str m6502_pc,lastbank

	mov r0,#0			;default ROM mappingĬ�ϵ�ROMӳ��
	bl map89AB_			;89AB=1st 16k
	mov r0,#-1
	bl mapCDEF_			;CDEF=last 16k

	ldrb r0,[r3,#-10]
	ldrb r1,[r3,#-9]
	and r0,r0,#0x0f
	orr r1,r0,r1,lsl#4
	tst r3,#0x8000000
	biceq r1,r1,#SRAM		;don't use true SRAM if not running from a flash cart
	strb r1,cartflags		;set cartflags

;	ldr r0,=default_scanlinehook
	ldr r0,=pcm_scanlinehook
	str r0,scanlinehook	;no mapper irq

	mov r0,#0xFFFFFFFF		;��� nes ram
;	mov r0,#0
	mov r1,cpu_zpage
	mov r2,#0x800/4
	bl filler_
	mov r0,#0				;clear nes sram
	add r1,cpu_zpage,#0x800
	mov r2,#0x2000/4
	bl filler_
	ldr r1,=mapperstate		;clear mapperdata so we don't have to do that in every MapperInit.
	mov r2,#32/4
	bl filler_

	mov r0,#0x7c
	mov r1,cpu_zpage
	ldr r2,=0x247d			;0x7c7d
	strb r0,[r1,r2]			;for "Low G Man".
	add r2,r2,#0x100
	mov r0,#0x7d
	strb r0,[r1,r2]			;for "Low G Man".

	ldr r0,=joy0_W
	ldr r1,=joypad_write_ptr
	str r0,[r1]				;reset 4016 write (mapper99 messes with it)

	ldr r1,=IO_R			;reset other writes..
	str r1,readmem_tbl+8
	ldr r1,=sram_R			;reset other writes..
	str r1,readmem_tbl+12
	ldr r1,=IO_W			;reset other writes..
	str r1,writemem_tbl+8
	ldr r1,=sram_W
	str r1,writemem_tbl+12
	ldr r1,=NES_RAM-0x5800	;$6000 for mapper 40, 69 & 90 that has rom here.
	str r1,memmap_tbl+12

	ldrb r1,[r3,#-10]		;get mapper#
	ldrb r2,[r3,#-9]
	tst r2,#0x0e			;long live DiskDude!
	and r1,r1,#0xf0
	and r2,r2,#0xf0
	orr r0,r2,r1,lsr#4
	movne r0,r1,lsr#4		;ignore high nibble if header looks bad
							;lookup mapper*init
	adr r1,mappertbl
lc0	ldr r2,[r1],#8
	teq r2,r0
	beq lc1
	bpl lc0
lc1				;call mapper*init
	adr lr,%F0
	adr r5,writemem_tbl+16
	ldr r0,[r1,#-4]
	ldmia r0!,{r1-r4}
	stmia r5,{r1-r4}
	mov pc,r0			;Jump to MapperInit
0
	ldrb r1,cartflags
	tst r1,#MIRROR		;set default mirror	����Ĭ�ϵľ���
	bl mirror2H_		;(������ӳ��������cartflags ����һ��mapperinit)

	bl PPU_reset
	bl IO_reset
	bl Sound_reset
	bl CPU_reset		;reset everything else
	ldmfd sp!,{r4-r11,lr}
	bx lr
;----------------------------------------------------------------------------
savestate	;called from ui.c.
;int savestate(void *here): copy state to <here>, return size
;----------------------------------------------------------------------------
	stmfd sp!,{r4-r6,globalptr,lr}

	ldr globalptr,=|wram_globals0$$Base|

	ldr r2,rombase
	rsb r2,r2,#0			;adjust rom maps,etc so they aren't based on rombase
	bl fixromptrs			;(so savestates are valid after moving roms around)

	mov r6,r0			;r6=where to copy state
	mov r0,#0			;r0 holds total size (return value)

	adr r4,savelst			;r4=list of stuff to copy
	mov r3,#(lstend-savelst)/8	;r3=items in list
ss1	ldr r2,[r4],#4				;r2=what to copy
	ldr r1,[r4],#4				;r1=how much to copy
	add r0,r0,r1
ss0	ldr r5,[r2],#4
	str r5,[r6],#4
	subs r1,r1,#4
	bne ss0
	subs r3,r3,#1
	bne ss1

	ldr r2,rombase
	bl fixromptrs

	ldmfd sp!,{r4-r6,globalptr,lr}
	bx lr

savelst	DCD rominfo,8,NES_RAM,0x2800,NES_VRAM,0x3000,agb_pal,96
	DCD vram_map,64,agb_nt_map,16,mapperstate,48,rommap,16,cpustate,44,ppustate,32
lstend

fixromptrs	;add r2 to some things
	adr r1,memmap_tbl+16
	ldmia r1,{r3-r6}
	add r3,r3,r2
	add r4,r4,r2
	add r5,r5,r2
	add r6,r6,r2
	stmia r1,{r3-r6}

	ldr r3,lastbank
	add r3,r3,r2
	str r3,lastbank

	ldr r3,cpuregs+6*4	;6502 PC
	add r3,r3,r2
	str r3,cpuregs+6*4

	mov pc,lr
;----------------------------------------------------------------------------
loadstate	;called from ui.c
;void loadstate(int rom#,u32 *stateptr)	 (stateptr must be word aligned)
;----------------------------------------------------------------------------
	stmfd sp!,{r4-r7,globalptr,lr}

	mov r6,r1		;r6=where state is at
	ldr globalptr,=|wram_globals0$$Base|

        ldr r1,[r6]             ;emuflags
	bl loadcart		;cart init

	mov r0,#(lstend-savelst)/8	;read entire state
	adr r4,savelst
ls1	ldr r2,[r4],#4
	ldr r1,[r4],#4
ls0	ldr r5,[r6],#4
	str r5,[r2],#4
	subs r1,r1,#4
	bne ls0
	subs r0,r0,#1
	bne ls1

	ldr r2,rombase		;adjust ptr shit (see savestate above)
	bl fixromptrs

	ldr r3,=NES_VRAM+0x2000	;init nametbl+attrib
	ldr r4,=AGB_BG
ls4	mov r5,#0
ls3	mov r1,r3
	mov r2,r4
	mov addy,r5
	ldrb r0,[r1,addy]
	bl writeBG
	add r5,r5,#1
	tst r5,#0x400
	beq ls3
	add r3,r3,#0x400
	add r4,r4,#0x800
	tst r4,#0x10000
	beq ls4

;--------------------------------
	ldr r2,vrommask		;if vromsize=0
	tst r2,#0x80000000
	bne lc3

	mov r0,#-1			;reset all CHR
	adrl r1,agb_bg_map
	mov r2,#6			;agb_bg_map,agb_obj_map
	bl filler_
	ldr r0,=0x0004080c
	str r0,bg_recent
lc3
;--------------------------------


	mov r1,#-1			;init BG CHR
	ldr r5,=AGB_VRAM
	adrl r6,nes_chr_map
	bl im_lazy
	mov r1,#-1
	ldr r5,=AGB_VRAM+0x4000
	adrl r6,nes_chr_map+4
	bl im_lazy

	ldrb r0,ppuctrl1	;prep buffered DMA stuff
	bl ctrl1_W
	bl newX
	bl resetBGCHR

	ldmfd sp!,{r4-r7,globalptr,lr}
	bx lr
;----------------------------------------------------------------------------
m0000	DCD 0x1c02,NES_VRAM+0x2000,NES_VRAM+0x2000,NES_VRAM+0x2000,NES_VRAM+0x2000
	DCD AGB_BG+0x0000,AGB_BG+0x0000,AGB_BG+0x0000,AGB_BG+0x0000
m1111	DCD 0x1d02,NES_VRAM+0x2400,NES_VRAM+0x2400,NES_VRAM+0x2400,NES_VRAM+0x2400
	DCD AGB_BG+0x0800,AGB_BG+0x0800,AGB_BG+0x0800,AGB_BG+0x0800
m0101	DCD 0x5c02,NES_VRAM+0x2000,NES_VRAM+0x2400,NES_VRAM+0x2000,NES_VRAM+0x2400
	DCD AGB_BG+0x0000,AGB_BG+0x0800,AGB_BG+0x0000,AGB_BG+0x0800
m0011	DCD 0x9c02,NES_VRAM+0x2000,NES_VRAM+0x2000,NES_VRAM+0x2400,NES_VRAM+0x2400
	DCD AGB_BG+0x0000,AGB_BG+0x0000,AGB_BG+0x0800,AGB_BG+0x0800
m0123	DCD 0xdc02,NES_VRAM+0x2000,NES_VRAM+0x2400,NES_VRAM+0x2800,NES_VRAM+0x2c00
	DCD AGB_BG+0x0000,AGB_BG+0x0800,AGB_BG+0x1000,AGB_BG+0x1800
;----------------------------------------------------------------------------
 AREA wram_code4, CODE, READWRITE
;----------------------------------------------------------------------------
mirrorKonami_
	movs r1,r0,lsr#2
	tst r0,#1
	bcc mirror2V_
;	bcs mirror1_
mirror1_
	ldrne r0,=m1111
	ldreq r0,=m0000
	b mirrorchange
mirror2V_
	ldreq r0,=m0101
	ldrne r0,=m0011
	b mirrorchange
mirror2H_
	ldreq r0,=m0011
	ldrne r0,=m0101
	b mirrorchange
mirror4_
	ldr r0,=m0123
mirrorchange
	ldrb r1,cartflags
	tst r1,#SCREEN4+VS
	ldrne r0,=m0123		;force 4way mirror for SCREEN4 or VS flags

	stmfd sp!,{r0,r3-r5,lr}

	ldr r0,chrold
	ldr r1,chrline
	ldr r2,scanline
	cmp r2,#239
	movhi r2,#239
	bl ubg2_	;allow mid-frame change

	ldr r0,[sp],#4
	ldr r3,[r0],#4
	str r3,BGmirror

	ldr r1,=vram_map+32
	ldmia r0!,{r2-r5}
	stmia r1,{r2-r5}
	ldr r1,=agb_nt_map
	ldmia r0!,{r2-r5}
	stmia r1,{r2-r5}
	ldmfd sp!,{r3-r5,pc}
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
	ldr r1,rombase
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
	ldr r1,rombase
	sub r1,r1,#0x8000
	ldr r2,rommask
	and r0,r2,r0,lsl#14
	add r0,r1,r0
	str r0,memmap_tbl+16
	str r0,memmap_tbl+20
flush		;update m6502_pc & lastbank
	ldr r1,lastbank
	sub m6502_pc,m6502_pc,r1
	encodePC
	mov pc,lr
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
;----------------------------------------------------------------------------
writeCHRTBL	DCD chr0_,chr1_,chr2_,chr3_,chr4_,chr5_,chr6_,chr7_
;----------------------------------------------------------------------------
chr0_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#10

	strb r0,nes_chr_map
	ldr r1,vrombase
	add r1,r1,r0,lsl#10
	str r1,vram_map
	b updateBGCHR_
;----------------------------------------------------------------------------
chr1_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#10

	strb r0,nes_chr_map+1
	ldr r1,vrombase
	add r1,r1,r0,lsl#10
	str r1,vram_map+4
	b updateBGCHR_
;----------------------------------------------------------------------------
chr2_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#10

	strb r0,nes_chr_map+2
	ldr r1,vrombase
	add r1,r1,r0,lsl#10
	str r1,vram_map+8
	b updateBGCHR_
;----------------------------------------------------------------------------
chr3_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#10

	strb r0,nes_chr_map+3
	ldr r1,vrombase
	add r1,r1,r0,lsl#10
	str r1,vram_map+12
	b updateBGCHR_
;----------------------------------------------------------------------------
chr4_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#10

	strb r0,nes_chr_map+4
	ldr r1,vrombase
	add r1,r1,r0,lsl#10
	str r1,vram_map+16
	b updateBGCHR_
;----------------------------------------------------------------------------
chr5_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#10

	strb r0,nes_chr_map+5
	ldr r1,vrombase
	add r1,r1,r0,lsl#10
	str r1,vram_map+20
	b updateBGCHR_
;----------------------------------------------------------------------------
chr6_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#10

	strb r0,nes_chr_map+6
	ldr r1,vrombase
	add r1,r1,r0,lsl#10
	str r1,vram_map+24
	b updateBGCHR_
;----------------------------------------------------------------------------
chr7_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#10

	strb r0,nes_chr_map+7
	ldr r1,vrombase
	add r1,r1,r0,lsl#10
	str r1,vram_map+28
	b updateBGCHR_
;----------------------------------------------------------------------------
chr01_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#11

	mov r1,r0,lsl#1
	strb r1,nes_chr_map
	orr r1,r1,#1
	strb r1,nes_chr_map+1

	ldr r1,vrombase
	add r1,r1,r0,lsl#11
	str r1,vram_map
	add r1,r1,#0x400
	str r1,vram_map+4
	b updateBGCHR_
;----------------------------------------------------------------------------
chr23_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#11

	mov r1,r0,lsl#1
	strb r1,nes_chr_map+2
	orr r1,r1,#1
	strb r1,nes_chr_map+3

	ldr r1,vrombase
	add r1,r1,r0,lsl#11
	str r1,vram_map+8
	add r1,r1,#0x400
	str r1,vram_map+12
	b updateBGCHR_
;----------------------------------------------------------------------------
chr45_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#11

	mov r1,r0,lsl#1
	strb r1,nes_chr_map+4
	orr r1,r1,#1
	strb r1,nes_chr_map+5

	ldr r1,vrombase
	add r1,r1,r0,lsl#11
	str r1,vram_map+16
	add r1,r1,#0x400
	str r1,vram_map+20
	b updateBGCHR_
;----------------------------------------------------------------------------
chr67_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#11

	mov r1,r0,lsl#1
	strb r1,nes_chr_map+6
	orr r1,r1,#1
	strb r1,nes_chr_map+7

	ldr r1,vrombase
	add r1,r1,r0,lsl#11
	str r1,vram_map+24
	add r1,r1,#0x400
	str r1,vram_map+28
	b updateBGCHR_
;----------------------------------------------------------------------------
chr0123_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#12

	orr r1,r0,r0,lsl#8
	orr r1,r1,r1,lsl#16
	ldr r2,=0x03020100
	orr r2,r2,r1,lsl#2
	str r2,nes_chr_map

	ldr r1,vrombase
	add r1,r1,r0,lsl#12
	str r1,vram_map
	add r1,r1,#0x400
	str r1,vram_map+4
	add r1,r1,#0x400
	str r1,vram_map+8
	add r1,r1,#0x400
	str r1,vram_map+12
	b updateBGCHR_
;----------------------------------------------------------------------------
chr01234567_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#13

	orr r1,r0,r0,lsl#8
	orr r1,r1,r1,lsl#16
	ldr r2,=0x03020100
	orr r2,r2,r1,lsl#3
	str r2,nes_chr_map
	ldr r2,=0x07060504
	orr r2,r2,r1,lsl#3
	str r2,nes_chr_map+4

	ldr r1,vrombase
	add r1,r1,r0,lsl#13
	str r1,vram_map
	add r1,r1,#0x400
	str r1,vram_map+4
	add r1,r1,#0x400
	str r1,vram_map+8
	add r1,r1,#0x400
	str r1,vram_map+12
	add r1,r1,#0x400
	b _4567
;----------------------------------------------------------------------------
chr4567_
;----------------------------------------------------------------------------
	ldr r2,vrommask
	and r0,r0,r2,lsr#12

	orr r1,r0,r0,lsl#8
	orr r1,r1,r1,lsl#16
	ldr r2,=0x03020100
	orr r2,r2,r1,lsl#2
	str r2,nes_chr_map+4

	ldr r1,vrombase
	add r1,r1,r0,lsl#12
_4567	str r1,vram_map+16
	add r1,r1,#0x400
	str r1,vram_map+20
	add r1,r1,#0x400
	str r1,vram_map+24
	add r1,r1,#0x400
	str r1,vram_map+28
;- - - - - - - - ��BG CHR��Ҫ�ı䣬����BGxCNTBUFF- - - - - - - - - - - - - - - - - - - - - - - -
updateBGCHR_	;see if BG CHR needs to change, setup BGxCNTBUFF
;----------------------------------------------------------------------------
	ldrb r2,ppuctrl0
	tst r2,#0x10
	ldreq r0,nes_chr_map
	ldrne r0,nes_chr_map+4	;r0=new bg chr group

	adr r1,chrold
	swp r0,r0,[r1]

	ldr r1,chrline
	ldr r2,scanline
	cmp r2,#239
	movhi r2,#239
	sub r1,r2,r1
	cmp r1,#3		;if(scanline-lastline<3)
	movmi pc,lr		;	return
ubg2_			;now setup BG for last request: (chrfinish,mirror* jumps here)
	stmfd sp!,{r2-r7,lr}
	bl chr_req_
	ldmfd sp!,{r2-r6}

	ldrb r0,bg_recent
	ldr r1,BGmirror
	orr r0,r0,r1
	adr r7,chrline
	swp r1,r2,[r7]

	ldr r7,=BG0CNTBUFF
	add r1,r7,r1,lsl#1
	add r2,r7,r2,lsl#1
ubg1	strh r0,[r2],#-2	;fill backwards from scanline to lastline��ɨ����������lastline
	cmp r2,r1
	bpl ubg1

	ldmfd sp!,{r7,pc}

chrold	DCD 0 ;last write
chrline	DCD 0 ;when?
;----------------------------------------------------------------------------
chrfinish	;end of frame...  finish up BGxCNTBUFF
;----------------------------------------------------------------------------
	mov addy,lr

	ldr r0,chrold
	mov r2,#239
	bl ubg2_
	mov r0,#0
	str r0,chrline

 [ DEBUG
 ldr r0,agb_bg_map
	mov r1,#0
	bl debug_
 ldr r0,agb_bg_map+4
	mov r1,#1
	bl debug_
 ldr r0,agb_bg_map+8
	mov r1,#2
	bl debug_
 ldr r0,agb_bg_map+12
	mov r1,#3
	bl debug_
 ldr r0,bg_recent
	mov r1,#4
	bl debug_

 ldr r0,nes_chr_map
	mov r1,#5
	bl debug_
 ldr r0,nes_chr_map+4
	mov r1,#6
	bl debug_
 ]

	mov pc,addy
;----------------------------------------------------------------------------
resetBGCHR
;----------------------------------------------------------------------------
	mov r0,#0
	str r0,chrline

	ldrb r2,ppuctrl0
	tst r2,#0x10
	ldreq r0,nes_chr_map
	ldrne r0,nes_chr_map+4
	str r0,chrold

	mov pc,lr
;----------------------------------------------------------------------------
updateOBJCHR	;sprite CHR update (r3-r7 killed����)����CHR����
;----------------------------------------------------------------------------
	ldrb r2,ppuctrl0frame
	tst r2,#0x20	;8x16?
	beq uc3
	mov addy,lr
	bl uc1
	bl uc2
	mov pc,addy
uc3
	tst r2,#0x08	 ;8x8?
	bne uc2
uc1
	ldr r0,new_chr_map ;use old copyʹ�þɸ��� (OAM lags behind 2 framesOAM���2֡)
	ldr r1,old_chr_map ;use old copy           (OAM lags behind a frame)
	str r1,new_chr_map
	ldr r1,agb_obj_map
	eors r1,r1,r0
	moveq pc,lr
	str r0,agb_obj_map
	ldr r5,=AGB_VRAM+0x10000
	adrl r6,agb_obj_map
	b im_lazy
uc2
	ldr r0,new_chr_map+4
	ldr r1,old_chr_map+4
	str r1,new_chr_map+4
	ldr r1,agb_obj_map+4
	eors r1,r1,r0
	moveq pc,lr
	str r0,agb_obj_map+4
	ldr r5,=AGB_VRAM+0x12000
	adrl r6,agb_obj_map+4
	b im_lazy
;----------------------------------------------------------------------------
chr_req_		;request BG CHR group in r0
;		r0=chr group (4 1k CHR pages)
;----------------------------------------------------------------------------
	adrl r6,agb_bg_map

	mov r2,r6
	ldr r1,[r2]
	cmp r0,r1		;check for existing group
	ldrne r1,[r2,#4]!
	cmpne r0,r1
	ldrne r1,[r2,#4]!
	cmpne r0,r1
	ldrne r1,[r2,#4]!
	cmpne r0,r1
	beq cached	;(r2-agb_bg_map)=matching group#

	ldr r2,bg_recent		;move oldest group to front of the list
	mov r7,r2,lsr#24		;r7=oldest group#*4
	ldr r1,[r6,r7]			;r1=old group
	str r0,[r6,r7]!			;save new group, r6=new chr map ptr
	mov r2,r2,ror#24
	str r2,bg_recent
	eor r1,r1,r0

decodeptr	RN r2 ;mem_chr_decode
tilecount	RN r3
nesptr		RN r4 ;chr src
agbptr		RN r5 ;chr dst
bankptr		RN r6 ;vrom bank lookup ptr

	mov agbptr,#AGB_VRAM
	add agbptr,agbptr,r7,lsl#12	;0000/4000/8000/C000
im_lazy		;----------r1=old^new
	ldr decodeptr,=CHR_DECODE  ;����ָ��
bg0	 tst r1,#0xff
	 ldrb r0,[bankptr],#1
	 mov r1,r1,lsr#8
	 addeq agbptr,agbptr,#0x800
	 beq bg2
	 mov tilecount,#64
	 ldr nesptr,vrombase
	 add nesptr,nesptr,r0,lsl#10	;bank#*$400
 [ DEBUG
	ldr r0,misscount
	add r0,r0,#4
	str r0,misscount
 ]
bg1	  ldrb r0,[nesptr],#1
	  ldrb r7,[nesptr,#7]
	  ldr r0,[decodeptr,r0,lsl#2]
	  ldr r7,[decodeptr,r7,lsl#2]
	  orr r0,r0,r7,lsl#1
	  str r0,[agbptr],#4
	  tst agbptr,#0x1f
	  bne bg1
	 subs tilecount,tilecount,#1
	 add nesptr,nesptr,#8
	 bne bg1
bg2	tst bankptr,#3
	bne bg0
 [ DEBUG
	ldr r0,misscount
	mov r1,#18
	b debug_
misscount DCD 0
 |
	mov pc,lr
 ]
cached;--------------move to the top of the list:
	adrl r4,bg_recent
	sub r7,r2,r6	;r7=group#*4
	mov r2,r7	;r2=new xx_recent
	ldrb r0,[r4]
	cmp r7,r0
	orrne r2,r0,r2,ror#8
	ldrb r0,[r4,#1]
	cmp r7,r0
	orrne r2,r0,r2,ror#8
	ldrb r0,[r4,#2]
	cmp r7,r0
	orrne r2,r0,r2,ror#8
	ldrb r0,[r4,#3]
	cmp r7,r0
	orrne r2,r0,r2,ror#8
	mov r2,r2,ror#8
	str r2,[r4]
	mov pc,lr
;----------------------------------------------------------------------------
 [ BUILD = "DEBUG"
 AREA zzzzz, DATA, READWRITE ;MUST be last area

	DCB "0123456789abcdef0123456789abcde",0
	DCD 16400 ;romsize
	DCD 0 ;flags
	DCD 0 ;follow
	DCD 0 ;saveslot
	DCB "NES",0x1a

;	INCBIN ..\gbabin\roms\sndtest.nes

 ]
;----------------------------------------------------------------------------
 AREA wram_globals2, CODE, READWRITE

mapperstate
	% 32	;mapperdata
	% 8	;nes_chr_map	ROM��ҳӳ��NES VRAM $0000-1FFF
	% 8	;old_chr_map	(for updateOBJCHR) ���ڸ���OBJCHR
	% 8	;new_chr_map	(FluBBas fix)	FluBBas�޸�

	DCD 0,0,0,0	;agb_bg_map	VROM��ҳӳ�� AGB BG CHR
	DCD 0,0		;agb_obj_map	vrom paging map for AGB OBJ CHR
	DCB 0,0,0,0	;bg_recent	AGB BG CHR group#s ordered by most recently used
romstart
	DCD 0 ;rombase
romnum
	DCD 0 ;romnumber
rominfo                 ;keep emuflags/BGmirror together for savestate/loadstate
g_emuflags	DCB 0 ;emuflags        (label this so UI.C can take a peek) see equates.h for bitfields
g_scaling	DCB SCALED_SPRITES ;(display type)
	% 2   ;(sprite follow val)
	DCD 0 ;BGmirror		(BG size for BG0CNT)

	DCD 0 ;rommask
	DCD 0 ;vrombase
	DCD 0 ;vrommask
g_cartflags
	DCB 0 ;cartflags
g_hackflags
	DCB 0 ;hackflags
;----------------------------------------------------------------------------
	END
