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
PUBLIC		DetectVin
PUBLIC		ObjectDetection
PUBLIC		ObjectDetectLeave
PUBLIC		ObjDetLeaveIni
PUBLIC		ObjDetLeavePowe
PUBLIC		ObjDetLeaveDetect
PUBLIC		ObjDetLeaveCheck

EXTERN		Sensoring10_8					:	near
EXTERN		PreCarry					:	near
EXTERN		PostCarry					:	near
EXTERN		ADCData						:	near
EXTERN		DelayTimer					:	near
EXTERN		Delay3						:	near

EXTERN		fg_MutipleTimeHflagCTM				:	bit
EXTERN		a_MutipleTimeLCTM				:	byte
EXTERN		a_MutipleTimeHCTM				:	byte
EXTERN		a_data0						:	byte
EXTERN		a_data1				        	:	byte
EXTERN		a_data2						:	byte
EXTERN		a_data3						:	byte				
EXTERN		a_to1				        	:	byte
EXTERN		a_to2                                   	:	byte
EXTERN		a_to3                                   	:	byte
EXTERN		a_to4                           		:	byte
EXTERN		a_to5                           		:	byte
EXTERN		a_to7                                   	:	byte
EXTERN		a_temp1                                 	:	byte
EXTERN		fg_PSVin					:	bit
EXTERN		fg_RXCoilD					:	bit
EXTERN		fg_DetectVin					:	bit
EXTERN		fg_VinLow					:	bit
EXTERN		a_Carry						:	byte


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
Detection		.Section 	'code'
;========================================================
;Function : DetectVin
;Note     : Call Function Type for Obfject Detection
;input    : 
;output   : 
;setting  : (1) Setting WDTC reg. for Period Timing
;	  : (2) Setting c_IniDetectMutipleTimeH/L
;	  : (3) Setting OCP INT ON/OFF
;========================================================
	DetectVin:
			MOV	A, 003H					; set ADCR0 = 0000_0011 = 003h, AN3
			MOV	ADCR0, A				; ADCR0 @SPDM 2AH (POR=0110_0000, WDT Out=0110_0000)
			CALL	Sensoring10_8
			SZ	fg_PSVin
			JMP	DetectVinSet1

			;JMP	DetectVinSet0
	DetectVinSet0:
			MOV	A, c_IniVinMaxH
			MOV	a_to2, A
			MOV	A, c_IniVinMaxL
			MOV	a_to1, A

			MOV	A, c_IniVinMinH
			MOV	a_to5, A
			MOV	A, c_IniVinMinL
			MOV	a_to4, A
			CLR	a_to3.7
			JMP	PS_VinCheckmax
	DetectVinSet1:		
			MOV	A, c_IniPTVinLowH
			MOV	a_to2, A
			MOV	A, c_IniPTVinLowL
			MOV	a_to1, A

			MOV	A, c_IniPTVinMinH
			MOV	a_to5, A
			MOV	A, c_IniPTVinMinL
			MOV	a_to4, A
			CLR	a_to3.7
			;JMP	PS_VinCheckmax
	PS_VinCheckmax:							; DetectVin max = 3D8h
			CALL	PreCarry
			MOV	A, a_to7				; Low Byte
			SUB	A, a_to1
			MOV	A, a_temp1				; High Byte
			SBC	A, a_to2
			CALL	PostCarry
			SZ	a_Carry
			JMP	PS_VinCheckmin				; < 

			JMP	PS_LightDark				; >=
	PS_VinCheckmin:							; DetectVin min = 325h
			CALL	PreCarry
			SET	a_to3.7
			MOV	A, a_to7                   		; Low Byte
			SUB	A, a_to4
			MOV	A, a_temp1                   		; High Byte
			SBC	A, a_to5
			CALL	PostCarry
			SZ	a_Carry
			JMP	PS_LightDark				; < 

			JMP	DetectVinEnd				; >=
	PS_LightDark:	
			SZ	fg_PSVin
			JMP	PS_LightDark1
			;JMP	PS_LightDark0
	PS_LightDark0:
			SET	fg_DetectVin
			RET
	PS_LightDark1:
			CLR	fg_VinLow
			SNZ	a_to3.7
			RET

			SET	fg_VinLow
			RET
	DetectVinEnd:
			SZ	fg_PSVin
			JMP	DetectVinEnd1
			CLR	fg_DetectVin
			RET
	DetectVinEnd1:
			SET	fg_VinLow
			RET


;========================================================
;Function : ObjectDetection
;Note     : Call Function Type for Obfject Detection
;input    : 
;output   : 
;setting  : (1) Setting WDTC reg. for Period Timing
;	    (2) Setting c_IniDetectMutipleTimeH/L
;	    (3) Setting OCP INT ON/OFF
;========================================================
	ObjectDetection:
			CLR WDT

			MOV	A, 009H					; set ADCR0 = 0000_1001 = 009 ;;AN9 when OCP
			MOV	ADCR0, A				; ADCR0 @SPDM 2AH (POR=0110_0000, WDT Out=0110_0000)
			SZ	fg_RXCoilD				;default=0
			JMP	OD_ParaSetupRXD

			;JMP	OD_ParaSetup
	OD_ParaSetup:
			CALL	ObjDetLeaveIni
			MOV	A, c_IniDetObjMinL
			MOV	a_data2, A
			MOV	A, c_IniDetObjMinH
			MOV	a_data3, A
			JMP	OD_Power
	OD_ParaSetupRXD:
			MOV	A, c_IniDetectRXDMutipleTimeL
			MOV	a_data0, A
			MOV	A, c_IniDetectRXDMutipleTimeH
			MOV	a_data1, A
			MOV	A, c_IniDetObjRXDMinL
			MOV	a_data2, A
			MOV	A, c_IniDetObjRXDMinH
			MOV	a_data3, A
	OD_Power:
			CALL	ObjDetLeavePowe
			SZ	fg_RXCoilD				;default=0
			JMP	OD_ADdetect

			;JMP	OD_Detection				
	OD_Detection:
			CALL	ObjDetLeaveDetect
			SDZ 	ACC
			JMP 	$-1
	OD_ADdetect:
			CALL	ADCData
			MOV	A, 050H
			MOV	PWMC, A
	OD_DetectCheck:							;DetectObject min = 027h
			CALL	ObjDetLeaveCheck                	
			SZ	a_Carry                         	
			JMP	OD_Repeat				; < 
                                                                	
			JMP	ObjectDetectionEnd			; >=
	OD_Repeat:                                              	
			SET	INTC0.5                         	
			CLR	CKGEN.7					; 1 as VCO OFF
			CLR	INTC0.0					; 0 as EMI OFF
			HALT                                    	
	ObjectDetectionEnd:						
			MOV	A, 0C8H					
			MOV	a_MutipleTimeLCTM, A			
			MOV	A, 032H
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM
                       	
			CALL	DelayTimer
			RET


;========================================================
;Function : ObjectDetectLeave
;Note     : Call Function Type for Obfject Detection
;input    :
;output   :
;setting  :
;========================================================
	ObjectDetectLeave:
			CLR 	WDT
			MOV	A, 009H					; set ADCR0 = 0000_1001 = 009 ;;AN9 when OCP
			MOV	ADCR0, A				; ADCR0 @SPDM 2AH (POR=0110_0000, WDT Out=0110_0000)
			CALL	ObjDetLeaveIni
			MOV	A, c_IniDetObjLeaMaxL
			MOV	a_data2, A
			MOV	A, c_IniDetObjLeaMaxH
			MOV	a_data3, A
			CALL	ObjDetLeavePowe
			CALL	ObjDetLeaveDetect
			SDZ 	ACC
			JMP 	$-1
			
			CALL	ADCData
			CALL	ObjDetLeaveCheck
			SZ	a_Carry
			RET						; < 
		
			CALL	Delay3					; >=
			CALL	Delay3
			JMP	ObjectDetectLeave
		

;========================================================
;Function : ObjDetLeaveIni
;Note     : Call Function Type for Obfject Detection
;input    : c_IniDetectMutipleTimeL
;         : c_IniDetectMutipleTimeH
;output   : a_data0
;    	  : a_data1
;Presetting:
;========================================================
	ObjDetLeaveIni:
			MOV	A, c_IniDetectMutipleTimeL
			MOV	a_data0, A
			MOV	A, c_IniDetectMutipleTimeH
			MOV	a_data1, A
			RET

;========================================================
;Function : ObjDetLeavePowe
;Note     : Call Function Type for Obfject Detection
;input    : a_data0
;	  : a_data1
;output   : 
;setting  :
;========================================================
	ObjDetLeavePowe :
			MOV	A, a_data0
			MOV	a_MutipleTimeLCTM, A
			MOV	A, a_data1
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM
        	
			MOV	A, 053H					;  PWM output for PWM0 and PWM0B,  需要修正判讀位置?????????????
			MOV	PWMC, A
			CALL	DelayTimer
			RET
		
		
;========================================================
;Function : ObjDetLeaveDetect
;Note     : Call Function Type for Obfject Detection
;input    : 
;output   : 
;setting  :
;========================================================
	ObjDetLeaveDetect:
			CLR WDT
			MOV	A, 050H
			MOV	PWMC, A
			MOV	A, 00AH					;;delay to detect coil
			RET
		
;========================================================
;Function : ObjDetLeaveCheck
;Note     : Call Function Type for Obfject Detection
;input    : 
;output   : 
;setting  :
;========================================================
	ObjDetLeaveCheck:
			CALL	PreCarry
			MOV	A, ADRL   				; Low Byte
			SUB	A, a_data2
			MOV	A, ADRH					; High Byte
			SBC	A, a_data3
			CALL	PostCarry
			RET
		


END