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
PUBLIC		ReciPackageDataUnitPreee1
PUBLIC		ReciPackageDataUnit

EXTERN		DelayTimer				:	near
EXTERN		INTTimer				:	near
EXTERN		INTCheck				:	near

EXTERN		a_r_DetectCNT			        :	byte
EXTERN		a_MutipleTimeLCTM		        :	byte
EXTERN		a_MutipleTimeHCTM		        :	byte
EXTERN		a_DemoV_I1_I2			        :	byte
EXTERN		a_MutipleTimeLSTM		        :	byte
EXTERN		a_MutipleTimeHSTM		        :	byte
EXTERN		fg_FlagDemo			        :	bit
EXTERN		fg_INT1				        :	bit
EXTERN		fg_DemoDetect			        :	bit
EXTERN		fg_DemoDetectTimeOut			:	bit		
EXTERN		fg_TimeOut			        :	bit
EXTERN		fg_MutipleTimeHflagCTM		        :	bit

EXTERN		fg_DUDataStart				:	bit
EXTERN		fg_DU					:	bit
EXTERN		fg_StartBit				:	bit
EXTERN		fg_ParityBit				:	bit
EXTERN		fg_ParityErr				:	bit
EXTERN		fg_StopBit				:	bit
EXTERN		fg_WaitDataOut				:	bit
EXTERN		fg_StopBitPre				:	bit
EXTERN		fg_DataFirst				:	bit
EXTERN		fg_Preamble				:	bit
EXTERN		fg_ChecksumBit				:	bit
EXTERN		fg_StartReci				:	bit
EXTERN		fg_DataByteCNTFull			:	bit
EXTERN		a_StatusCntInt1				:	byte
EXTERN		a_DataOUTtemp				:	byte
EXTERN		a_DataParityCNT				:	byte
EXTERN		a_TimeOutCNT				:	byte
EXTERN		a_DataOUT				:	byte
EXTERN		a_DataCNT				:	byte
EXTERN		a_Preamble4BitCNT			:	byte
EXTERN		a_Preamble25BitCNT			:	byte
EXTERN		a_NoToggleCNT				:	byte
EXTERN		a_DataByteCNT				:	byte
EXTERN		a_DataByteCNTtemp			:	byte
EXTERN		a_AddrDataOUT				:	byte


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
ReciPackageDataUnit		.Section 	'code'
;========================================================
;Function : ReciPackageDataUnitPreee1
;Note     : Call Function Type for Detection
;input    : 
;output   : 
;========================================================
	ReciPackageDataUnitPreee1:
			MOV	A, 00EH					;; without ReciPackageDataUnitPre
			MOV	a_r_DetectCNT, A
	RPDUP_INTcheck:
			CLR WDT
			MOV	A, c_IniComBy0MutipleTimeL		; 100us
			MOV	a_MutipleTimeLCTM, A
			MOV	A, c_IniComBy0MutipleTimeH
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM

			CALL	DelayTimer
			SET	fg_INT1
			;SET	fg_INT0
			SET	fg_FlagDemo	;3
			MOV	A, c_IniComByMutipleTimeL0		; 250us
			MOV	a_MutipleTimeLCTM, A
			MOV	A, c_IniComByMutipleTimeH0
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM

			CALL	INTTimer
			SNZ	fg_TimeOut
			RET
	RPDUP_INT_DEMO1:;;;
			SNZ	a_DemoV_I1_I2.0
			JMP	RPDUP_INT_DEMO2;;;
			
			SZ	fg_FlagDemo	;4	
			JMP	RPDUP_Recheck;;;
			JMP	RPDUP_INT;;;
	RPDUP_INT_DEMO2:;;;
			SZ	fg_INT1	;4
			JMP	RPDUP_Recheck;;;

			;JMP	RPDUP_INT;;;
	RPDUP_INT:		
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 0 as TM1 OFF
			SET	fg_INT1
			;SET	fg_INT0
			SET	fg_FlagDemo	;5
			SDZ	a_r_DetectCNT
			JMP	RPDUP_INTcheck

			RET
	RPDUP_Recheck:
			MOV	A, 00EH
			MOV	a_r_DetectCNT, A
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 0 as TM1 OFF
			SET	fg_INT1
			;SET	fg_INT0
			SET	fg_FlagDemo
			SNZ	fg_DemoDetect
			JMP	RPDUP_INTcheck
	
			MOV	A, a_MutipleTimeHSTM
			SUB	A, 053H					;;53F7h   807Fh-2C88h(570ms)=53F7h
			SZ	STATUS.0
			JMP	RPDUP_INTcheck
			;JMP	TO_Repeat_L1
	TO_Repeat_L1:
			MOV	A, a_MutipleTimeLSTM
			SUB	A, 0F7H					;;53F7h   807Fh-2C88h(570ms)=53F7h
			SZ	STATUS.0
			JMP	RPDUP_INTcheck
	TO_Repeat_H:
			SET	fg_DemoDetectTimeOut
			CLR	fg_DemoDetect
			RET

;========================================================
;Function : ReciPackageDataUnit
;Note     : Call Function Type for Package Data 
;input    : (1) INT signal Rising/Falling
;output   : (1) a_DataOUT by IAR0 for Header, Message, checksum
;	    (2) a_DataByteCNTtemp for CNT Header, Message, checksum data byte times
;	    (3) a_AddrDataOUT for MP0
;	    (4) fg_ChecksumBit(to detect checksum stop)(Default=0, True(OK)=1)
;========================================================
	ReciPackageDataUnit:
			MOV	A, 001H
			MOV	a_StatusCntInt1, A
	;--------------------Data Latch-------------------------
	DU_DataLatch:
			CLR WDT
			SET	fg_INT1
			;SET	fg_INT0
			SET	fg_FlagDemo
			SNZ	fg_StopBitPre				;;default=1
			CLR	fg_StopBit
			
			SZ	fg_DUDataStart				;;default=1
			JMP	DU_DataLatchCheck
			
			MOV	A, a_StatusCntInt1
			XOR	A, 001H
			MOV	a_StatusCntInt1, A
	DU_DataLatchCheck:
			CLR WDT
			SZ	a_StatusCntInt1				;;default=1
			JMP	DU_DataLatchCheck1
			
			SNZ	fg_StopBit				;;default=1
			JMP	DU_DataLatchCheck1
			
			SZ	fg_StartBit				;;default=1
			JMP	DU_DataStart

			JMP	DU_DataOUTcnt
	DU_DataStart:
			CLR WDT
			CLR	fg_StartBit
			CLR	fg_WaitDataOut
			JMP	DU_DataLatchCheck
	DU_DataOUTcnt:
			SZ	fg_WaitDataOut
			JMP	DU_DataLatchCheck1

			SET	fg_WaitDataOut
			SDZ	a_DataCNT
			JMP	DU_DataOUT
			
			;JMP	DU_DataOUTParCheck
	DU_DataOUTParCheck:
			SZ	fg_DU
			SET	fg_ParityBit
			
			SZ	a_DataParityCNT.0
			JMP	DU_DataOUTParCheckOd			;fg_ParityBit=0
	
			JMP	DU_DataOUTParCheckEv			;fg_ParityBit=1
	DU_DataOUTParCheckOd:
			SNZ	fg_ParityBit
			JMP	DU_DataOUTParCheck0
	
			SET	fg_ParityErr
			JMP	DU_DataOUTParCheck0
	DU_DataOUTParCheckEv:
			SZ	fg_ParityBit
			JMP	DU_DataOUTParCheck0
	
			SET	fg_ParityErr
			JMP	DU_DataOUTParCheck0
	DU_DataOUTParCheck0:
			CLR WDT
			SET	fg_DU
			CLR	a_DataParityCNT
			CLR	fg_StopBitPre
			JMP	DU_DataLatchCheck1
	DU_DataOUT:
			CLR WDT
			SZ	fg_DU
			JMP	DU_DataOUThigh
	
			JMP	DU_DataOUTlow
	DU_DataOUThigh:
			SET	a_DataOUTtemp.7
			INC	a_DataParityCNT
			MOV	A, 00BH
			MOV	a_TimeOutCNT, A
			JMP	DU_DataOUTRR			
	DU_DataOUTlow:
			CLR	a_DataOUTtemp.7

			SDZ	a_TimeOutCNT
			JMP	DU_DataOUTRR

			JMP	DU_End
	DU_DataOUTRR:				
			MOV	A, a_DataCNT
			XOR	A, 001H
			SNZ	STATUS.2 				;;1=True
			RR	a_DataOUTtemp

			SET	fg_DU
			;JMP	DU_DataLatchCheck1
	DU_DataLatchCheck1:					
			CLR WDT
	
	;--------------------INT Capture & Time-------------------------
	DU_TimerINT:
			SET	fg_INT1
			;SET	fg_INT0
			SET	fg_FlagDemo
			CALL	INTCheck
			SNZ	fg_TimeOut
			JMP	DU_End

			;SZ	fg_INT1
	DU_INT_DEMO1:
			SNZ	a_DemoV_I1_I2.0
			JMP	DU_INT_DEMO2
			
			SZ	fg_FlagDemo
			JMP	DU_Out

			JMP	DU_INT
	DU_INT_DEMO2:
			SZ	fg_INT1	;4
			JMP	DU_Out
			;JMP	DU_INT					;enable when having DU_INT_DEMO3
	
	;DU_INT_DEMO3:
	;		SNZ	a_DemoV_I1_I2.2
	;		JMP	DU_INT_DEMO2
	;		
	;		SZ	fg_INT0	;4
	;		JMP	DU_Out
	;		;JMP	DU_INT
	DU_INT:		
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 0 as TM1 OFF

	DU_INT_1:
			SET	fg_INT1
			;SET	fg_INT0
			SET	fg_FlagDemo
			;------------------Preamble CNT 4bit----------------
			CLR WDT
			SNZ	fg_Preamble				;;default=1
			JMP	DU_INTcheck0
	
			SDZ	a_Preamble4BitCNT			;;default=7
			JMP	DU_DataLatch

			CLR	fg_Preamble
	DU_INTcheck0:				
			MOV	A, 002H
			MOV	a_NoToggleCNT, A
			SZ	fg_StartReci				;;default=1
			JMP	DU_INTcheck01

			JMP	DU_INTcheck02
	DU_INTcheck01:
			SDZ	a_Preamble25BitCNT
			JMP	DU_INTcheck02

			JMP	DU_End
	DU_INTcheck02:
			SZ	fg_StartBit				;;default=1
			JMP	DU_INTcheck1

			CLR	fg_WaitDataOut
			CLR	fg_StartReci
	DU_INTcheck1:		
			SZ	fg_StopBit				; default=1
			JMP	DU_DataLatch
			;--------------------Data OUT-------------------------
			SNZ	fg_DataFirst				; default=1
			JMP	DU_INTcheck2
			
			MOV	A, offset a_DataOUT
			MOV	a_AddrDataOUT, A
			MOV	MP0, A
			CLR	fg_DataFirst
	DU_INTcheck2:		
			CLR WDT
			SZ	fg_DataByteCNTFull
			JMP	DU_INTcheck3
				
			MOV	A, a_DataOUTtemp
			MOV	IAR0, A
			INC	a_DataByteCNT
			MOV	A, a_DataByteCNT
			MOV	a_DataByteCNTtemp, A
			INC	MP0
			MOV	A, a_DataByteCNT
			XOR	A, 00BH
			SZ	STATUS.2
			SET	fg_DataByteCNTFull
	DU_INTcheck3:	
			SET	fg_DUDataStart
			SET	fg_StartBit
			SET	fg_StopBit
			SET	fg_StopBitPre
			CLR	fg_ParityBit
			CLR	fg_ParityErr
			CLR	a_DataParityCNT
			CLR	a_DataOUTtemp
			MOV	A, 00BH
			MOV	a_TimeOutCNT, A
			MOV	A, 00AH
			MOV	a_DataCNT, A
			JMP	DU_DataLatch
	DU_Out:		
			CLR WDT
	DU_Out_1:		
			SZ	fg_Preamble
			JMP	DU_OutPre0

			JMP	DU_OutPre1
	DU_OutPre0:		
			JMP	DU_DataLatch
	DU_OutPre1:		
			SDZ	a_NoToggleCNT
			JMP	DU_Out0
      	
			SZ	a_DataByteCNTtemp
			SET	fg_ChecksumBit				;Mark checksum stop-bit

			JMP	DU_End
	DU_Out0:
			CLR	fg_DU
			SZ	fg_StartBit				;;defualt=1
			JMP	DU_Out1

			CLR	fg_WaitDataOut
	DU_Out1:
			CLR	fg_DUDataStart
			SZ	fg_StopBit				;;default=1
			JMP	DU_DataLatch
	DU_End:
			CLR WDT
			SET	fg_DUDataStart
			SET	fg_StartBit
			CLR	fg_ParityBit
			CLR	fg_ParityErr
			CLR	a_DataParityCNT
			SET	fg_StopBit
			SET	fg_StopBitPre
			CLR	a_DataOUTtemp
			CLR	a_DataOUTtemp.7
			SET	fg_WaitDataOut
			SET	fg_DU
			MOV	A, 002H
			MOV	a_NoToggleCNT, A
			MOV	A, 00BH
			MOV	a_TimeOutCNT, A
			MOV	A, 00AH
			MOV	a_DataCNT, A
			SET	fg_DataFirst
			SET	fg_Preamble
			MOV	A, 007H
			MOV	a_Preamble4BitCNT, A
			CLR	a_DataByteCNT
			MOV	A, 01DH
			MOV	a_Preamble25BitCNT, A
			SET	fg_StartReci
			RET



END