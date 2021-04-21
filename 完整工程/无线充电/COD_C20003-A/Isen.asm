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
PUBLIC		PID_SenPriCoilCurrWay65Double
PUBLIC		PID_Isen65_SUBIsen
PUBLIC		PID_SenPriCoilCurrWay65
PUBLIC		PID_Isen65AvgTwo

EXTERN		Sensoring10_8					:	near
EXTERN		CLRMath						:	near
EXTERN		PreCarry					:	near
EXTERN		PostCarry					:	near
EXTERN		SignedMul_16Bit					:	near

EXTERN		a_ADRHbuffer					:	byte
EXTERN		a_ADRLbuffer			        	:	byte
EXTERN		a_data0						:	byte
EXTERN		a_data1				        	:	byte
EXTERN		a_data4						:	byte
EXTERN		a_data5				        	:	byte
EXTERN		a_to0						:	byte
EXTERN		a_to1				        	:	byte
EXTERN		a_to2                                   	:	byte
EXTERN		a_to3                                   	:	byte
EXTERN		a_to6                           		:	byte
EXTERN		a_to7                                   	:	byte
EXTERN		a_temp1                                 	:	byte
EXTERN		fg_IsenSmall					:	bit
EXTERN		fg_IsenBig					:	bit
EXTERN		fg_IsenFirst					:	bit
EXTERN		a_ExIP0x81_B1					:	byte
EXTERN		a_ExIP0x81_B2                   		:	byte
EXTERN		a_Carry						:	byte


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
Isen		.Section 	'code'
;========================================================
;Function 	: PID_SenPriCoilCurrWay65Double  ( 370 us)
;Note     	: Call Function Type for Sensor Primary Coil Current
;========================================================
PID_SenPriCoilCurrWay65Double:
			CALL	PID_SenPriCoilCurrWay65
			CALL	PID_SenPriCoilCurrWay65
			RET


;========================================================
;Function 	: PID_Isen65_SUBIsen  (  us)
;Note     	: Call Function Type for FOD Isen 
;input  	: 	
;output 	: 	
;parameter	: 	
;Setting	:
;========================================================
	PID_Isen65_SUBIsen:
			CALL	PreCarry
			MOV	A, a_ADRLbuffer				;New Isen_L	; Low Byte
			SUB	A, a_to6				;IsenSmallTh_L
			MOV	A, a_ADRHbuffer				;New Isen_H	; High Byte
			SBC	A, a_to7				;IsenSmallTh_H
			CALL	PostCarry
			RET

;========================================================
;Function 	: PID_SenPriCoilCurrWay65  ( 370 us)
;Note     	: Call Function Type for Sensor Primary Coil Current
;Description    : sensor 10 to access 8, then avg_ADC = sum_ADC /8 with
;		  checking PLL and precious avg_ADC 
;input  	: 	
;output 	: 	
;parameter	: 
;Setting	:
;========================================================
	PID_SenPriCoilCurrWay65:
			CLR 	WDT
			CALL	PID_Isen65AvgTwo
			SZ	fg_IsenFirst
			RET
			
			CLR	fg_IsenSmall
			CLR	fg_IsenBig
   
   	;;IsenSmall and IsenBig
  	PID_Isen65_IsenCheckSmall:
			MOV	A, c_IniIsenSmallTh_H			;IsenSmallTh_H
			MOV	a_to7, A                        	
			MOV	A, c_IniIsenSmallTh_L			;IsenSmallTh_L
			MOV	a_to6, A                        	
			CALL	PID_Isen65_SUBIsen              	
			SZ	a_Carry                         	
			JMP	PID_Isen65_IsenSmallfg			; < 
                                                                	
			JMP	PID_Isen65_IsenCheckBig			; >=
	PID_Isen65_IsenSmallfg:                                 	
			SET	fg_IsenSmall                    	
			JMP	PID_Isen65END                   	
	PID_Isen65_IsenCheckBig:                                	
			MOV	A, c_IniIsenBigTh_H			;IsenBigTh_H
			MOV	a_to7, A                        	
			MOV	A, c_IniIsenBigTh_L			;IsenBigTh_L
			MOV	a_to6, A                        	
			CALL	PID_Isen65_SUBIsen              	
			SZ	a_Carry                         	
			JMP	PID_Isen65END				; <
	PID_Isen65_IsenBigfg:
			SET	fg_IsenBig
	PID_Isen65END:
			CLR 	WDT
			RET	


;========================================================
;Function 	: PID_Isen65AvgTwo  (  us)
;Note     	: Call Function Type for Isen twice
;input  	: 	
;output 	: 	
;parameter	: 	
;Setting	:
;========================================================
	PID_Isen65AvgTwo:
			MOV	A, 009H					; set ADCR0 = 0000_0001 = 001h
			MOV	ADCR0, A				; ADCR0 @SPDM 2AH (POR=0110_0000, WDT Out=0110_0000)
			;; Output a_temp1(High Byte)+ a_to7(Low Byte)
			CALL	Sensoring10_8
			;;;~~~Save Pre ADC_H/L and Avg_ADC_H/L Convert to Now ADC_H/L~~~
			;;;~~~	Isen(A)=Isen(v)=(VsenADC/4096)*2.08v ~~~
			;;;~~~ => Isen(mA)=(VsenADC/4096)*2.08v*1000 (mA) ~~~
			;;;~~~ => Isen(mA)=VsenADC*130/256=VsenADC*82h/(2^8)~~~
			SZ	fg_IsenFirst
			JMP	PID_Isen65Isne2
			;JMP	PID_Isen65Isne1
	PID_Isen65Isne1:	
			SET	fg_IsenFirst
			;; Save Now Avg_ADC_H/L first
			MOV	A, a_temp1				;;Now Avg_ADC_H
			MOV	a_ExIP0x81_B2, A
			MOV	A, a_to7				;;Now Avg_ADC_L
			MOV	a_ExIP0x81_B1, A
			RET
	PID_Isen65Isne2:
			CLR	fg_IsenFirst
			MOV	A, a_ExIP0x81_B1			;Low Byte
			ADD	A, a_to7
			MOV	a_to7	, A  ;;Saving
			MOV	A, a_ExIP0x81_B2			;High Byte
			ADC	A, a_temp1
			MOV	a_temp1	, A  ;;Saving

			;; /256=/2^1
			CLR	c
			RRC	a_temp1
			RRC	a_to7
	
			;; Save Now Avg_ADC_H/L
			MOV	A, a_temp1				;;Now Avg_ADC_H
			MOV	a_ADRHbuffer, A
			MOV	A, a_to7				;;Now Avg_ADC_L
			MOV	a_ADRLbuffer, A
			
	;; Now Avg_ADC_H/L Isen(A) convert to Now ADC_H/L Isen(mA)
	PID_Isen65Conversion:
			;; ADC*82h
			CALL	CLRMath
			MOV	A, a_ADRHbuffer				;;Now Avg_ADC_H
			MOV	a_data1, A              		
			MOV	A, a_ADRLbuffer				;;Now Avg_ADC_L
			MOV	a_data0, A              		
			CLR	a_data5                 		
			MOV	A, 082h					;; 82h
			MOV	a_data4, A
			CALL	SignedMul_16Bit
			
			;; /256=/2^8 
			CLR		c
			RRC		a_to3
			RRC		a_to2
			RRC		a_to1
			RRC		a_to0
				
			CLR		c
			RRC		a_to3
			RRC		a_to2
			RRC		a_to1
			RRC		a_to0
        	
			CLR		c
			RRC		a_to3
			RRC		a_to2
			RRC		a_to1
			RRC		a_to0
        	
			CLR		c
			RRC		a_to3
			RRC		a_to2
			RRC		a_to1
			RRC		a_to0
        	
			CLR		c
			RRC		a_to3
			RRC		a_to2
			RRC		a_to1
			RRC		a_to0
        	
			CLR		c
			RRC		a_to3
			RRC		a_to2
			RRC		a_to1
			RRC		a_to0
        	
			CLR		c
			RRC		a_to3
			RRC		a_to2
			RRC		a_to1
			RRC		a_to0
        	
			CLR		c
			RRC		a_to3
			RRC		a_to2
			RRC		a_to1
			RRC		a_to0
        	
			MOV		A, a_to0
			MOV		a_ADRLbuffer, A			;Now Isen_L
			MOV		A, a_to1
			MOV		a_ADRHbuffer, A			;Now Isen_H
			RET



END