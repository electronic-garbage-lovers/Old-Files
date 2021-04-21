		GBLL DEBUG
		GBLL SAFETY

DEBUG		SETL {FALSE}

;BUILD		SETS "DEBUG"/"GBA"	(defined at cmdline)
;----------------------------------------------------------------------------

NES_RAM			EQU 0x3004800		;keep $400 byte aligned for 6502 stack shit
NES_SRAM		EQU NES_RAM+0x0800	;IMPORTANT!! NES_SRAM in GBA.H points here.  keep it current if you fuck with this
CHR_DECODE		EQU NES_SRAM+0x2000		 ;1024
OAM_BUFFER1		EQU CHR_DECODE+0x400	 ;512	;// RAM���飬��OAM��
OAM_BUFFER2		EQU OAM_BUFFER1+0x200	 ;512
OAM_BUFFER3		EQU OAM_BUFFER2+0x200	 ;512
YSCALE_EXTRA	EQU OAM_BUFFER3+0x200	 
YSCALE_LOOKUP	EQU YSCALE_EXTRA+0x50
PCMWAVSIZE		EQU 128
PCMWAV			EQU YSCALE_LOOKUP+0x100
;?				EQU PCMWAV+PCMWAVSIZE

NES_VRAM		EQU 0x2040000-0x3000	  ;12kb??
FREQTBL			EQU NES_VRAM-0x1000
MAPPED_RGB		EQU FREQTBL-64*3	;mapped NES palette (for VS unisys)
DISPCNTBUFF		EQU MAPPED_RGB-240*2	;480
DMA1BUFF		EQU DISPCNTBUFF-164*2
BG0CNTBUFF		EQU DMA1BUFF-240*2		;// |  $2000   |  $23BF   | Name �� #0  |��960 �ֽڣ�?
DMA3BUFF		EQU BG0CNTBUFF-164*2	;328
SCROLLBUFF1		EQU DMA3BUFF-240*4		;960
SCROLLBUFF2		EQU SCROLLBUFF1-240*4	 ;960
DMA0BUFF		EQU SCROLLBUFF2-164*4
END_OF_EXRAM	EQU DMA0BUFF-14200	;!How much data is left for Multiboot to work!

AGB_IRQVECT		EQU 0x3007FFC
AGB_PALETTE		EQU 0x5000000
AGB_VRAM		EQU 0x6000000
AGB_OAM			EQU 0x7000000
AGB_SRAM		EQU 0xE000000
AGB_BG			EQU AGB_VRAM+0xe000
DEBUGSCREEN		EQU AGB_VRAM+0x3800

REG_BASE		EQU 0x4000000
REG_DISPCNT		EQU 0x00
REG_DISPSTAT	EQU 0x04
REG_VCOUNT		EQU 0x06
REG_BG0CNT		EQU 0x08
REG_BG1CNT		EQU 0x0A
REG_BG2CNT		EQU 0x0C
REG_BG3CNT		EQU 0x0E
REG_BG0HOFS		EQU 0x10
REG_BG0VOFS		EQU 0x12
REG_BG1HOFS		EQU 0x14
REG_BG1VOFS		EQU 0x16
REG_BG2HOFS		EQU 0x18
REG_BG2VOFS		EQU 0x1A
REG_BG3HOFS		EQU 0x1C
REG_BG3VOFS		EQU 0x1E
REG_WIN0H		EQU 0x40
REG_WIN1H		EQU 0x42
REG_WIN0V		EQU 0x44
REG_WIN1V		EQU 0x46
REG_WININ		EQU 0x48
REG_WINOUT		EQU 0x4A
REG_BLDCNT		EQU 0x50
REG_BLDALPHA	EQU 0x52
REG_BLDY		EQU 0x54
REG_SG1CNT_L	EQU 0x60
REG_SG1CNT_H	EQU 0x62
REG_SG1CNT_X	EQU 0x64
REG_SG2CNT_L	EQU 0x68
REG_SG2CNT_H	EQU 0x6C
REG_SG3CNT_L	EQU 0x70
REG_SG3CNT_H	EQU 0x72
REG_SG3CNT_X	EQU 0x74
REG_SG4CNT_L	EQU 0x78
REG_SG4CNT_H	EQU 0x7c
REG_SGCNT_L		EQU 0x80
REG_SGCNT_H		EQU 0x82
REG_SGCNT_X		EQU 0x84
REG_SGBIAS		EQU 0x88
REG_SGWR0_L		EQU 0x90
REG_FIFO_A_L	EQU 0xA0
REG_FIFO_A_H	EQU 0xA2
REG_FIFO_B_L	EQU 0xA4
REG_FIFO_B_H	EQU 0xA6
REG_DM0SAD		EQU 0xB0
REG_DM0DAD		EQU 0xB4
REG_DM0CNT_L	EQU 0xB8
REG_DM0CNT_H	EQU 0xBA
REG_DM1SAD		EQU 0xBC
REG_DM1DAD		EQU 0xC0
REG_DM1CNT_L	EQU 0xC4
REG_DM1CNT_H	EQU 0xC6
REG_DM2SAD		EQU 0xC8
REG_DM2DAD		EQU 0xCC
REG_DM2CNT_L	EQU 0xD0
REG_DM2CNT_H	EQU 0xD2
REG_DM3SAD		EQU 0xD4
REG_DM3DAD		EQU 0xD8
REG_DM3CNT_L	EQU 0xDC
REG_DM3CNT_H	EQU 0xDE
REG_TM0D		EQU 0x100
REG_TM0CNT		EQU 0x102
REG_IE			EQU 0x200
REG_IF			EQU 0x4000202
REG_P1			EQU 0x4000130
REG_P1CNT		EQU 0x132
REG_WAITCNT		EQU 0x4000204

REG_SIOMULTI0	EQU 0x20 ;+100
REG_SIOMULTI1	EQU 0x22 ;+100
REG_SIOMULTI2	EQU 0x24 ;+100
REG_SIOMULTI3	EQU 0x26 ;+100
REG_SIOCNT		EQU 0x28 ;+100
REG_SIOMLT_SEND	EQU 0x2a ;+100
REG_RCNT		EQU 0x34 ;+100

		;r0,r1,r2=temp regs
m6502_nz	RN r3 ;bit 31=N, Z=1 if bits 0-7=0
m6502_rmem	RN r4 ;readmem_tbl
m6502_a		RN r5 ;bits 0-23=0, also used to clear bytes in memory
m6502_x		RN r6 ;bits 0-23=0
m6502_y		RN r7 ;bits 0-23=0
cycles		RN r8 ;also VDIC flags
m6502_pc	RN r9
globalptr	RN r10 ;=wram_globals* ptr
m6502_optbl	RN r10
cpu_zpage	RN r11 ;=CPU_RAM
addy		RN r12 ;keep this at r12 (scratch for APCS)
		;r13=SP
		;r14=LR
		;r15=PC
;----------------------------------------------------------------------------

 MAP 0,cpu_zpage
nes_ram # 0x800			 ;2048
nes_sram # 0x2000		 ;8192
chr_decode # 0x400		 ;1024
oam_buffer1 # 0x200		 ;512  //��ʾ������1  ???
oam_buffer2 # 0x200		 ;512
oam_buffer3 # 0x200		 ;512
yscale_extra # 0x50	;(240-160) extra 80 is for scrolling unscaled sprites//	�����80�ǹ������ŵľ���
yscale_lookup # 0x100	;sprite Y LUT

;everything in wram_globals* areas:

 MAP 0,globalptr	;6502.s
opz # 256*4
readmem_tbl # 8*4
writemem_tbl # 8*4
memmap_tbl # 8*4
cpuregs # 7*4
m6502_s # 4
lastbank # 4
nexttimeout # 4
scanline # 4		  ;// ɨ����
scanlinehook # 4
frame # 4
cyclesperscanline # 4
lastscanline # 4
			;ppu.s (wram_globals1)
fpsvalue # 4
AGBjoypad # 4
NESjoypad # 4
adjustblend # 4
windowtop # 16
vramaddr # 4
vramaddr2 # 4
scrollX # 4
scrollY # 4
sprite0y # 4	  ;//�����־����
readtemp # 4

sprite0x # 1
vramaddrinc # 1
ppustat # 1		   ;
toggle # 1		   ;//�л�
ppuctrl0 # 1
ppuctrl0frame # 1			;//frame���
ppuctrl1 # 1
ppuoamadr # 1
			;cart.s (wram_globals2)
mapperdata # 32
nes_chr_map # 8
old_chr_map # 8
new_chr_map # 8
agb_bg_map # 16
agb_obj_map # 8
bg_recent # 4

rombase # 4
romnumber # 4
emuflags # 4
BGmirror # 4

rommask # 4
vrombase # 4
vrommask # 4

cartflags # 1
hackflags # 1

 # 2 ;align
;----------------------------------------------------------------------------
IRQ_VECTOR		EQU 0xfffe ; IRQ/BRK interrupt vector address
RES_VECTOR		EQU 0xfffc ; RESET interrupt vector address
NMI_VECTOR		EQU 0xfffa ; NMI interrupt vector address
;-----------------------------------------------------------cartflags
MIRROR			EQU 0x01 ;horizontal mirroring
SRAM			EQU 0x02 ;save SRAM
TRAINER			EQU 0x04 ;trainer present
SCREEN4			EQU 0x08 ;4way screen layout
VS				EQU 0x10 ;VS unisystem
;-----------------------------------------------------------hackflags
NoHacks			EQU 0x00
BplHack			EQU 0x10
BneHack			EQU 0xD0
BeqHack			EQU 0xF0
;-----------------------------------------------------------emuflags
USEPPUHACK		EQU 1	;use $2002 hack
NOCPUHACK		EQU 2	;don't use JMP hack
PALTIMING		EQU 4	;0=NTSC 1=PAL
;?				EQU 8
;?				EQU 16
FOLLOWMEM		EQU 32  ;0=follow sprite, 1=follow mem
;?				EQU 64
;?				EQU 128

				;bits 8-15=scale type

UNSCALED_NOAUTO	EQU 0	;display types
UNSCALED_AUTO	EQU 1
SCALED			EQU 2
SCALED_SPRITES	EQU 3

				;bits 16-31=sprite follow val

;----------------------------------------------------------------------------
CYC_SHIFT		EQU 8
CYCLE			EQU 1<<CYC_SHIFT ;one cycle (341*CYCLE cycles per scanline)

;cycle flags- (stored in cycles reg for speed)

CYC_C			EQU 0x01	;Carry bit
BRANCH			EQU 0x02	;branch instruction encountered
CYC_I			EQU 0x04	;IRQ mask
CYC_D			EQU 0x08	;Decimal bit
CYC_V			EQU 0x40	;Overflow bit
CYC_MASK		EQU CYCLE-1	;Mask
;----------------------------------------------------------------------------
YSTART			EQU 16 ;scaled NES screen starts on this line

		END
