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
PUBLIC		DemoVI1I2Select
PUBLIC		DemoVI1I2swEN
PUBLIC		DemoVI1I2swDisEN
PUBLIC		INTCheck
PUBLIC		INTTimer

EXTERN		fg_BaseTimeCTM				:	bit
EXTERN		fg_MutipleTimeHflagCTM			:	bit
EXTERN		a_MutipleTimeLCTM			:	byte
EXTERN		a_MutipleTimeHCTM			:	byte
EXTERN		fg_TimeOut				:	bit
EXTERN		fg_FlagDemo				:	bit
EXTERN		a_DemoV_I1_I2				:	byte
EXTERN		fg_INT1					:	bit


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
DemoFun		.Section 	'code'
;========================================================
;Function : DemoVI1I2Select
;Note     : Call Function Type for Demo Selection
;input    :  
;output   : a_DemoV_I1_I2
;========================================================
	DemoVI1I2Select:
			CLR 	WDT
	DemoVI1I2Select11:
			;SNZ	a_DemoV_I1_I2.2				; enable when having PPT_DemoVI1I2Select13
			SNZ	a_DemoV_I1_I2.1				; disenable when having PPT_DemoVI1I2Select13
			JMP	DemoVI1I2Select12

			MOV	A, 001H
			MOV	a_DemoV_I1_I2, A
			RET
	
	DemoVI1I2Select12:
			;SNZ	a_DemoV_I1_I2.0				; enable when having PPT_DemoVI1I2Select13
			;JMP	DemoVI1I2Select13			; enable when having PPT_DemoVI1I2Select13
			RL	a_DemoV_I1_I2
			RET
		
	;DemoVI1I2Select13:
	;		RL	a_DemoV_I1_I2
	;		RET


;========================================================
;Function : DemoVI1I2swEN
;Note     : Call Function Type for Demo Enable
;input    : a_DemoV_I1_I2
;output   : 
;========================================================
	DemoVI1I2swEN:
			CLR	WDT
	DemoVI1I2sw11:				
			SNZ	a_DemoV_I1_I2.0
			JMP	DemoVI1I2sw12
			SET	INTC0.2					; DEME-bit = 1 as Demodulation INT ON
			;CLR	INTC2.3					; INT1E=1 as INT1 OFF
			RET
	DemoVI1I2sw12:
			;SNZ	a_DemoV_I1_I2.1				; enable when having PPT_DemoVI1I2sw13
			;JMP	DemoVI1I2sw13				; enable when having PPT_DemoVI1I2sw13
			
			CLR	INTC2.7
			MOV	A, 00CH					; set INTEG = 0000_1100 = 0Ch
			MOV	INTEG, A				; INTEG @SPDM 30H (POR=----_0000, WDT Out=----_0000)
			SET	INTC2.3					; INT1E=1 as INT1 ON
			;CLR	INTC0.2					; DEME-bit = 1 as Demodulation INT OFF
			RET
	;DemoVI1I2sw13:	;;Need to check pin setting
	;		CLR	INTC0.6
	;		MOV	A, 003H					; set INTEG = 0000_0011 = 03h
	;		MOV	INTEG, A				; INTEG @SPDM 30H (POR=----_0000, WDT Out=----_0000)
	;		SET	INTC0.3					; INT0E=1 as INT0 ON
	;		RET

;========================================================
;Function : DemoVI1I2swDisEN
;Note     : Call Function Type for Demo Disenable
;input    : a_DemoV_I1_I2
;output   : 
;========================================================
	DemoVI1I2swDisEN:
			CLR	WDT
	DemoVI1I2sw21:				
			SNZ	a_DemoV_I1_I2.0
			JMP	DemoVI1I2sw22
			CLR	INTC0.2					; DEME-bit = 1 as Demodulation INT ON
			RET
	DemoVI1I2sw22:
			;SNZ	a_DemoV_I1_I2.1				; enable when having PPT_DemoVI1I2sw13
			;JMP	PPT_DemoVI1I2sw23			; enable when having PPT_DemoVI1I2sw13
			CLR	INTC2.3					; INT1E=1 as INT1 ON
			MOV	A, 000H					; set INTEG = 0000_0000 = 00h
			MOV	INTEG, A				; INTEG @SPDM 30H (POR=----_0000, WDT Out=----_0000)
			CLR	INTC2.7
			RET
	;DemoVI1I2sw23:							;;Need to check pin setting
	;		CLR	INTC0.6
	;		MOV	A, 000H					; set INTEG = 0000_0000 = 00h
	;		MOV	INTEG, A				; INTEG @SPDM 30H (POR=----_0000, WDT Out=----_0000)
	;		CLR	INTC0.3					; INT0E=1 as INT0 ON
	;		RET
	;		RET


;========================================================
;Function : INTCheck  
;Note     : Call Function Type for INT Capture
;input    : c_IniComByMutipleTimeL
;	  : c_IniComByMutipleTimeH
;output   : 
;========================================================
	INTCheck:
			MOV	A, c_IniComByMutipleTimeL		; 300us   (100us + 300us = 400us)
			MOV	a_MutipleTimeLCTM, A
			MOV	A, c_IniComByMutipleTimeH
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM
			CALL	INTTimer
			RET
			

;========================================================
;Function : INTTimer  
;Note     : Call Function Type for Timer of 10-bit TM1(CTM)
;input 	  : a_MutipleTimeLCTM
;	  : a_MutipleTimeHCTM
;	  : fg_MutipleTimeHflagCTM
;	  : fg_INT1
;	  : fg_FlagDemo
;output   : 
;========================================================
	INTTimer:
			SET	fg_BaseTimeCTM				; TM1(CTM) basetime flag reset
			SET	TM1C0.3					; TM1C0[3] (T1ON-bit) = 1 as TM1 ON

	CT_Start:
			CLR WDT
			SNZ	fg_TimeOut
			JMP	CT_End
	CT_Start_DEMO1:		
			SNZ	a_DemoV_I1_I2.0
			JMP	CT_Start_DEMO2
			
			SNZ	fg_FlagDemo
			JMP	CT_End

			JMP	CT_Start_DEMOEnd
	CT_Start_DEMO2:
			;SNZ	a_DemoV_I1_I2.1				;enable when having CT_Start_DEMO3
			;JMP	CT_Start_DEMO2				;enable when having CT_Start_DEMO3
			
			SNZ	fg_INT1
			JMP	CT_End
			;JMP	CT_Start_DEMOEnd			;enable when having CT_Start_DEMO3
				
	;CT_Start_DEMO3:
	;		SNZ	a_DemoV_I1_I2.2
	;		JMP	CT_Start_DEMO2
  	;
	;		SNZ	fg_INT0
	;		JMP	CT_End
	;		;JMP	CT_Start_DEMOEnd
			
			
	CT_Start_DEMOEnd:
			SZ	fg_BaseTimeCTM				; TM1(CTM) basetime stop
			JMP	CT_Start
	CT_RunTimeL0:
			SZ	a_MutipleTimeLCTM
			JMP	CT_RunTimeL1

			JMP	CT_RunTimeL2
	CT_RunTimeL1:
			SDZ	a_MutipleTimeLCTM
			JMP	INTTimer
	CT_RunTimeL2:		
			SZ	fg_MutipleTimeHflagCTM
			JMP	CT_RunTimeH0
			
			JMP	CT_End
	CT_RunTimeH0:
			SDZ	a_MutipleTimeHCTM
			JMP	CT_RunTimeH1
			
			CLR	fg_MutipleTimeHflagCTM
	CT_RunTimeH1:
			SET	a_MutipleTimeLCTM
			JMP	INTTimer
	CT_End:
			CLR WDT
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 1 as TM1 OFF
			RET		



END