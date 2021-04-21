;*******************************************************************************************
;*****	                               History	                                       *****
;*******************************************************************************************
;V1.0 - WPC Qi Certification Source Code by Edward in HOLTEK Semiconductor Inc. on 2014/12/25



;*******************************************************************************************
;*****	                           Including File	                               *****
;*******************************************************************************************
#INCLUDE 	HT66FW2230.inc
#INCLUDE	TxUserDEF2230v302.inc


;*******************************************************************************************
;*****	                        Function / Parameter Claim	                       *****
;*******************************************************************************************
PUBLIC			PT_PIDandPWM
PUBLIC			ReSetPLL205
PUBLIC			DTdecPWinc			
PUBLIC			DTincPWdec
PUBLIC			PLLCompare


EXTERN			CLRMath					:	near
EXTERN			SignedSub_8Bit				:	near
EXTERN			SignedAdd_16Bit				:	near
EXTERN			SignedMul_16Bit				:	near
EXTERN			SignedSub_24Bit				:	near
EXTERN			SignedAdd_24Bit				:	near
EXTERN			SignedMul_24Bit				:	near
EXTERN			SignedDiv_24Bit				:	near
EXTERN			PreCarry				:	near
EXTERN			PostCarry				:	near
EXTERN			PID_SenPriCoilCurrWay65Double		:	near
EXTERN			DetectVin				:	near
EXTERN			PT_SvParaSelect				:	near


EXTERN			a_ParPLLFH				:	byte
EXTERN			a_ParPLLFL				:	byte
EXTERN			a_StatusCntInt1				:	byte
EXTERN			a_ADRHbuffer				:	byte
EXTERN			a_ADRLbuffer			        :	byte
EXTERN			a_data0					:	byte
EXTERN			a_data1				        :	byte
EXTERN			a_data2					:	byte
EXTERN			a_data4					:	byte
EXTERN			a_data5				        :	byte
EXTERN			a_data6					:	byte
EXTERN			a_to0					:	byte
EXTERN			a_to1				        :	byte
EXTERN			a_to2                                   :	byte
EXTERN			a_to3                                   :	byte
EXTERN			a_to4                           	:	byte
EXTERN			a_to5                           	:	byte
EXTERN			a_to6                           	:	byte
EXTERN			a_to7                                   :	byte
EXTERN			a_temp2                         	:	byte
EXTERN			a_temp1                                 :	byte
EXTERN			a_temp0                                 :	byte
EXTERN			fg_start				:	bit
EXTERN			fg_IterationStart			:	bit
EXTERN			a_IL              	   		:	byte
EXTERN			a_IM0                 		        :	byte
EXTERN			a_IM1                 		        :	byte
EXTERN			a_VL				        :	byte
EXTERN			a_VM0				        :	byte
EXTERN			a_VM1				        :	byte
EXTERN			a_EL				        :	byte
EXTERN			a_EM				        :	byte
EXTERN			a_EH				        :	byte
EXTERN			a_Sv				        :	byte
EXTERN			a_LoopIteration				:	byte
EXTERN		    	fg_RXCoilD				:	bit
EXTERN		    	fg_IsenSmall				:	bit
EXTERN		    	fg_IsenBig				:	bit
EXTERN		    	fg_CEThr				:	bit
EXTERN		    	fg_CEThrPana				:	bit
EXTERN			fg_VinLow				:	bit
EXTERN			fg_PLL205				:	bit
EXTERN			fg_DTCPR				:	bit
EXTERN			fg_DTCPRmin			        :	bit
EXTERN			fg_PLLThr				:	bit
EXTERN			a_PCHO0x06_B0				:	byte
EXTERN			a_ExIP0x81_B4                   	:	byte
EXTERN			a_ExIP0x81_B5                   	:	byte
EXTERN			a_ExIP0x81_B6                   	:	byte
EXTERN			a_ExIP0x81_B7                           :	byte
EXTERN			a_0x03ContlErr			        :	byte
EXTERN			a_StatusEndPower			:	byte
EXTERN			a_OptConfiCNT			        :	byte
EXTERN			a_ParPLLFHpre				:	byte
EXTERN			a_ParPLLFLpre			        :	byte
EXTERN		    	a_Carry					:	byte

;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
PID		.Section 	'code'
;========================================================
;Function : PT_PIDandPWM
;Note     : Call Function Type for PID and PWM Control
;		input = (1) a_0x03ContlErr

;		output = (1) 
;			 (2) a_CEP0x03_B0
;			 (3) a_RPP0x04_B0
;			 (4) a_CSP0x05_B0
;		Paramenter = 	a_ExIP0x81_B7 (Record)
;========================================================
	PT_PIDandPWM:
			CLR WDT
			CLR	a_StatusCntInt1				;;a_r_Kp10_8_6_4

	;~~~80hTd(j) = [80h + CE(j)]*Ta(j-1)~~~
	PT_PIDCalculation0:
			CLR	a_temp2
			CLR	a_temp1
			CLR	a_temp0
			CALL	CLRMath
			MOV	A, a_0x03ContlErr
			MOV	a_data0, A
			MOV	A, 000H
			MOV	a_data4, A
			CALL	SignedSub_8Bit				; ~~~ CE from 8bit to 16bit ~~~(16us) 
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A
			
			;~~~~[80h+CE(j)]   (20us)~~~~
			CALL	CLRMath
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 000H
			MOV	a_data5, A
			MOV	A, 080H
			MOV	a_data4, A
			CALL	SignedAdd_16Bit
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A
			CALL	CLRMath
			SZ	fg_start
			JMP	PT_PIDCalc1
			
			;JMP	PT_PIDCalc0
	PT_PIDCalc0:
			MOV	A, a_ADRHbuffer 			;;Ta(0) =Ta(1)	;ADRH
			MOV	a_data1, A
			MOV	A, a_ADRLbuffer
			MOV	a_data0, A
			JMP	PT_PIDCalcEnd
	PT_PIDCalc1:
			MOV	A, a_ExIP0x81_B7 			;;Ta(j-1) 	;ADRH
			MOV	a_data1, A
			MOV	A, a_ExIP0x81_B6					;ADRL
			MOV	a_data0, A
	PT_PIDCalcEnd:
			MOV	A, a_temp1				; ~~~ [80h+CE(j)] ~~~
			MOV	a_data5, A
			MOV	A, a_temp0
			MOV	a_data4, A
			CALL	SignedMul_16Bit				;; ~~~ Target 80hTd(j) = Ta(j-1)*[80h + CE(j)] ~~~(66us)
			MOV	A, a_to2
			MOV	a_PCHO0x06_B0, A			; a_PCHO0x06_B0 = 80hTd(j) high byte
			MOV	A, a_to1
			MOV	a_StatusEndPower, A			; a_StatusEndPower = 80hTd(j) Middle byte
			MOV	A, a_to0
			MOV	a_OptConfiCNT, A			; a_OptConfiCNT = 80hTd(j) Low byte
			SNZ	fg_CEThrPana
			JMP	PT_PIDCalcEnd1
	
			SNZ	fg_PLLThr
			JMP	PT_PIDCalcEnd1
	     		
	     		MOV		A, 000H				;;200mA=0C8h, 150mA=096h, 110mA=06Eh, 250mA=0FAh
			MOV	a_to7, A
			MOV	A, 0C8H
			MOV	a_to6, A
			SZ	a_0x03ContlErr.7
			JMP	PT_PIDCalcN
			
			;JMP	PT_PIDCalcP
	PT_PIDCalcP:
			MOV	A, a_ExIP0x81_B6			;; Low Byte
			ADD	A, a_to6
			MOV	a_data0, A  				;;Saving
			MOV	A, a_ExIP0x81_B7			;; High Byte
			ADC	A, a_to7
			MOV	a_data1, A  				;;Saving
			JMP	PT_PIDCalcPN
	PT_PIDCalcN:				
			MOV	A, a_ExIP0x81_B6			;; Low Byte
			SUB	A, a_to6
			MOV	a_data0, A  				;;Saving
			MOV	A, a_ExIP0x81_B7			;; High Byte
			SBC	A, a_to7
			MOV	a_data1, A  				;;Saving
	PT_PIDCalcPN:
			MOV	A, 000H					; ~~~ [80h] ~~~
			MOV	a_data5, A
			MOV	A, 080H
			MOV	a_data4, A
			CALL	SignedMul_16Bit				;; ~~~ Target 80hTd(j) = Ta(j-1)*[80h] ~~~(66us)
			CALL	PreCarry
			MOV	A, a_OptConfiCNT			;; Low Byte
			SUB	A, a_to0
			MOV	A, a_StatusEndPower			;; Mid Byte
			SBC	A, a_to1
			MOV	A, a_PCHO0x06_B0			;; High Byte
			SBC	A, a_to2
			CALL	PostCarry
			SZ	a_0x03ContlErr.7
			JMP	PT_PIDCalcNN
			
			JMP	PT_PIDCalcPP
	PT_PIDCalcPP:
			SZ	a_Carry
			JMP	PT_PIDCalcEnd1				; < 
			
			JMP	PT_PIDCalcEndMax			; >=
	PT_PIDCalcNN:
			SZ	a_Carry
			JMP	PT_PIDCalcEndMax			; < 
			
			JMP	PT_PIDCalcEnd1				; >=
	PT_PIDCalcEndMax:
			MOV	A, a_to2
			MOV	a_PCHO0x06_B0, A			; a_PCHO0x06_B0 = 80hTd(j) high byte
			MOV	A, a_to1
			MOV	a_StatusEndPower, A			; a_StatusEndPower = 80hTd(j) Middle byte
			MOV	A, a_to0
			MOV	a_OptConfiCNT, A			; a_OptConfiCNT = 80hTd(j) Low byte
			;JMP	PT_PIDCalcEnd1
	PT_PIDCalcEnd1:
			CALL	PT_SvParaSelect
			MOV	A, a_ADRHbuffer 			;;;~~~ to as Ta(j-1)~~~
			MOV	a_ExIP0x81_B7,A				;ADRH
			MOV	A, a_ADRLbuffer
			MOV	a_ExIP0x81_B6,A				;ADRL
	
	
	PT_PIDInteration:
			;--80hE(j,i) = [80hTd(j) - 80hTa(j,i-1)] -----
			SNZ	fg_IterationStart
			JMP	PT_PIDInteration1	
			
			CALL	PID_SenPriCoilCurrWay65Double
			CALL	PT_SvParaSelect
	PT_PIDInteration1:
			CALL	CLRMath
			SZ	fg_IterationStart
			JMP	PT_PIDIter1
			;JMP	PT_PIDIter0
	PT_PIDIter0:
			MOV	A, a_ADRHbuffer 			;;Ta(j,0)=Ta(j) ;ADRH
			MOV	a_data1, A
			MOV	A, a_ADRLbuffer				;;ADRL
			MOV	a_data0, A
			JMP	PT_PIDIterEnd
	PT_PIDIter1:	
			MOV	A, a_ExIP0x81_B5 			;;Ta(j,i-1) ;ADRH
			MOV	a_data1, A
			MOV	A, a_ExIP0x81_B4			;;ADRL
			MOV	a_data0, A
			;JMP	PT_PIDIterEnd
	PT_PIDIterEnd:
			MOV	A, 000H
			MOV	a_data5, A
			MOV	A, 080H
			MOV	a_data4, A
			CALL	SignedMul_16Bit				; ~~~ 80h*Ta(j,i-1) ~~~(66us) =>850us
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A
			MOV	A, a_ADRHbuffer
			MOV	a_ExIP0x81_B5, A
			MOV	A, a_ADRLbuffer
			MOV	a_ExIP0x81_B4, A
			CALL	CLRMath
			MOV	A, a_PCHO0x06_B0			; ~~~ 80hTd(j) ~~~~
			MOV	a_data2, A
			MOV	A, a_StatusEndPower
			MOV	a_data1, A
			MOV	A, a_OptConfiCNT
			MOV	a_data0, A
			MOV	A, a_temp2				; ~~~ 80h*Ta(j,i-1) ~~~
			MOV	a_data6, A
			MOV	A, a_temp1
			MOV	a_data5, A
			MOV	A, a_temp0
			MOV	a_data4, A
			CALL	SignedSub_24Bit				; ~~~80hE(j,i) = [80hTd(j) - 80h*Ta(j,i-1)] ~~~(20us)
			MOV	A, a_to2
			MOV	a_EH, A
			MOV	A, a_to1
			MOV	a_EM, A
			MOV	A, a_to0
			MOV	a_EL, A

			;-------80hI(j,i) = 80hI(j,i-1) + [Ki(0.05)*80hE(j,i)*Tinner] 
			;-------80hI(j,i) = 80hI(j,i-1) + [80hE(j,i)*Tinner]/14h
			;------------  -384000(FA2400h) <= 80hI(j,i) <= +384000(05DC00h)  ---------
			;------------  -3000 <= I(j,i) <= +3000  ---------
			CALL	CLRMath
			MOV	A, a_EH					;~~~ 80hE(j,i)~~~
			MOV	a_data2, A
			MOV	A, a_EM
			MOV	a_data1, A
			MOV	A, a_EL
			MOV	a_data0, A
			MOV	A, 000H					;~~~ Tinner = 2ms~~~
			MOV	a_data6, A				;~~~ Tinner = 3ms~~~
			MOV	A, 000H
			MOV	a_data5, A
			;MOV	A, 002H
			MOV	A, 003H
			MOV	a_data4, A
			CALL	SignedMul_24Bit				;~~~ [80hE(j,i)*Tinner] ~~~(78us)
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A

			CALL	CLRMath
			MOV	A, a_temp2				; ~~~[80hE(j,i)*Tinner] ~~~
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 000H					; ~~~ /14h~~~
			MOV	a_data6, A
			MOV	A, 000H
			MOV	a_data5, A
			MOV	A, 014h
			MOV	a_data4, A
			CALL	SignedDiv_24Bit				; ~~~~[80hE(j,i)*Tinner]/14h~~~(20us)
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A

			CALL	CLRMath
			SZ	fg_IterationStart
			JMP	PT_PIDIter1I
			;JMP	PT_PIDIter0I
	PT_PIDIter0I:
			MOV	A, 000H					;;80hI(j,0)=0
			MOV	a_data2, A
			MOV	A, 000H
			MOV	a_data1, A
			MOV	A, 000H
			MOV	a_data0, A
			JMP	PT_PIDIterEndI
	PT_PIDIter1I:	
			MOV	A, a_IM1 				;;80hI(j,i-1)
			MOV	a_data2, A
			MOV	A, a_IM0
			MOV	a_data1, A
			MOV	A, a_IL
			MOV	a_data0, A
			;JMP	PT_PIDIterEndI
	PT_PIDIterEndI:
			MOV	A, a_temp2
			MOV	a_data6, A
			MOV	A, a_temp1
			MOV	a_data5, A
			MOV	A, a_temp0
			MOV	a_data4, A
			CALL	SignedAdd_24Bit				;;80hI(j,i) = 80hI(j,i-1) + [80hE(j,i)*Tinner]/14h~~~
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A

			; 80hI(j,i) <= +384000 = 05DC00h; x - 05DC00h >= 0, 80hI(j,i)=Max=05DC00h; x - 05DC00h < 0 to Check
			; I <= +3000 = BB8h; x - BB8h >= 0, I=Max=BB8h; x - BB8h < 0 to Check
			CALL	CLRMath
			MOV	A, a_temp2
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 005H
			MOV	a_data6, A
			MOV	A, 0DCH
			MOV	a_data5, A
			MOV	A, 000H
			MOV	a_data4, A
			CALL	SignedSub_24Bit
			SNZ	a_to3.7
			JMP	PT_PIDC_IiniPlusMax

			; FA2400h = -384000 <= 80hI(j,i); x - FA2400h >= 0, 80hI(j,i)=I_ini ; x - FA2400h < 0, 80hI(j,i)=Min=FA2400h 
			; F448h = -3000 <= I; x - F448h >= 0, I=I_ini ; x - F448h < 0, I=Min=F448h 
			CALL	CLRMath
			MOV	A, a_temp2
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 0FAH
			MOV	a_data6, A
			MOV	A, 024H
			MOV	a_data5, A
			MOV	A, 000H
			MOV	a_data4, A
			CALL	SignedSub_24Bit
			SNZ	a_to3.7
			JMP	PT_PIDC_I_Cal
			JMP	PT_PIDC_IiniMinusMin
			
	; x - 05DC00h >= 0, 80hI(j,i)=Max=05DC00h
	; x - BB8h >= 0, I=Max=BB8h
	PT_PIDC_IiniPlusMax:					
			MOV	A, 005H
			MOV	a_IM1, A
			MOV	A, 0DCH
			MOV	a_IM0, A
			MOV	A, 000H
			MOV	a_IL, A
			JMP	PT_PIDC_Iend
	
	; x - FA2400h < 0, 80hI(j,i)=Min=FA2400h 
	; x - F448h < 0, I=Min=F448h
	PT_PIDC_IiniMinusMin:					
			MOV	A, 0FAH
			MOV	a_IM1, A
			MOV	A, 024H
			MOV	a_IM0, A
			MOV	A, 000H
			MOV	a_IL, A
			JMP	PT_PIDC_Iend
	PT_PIDC_I_Cal:
			MOV	A, a_temp2
			MOV	a_IM1, A
			MOV	A, a_temp1
			MOV	a_IM0, A
			MOV	A, a_temp0
			MOV	a_IL, A
			;JMP	PT_PIDC_Iend

	;-----------------------------
	;--80hP(j,i)=Kp*80hE(j,i)----
	;-----------------------------
	PT_PIDC_Iend:
			CALL	CLRMath
			MOV	A, a_EH
			MOV	a_data2, A
			MOV	A, a_EM
			MOV	a_data1, A
			MOV	A, a_EL
			MOV	a_data0, A
			MOV	A, 000H
			MOV	a_data6, A
			MOV	A, 000H
			MOV	a_data5, A
	PT_PIDC_IendKp4:
			SNZ	a_StatusCntInt1.0
			JMP	PT_PIDC_IendKp6
			MOV	A, 003H
			JMP	PT_PIDC_IendKp
	PT_PIDC_IendKp6:
			SNZ	a_StatusCntInt1.1
			JMP	PT_PIDC_IendKp8
			MOV	A, 006H
			JMP	PT_PIDC_IendKp
	PT_PIDC_IendKp8:
			SNZ	a_StatusCntInt1.2
			JMP	PT_PIDC_IendKp10
			MOV	A, 008H
			JMP	PT_PIDC_IendKp		
	PT_PIDC_IendKp10:
			MOV	A, 00AH
	PT_PIDC_IendKp:
			MOV	a_data4, A
			CALL	SignedMul_24Bit				;~~~ Kp*80hE(j,i) ~~~(78us)
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A
                	
			
			;--80hPID(j,i)=80hP(j,i)+80hI(j,i)------
			;--PID(j,i)= [80hP(j,i)+80hI(j,i)] / 80h------
			;----------   -20000(FFB1E0h) <= PID <= +20000(004E20h)
			;~~~ [80hP(j,i)+80hI(j,i)] ~~~(17us)
			CALL	CLRMath
			MOV	A, a_temp2				;~~~ 80hP(j,i) ~~~
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, a_IM1				;~~~ 80hI(j,i) ~~~
			MOV	a_data6, A
			MOV	A, a_IM0
			MOV	a_data5, A
			MOV	A, a_IL
			MOV	a_data4, A
			CALL	SignedAdd_24Bit
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A

			; ~~~~PID(j,i)= [80hP(j,i)+80hI(j,i)] / 80h~~~
			CALL	CLRMath
			MOV	A, a_temp2				; ~~~ [80hP(j,i)+80hI(j,i)] ~~~
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 000H					; ~~~ /80h~~~
			MOV	a_data6, A
			MOV	A, 000H
			MOV	a_data5, A
			MOV	A, 080h
			MOV	a_data4, A
			CALL	SignedDiv_24Bit					
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A

			; PID <= +20000 = 4E20h; x - 004E20h >= 0, PID=Max=4E20h ; x - 4E20h < 0 to Check
			CALL	CLRMath
			MOV	A, a_temp2
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 000H
			MOV	a_data6, A
			MOV	A, 04EH
			MOV	a_data5, A
			MOV	A, 020H
			MOV	a_data4, A
			CALL	SignedSub_24Bit
			SNZ	a_to3.7
			JMP	PT_PIDC_PIDiniPlusMax
			
			; FFB1E0h = -20000 <= PID; x - FFB1E0h >= 0, PID=x ; x - FFB1E0h < 0, PID=Min=FFB1E0h 
			CALL	CLRMath
			MOV	A, a_temp2
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 0FFH
			MOV	a_data6, A
			MOV	A, 0B1H
			MOV	a_data5, A
			MOV	A, 0E0H
			MOV	a_data4, A
			CALL	SignedSub_24Bit			
			SNZ	a_to3.7
			JMP	PT_PIDC_PIDend
			JMP	PT_PIDC_PIDiniMinusMin
		
	PT_PIDC_PIDiniPlusMax:
			MOV	A, 000H					; x - 004E20h >= 0, PID=Max=4E20h
			MOV	a_temp2, A
			MOV	A, 04EH
			MOV	a_temp1, A
			MOV	A, 020H
			MOV	a_temp0, A
			JMP	PT_PIDC_PIDend
               	
	PT_PIDC_PIDiniMinusMin:
			MOV	A, 0FFH					; x - FFB1E0h < 0, PID=Min=FFB1E0h 
			MOV	a_temp2, A
			MOV	A, 0B1H
			MOV	a_temp1, A
			MOV	A, 0E0H
			MOV	a_temp0, A
			;JMP	PT_PIDC_PIDend

			;--V(j,i)=[V(j,i-1)-[Sv*PID(j,i)]]-------
	PT_PIDC_PIDend:
			CALL	CLRMath
			MOV	A, a_temp2				; ~~~PID(j,i) ~~~
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 000H					; ~~~ [Sv]~~~
			MOV	a_data6, A
			MOV	A, 000H
			MOV	a_data5, A
			MOV	A, a_Sv
			MOV	a_data4, A
			CALL	SignedMul_24Bit				; ~~~~[Sv*PID(j,i)]~~~(78us)
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A

			CALL	CLRMath
			MOV	A, a_temp2				; ~~~[AhSv*PID(j,i)] ~~~
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 000H					; ~~~ /Ah~~~
			MOV	a_data6, A
			MOV	A, 000H
			MOV	a_data5, A
			MOV	A, 00Ah
			MOV	a_data4, A
			CALL	SignedDiv_24Bit				; ~~~~[AhSv*PID(j,i)]/Ah~~~(20us)
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A

			CALL	CLRMath
			SZ	fg_start
			JMP	PT_PIDIter1V
			
			SZ	fg_IterationStart
			JMP	PT_PIDIter1V
			;JMP	PT_PIDIter0V

	PT_PIDIter0V:
			SZ	fg_RXCoilD
			JMP	  PT_PIDIter0V1
			;JMP  PT_PIDIter0V0
	PT_PIDIter0V0:
			;MOV	A, 002H					;~~~ V(0,0) PLL=2EEh, 175kHz=2AB98h
			;MOV	a_data2, A
			;MOV	A, 0ABH
			;MOV	a_data1, A
			;MOV	A, 098H
			;MOV	a_data0, A
			
			;MOV	A, 002H					;~~~ V(0,0) PLL=316h, 179kHz=2BB38h
			;MOV	a_data2, A
			;MOV	A, 0BBH
			;MOV	a_data1, A
			;MOV	A, 038H
			;MOV	a_data0, A

			MOV	A, 002H					;~~~ V(0,0) PLL=2D0h, 172kHz=29FE0h
			MOV	a_data2, A
			MOV	A, 09FH
			MOV	a_data1, A
			MOV	A, 0E0H
			MOV	a_data0, A
		
			;SET	fg_restart
			JMP	PT_PIDIter0Vend
	PT_PIDIter0V1:
			;MOV	A, 002H					;~~~ V(0,0) PLL=2CBh, 171.5kHz=29DECh
			;MOV	a_data2, A
			;MOV	A, 09DH
			;MOV	a_data1, A
			;MOV	A, 0ECH
			;MOV	a_data0, A

			;MOV	A, 002H					;~~~ V(0,0) PLL=2EEh, 175kHz=2AB98h
			;MOV	a_data2, A
			;MOV	A, 0ABH
			;MOV	a_data1, A
			;MOV	A, 098H
			;MOV	a_data0, A

			MOV	A, 002H					;~~~ V(0,0) PLL=2D0h, 172kHz=29FE0h
			MOV	a_data2, A
			MOV	A, 09FH
			MOV	a_data1, A
			MOV	A, 0E0H
			MOV	a_data0, A
			;JMP	PT_PIDIter0Vend
	PT_PIDIter0Vend:
			JMP	PT_PIDIterEndV
	PT_PIDIter1V:
			;SET	fg_RestartCE00	
			MOV	A, a_VM1				;~~~V(j,i-1)
			MOV	a_data2, A
			MOV	A, a_VM0
			MOV	a_data1, A
			MOV	A, a_VL
			MOV	a_data0, A
			;JMP	PT_PIDIterEndV
	PT_PIDIterEndV:
			MOV	A, a_temp2				; ~~~~[Sv*PID(j,i)]~~~(20us)
			MOV	a_data6, A
			MOV	A, a_temp1
			MOV	a_data5, A
			MOV	A, a_temp0
			MOV	a_data4, A
			CALL	SignedSub_24Bit				;~~~ V(j,i)=V(j,i-1)-[Sv*PID(j,i)] ~~~(22us)
			MOV	A, a_to2
			MOV	a_VM1, A
			MOV	A, a_to1
			MOV	a_VM0, A
			MOV	A, a_to0
			MOV	a_VL, A

	PT_PIDVconverPWM:
			;CLR WDT
			CALL	CLRMath
			MOV	A, a_VM1
			MOV	a_data2, A
			MOV	A, a_VM0
			MOV	a_data1, A
			MOV	A, a_VL
			MOV	a_data0, A
			MOV	A, 001H
			MOV	a_data6, A
			MOV	A, 086H
			MOV	a_data5, A
			MOV	A, 0A0H
			MOV	a_data4, A
			CALL	SignedSub_24Bit
			MOV	A, a_to2
			MOV	a_temp2, A
			MOV	A, a_to1
			MOV	a_temp1, A
			MOV	A, a_to0
			MOV	a_temp0, A
			                        
			;CLR WDT
			CALL	CLRMath
			MOV	A, a_temp2
			MOV	a_data2, A
			MOV	A, a_temp1
			MOV	a_data1, A
			MOV	A, a_temp0
			MOV	a_data0, A
			MOV	A, 000H
			MOV	a_data6, A
			MOV	A, 000H
			MOV	a_data5, A
			MOV	A, 064H
			MOV	a_data4, A
			CALL	SignedDiv_24Bit
			MOV	A, a_to1
			MOV	a_ParPLLFH, A
			MOV	A, a_to0
			MOV	a_ParPLLFL, A

	PT_PLLProtect:
			MOV	A, c_IniPLLFmaxH110
			MOV	a_to7, A
			MOV	A, c_IniPLLFmaxL110
			MOV	a_to6, A
			CALL	PLLCompare
			SZ	a_Carry
			JMP	PT_PLLProtectPLLHset			; < 

			JMP	PT_PLLProtectCheckL			; >=
	PT_PLLProtectPLLHset:	
			MOV	A, c_IniPLLFmaxH110
			MOV	a_ParPLLFH, A
			MOV	A, c_IniPLLFmaxL110
			MOV	a_ParPLLFL, A
			MOV	A, 001H					;;110kHz
			MOV	a_VM1, A
			MOV	A, 0ADH
			MOV	a_VM0, A
			MOV	A, 0B0H
			MOV	a_VL, A
			JMP	PPT_PLLSetting
			
	PT_PLLProtectCheckL:	
			MOV	A, c_IniPLLFminH205
			;MOV	A, c_IniPLLFminH220
			MOV	a_to7, A
			MOV	A, c_IniPLLFminL205
			;MOV	A, c_IniPLLFminL220
			MOV	a_to6, A
  			CALL	PLLCompare
			SZ	a_Carry
			JMP	PPT_PLLSettingOFF			; <

			;JMP	PT_PLLProtectPLLLset			; >=
	PT_PLLProtectPLLLset:
			;; Normal 205kHz
			SZ	fg_PLL205
			CALL	DTincPWdec
		
			CALL	ReSetPLL205
			SET	fg_PLL205
			JMP	PPT_PLLSetting
			
	PPT_PLLSettingOFF:
			SNZ	fg_PLL205
			JMP	PPT_PLLSetting	

			MOV	A, c_IniPLLFH162
			MOV	a_to7, A
			MOV	A, c_IniPLLFL162
			MOV	a_to6, A
			CALL	PLLCompare
			SZ	a_Carry
			JMP	PPT_PLLSettingOFF1			; < 200kHz, 198kHz...

			JMP	PPT_PLLSetting				; >= 200kHz, 201kHz...
	PPT_PLLSettingOFF1:
			CALL	DTdecPWinc
	PPT_PLLSetting:	
			MOV	A, a_ParPLLFL
			MOV	PLLFL, A
			MOV	A, a_ParPLLFH
			MOV	PLLFH, A
	PIDandPWMLoopIterCheck:
			SET	fg_IterationStart
			CALL	DetectVin
			SZ	fg_VinLow
			JMP	PT_PIDandPWMEnd
			
			SDZ	a_LoopIteration				; Loop time =1.76ms including AD10¦¸
			JMP	PT_PIDInteration
	PT_PIDandPWMEnd:
			MOV	A, a_ParPLLFL				;New PLL_L	; Low Byte
			XOR	A, a_ParPLLFLpre
			SNZ	STATUS.2
			JMP	PPT_PLLSetting0
			;MOV	, A   ;;Saving
			MOV	A, a_ParPLLFH				;New PLL_H	; High Byte
			XOR	A, a_ParPLLFHpre
			SNZ	STATUS.2
			JMP	PPT_PLLSetting0

			MOV	A, 000H
			MOV	a_to7, A
			;MOV	A, 001H
			MOV	A, 008H
			MOV	a_to6, A
			
			SZ	a_0x03ContlErr.7
			JMP	PLLINC
			;JMP	PLLDEC
	PLLDEC:
			MOV	A, a_ParPLLFL
			SUB	A, a_to6
			MOV	a_ParPLLFL, A
			MOV	A, a_ParPLLFH
			SBC	A, a_to7
			MOV	a_ParPLLFH, A
			MOV	A, 000H
			MOV	a_to7, A
			MOV	A, 003H
			MOV	a_to6, A
			MOV	A, 020H
			MOV	a_to5, A
			MOV	A, a_VL
			SUB	A, a_to5
			MOV	a_VL, A
			MOV	A, a_VM0
			SBC	A, a_to6
			MOV	a_VM0, A
			MOV	A, a_VM1
			SBC	A, a_to7
			MOV	a_VM1, A
			JMP	PPT_PLLSetting0
	PLLINC:
			MOV	A, a_ParPLLFL
			ADD	A, a_to6
			MOV	a_ParPLLFL, A
			MOV	A, a_ParPLLFH
			ADC	A, a_to7
			MOV	a_ParPLLFH, A
			MOV	A, 000H
			MOV	a_to7, A
			MOV	A, 003H
			MOV	a_to6, A
			MOV	A, 020H
			MOV	a_to5, A
			MOV	A, a_VL
			ADD	A, a_to5
			MOV	a_VL, A
			MOV	A, a_VM0
			ADC	A, a_to6
			MOV	a_VM0, A
			MOV	A, a_VM1
			ADC	A, a_to7
			MOV	a_VM1, A
	PPT_PLLSetting0:
			MOV	A, a_ParPLLFL
			MOV	PLLFL, A
			MOV	a_ParPLLFLpre, A			
			MOV	A, a_ParPLLFH
			MOV	PLLFH, A
			MOV	a_ParPLLFHpre, A
			SET	fg_start
			CLR	fg_IterationStart
 			;MOV	A, 00AH
 			MOV	A, 009H
			MOV	a_LoopIteration, A
			MOV	A, 005H
			MOV	a_PCHO0x06_B0, A
			SET	a_StatusEndPower
			CLR	a_OptConfiCNT
			RET


;========================================================
;Function : ReSetPLL205
;Note     : Call Function Type for 205kHz
;		input = 
;(1)
;		output = 
;(1)
;========================================================
	ReSetPLL205:
			MOV	A, c_IniPLLFminH205
			MOV	a_ParPLLFH, A
			MOV	A, c_IniPLLFminL205
			MOV	a_ParPLLFL, A
			MOV	A, 003H					;;205kHz
			MOV	a_VM1, A
			MOV	A, 020H
			MOV	a_VM0, A
			MOV	A, 0C8H
			MOV	a_VL, A
			RET


;========================================================
;Function : DTincPWdec
;Note     : Call Function Type for 205kHz
;input 	  : 
;output	  :  
;========================================================
	DTincPWdec:
			SZ	CPR
			JMP	DTi2
			;JMP	DTi1
	DTi1:	
			MOV	A, 050H
			MOV	PWMC, A
	DTi2:	
			MOV	A, CPR
			XOR	A, 007H					;;SC=00, DT=111
			SZ	STATUS.2
			JMP	DTiSet1
			
			MOV	A, CPR
			XOR	A, 00FH					;;SC=01, DT=111
			SZ	STATUS.2
			JMP	DTiSet2

			MOV	A, CPR
			XOR	A, 017H					;;SC=10, DT=111
			SZ	STATUS.2
			JMP	DTiSetEnd1				;;True => Zreo-bit=1

			JMP	DTiSetEnd
	DTiSet1:
			MOV	A, 00BH					;;SC=01, DT=011
			MOV 	CPR, A
			JMP	DTiSetEnd
	DTiSet2:		
			MOV	A, 013H					;;SC=10, DT=011
			MOV 	CPR, A
			;JMP	DTiSetEnd
	DTiSetEnd:		
			INC		CPR
	DTiSetEnd1:		
			MOV	A, 0A3H
			MOV	PWMC, A
			RET
			
			
;;;=============================================================
;						MOV	A, 050H
;						MOV	PWMC, A
;
;						SZ	fg_DTCPRmin
;						RET
;						
;						SZ	fg_DTCPR
;						JMP	DTincPWdecDTmin
;						;JMP		DTincPWdecDTde
;			DTincPWdecDTde:			
;						MOV	A, 001H			;;SC=00, DT=001
;						MOV CPR, A
;						SET	fg_DTCPR
;						JMP	DTincPWdecEND
;
;			DTincPWdecDTmin:			
;						MOV	A, 017H			;;SC=10, DT=111
;						MOV CPR, A
;						SET	fg_DTCPRmin
;						;JMP	DTincPWdecEND
;			DTincPWdecEND:
;						MOV	A, 0A3H
;						MOV	PWMC, A
;
;			RET


;;========================================================
;;Function : DTincPWdec1
;;Note     : Call Function Type for 205kHz
;;		input = 
;;(1)
;;		output = 
;;(1)
;;========================================================
	DTincPWdec1:
			MOV	A, 050H
			MOV	PWMC, A
			MOV	A, 017H					;;SC=10, DT=111
			MOV 	CPR, A
			MOV	A, 0A3H
			MOV	PWMC, A
			RET

;========================================================
;Function : DTdecPWinc
;Note     : Call Function Type for 205kHz
;input 	  :
;output	  : 
;========================================================
	DTdecPWinc:
			MOV	A, CPR
			XOR	A, 014H					;;SC=10, DT=100
			SZ	STATUS.2
			JMP	DTdSet1
			
			MOV	A, CPR
			XOR	A, 00CH					;;SC=01, DT=100
			SZ	STATUS.2
			JMP	DTdSet2
       
			SZ CPR						;;SC=00, DT=000
			JMP	DTdSetEnd
       
			CLR	fg_PLL205
			MOV	A, 0A0H
			MOV	PWMC, A
			CLR	fg_DTCPR
			CLR	fg_DTCPRmin
			MOV	A, 053H
			MOV	PWMC, A
			;JMP	DTdSetEnd1
			RET
	 			
	DTdSet1:
			MOV	A, 010H					;;SC=10, DT=000
			MOV 	CPR, A
			JMP	DTdSetEnd
	DTdSet2:		
			MOV	A, 008H					;;SC=01, DT=000
			MOV 	CPR, A
			;JMP	DTdSetEnd
	DTdSetEnd:		
			DEC	CPR
               
;			CLR	CPR
;			CLR	fg_PLL205
;			MOV	A, 0A0H
;			MOV	PWMC, A
			
;			MOV	A, 053H
;			MOV	PWMC, A
			
;			CALL	ReSetPLL205
			
			RET
					


;========================================================
;Function 	: PLLCompare  (  us)
;Note     	: Call Function Type for FOD Isen 
;input 		:  	
;output 	: 	
;parameter	:
;PreSetting	:
;========================================================
	PLLCompare:
			CALL	PreCarry
			MOV		A, a_ParPLLFL			;New PLL_L	; Low Byte
			SUB		A, a_to6
			MOV		A, a_ParPLLFH			;New PLL_H	; High Byte
			SBC		A, a_to7
			CALL	PostCarry
			RET


END