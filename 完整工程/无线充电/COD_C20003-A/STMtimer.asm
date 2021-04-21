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
PUBLIC		SetTimer1
PUBLIC		SetTimer2

EXTERN		a_MutipleTimeLSTM		        :	byte
EXTERN		a_MutipleTimeHSTM		        :	byte
EXTERN		fg_MutipleTimeHflagSTM		        :	bit
EXTERN		fg_BaseTimeSTM				:	bit

;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
STMtimer		.Section 	'code'
;========================================================
;Function : SetTimer1
;Note     : Call Function Type for timer
;========================================================
	SetTimer1:
			MOV	A, c_IniPowTrTtimeoutMutipleTimeL	; Ttimeout <= 1800ms
			MOV	a_MutipleTimeLSTM, A
			MOV	A, c_IniPowTrTtimeoutMutipleTimeH
			MOV	a_MutipleTimeHSTM, A
			SZ	a_MutipleTimeHSTM
			SET	fg_MutipleTimeHflagSTM

			SET	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			RET

;========================================================
;Function : SetTimer2
;Note     : Call Function Type for timer
;========================================================
	SetTimer2:
			MOV	A, c_IniPowTrTtioutMutipleTimeL		; Ttiout = Ttimeout - T(unknown)
			MOV	a_MutipleTimeLSTM, A
			MOV	A, c_IniPowTrTtioutMutipleTimeH
			MOV	a_MutipleTimeHSTM, A
			SZ	a_MutipleTimeHSTM
			SET	fg_MutipleTimeHflagSTM

			SET	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			RET

END