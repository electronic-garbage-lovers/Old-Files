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
PUBLIC		PT_DecodeCommand
PUBLIC		EndPowCMD0x02Decode
PUBLIC		ConErrCMD0x03Decode
PUBLIC		RecPowCMD0x04Decode
PUBLIC		PowContlHoldCMD0x06Decode
PUBLIC		ConfigCMD0x51Decode

EXTERN		FOD_TempertureSensor62				:	near
EXTERN		FOD_TempTime					:	near
EXTERN		PreCarry					:	near
EXTERN		PostCarry					:	near
EXTERN		FOD_ReceivePowCheck				:	near
EXTERN		FOD_SenPriCoilCurrWay65Double			:	near
EXTERN		FOD_FObjectDetect2				:	near

EXTERN		a_DataHeader					:	byte
EXTERN		a_DataMessageB0					:	byte
EXTERN		a_to7                                   	:	byte
EXTERN		a_temp1                                 	:	byte
EXTERN		fg_0x02PowDownChargeComplete    		:	bit
EXTERN		fg_0x02PowDownReconfigure       		:	bit
EXTERN		fg_0x02PowDownNoResponse        		:	bit
EXTERN		fg_EndPowDown					:	bit
EXTERN		fg_CEinput					:	bit
EXTERN		fg_0x04ReceiPowCNTHflag				:	bit
EXTERN		fg_PCH0x06Abnor					:	bit
EXTERN		fg_RPNoStable					:	bit
EXTERN		fg_VinLow					:	bit
EXTERN		fg_FODEfficLow					:	bit
EXTERN		fg_ReCordTemp					:	bit
EXTERN		fg_CalTempTimeHigh				:	bit
EXTERN		fg_PowOver5wLEDsw				:	bit
EXTERN          fg_RxTI						:	bit
EXTERN		a_CSP0x05_B0					:	byte
EXTERN		a_PCHO0x06_B0					:	byte
EXTERN		a_Config0x51_B0					:	byte
EXTERN		a_0x03ContlErr			        	:	byte
EXTERN		a_0x04ReceivedPow				:	byte
EXTERN		a_0x06TdelayML			        	:	byte
EXTERN		a_0x06TdelayMH					:	byte
EXTERN		a_StatusEndPower				:	byte
EXTERN		a_0x51PowMax					:	byte
EXTERN		a_0x04ReceiPowCNTH				:	byte
EXTERN		a_0x04ReceiPowCNTL		        	:	byte
EXTERN		a_Carry						:	byte
EXTERN		a_r_RPowCNT					:	byte
EXTERN		a_TempH						:	byte
EXTERN		a_TempL						:	byte


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
Decode		.Section 	'code'
;========================================================
;Function : PT_DecodeCommand
;Note     : Call Function Type for Decode Command 
;input 	  : (1) a_DataHeader
;	    (2) a_DataMessageB0
;output   : (1) fg_EndPowDown
;	    (2) a_CSP0x05_B0
;	    (3) fg_CEinput
;========================================================
	PT_DecodeCommand:
			SNZ	fg_VinLow
			JMP	PT_EPTP0x02
			
	PT_PowOver5wLEDstart:	
			SNZ	fg_PowOver5wLEDsw
			JMP	PT_PowOver5wLEDoff
			;JMP	PT_PowOver5wLEDon
	PT_PowOver5wLEDon:
			SET	PB.3					;;Red LED
			CLR	fg_PowOver5wLEDsw
			JMP	PT_EPTP0x02
	PT_PowOver5wLEDoff:	
			CLR	PB.3					;;Red LED
			SET	fg_PowOver5wLEDsw
			;JMP	PT_EPTP0x02
	PT_EPTP0x02:
			SNZ	fg_VinLow
			SET	PB.3					;;Red LED

			MOV	A, a_DataHeader
			XOR	A, 002H
			SNZ	STATUS.2
			JMP	PT_CEP0x03
		
			CALL	EndPowCMD0x02Decode
			CLR	fg_CEinput
			JMP	PT_DeComEnd
	PT_CEP0x03:
			MOV	A, a_DataHeader
			XOR	A, 003H
			SNZ	STATUS.2
			JMP	PT_RPP0x04
		
			CALL	ConErrCMD0x03Decode
			SET	fg_CEinput
			JMP	PT_DeComEnd
	PT_RPP0x04:
			MOV	A, a_DataHeader
			XOR	A, 004H
			SNZ	STATUS.2
			JMP	PT_CSP0x05
		
			CLR	fg_CEinput
			CALL	RecPowCMD0x04Decode
			;;;~~~ FOD Temp Alarm function~~~
			CALL	FOD_TempertureSensor62			;; d50mV=62H, d100mV=C4H, d150mV=127H
			SZ	fg_ReCordTemp
			JMP	PT_RPP0x04_CalTemp
			
			CALL	FOD_TempTime
	PT_RPP0x04_CalTemp:
			SDZ	a_r_RPowCNT
			JMP	PT_RPP0x04_NoFOD
			
			MOV	A, 008H
			MOV	a_r_RPowCNT, A
			CALL	PreCarry
			MOV	A, a_to7
			SUB	A, a_TempL	
			MOV	A, a_temp1
			SBC	A, a_TempH	
			CALL	PostCarry
			SZ	a_Carry
			JMP	PT_RPP0x04a				; < 

			SET	fg_CalTempTimeHigh			; >=
	PT_RPP0x04a:
			CALL	FOD_TempTime
			SZ	a_0x04ReceivedPow
			JMP	PT_RPP0x04_FOD

			JMP	PT_RPP0x04_NoFOD
	PT_RPP0x04_FOD:
			CALL	FOD_ReceivePowCheck
			SZ	fg_RPNoStable				;fg_RPNoStable =1, No stable then no FOD 
			JMP	PT_RPP0x04_NoFOD
			
			CALL	FOD_SenPriCoilCurrWay65Double
			SZ	fg_FODEfficLow
			JMP	PT_RPP0x04_NoFOD

			CALL	FOD_FObjectDetect2
	PT_RPP0x04_NoFOD:
			JMP	PT_DeComEnd
	PT_CSP0x05:
			MOV	A, a_DataHeader
			XOR	A, 005H
			SNZ	STATUS.2
			JMP	PT_Unknown
			
			MOV	A, a_DataMessageB0
			MOV	a_CSP0x05_B0, A
			CLR	fg_CEinput
			JMP	PT_DeComEnd
	PT_Unknown:
			CLR	fg_CEinput
			MOV	A, a_DataHeader
			XOR	A, 001H
			SNZ	STATUS.2
			JMP	PT_Unknown1
			
			SNZ	fg_RxTI
			SET	fg_EndPowDown

			JMP	PT_DeComEnd
	PT_Unknown1:
			CLR	fg_CEinput
			MOV	A, a_DataHeader
			XOR	A, 006H
			SNZ	STATUS.2
			JMP	PT_Unknown2
			
			SNZ	fg_RxTI
			SET	fg_EndPowDown

			JMP	PT_DeComEnd
	PT_Unknown2:
			CLR	fg_CEinput
			MOV	A, a_DataHeader
			XOR	A, 051H
			SNZ	STATUS.2
			JMP	PT_Unknown3

			SNZ	fg_RxTI
			SET	fg_EndPowDown

			JMP	PT_DeComEnd
	PT_Unknown3:
			CLR	fg_CEinput
			MOV	A, a_DataHeader
			XOR	A, 071H
			SNZ	STATUS.2
			JMP	PT_Unknown4

			SNZ	fg_RxTI
			SET	fg_EndPowDown

			JMP	PT_DeComEnd
	PT_Unknown4:
			CLR	fg_CEinput
			MOV	A, a_DataHeader
			XOR	A, 081H
			SNZ	STATUS.2
			JMP	PT_UnknownOther

			SNZ	fg_RxTI
			SET	fg_EndPowDown

			JMP	PT_DeComEnd
	PT_UnknownOther:
			CLR	fg_CEinput
	PT_DeComEnd:
			CLR 	WDT
			RET


;========================================================
;Function : EndPowCMD0x02Decode
;Note     : Call Function Type for Data-Decode of End Power(0x02)
;input    : a_DataMessageB0(a_EPTP0x02_B0)
;output   : 
;	  : fg_0x02PowDownChargeComplete [1= true]
;	  : fg_0x02PowDownReconfigure [1= true]
;	  : fg_0x02PowDownNoResponse [1= true]
;========================================================
	EndPowCMD0x02Decode:
			CLR 	WDT
			SZ	a_DataMessageB0
			JMP	EndPowerUnit01

			SET	fg_EndPowDown
			JMP	EndPowerUnitEnd
	EndPowerUnit01:		

			MOV	A, a_DataMessageB0
			XOR	A, 001
			SNZ	STATUS.2
			JMP	EndPowerUnit02

			SET	fg_0x02PowDownChargeComplete
			SET	fg_EndPowDown
			JMP	EndPowerUnitEnd
	EndPowerUnit02:		
			MOV	A, a_DataMessageB0
			XOR	A, 002
			SNZ	STATUS.2
			JMP	EndPowerUnit03

			SET	fg_EndPowDown
			JMP	EndPowerUnitEnd
	EndPowerUnit03:		
			MOV	A, a_DataMessageB0
			XOR	A, 003
			SNZ	STATUS.2
			JMP	EndPowerUnit04

			SET	fg_EndPowDown
			JMP	EndPowerUnitEnd
	EndPowerUnit04:		
			MOV	A, a_DataMessageB0
			XOR	A, 004
			SNZ	STATUS.2
			JMP	EndPowerUnit05

			SET	fg_EndPowDown
			JMP	EndPowerUnitEnd
	EndPowerUnit05:		
			MOV	A, a_DataMessageB0
			XOR	A, 005
			SNZ	STATUS.2
			JMP	EndPowerUnit06

			SET	fg_EndPowDown
			JMP	EndPowerUnitEnd
	EndPowerUnit06:		
			MOV	A, a_DataMessageB0
			XOR	A, 006
			SNZ	STATUS.2
			JMP	EndPowerUnit07

			SET	fg_EndPowDown
			JMP	EndPowerUnitEnd
	EndPowerUnit07:		
			MOV	A, a_DataMessageB0
			XOR	A, 007
			SNZ	STATUS.2
			JMP	EndPowerUnit08

			SET	fg_0x02PowDownReconfigure
			JMP	EndPowerUnitEnd
	EndPowerUnit08:
			MOV	A, a_DataMessageB0
			XOR	A, 008
			SNZ	STATUS.2
			JMP	EndPowerUnit09

			SET	fg_0x02PowDownNoResponse
			SET	fg_EndPowDown
			JMP	EndPowerUnitEnd
	EndPowerUnit09:		
	EndPowerUnitEnd:
			SET	a_StatusEndPower
			RET

;========================================================
;Function : ConErrCMD0x03Decode
;Note     : Call Function Type for Data-Decode of -128~127 Control Error(0x03)
;input    : a_DataMessageB0
;output   : a_0x03ContlErr
;========================================================
	ConErrCMD0x03Decode:
			MOV	A, a_DataMessageB0
			MOV	a_0x03ContlErr, A
	ConErrCMD0x03DecodeEnd:
			CLR 	WDT
			RET


;========================================================
;Function : RecPowCMD0x04Decode
;Note     : Call Function Type for Data-Decode of Received Power(0x04)
;input    : (1) a_DataMessageB0
;output   : (1) a_0x04ReceivedPow
;	  : a_0x04ReceiPowCNTL
;	  : a_0x04ReceiPowCNTH
; 	  : fg_0x04ReceiPowCNTHflag
;========================================================
	RecPowCMD0x04Decode:
			CLR 	WDT
			MOV	A, a_DataMessageB0
			MOV	a_0x04ReceivedPow, A
			MOV	A, c_IniReceiPowCNTL
			MOV	a_0x04ReceiPowCNTL, A
			MOV	A, c_IniReceiPowCNTH
			MOV	a_0x04ReceiPowCNTH, A
			SZ	a_0x04ReceiPowCNTH
			SET	fg_0x04ReceiPowCNTHflag

			RET


;========================================================
;Function : PowContlHoldCMD0x06Decode
;Note     : Call Function Type for Data-Decode of Power Control Hold-off(0x06)
;input    : a_PCHO0x06_B0
;output = : a_0x06TdelayML
;	  : a_0x06TdelayMH
;	  : fg_PCH0x06Abnor
;========================================================
	PowContlHoldCMD0x06Decode:
			CLR 	WDT
			MOV	A, a_PCHO0x06_B0
			SUB	A, 005H
			SNZ	STATUS.0
			JMP	PCHCMD0x06Abnormal
			
			MOV	A, a_PCHO0x06_B0
			SUB	A, 0CEH
			SZ	STATUS.0
			JMP	PCHCMD0x06Abnormal

	PowContlHoldCMD0x06Decode2:		
			;;; 5ms <= Tdelay <= 205ms
			;;; 014h=20, 50us x (20*5) = 5000us = 5.00ms, 50us x (20*205) = 205000us = 205ms
			;;;;013h=19, 50us x (19*5) = 4750us = 4.75ms, 50us x (19*205) = 194000us = 194ms
			MOV	A, 014H
			ADD	A, a_0x06TdelayML
			MOV	a_0x06TdelayML, A
			MOV	A, 000H
			ADC	A, a_0x06TdelayMH
			MOV	a_0x06TdelayMH, A
	PowContlHoldCMD0x06Decode1:
			SDZ	a_PCHO0x06_B0
			JMP	PowContlHoldCMD0x06Decode2

			RET
	PCHCMD0x06Abnormal:
			SET	fg_PCH0x06Abnor
			RET
;========================================================
;Function : ConfigCMD0x51Decode
;Note     : Call Function Type for Data-Decode of Configuration(0x51)
;input    : a_Config0x51_B0
;output   : a_0x51PowMax [Power max (w) when PowClass=0]
;========================================================
	ConfigCMD0x51Decode:
			;; --- Maximum Power ---
			MOV	A, 03FH
			AND	A, a_Config0x51_B0
			MOV	a_0x51PowMax, A
			;; a_0x51PowMax/2 = a_0x51PowMax/2^1 
			CLR	c
			RRC	a_0x51PowMax
	ConfigCMD0x51DecodeEnd:		 
			RET

END