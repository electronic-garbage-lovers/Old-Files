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
PUBLIC		Delay1
PUBLIC		Delay3
PUBLIC		DelayTimer
PUBLIC		TimeOutTimer
PUBLIC		PT_ReceiPowerCNT

EXTERN		a_MutipleTimeLCTM		        :	byte
EXTERN		a_MutipleTimeHCTM		        :	byte
EXTERN		fg_MutipleTimeHflagCTM		        :	bit
EXTERN		fg_BaseTimeCTM				:	bit
EXTERN		fg_MutipleTimeHflagSTM		        :	bit
EXTERN		fg_TimeOut			        :	bit
EXTERN		a_MutipleTimeLSTM		        :	byte
EXTERN		a_MutipleTimeHSTM		        :	byte
EXTERN		fg_BaseTimeSTM			        :	bit
EXTERN		a_0x04ReceiPowCNTL			:	byte
EXTERN		a_0x04ReceiPowCNTH                      :	byte
EXTERN		fg_0x04ReceiPowCNTHflag                 :	bit
EXTERN		fg_RxTI					:	bit
EXTERN		fg_0x04OutReceiPowTime			:	bit


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
Delay		.Section 	'code'
;========================================================
;Function : Delay1
;Note     : Call Function Type for delay timer
;input    : c_IniTtermiMutipleTimeH
;	  : c_IniTtermiMutipleTimeL 
;output   : 
;========================================================
	Delay1:
			MOV	A, c_IniTtermiMutipleTimeL
			MOV	a_MutipleTimeLCTM, A
			MOV	A, c_IniTtermiMutipleTimeH
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM

			CALL	DelayTimer
			RET


;========================================================
;Function : Delay3
;Note     : Call Function Type for delay timer
;input    : Constant
;output   : 
;========================================================
	Delay3:
			MOV	A, 0AAh
			MOV	a_MutipleTimeLCTM, A
			MOV	A, 04Ah
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM

			CALL	DelayTimer
			RET


;========================================================
;Function : DelayTimer  
;Note     : Call Function Type for Timer of 10-bit TM1(CTM)
;input    : a_MutipleTimeLCTM
;	  : a_MutipleTimeHCTM
;	  : fg_MutipleTimeHflagCTM
;========================================================
	DelayTimer:
			SET	fg_BaseTimeCTM				; TM1(CTM) basetime flag reset
	DelayT_Start:
			SET	EMI
			SET	TM1C0.3					; TM1C0[3] (T1ON-bit) = 1 as TM1 ON
			CLR WDT
			SZ	fg_BaseTimeCTM				; TM1(CTM) basetime stop
			JMP	DelayT_Start
	DelayT_RunTimeL0:
			SZ	a_MutipleTimeLCTM
			JMP	DelayT_RunTimeL1
			JMP	DelayT_RunTimeL2			
	DelayT_RunTimeL1:
			SDZ	a_MutipleTimeLCTM
			JMP	DelayTimer
	
	DelayT_RunTimeL2:		
			SZ	fg_MutipleTimeHflagCTM
			JMP	DelayT_RunTimeH0
			
			JMP	DelayT_End
	DelayT_RunTimeH0:
			SDZ	a_MutipleTimeHCTM
			JMP	DelayT_RunTimeH1
			
			CLR	fg_MutipleTimeHflagCTM
	DelayT_RunTimeH1:
			SET	a_MutipleTimeLCTM
			JMP	DelayTimer

	DelayT_End:
			CLR WDT
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 1 as TM1 ON			
			RET

;========================================================
;Function : TimeOutTimer  
;Note     : Call Function Type for Timer of 10-bit TM0(STM)
;input    : a_MutipleTimeLSTM
;	  : a_MutipleTimeHSTM
;	  : fg_MutipleTimeHflagSTM
;output   : fg_TimeOut
;========================================================
	TimeOutTimer:
			CLR WDT
	TO_RunTimeL0:
			SZ	a_MutipleTimeLSTM
			JMP	TO_RunTimeL1

			JMP	TO_RunTimeL2
	TO_RunTimeL1:
			SDZ	a_MutipleTimeLSTM
			JMP	TO_Repeat
	TO_RunTimeL2:
			SZ	fg_MutipleTimeHflagSTM
			JMP	TO_RunTimeH0
			
			JMP	TO_Check
	TO_RunTimeH0:
			SDZ	a_MutipleTimeHSTM
			JMP	TO_RunTimeH1
			
			CLR	fg_MutipleTimeHflagSTM
	TO_RunTimeH1:
			SET	a_MutipleTimeLSTM
	TO_Repeat:
			CLR WDT
			SET	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			SET	TM0C0.3					; TM0C0[3] (T0ON-bit) = 1 as TM0 ON
			JMP	TO_End
	TO_Check:
			CLR	fg_TimeOut	
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
	TO_End:
			RET


;========================================================
;Function : PT_ReceiPowerCNT
;Note     : Call Function Type for CNT 
;input    : a_0x04ReceiPowCNTL
;	  : a_0x04ReceiPowCNTH
;	  : fg_0x04ReceiPowCNTHflag
;output   : fg_0x04OutReceiPowTime
;========================================================
	PT_ReceiPowerCNT:
			CLR WDT
	PT_RunCNTL:
			SZ	a_0x04ReceiPowCNTL
			JMP	PT_RunCNTL0
			JMP	PT_RunCNTL1
	PT_RunCNTL0:
			SDZ	a_0x04ReceiPowCNTL
			JMP	PT_ReceiPowerCNTEnd

	PT_RunCNTL1:		
			SZ	fg_0x04ReceiPowCNTHflag
			JMP	PT_RunCNTH0
			
			JMP	PT_ReceiPowerCNTFlag
	PT_RunCNTH0:
			SDZ	a_0x04ReceiPowCNTH
			JMP	PT_RunCNTH1
			
			CLR	fg_0x04ReceiPowCNTHflag
	PT_RunCNTH1:
			SET	a_0x04ReceiPowCNTL
			JMP	PT_ReceiPowerCNTEnd
	
	PT_ReceiPowerCNTFlag:
			SNZ	fg_RxTI
			SET	fg_0x04OutReceiPowTime
			
	PT_ReceiPowerCNTEnd:
			CLR 	WDT
			RET


END

