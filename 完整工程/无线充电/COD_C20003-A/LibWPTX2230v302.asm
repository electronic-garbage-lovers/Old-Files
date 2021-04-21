;*******************************************************************************************
;*****	                               History	                                       *****
;*******************************************************************************************
;V1.0 - WPC Qi Certification Source Code by Edward in HOLTEK Semiconductor Inc. on 2014/12/25



;*******************************************************************************************
;*****	                          IC Application Information                           *****
;*******************************************************************************************
;;   	Work Voltage 			: 5.0V
;;      Osc. Type 			: HXT 20MHz	
;;      MCU Type			: HT66FW2230
;;                      		: 4KB (4096 *16) Program ROM
;;                      		: 128 ( 128 * 8) Bytes Data RAM
;;			 		:  64 (  64 * 8) Bytes EEPROM
;; 	Package 			: 28-Pin SSOP
;;
;;	HT66FW2230 Pin Application	:
;;
;;				                   +---------+      
;;				               AX  |1      28| AN  
;;				               CP  |2      27| COMM0  
;;				               CN  |3      26| AN7  
;;				               CX  |4      25| PA5  
;;				           OCDSDA  |5      24| PA4  
;;				           OCDSCK  |6      23| AN3  
;;				              VSS  |7      22| OCP 
;;				              VDD  |8      21| PLLCOM
;;				            PWM03  |9      20| AVSS 
;;				            PWM02  |10     19| AVDD  
;;				            PWM01  |11     18| OSC1  
;;				            PWM00  |12     17| OSC2  
;;				       (LED_G)PB2  |13     16| INT1  
;;				       (LED_R)PB3  |14     15| DEMO  
;;				                   +---------+      
;;


;*******************************************************************************************
;*****	                           Including File	                               *****
;*******************************************************************************************
#INCLUDE 	HT66FW2230.inc
#INCLUDE	TxUserDEF2230v302.inc	


;*******************************************************************************************
;*****	                        Function / Parameter Claim	                       *****
;*******************************************************************************************
EXTERN		ReciPackageDataUnitPreee1		:	near
EXTERN		ReciPackageDataUnit			:	near
EXTERN		Delay1					:	near
EXTERN		Delay3					:	near
EXTERN		DelayTimer                              :	near
EXTERN		TimeOutTimer				:	near
EXTERN		SetTimer1				:	near
EXTERN		SetTimer2                               :	near
EXTERN		PT_PIDandPWM				:	near
EXTERN		DemoVI1I2Select                         :	near
EXTERN		DemoVI1I2swEN                           :	near
EXTERN		DemoVI1I2swDisEN			:	near
EXTERN		CLRMath					:	near
EXTERN		SignedSub_8Bit                          :	near
EXTERN		SignedAdd_16Bit                         :	near
EXTERN		SignedMul_16Bit                         :	near
EXTERN		SignedSub_24Bit			        :	near
EXTERN		SignedAdd_24Bit			        :	near
EXTERN		SignedMul_24Bit			        :	near
EXTERN		SignedDiv_24Bit			        :	near
EXTERN		sum_ADC_value				:	near
EXTERN		avg_ADC_value				:	near
EXTERN		DetectVin				:	near
EXTERN		ObjectDetection                         :	near
EXTERN		ObjectDetectLeave                       :	near
EXTERN		ObjDetLeaveIni                          :	near
EXTERN		ObjDetLeavePowe                         :	near
EXTERN		ObjDetLeaveDetect                       :	near
EXTERN		ObjDetLeaveCheck                        :	near
EXTERN		PT_DecodeCommand                        :	near
EXTERN		EndPowCMD0x02Decode                     :	near
EXTERN		PowContlHoldCMD0x06Decode               :	near
EXTERN		ConfigCMD0x51Decode			:	near
EXTERN		PID_SenPriCoilCurrWay65Double           :	near
EXTERN		PID_Isen65_SUBIsen                      :	near
EXTERN		PID_Isen65AvgTwo			:	near
EXTERN		ExtractPacData				:	near
EXTERN		PT_PIDCE4				:	near
EXTERN		INTCheck				:	near
EXTERN		INTTimer				:	near
EXTERN		PT_ReceiPowerCNT			:	near
EXTERN		PLLCompare				:	near
EXTERN		Sensoring10_8                           :	near
EXTERN		PreCarry                                :	near
EXTERN		PostCarry                               :	near
EXTERN		DemoCLR                                 :	near
EXTERN		ADCData 				:	near

EXTERN		a_ParPLLFH			        :	byte
EXTERN		a_ParPLLFL			        :	byte
EXTERN		fg_BaseTimeCTM			        :	bit
EXTERN		fg_MutipleTimeHflagCTM		        :	bit
EXTERN		a_MutipleTimeLCTM		        :	byte
EXTERN		a_MutipleTimeHCTM		        :	byte
EXTERN		fg_BaseTimeSTM			        :	bit
EXTERN		fg_MutipleTimeHflagSTM		        :	bit
EXTERN		fg_TimeOut			        :	bit
EXTERN		a_MutipleTimeLSTM		        :	byte
EXTERN		a_MutipleTimeHSTM		        :	byte
EXTERN		fg_FlagDemo			        :	bit
EXTERN		a_DemoV_I1_I2			        :	byte
EXTERN		fg_INT1				        :	bit
EXTERN		fg_INT0				        :	bit
EXTERN		fg_DUDataStart			        :	bit
EXTERN		fg_DU				        :	bit
EXTERN		fg_StartBit			        :	bit
EXTERN		fg_ParityBit			        :	bit
EXTERN		fg_ParityErr			        :	bit
EXTERN		fg_StopBit			        :	bit
EXTERN		fg_WaitDataOut			        :	bit
EXTERN		fg_StopBitPre			        :	bit
EXTERN		fg_DataFirst			        :	bit
EXTERN		fg_Preamble			        :	bit
EXTERN		fg_ChecksumBit			        :	bit
EXTERN		fg_PacDataOK			        :	bit
EXTERN		fg_StartReci			        :	bit
EXTERN		fg_DataByteCNTFull		        :	bit
EXTERN		a_StatusCntInt1			        :	byte
EXTERN		a_DataOUTtemp			        :	byte
EXTERN		a_DataParityCNT			        :	byte
EXTERN		a_TimeOutCNT			        :	byte
EXTERN		a_DataOUT			        :	byte
EXTERN		a_DataCNT			        :	byte
EXTERN		a_Preamble4BitCNT		        :	byte
EXTERN		a_Preamble25BitCNT		        :	byte
EXTERN		a_NoToggleCNT			        :	byte
EXTERN		a_DataByteCNT			        :	byte
EXTERN		a_DataByteCNTtemp		        :	byte
EXTERN		a_AddrDataOUT			        :	byte
EXTERN		a_HeadMessageCNT		        :	byte
EXTERN		a_ContlDataMessag		        :	byte
EXTERN		a_DataHeader			        :	byte
EXTERN		a_DataMessageB0			        :	byte
EXTERN		a_DataMessageB1             	        :	byte
EXTERN		a_DataMessageB2             	        :	byte
EXTERN		a_DataMessageB3             	        :	byte
EXTERN		a_DataMessageB4             	        :	byte
EXTERN		a_DataMessageB5             	        :	byte
EXTERN		a_DataMessageB6             	        :	byte
EXTERN		a_DataMessageB7             	        :	byte
EXTERN		a_DataChecksum			        :	byte
EXTERN		a_XORchecksum			        :	byte
EXTERN		fg_INT_AD			        :	bit
EXTERN		a_ADRHbuffer			        :	byte
EXTERN		a_ADRLbuffer			        :	byte
EXTERN		a_com1				        :	byte
EXTERN		a_com2				        :	byte
EXTERN		a_com3				        :	byte
EXTERN		a_com4				        :	byte
EXTERN		a_data0				        :	byte
EXTERN		a_data1				        :	byte
EXTERN		a_data2				        :	byte
EXTERN		a_data3				        :	byte
EXTERN		a_data4				        :	byte
EXTERN		a_data5				        :	byte
EXTERN		a_data6				        :	byte
EXTERN		a_data7				        :	byte
EXTERN		a_to0				        :	byte
EXTERN		a_to1				        :	byte
EXTERN		a_to2                                   :	byte
EXTERN		a_to3                                   :	byte
EXTERN		a_to4                                   :	byte
EXTERN		a_to5                                   :	byte
EXTERN		a_to6                                   :	byte
EXTERN		a_to7                                   :	byte
EXTERN		a_count0			        :	byte
EXTERN		a_temp2                                 :	byte
EXTERN		a_temp1                                 :	byte
EXTERN		a_temp0                                 :	byte
EXTERN		fg_PIDIni			        :	bit
EXTERN		fg_start			        :	bit
EXTERN		fg_IterationStart		        :	bit
EXTERN		fg_FODTemp60                            :	bit
EXTERN		a_IL              	   	        :	byte
EXTERN		a_IM0                 		        :	byte
EXTERN		a_IM1                 		        :	byte
EXTERN		a_VL				        :	byte
EXTERN		a_VM0				        :	byte
EXTERN		a_VM1				        :	byte
EXTERN		a_EL				        :	byte
EXTERN		a_EM				        :	byte
EXTERN		a_EH				        :	byte
EXTERN		a_Sv				        :	byte
EXTERN		a_LoopIteration			        :	byte
EXTERN		fg_0x02PowDownChargeComplete            :	bit
EXTERN		fg_0x02PowDownReconfigure               :	bit
EXTERN		fg_0x02PowDownNoResponse                :	bit
EXTERN		fg_ExIdet0x81			        :	bit
EXTERN		fg_Idet				        :	bit
EXTERN		fg_Tdelay			        :	bit
EXTERN		fg_0x04OutReceiPowTime		        :	bit
EXTERN		fg_0x51PowClass			        :	bit
EXTERN		fg_0x51NonPID			        :	bit
EXTERN		fg_EndPowDown			        :	bit
EXTERN		fg_CEinput			        :	bit
EXTERN		fg_0x04ReceiPowCNTHflag		        :	bit
EXTERN		fg_PSVin			        :	bit
EXTERN		fg_PCH0x06Abnor			        :	bit
EXTERN		fg_RecodeRPpre			        :	bit
EXTERN		fg_RPNoStable			        :	bit
EXTERN		fg_adc_avg_cnt			        :	bit
EXTERN		fg_RXCoilD			        :	bit
EXTERN		fg_NoChange			        :	bit
EXTERN		fg_IsenSmall			        :	bit
EXTERN		fg_IsenBig			        :	bit
EXTERN		fg_WaitNextCE			        :	bit
EXTERN		fg_CEThr			        :	bit
EXTERN		fg_CEThrPana			        :	bit
EXTERN		fg_IsenFirst			        :	bit
EXTERN		fg_PLLDown			        :	bit
EXTERN		fg_PLLPana			        :	bit
EXTERN		fg_DetectVin			        :	bit
EXTERN		fg_VinLow			        :	bit
EXTERN		fg_PLL205			        :	bit
EXTERN		fg_DTCPR			        :	bit
EXTERN		fg_DTCPRmin			        :	bit
EXTERN		fg_PLLThr			        :	bit
EXTERN		fg_Ping				        :	bit
EXTERN		fg_FODEfficLow			        :	bit
EXTERN		fg_ReCordTemp			        :	bit
EXTERN		fg_CalTempTimeHigh		        :	bit
EXTERN		fg_PowOver5wLEDsw		        :	bit
EXTERN		fg_DemoDetect			        :	bit
EXTERN		fg_DemoDetectTimeOut			:	bit		
EXTERN          fg_RxTI					:	bit
EXTERN          fg_RxPana			        :	bit
EXTERN		a_SSP0x01_B0			        :	byte
EXTERN		a_CSP0x05_B0			        :	byte
EXTERN		a_PCHO0x06_B0			        :	byte
EXTERN		a_Config0x51_B0			        :	byte
EXTERN		a_Config0x51_B2                         :	byte
EXTERN		a_Config0x51_B3                         :	byte
EXTERN		a_IP0x71_B0			        :	byte
EXTERN		a_IP0x71_B1			        :	byte
EXTERN		a_IP0x71_B2			        :	byte
EXTERN		a_IP0x71_B3			        :	byte
EXTERN		a_IP0x71_B4			        :	byte
EXTERN		a_IP0x71_B5			        :	byte
EXTERN		a_IP0x71_B6			        :	byte
EXTERN		a_ExIP0x81_B0			        :	byte
EXTERN		a_ExIP0x81_B1			        :	byte
EXTERN		a_ExIP0x81_B2                           :	byte
EXTERN		a_ExIP0x81_B3                           :	byte
EXTERN		a_ExIP0x81_B4                           :	byte
EXTERN		a_ExIP0x81_B5                           :	byte
EXTERN		a_ExIP0x81_B6                           :	byte
EXTERN		a_ExIP0x81_B7                           :	byte
EXTERN		a_0x03ContlErr			        :	byte
EXTERN		a_0x04ReceivedPow		        :	byte
EXTERN		a_0x04ReceivedPowPre		        :	byte
EXTERN		a_0x06TdelayML			        :	byte
EXTERN		a_0x06TdelayMH			        :	byte
EXTERN		a_StatusEndPower		        :	byte
EXTERN		a_OptConfiCNT			        :	byte
EXTERN		a_0x51PowMax			        :	byte
EXTERN		a_0x04ReceiPowCNTH		        :	byte
EXTERN		a_0x04ReceiPowCNTL		        :	byte
EXTERN		a_ParPLLFHpre			        :	byte
EXTERN		a_ParPLLFLpre			        :	byte
EXTERN		a_Carry				        :	byte
EXTERN		a_r_DetectCNT			        :	byte
EXTERN		a_r_RPowCNT			        :	byte
EXTERN		a_TempH				        :	byte
EXTERN		a_TempL	                                :	byte


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
MainCode	.Section 	at 0000H 	'code'
;========================================================
;Function : Program Memory Define
;Note     : 
;========================================================
			ORG	0000H					; Reset in Program Memory 0000H
           		JMP	Initialization				; Jump into Initial
                                                                	
			ORG	0004H					; Over Currrent Protection Interrupt
			JMP	ISR_OCP                         	
			                                        	
			ORG	0008H					; Demodulation Interrupt
			JMP	ISR_DeMod                       	
			                                        	
			ORG	000CH					; External Interrupt 0
			JMP	ISR_ExInt0                      	
			                                        	
			ORG	0010H					; MultiFunction0 Interrupt for TM0
			JMP	ISR_MultiFun_TM0                	
                                                                	
			ORG	0014H					; MultiFunction1 Interrupt for TM1
			JMP	ISR_MultiFun_TM1                	
                                                                	
			ORG	0018H					; MultiFunction2 Interrupt for LVD / EEPROM
			JMP	ISR_MultiFun_LVD_EEP            	
			                                        	
			ORG	001CH					; ADC Interrupt
			JMP	ISR_ADC                         	
                                                                	
			ORG	0020H					; IIC Interrupt
			JMP	ISR_IIC                         	
			                                        	
			ORG	0024H					; Time Base 0 Interrupt
			JMP	ISR_TimeBase0                   	
			                                        	
			ORG	0028H					; Time Base 1 Interrupt
			JMP	ISR_TimeBase1                   	
			                                        	
			ORG	002CH					; External Interrupt 1
			JMP	ISR_ExInt1


;========================================================
;Function : Initial 
;Note     : IO and parameter initial setting
;========================================================
		Initialization:	
			SNZ	STATUS.4				; PDF flag
			JMP	InitiIO
			SNZ	STATUS.5				;;TO flag
			JMP	InitiIO
			;JMP	Phase_Selection

			SET	fg_NoChange
	PS_PWMsw:
			SDZ	a_r_DetectCNT
			JMP	PS_175KHz

			JMP	PS_171KHz
	PS_175KHz:							;Normal
			MOV	A, 0D0H                         	
			MOV	PLLFL, A				; PLLFL @SPDM 61H (POR=0000_0000, WDT Out=0000_0000)
			MOV	a_ParPLLFL, A                   	
			MOV	A, 002H                         	
			MOV	PLLFH, A				; PLLFH @SPDM 62H (POR=----_-000, WDT Out=----_-000)
			MOV	a_ParPLLFH, A                   	
			CLR	fg_RXCoilD                      	
			JMP	InitiIO1                        	
	PS_171KHz:							;for type D Rx Coil
			MOV	A, 0D0H					; 172kHz
			MOV	PLLFL, A				; PLLFL @SPDM 61H (POR=0000_0000, WDT Out=0000_0000)
			MOV	a_ParPLLFL, A
			MOV	A, 002H	
			MOV	PLLFH, A
			MOV	a_ParPLLFH, A
			MOV	A, 008H
			MOV	a_r_DetectCNT, A
			SET	fg_RXCoilD
			JMP	InitiIO1

;-----------------------I/O Setting------------------------
	InitiIO:
			CLR	fg_NoChange
			MOV	A, 001H
			MOV	a_DemoV_I1_I2, A   
	InitiIO1:
			MOV	A, 005H					; set PCS0 = 0000_0101 = 05h
			MOV	PCS0, A					; PCS0 @SPDM 3DH
                                                                	
			MOV	A, 0FAH					; set PCS1 = 1111_1010 = FAh
			MOV	PCS1, A					; PCS1 @SPDM 3FH
                                                                	
			MOV	A, 0D0H					; set PCC = 1101_0000 = D0h 
			MOV	PCC, A					; PCC @SPDM 38H
                                                                	
			;MOV	A, 000H					; set PCPU = 0000_0000 = 00h
			;MOV	PCPU, A					; PCPU @SPDM 39H
                                                                	
			MOV	A, 04FH					; set PA = 0101_1111 = 5Fh ;;test PA.7/PA.5
			MOV	PA, A						; PA @SPDM 12H
			                                        	
			MOV	A, 0C8H					; set PAS0 = 0000_1000 = C8h;;AN3
			MOV	PAS0, A					; PAS0 @SPDM 3AH
                                                                	
			MOV	A, 0E0H					; set PAS1 = 1110_0000 = E0h	;; AN7
			;MOV	A, 020H					; set PAS1 = 0010_0000 = 20h;;test PA.7
			MOV	PAS1, A					; PAS1 @SPDM 3BH
			                                        	
			MOV	A, 0CFH					; set PAC = 1100_1111 = CFh ;;Temperture Sensor/PA.5
			;MOV	A, 04FH					; set PAC = 0100_1111 = 4Fh ;test PA.7/PA.5
			MOV	PAC, A					; PAC @SPDM 13H
                                                                	
			;MOV	A, 000H					; set PAPU = 0000_0000 = 00h as no pull high
			;MOV	PAPU, A					; PAPU @SPDM 14H (POR=0000_0000, WDT Out=0000_0000)
			                                        	
			;MOV	A, 000H					; set PAPU = 0000_0000 = 00h as no wake up HALT
			;MOV	PAWU, A					; PAPU @SPDM 15H (POR=0000_0000, WDT Out=0000_0000)
                                                                	
			MOV	A, 0F7H					; set PB = 1111_0111 = F7h 
			MOV	PB, A					; PB @SPDM 1AH
                                                                	
			MOV	A, 082H					; set PBS0 = 1000_0010 = 82h
			MOV	PBS0, A					; PBS0 @SPDM 3CH
	                                                        	
			MOV	A, 011H					; set PBC = ---1_0001 = 11h 
			MOV	PBC, A					; PBC @SPDM 1BH (POR=---1_1111, WDT Out=---1_1111)
                                                                	
			;MOV	A, 000H					; set PBPU = 0000_0000 = 00h as no pull high
			;MOV	PBPU, A					; PBPU @SPDM 1CH (POR=---0_0000, WDT Out=---0_0000)
                                                                	
			;MOV	A, 0FFH					; set PC = 1111_1111 = FFh 
			;MOV	PC, A					; PC @SPDM 37H
                                                                	
			MOV	A, 007H					; set IFS0 = 0000_0111 = 07h
			MOV	IFS0, A					; IFS0 @SPDM 3EH
                                                                	
;-----------------------System Setting---------------------     	
			;MOV	A, 001H					; set HXTC = 0000_0001 = 01h
			;MOV	HXTC, A					; HXTC @SPDM 2DH
			SET	HXTC.0

	Ini_CheckHXTF:
			CLR	WDT
			SNZ	HXTC.1
			JMP	Ini_CheckHXTF

			MOV	A, 008H
			MOV	SCC, A
			CLR	HIRCC.0
	
			;MOV	A, 000H					; set STATUS = --00_0000 = 00h
			;MOV	STATUS, A				; STATUS @SPDM 0AH (POR=xx00_xxxx, WDT Out=xx1u_uuuu)
			                                        	
			;MOV	A, 000H					; set RSTFC = --00_0000 = 00h
			;MOV	RSTFC, A				; RSTFC @SPDM 17H (POR=xx00_xxxx, WDT Out=xx1u_uuuu)
		                                                	
			;MOV	A, 053H					; set WDTC = 0101_0000 = 50h
			;MOV	WDTC, A					; WDTC @SPDM 23H (POR=0101_0011, WDT Out=0101_0011)
                                                                	
			;MOV	A, 055H					; set WDTC = 0101_0101 = 55h
			;MOV	LVRC, A					; WDTC @SPDM 23H (POR=0101_0101, WDT Out=0101_0101)
                                                                	
;-------------------VCO PLL / PWM setting------------------     	
			;MOV	A, 080H					; set CKGEN = 1000_0000 = 80h
			;MOV	CKGEN, A				; CKGEN @SPDM 60H (POR=0000_----, WDT Out=0000_----)
                                                                	
			MOV	A, 0D0H					;316h= 179kHz, 2EEh=175kHz, 2D0h=172kHz
			MOV	PLLFL, A				; PLLFL @SPDM 61H (POR=0000_0000, WDT Out=0000_0000)
			MOV	a_ParPLLFL, A                   	
                                                                	
			MOV	A, 002H					;316h= 179kHz
			MOV	PLLFH, A				; PLLFH @SPDM 62H (POR=----_-000, WDT Out=----_-000)
			MOV	a_ParPLLFH, A                   	
                                                                	
;			MOV	A, 001H					; set CPR = 0--0_0001 = 01h
;			MOV	CPR, A					; CPR @SPDM 72H
                                                                	
			;MOV	A, 050H					; set PWMC = 0101_0000 = 00h, as Mode 0
			;MOV	PWMC, A					; PWMC @SPDM 63H
			;CLR	PWMC                            	
                                                                	
;----------------Timer Module 0 (STM) setting--------------     	
			;MOV	A, 000H					; set TM0C0 = 0000_0000 = 00h
			;MOV	TM0C0, A				; TM0C0 @SPDM 43H (POR=0000_0000, WDT Out=0000_0000)
                                                                	
			MOV	A, 0C1H					; set TM0C1 = 1100_0001 = C1h
			MOV	TM0C1, A				; TM0C1 @SPDM 44H (POR=0000_0000, WDT Out=0000_0000)
                                                                	
			MOV	A, c_IniSTMTimeBaseL			; set TM0AL = 0000_0000 = 00h
			MOV	TM0AL, A				; TM0AL @SPDM 47H (POR=0000_0000, WDT Out=0000_0000)
                                                                	
			MOV	A, c_IniSTMTimeBaseH			; set TM0AH = 0000_0000 = 00h
			MOV	TM0AH, A				; TM0AH @SPDM 48H (POR=----_--00, WDT Out=----_--00)
                                                                	
;----------------Timer Module 1 (CTM) setting--------------     	
			;MOV	A, 000H					; set TM1C0 = 0000_0000 = 00h
			;MOV	TM1C0, A				; TM1C0 @SPDM 49H (POR=0000_0000, WDT Out=0000_0000)
                                                                	
			MOV	A, 0C1H					; set TM1C1 = 0000_0000 = 00h
			MOV	TM1C1, A				; TM1C1 @SPDM 4AH (POR=0000_0000, WDT Out=0000_0000)
                                                                	
			MOV	A, c_IniCTMTimeBaseL			; set TM1AL = 1111_1010 = FAh for 50us
			MOV	TM1AL, A				; TM1AL @SPDM 4DH (POR=0000_0000, WDT Out=0000_0000)
                                                                	
			MOV	A, c_IniCTMTimeBaseH			; set TM1AH = 0000_0000 = 00h
			MOV	TM1AH, A				; TM1AH @SPDM 4EH (POR=----_--00, WDT Out=----_--00)
                                                                	
;-------------------Internal VREF setting------------------     	
			MOV	A, 080H					; set VREFC = 1000_0000 = 80h
			MOV	VREFC, A				; VREFC @SPDM 6FH (POR=0---_---x, WDT Out=0---_---x)
                                                                	
			;MOV	A, 020H					; set VREACAL = 0010_0000 = 20h for Non-Calibration
			;MOV	VREACAL, A				; VREACAL @SPDM 70H (POR=0010_0000, WDT Out=0010_0000)
                                                                	
;----------------Demodulation & OCP setting-----------------    	
			;MOV	A, 000H					; set DCMISC = 0000_0000 = 00h @ AVDD=5v			
			;MOV	DCMISC, A				; DCMISC @SPDM 6EH (POR=000-_--00, WDT Out=000-_--00)
                                                                	
			;MOV	A, 020H					; set DMACAL = 0010_0000 = 20h for Non-Calibration
			;MOV	DEMACAL, A				; DMACAL @SPDM 67H (POR=0010_0000, WDT Out=0010_0000)
                                                                	
			;MOV	A, 010H					; set DMCCAL = 0001_0000 = 10h for Non-Calibration
			;MOV	DEMCCAL, A				; DMCCAL @SPDM 68H (POR=0001_0000, WDT Out=0001_0000)
                                                                	
			MOV	A, 040H					; set DEMC0 = 0100_0000 = 40h			
			MOV	DEMC0, A				; DEMC0 @SPDM 64H (POR=00--_----, WDT Out=00--_----)
			                                        	
			;MOV	A, 007H					; set DEMC1 = 0000_0110 = 06h for OPA gain= 1, 63~64 tFLT
			;MOV	DEMC1, A				; DEMC1 @SPDM 65H (POR=x-00_0000, WDT Out=x-00_0000)
                                                                	
			MOV	A, 042H					; set DEMREF = 0100_0010 = 42h for 5v / 256 x 66(42h) = 1.3v Reference voltage
			MOV	DEMREF, A				; DEMREF @SPDM 66H (POR=0000_0000, WDT Out=0000_0000)
                                                                	
			;MOV	A, 020H					; set OCPACAL = 0010_0000 = 20h for Non-Calibration
			;MOV	OCPACAL, A				; OCPACAL @SPDM 6CH (POR=0010_0000, WDT Out=0010_0000)
			;MOV	OCACAL, A                       	
                                                                	
			;MOV	A, 010H					; set OCPCCAL = 0001_0000 = 10h for Non-Calibration
			;MOV	OCPCCAL, A				; OCPCCAL @SPDM 6DH (POR=0001_0000, WDT Out=0001_0000)
			;MOV	OCCCAL, A                       	
                                                                	
			MOV	A, 040H					; set OCPC0 = 0100_0000 = 40h
			MOV	OCPC0, A				; OCPC0 @SPDM 69H (POR=00--_----, WDT Out=00--_----)
			                                        	
			MOV	A, 007H					; set OCPC1 = 0000_0111 = 07h
			MOV	OCPC1, A				; OCPC1 @SPDM 6AH (POR=x-00_0000, WDT Out=x-00_0000)
                                                                	
			MOV	A, 0B2H					; set OCPREF = 0B2h =3.5v@VREF=5V (2014/06/24), CCh=4V
			MOV	OCPREF, A				; OCPREF @SPDM 6BH (POR=0000_0000, WDT Out=0000_0000)
                                                                	
;-------------------------I2C setting----------------------     	
			; IICC0                                 	
			; IICC1                                 	
			; IICD                                  	
			; IICA                                  	
			; I2CTOC                                	
                                                                	
;-------------------------ADC setting----------------------     	
			MOV	A, 001H					; set ADCR0 = 0000_0001 = 001h
			MOV	ADCR0, A				; ADCR0 @SPDM 2AH (POR=0110_0000, WDT Out=0110_0000)
                                                                	
			MOV	A, 07CH					; set ADCR1 = 0111_1100 = 07Ch
			MOV	ADCR1, A				; ADCR1 @SPDM 2BH (POR=-000_0000, WDT Out=-000_0000)
                                                                	
;-----------------------EEPROM setting---------------------     	
			; EEA                                   	
			; EED                                   	
			; EEC                                   	
                                                                	
;-----------------------LVDC setting---------------------       	
			; LVDC                                  	
                                                                	
;----------------------Time Base setting-------------------     	
			MOV	A, 001					;; PSCR = 0000_0001=01h
			MOV	PSCR,	A				;; 00h=> Fsys, 01h=>Fsys/4, 11h=>Fsub
			                                        	
			MOV	A, 006					;; TBC0 = 0000_0110=06h
			MOV	TBC0, A					;; 110=>16384/Ftb
			                                        	
			MOV	A, 007					;; TBC1 = 0000_0111=07h
			MOV	TBC1, A					;; 111=>32768/Ftb
                                                                	
;-----------------------Parameter Setting-------------------    	
			SET	fg_BaseTimeCTM                  	
			CLR	fg_MutipleTimeHflagCTM          	
			CLR	a_MutipleTimeHCTM               	
			CLR	a_MutipleTimeLCTM               	
			SET	fg_BaseTimeSTM                  	
			CLR	fg_MutipleTimeHflagSTM          	
			CLR	a_MutipleTimeHSTM               	
			CLR	a_MutipleTimeLSTM               	
			SET	fg_FlagDemo				; Demodulation IP with bug
			SET	fg_INT1                         	
			SET	fg_INT0                         	
			CLR	a_DataOUTtemp                   	
			SET	fg_DUDataStart                  	
			SET	fg_DU                           	
			SET	fg_StartBit                     	
			CLR	fg_ParityBit                    	
			CLR	fg_ParityErr                    	
			MOV	A, 00AH					;00AH(Start-bit, b0~b7, Parity-bit)
			MOV	a_DataCNT, A                    	
			CLR	a_DataParityCNT                 	
			SET	fg_StopBit                      	
			MOV	A, 00BH                         	
			MOV	a_TimeOutCNT, A				; 09H for the front of Stop-bit
			CALL	DemoCLR	                        	
			SET	fg_WaitDataOut                  	
			SET	fg_StopBitPre                   	
			SET	fg_DataFirst                    	
			SET	fg_Preamble                     	
			MOV	A, 007H                         	
			MOV	a_Preamble4BitCNT, A            	
			MOV	A, 002H                         	
			MOV	a_NoToggleCNT, A                	
			CLR	fg_ChecksumBit                  	
			CLR	a_DataByteCNT                   	
			CLR	a_DataByteCNTtemp               	
			CLR	a_AddrDataOUT                   	
			CLR	fg_DataByteCNTFull              	
			CLR	a_HeadMessageCNT                	
			MOV	A, 080H                         	
			MOV	a_ContlDataMessag, A            	
			CLR	a_DataHeader                    	
			CLR	a_DataMessageB0                 	
			CLR	a_DataMessageB1                 	
			CLR	a_DataMessageB2                 	
			CLR	a_DataMessageB3                 	
			CLR	a_DataMessageB4                 	
			CLR	a_DataMessageB5                 	
			CLR	a_DataMessageB6                 	
			CLR	a_DataMessageB7                 	
			CLR	a_DataChecksum                  	
			CLR	a_XORchecksum                   	
			SET	fg_PacDataOK                    	
			SET	fg_StartReci                    	
			MOV	A, 01DH                         	
			MOV	a_Preamble25BitCNT, A			; preamble maximmn 25-bit[(25*2)-(4*2-1)=43=2BH]; 43-14=29=1Dh
			SET	fg_TimeOut
			CLR	a_SSP0x01_B0
			CLR	a_CSP0x05_B0
			CLR	a_IP0x71_B0
			CLR	a_IP0x71_B1
			CLR	a_IP0x71_B2
			CLR	a_IP0x71_B3
			CLR	a_IP0x71_B4
			CLR	a_IP0x71_B5
			CLR	a_IP0x71_B6
			CLR	a_ExIP0x81_B0
			CLR	a_ExIP0x81_B1
			CLR	a_ExIP0x81_B2
			CLR	a_ExIP0x81_B3
			CLR	a_ExIP0x81_B4
			CLR	a_ExIP0x81_B5
			CLR	a_ExIP0x81_B6
			CLR	a_ExIP0x81_B7
			CLR	a_Config0x51_B0
			CLR	a_Config0x51_B2
			CLR	a_Config0x51_B3
			CLR	fg_Idet
			CLR	fg_ExIdet0x81
			CLR	fg_0x51PowClass
			CLR	fg_PCH0x06Abnor
			CLR	fg_0x02PowDownChargeComplete
			CLR	fg_0x02PowDownReconfigure
			CLR	fg_0x02PowDownNoResponse
			SET	a_StatusEndPower
			CLR	a_OptConfiCNT
			SET	fg_Tdelay
			MOV	A, 005H
			MOV	a_PCHO0x06_B0, A
			CLR	a_0x03ContlErr
			CLR	a_0x04ReceivedPow
			CLR	a_0x04ReceivedPowPre
			CLR	a_0x06TdelayML
			CLR	a_0x06TdelayMH
			CLR	a_0x51PowMax
			CLR	fg_0x51NonPID
			CLR	fg_0x04OutReceiPowTime
			CLR	fg_EndPowDown
			CLR	fg_CEinput
			CLR	fg_ReCordTemp
			CLR	fg_CalTempTimeHigh
			CLR	fg_PowOver5wLEDsw
			CLR	fg_RecodeRPpre
			CLR	fg_RPNoStable
			SET	fg_INT_AD
			CLR	a_ADRHbuffer
			CLR	a_ADRLbuffer
		SkipStart:
			SZ	fg_NoChange
			JMP	SkipEnd
			MOV	A, 008H
			MOV	a_r_DetectCNT, A
			CLR	fg_RXCoilD
		SkipEnd:
			CALL	CLRMath
			CLR	a_temp2
			CLR	a_temp1
			CLR	a_temp0
			SET	fg_PIDIni
			CLR	a_IL
			CLR	a_IM0
			CLR	a_IM1
			CLR	a_VL
			CLR	a_VM0
			CLR	a_VM1
			CLR	a_EL
			CLR	a_EM
			CLR	a_EH
			MOV	A, c_IniSv161_180N0
			MOV	a_Sv, A
			CLR	fg_start
			CLR	fg_IterationStart
			MOV	A, 009H
			MOV	a_LoopIteration, A
			MOV	A, c_IniReceiPowCNTL
			MOV	a_0x04ReceiPowCNTL, A
			MOV	A, c_IniReceiPowCNTH
			MOV	a_0x04ReceiPowCNTH, A
			SZ	a_0x04ReceiPowCNTH
			SET	fg_0x04ReceiPowCNTHflag
			
			CLR	fg_0x04ReceiPowCNTHflag
			CLR	fg_adc_avg_cnt
			CLR	a_ParPLLFHpre
			CLR	a_ParPLLFLpre
			CLR	fg_FODTemp60
			CLR	fg_IsenSmall
			CLR	fg_IsenBig
			CLR	fg_WaitNextCE
			CLR	fg_CEThr
			CLR	fg_CEThrPana
			CLR	fg_PLLThr
			CLR	fg_IsenFirst
			CLR	fg_PLLDown
			CLR	fg_PLLPana
			CLR	fg_DetectVin
			CLR	fg_VinLow
			CLR	fg_PSVin
			CLR	fg_PLL205
			CLR	fg_DTCPR
			CLR	fg_DTCPRmin
			SET	fg_Ping
			CLR	fg_FODEfficLow   
			MOV	A, 00AH
			MOV	a_r_RPowCNT, A
			CLR	fg_DemoDetect
			CLR	fg_DemoDetectTimeOut
			CLR	fg_RxTI
			CLR	fg_RxPana
;-----------------------INT setting------------------------
	TestRepeat:
			;MOV	A, 00CH				; set INTEG = 0000_1100 = 0Ch
			;MOV	A, 000H
			;MOV	INTEG, A			; INTEG @SPDM 30H (POR=----_0000, WDT Out=----_0000)
			MOV	A, 002H				; set INTC0 = 0000_0010 = 02h, as OCPE
			MOV	INTC0, A			; INTC0 @SPDM 10H (POR=-000_0000, WDT Out=-000_0000)

			MOV	A, 00BH				; set INTC1 = 0000_1011 = 02h, as ADE, MF1E, MF0E ON(TM0/STM and TM1/CTM enable INT)
			MOV	INTC1, A			; INTC1 @SPDM 31H (POR=0000_0000, WDT Out=0000_0000)

			;MOV	A, 008H				; set INTC2 = 0000_1000 = 08h, as INT1E ON
			;MOV	INTC2, A			; INTC2 @SPDM 32H (POR=0000_0000, WDT Out=0000_0000)

			MOV	A, 002H				; set MFI0 = 0000_0010 = 02h, as T0AE ON
			MOV	MFI0, A				; MFI0 @SPDM 33H (POR=--00_--00, WDT Out=--00_--00)

			MOV	A, 002H				; set MFI1 = 0000_0010 = 02h, as T1AE ON
			MOV	MFI1, A				; MFI1 @SPDM 34H (POR=--00_--00, WDT Out=--00_--00)

;========================================================
;Function : Main Function Program  
;Note     : 
;========================================================
;--------------------Qi Selection Phase----------------------
	Phase_Selection:
			CLR 	WDT
	PS_VCOstart:
			SET	CKGEN.7					; 1 as VCO ON
	PS_EMIstart:
			CLR	INTC0.5
			CLR	INTC2.7
			SET	INTC0.1					; 1 as OCPE ON
			;SET	INTC0.2					; DEME-bit = 1 as Demodulation ON
			SET	INTC0.0					; 1 as EMI ON
	PS_WaitVCO_DTin:
			MOV	A, c_IniWVCOMutipleTimeL
			MOV	a_MutipleTimeLCTM, A
			MOV	A, c_IniWVCOMutipleTimeH
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM

	PS_WaitVCO_DTFunc:
			;Waiting for VCO Stable Time
			CALL	DelayTimer
	PS_DetectVin:
			CALL	DetectVin
			SNZ	fg_DetectVin
			JMP	PS_Remind

			CALL	LightDark
			JMP	PS_DetectVin
	PS_Remind:
		        SET	fg_PSVin
	PS_Detection:
			CALL	ObjectDetection
	Phase_SelectionEnd:		
			MOV	A, c_IniCTMTimeBaseL1			; set TM1AL = 1111_1010 = FAh for 50us
			MOV	TM1AL, A				; TM1AL @SPDM 4DH (POR=0000_0000, WDT Out=0000_0000)
 			MOV	A, c_IniCTMTimeBaseH1			; set TM1AH = 0000_0000 = 00h
			MOV	TM1AH, A				; TM1AH @SPDM 4EH (POR=----_--00, WDT Out=----_--00)
			MOV	A, 053H
			MOV	PWMC, A
			
;----------------------Qi Ping Phase-------------------------
	Phase_Ping:		
	PP_Tping:			
			SET	fg_TimeOut
			MOV	A, c_IniDiPingMutipleTimeL		; Tping <= 70ms
			MOV	a_MutipleTimeLSTM, A
			MOV	A, c_IniDiPingMutipleTimeH
			MOV	a_MutipleTimeHSTM, A
			SZ	a_MutipleTimeHSTM
			SET	fg_MutipleTimeHflagSTM

			SET	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			SET	TM0C0.3					; TM0C0[3] (T0ON-bit) = 1 as TM0 ON
			CALL	DemoVI1I2swEN        
			CALL	ReciPackageDataUnitPreee1
			SNZ	fg_TimeOut
			JMP	Status_DetectNoise

			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
	PP_Tfirst:
			SET	fg_TimeOut
			MOV	A, c_IniPingTfirstMutipleTimeL		; Tfirst <= 20ms
			MOV	a_MutipleTimeLSTM, A
			MOV	A, c_IniPingTfirstMutipleTimeH
			MOV	a_MutipleTimeHSTM, A
			SZ	a_MutipleTimeHSTM
			SET	fg_MutipleTimeHflagSTM
			SET	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			SET	TM0C0.3					; TM0C0[3] (T0ON-bit) = 1 as TM0 ON
	PP_Tfirst1:
			CALL	ReciPackageDataUnit
			CALL	DemoVI1I2swDisEN
			SNZ	fg_TimeOut				; for PP timing
			JMP	Status_DetectNoise
			
			SNZ	fg_ChecksumBit
			JMP	Status_PowerDown

			CALL	ExtractPacData
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			SET	fg_TimeOut
	PP_ErrData:
			SZ	fg_PacDataOK
			JMP	Status_PowerDown

			SET	fg_PacDataOK
	PP_SignalStregth:		
			MOV	A, a_DataHeader
			XOR	A, 001H
			SNZ	STATUS.2
			JMP	PP_EndPackage

			MOV	A, a_DataMessageB0
			MOV	a_SSP0x01_B0, A
			JMP	Phase_IdentConfi
	PP_EndPackage:		
			MOV	A, a_DataHeader
			XOR	A, 002H
			SNZ	STATUS.2
			JMP	Status_PowerDown
			
			CALL	EndPowCMD0x02Decode
			SZ	fg_EndPowDown				; for PP timing
			JMP	Status_PowerDown
		
;----------Qi Identification & Configuration Phase-----------
	Phase_IdentConfi:
			CLR	fg_0x02PowDownReconfigure
			CLR	fg_CEinput
	PIC_Tnext:
			CLR WDT
			SET	fg_TimeOut
			MOV	A, c_IniIdeConTnextMutipleTimeL		; Tnext <= 21ms
			MOV	a_MutipleTimeLSTM, A
			MOV	A, c_IniIdeConTnextMutipleTimeH
			MOV	a_MutipleTimeHSTM, A
			SZ	a_MutipleTimeHSTM
			SET	fg_MutipleTimeHflagSTM

			SET	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			SET	TM0C0.3					; TM0C0[3] (T0ON-bit) = 1 as TM0 ON
			CALL	DemoVI1I2swEN
			CALL	ReciPackageDataUnitPreee1
			SNZ	fg_TimeOut
			JMP	Status_PowerDown

			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
	PIC_Tmax:
			SET	fg_TimeOut
			MOV	A, c_IniIdeConTmaxMutipleTimeL		; Tmax <= 170ms
			MOV	a_MutipleTimeLSTM, A
			MOV	A, c_IniIdeConTmaxMutipleTimeH
			MOV	a_MutipleTimeHSTM, A
			SZ	a_MutipleTimeHSTM
			SET	fg_MutipleTimeHflagSTM

			SET	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			SET	TM0C0.3					; TM0C0[3] (T0ON-bit) = 1 as TM0 ON
	PIC_Tmax1:
			CALL	ReciPackageDataUnit
			CALL	DemoVI1I2swDisEN
			SNZ	fg_TimeOut
			JMP	Status_PowerDown

			SZ	fg_DataByteCNTFull
			JMP	PIC_Tmax2
			
			SNZ	fg_ChecksumBit
			JMP	Status_PowerDown ;;LAB test
	PIC_Tmax2:		
			CALL	ExtractPacData
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			SET	fg_TimeOut
	PIC_ErrData:
			SZ	fg_DataByteCNTFull
			JMP	PIC_IdentPac0x71			
			
			SZ	fg_PacDataOK
			JMP	Status_PowerDown
			;JMP	PIC_TmaxReCheck
			SET	fg_PacDataOK
			
	PIC_IdentPac0x71:
			CLR WDT
			CLR	fg_DataByteCNTFull
			SZ	fg_Idet
			JMP	PIC_PowContlHoldOffPac0x06
			
			SZ	fg_ExIdet0x81
			JMP	PIC_ExIdentPac0x81

			MOV	A, a_DataHeader
			XOR	A, 071H
			SNZ	STATUS.2
			JMP	Status_PowerDown
		
			MOV	A, a_DataMessageB0
			MOV	a_IP0x71_B0, A
			MOV	A, a_DataMessageB1
			MOV	a_IP0x71_B1, A
			MOV	A, a_DataMessageB2
			MOV	a_IP0x71_B2, A
			SZ	a_IP0x71_B1
			JMP	PIC_IdentPac0x71_TI

			XOR	A, 010H
			SZ	STATUS.2
			SET	fg_RxTI
		PIC_IdentPac0x71_TI:
			MOV	A, a_IP0x71_B1
			XOR	A, 034H
			SNZ	STATUS.2
			JMP	PIC_IdentPac0x71_Conti

			MOV	A, a_IP0x71_B2
			XOR	A, 033H
			SZ	STATUS.2
			SET	fg_RxPana
		PIC_IdentPac0x71_Conti:
			MOV	A, a_DataMessageB3
			MOV	a_IP0x71_B3, A
			MOV	A, a_DataMessageB4
			MOV	a_IP0x71_B4, A
			MOV	A, a_DataMessageB5
			MOV	a_IP0x71_B5, A
			MOV	A, a_DataMessageB6
			MOV	a_IP0x71_B6, A
			SNZ	a_IP0x71_B3.7
			JMP	PIC_IdentPac0x71_1

			SET	fg_ExIdet0x81
			JMP	PIC_Tnext
	PIC_IdentPac0x71_1:
			SET	fg_Idet
			JMP	PIC_Tnext	
	PIC_ExIdentPac0x81:
			MOV	A, a_DataHeader
			XOR	A, 081H
			SNZ	STATUS.2
			JMP	Status_PowerDown
		
			MOV	A, a_DataMessageB0
			MOV	a_ExIP0x81_B0, A
			MOV	A, a_DataMessageB1
			MOV	a_ExIP0x81_B1, A
			MOV	A, a_DataMessageB2
			MOV	a_ExIP0x81_B2, A
			MOV	A, a_DataMessageB3
			MOV	a_ExIP0x81_B3, A
			MOV	A, a_DataMessageB4
			MOV	a_ExIP0x81_B4, A
			MOV	A, a_DataMessageB5
			MOV	a_ExIP0x81_B5, A
			MOV	A, a_DataMessageB6
			MOV	a_ExIP0x81_B6, A
			MOV	A, a_DataMessageB7
			MOV	a_ExIP0x81_B7, A
			SET	fg_Idet
			CLR	fg_ExIdet0x81
			JMP	PIC_Tnext
	PIC_PowContlHoldOffPac0x06:
			MOV	A, a_DataHeader
			XOR	A, 071H
			SZ	STATUS.2
			JMP	Status_PowerDown

			MOV	A, a_DataHeader
			XOR	A, 006H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac
			
			INC	a_OptConfiCNT
			MOV	A, a_DataMessageB0
			MOV	a_PCHO0x06_B0, A
			CLR	fg_Tdelay
			JMP	PIC_Tnext
	PIC_ProprietaryPac:
			MOV	A, a_DataHeader
			XOR	A, 018H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac1
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac1:
			MOV	A, a_DataHeader
			XOR	A, 019H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac2
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac2:
			MOV	A, a_DataHeader
			XOR	A, 028H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac3
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac3:
			MOV	A, a_DataHeader
			XOR	A, 029H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac4
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac4:
			MOV	A, a_DataHeader
			XOR	A, 038H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac5
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac5:
			MOV	A, a_DataHeader
			XOR	A, 048H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac6
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac6:
			CLR WDT
			MOV	A, a_DataHeader
			XOR	A, 058H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac7
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac7:
			MOV	A, a_DataHeader
			XOR	A, 068H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac8
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac8:
			MOV	A, a_DataHeader
			XOR	A, 078H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac9
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac9:
			MOV	A, a_DataHeader
			XOR	A, 084H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac10
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac10:
			MOV	A, a_DataHeader
			XOR	A, 0A4H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac11
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac11:
			MOV	A, a_DataHeader
			XOR	A, 0C4H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac12
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac12:
			MOV	A, a_DataHeader
			XOR	A, 0E2H
			SNZ	STATUS.2
			JMP	PIC_ProprietaryPac13
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ProprietaryPac13:
			MOV	A, a_DataHeader
			XOR	A, 0F2H
			SNZ	STATUS.2
			JMP	PIC_ReservPac
			
			INC	a_OptConfiCNT
			JMP	PIC_Tnext
	PIC_ReservPac:
			MOV	A, a_DataHeader
			XOR	A, 051H
			SNZ	STATUS.2
			JMP	PIC_ReservPac0

			JMP	PIC_Config0x51
	PIC_ReservPac0:
			INC	a_OptConfiCNT
			JMP	Status_PowerDown
	PIC_Config0x51:
			CLR WDT
			MOV	A, a_DataMessageB0
			MOV	a_Config0x51_B0, A
			MOV	A, a_DataMessageB2
			MOV	a_Config0x51_B2, A
			MOV	A, a_DataMessageB3
			MOV	a_Config0x51_B3, A
			MOV	A, a_Config0x51_B2
			AND	A, 007H
			XOR	A, a_OptConfiCNT
			SNZ	STATUS.2
			JMP	Status_PowerDown
		
			CLR	a_OptConfiCNT
			CALL	ConfigCMD0x51Decode
			SNZ	fg_Tdelay
			JMP	PIC_Config0x51_1
			
			MOV	A, 005H
			MOV	a_PCHO0x06_B0, A
	PIC_Config0x51_1:
			;CLR WDT
			SET	fg_Tdelay
			CALL	PowContlHoldCMD0x06Decode
			
			SZ	fg_PCH0x06Abnor
			JMP	Status_PowerDown
			
				
;------------------Qi Power Transfer Phase-------------------Power Transfer
	Phase_PowerTrans:
			CLR	fg_Ping
	PPT_Ttimeout0:
			SET	fg_TimeOut
			CALL	SetTimer1				; Ttimeout <= 1800ms
			SET	TM0C0.3																; TM0C0[3] (T0ON-bit) = 1 as TM0 ON;????????check
			CALL	DemoVI1I2swEN
			CALL	ReciPackageDataUnitPreee1
			SNZ	fg_TimeOut
			JMP	Status_PowerDown

			CLR	TM0C0.3																; 1 as TM0 ON;(2014/05/15)
			SET	fg_TimeOut
			CALL	SetTimer1				; Ttimeout <= 1800ms
			SET	TM0C0.3																; TM0C0[3] (T0ON-bit) = 1 as TM0 ON;????????check
			CALL	ReciPackageDataUnit
			CALL	DemoVI1I2swDisEN
			SNZ	fg_ChecksumBit
			JMP	PPT_Recheck
			
			CALL	ExtractPacData
	PPT_ErrDataCheck0:
			SZ	fg_PacDataOK
			JMP	PPT_Recheck

			SET	fg_PacDataOK
			CLR	TM0C0.3															; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			SET	fg_TimeOut
	PPT_Command:				
			CALL	PT_DecodeCommand
			SZ	fg_0x02PowDownReconfigure
			JMP	Phase_IdentConfi

			SZ	fg_EndPowDown
			JMP	Status_PowerDown
	PPT_Recheck:
			SZ	fg_CEinput
			CALL	PT_ReceiPowerCNT

			MOV	A, 00AH
			MOV	a_ExIP0x81_B0, A
			CLR	PB.2					;Green LED
			SET	PB.3					;Red LED
	PPT_Nor:																			;----------?????????check
			CLR WDT
			SNZ	fg_CEinput				; To check first data for CE or RP
			JMP	PPT_NextPac
			SET	fg_TimeOut

			MOV	A, a_0x06TdelayML			; 5ms <= Tdelay <= 205ms
			MOV	a_MutipleTimeLCTM, A
			MOV	A, a_0x06TdelayMH
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM
	PPT_Tdelay:
			CALL	DelayTimer
	PPT_CellCurrJ:		
			CALL	PID_SenPriCoilCurrWay65Double
	PPT_Tactive:
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			SET	fg_TimeOut
			MOV	A, c_IniPowTrTactMutipleTimeL		; Tactive <= 21ms
			MOV	a_MutipleTimeLSTM, A
			MOV	A, c_IniPowTrTactMutipleTimeH
			MOV	a_MutipleTimeHSTM, A
			SZ	a_MutipleTimeHSTM
			SET	fg_MutipleTimeHflagSTM

			SET	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			SET	TM0C0.3					; TM0C0[3] (T0ON-bit) = 1 as TM0 ON
			
			;---PID Algorithm & Fpwm Output---
			SZ	fg_0x51NonPID
			JMP	PPT_TactiveNoPID

			;JMP	PPT_TactivePID
		PPT_TactivePID:
			CALL	PT_PIDCE4
		PPT_TactivePID1:
;			;;~~~FOD Temperture Check~~~
			SZ	fg_PLLDown
			JMP	PPT_TactiveCheck

			SZ	fg_PLLPana
			JMP	PPT_TactiveCheck
			
			SZ	a_0x03ContlErr
			JMP	PPT_TactivePID_Cal
			
			;; CNT=2, 5
			SDZ	a_ExIP0x81_B0
			JMP	PPT_TactiveCheck

			SET	fg_PLLDown
			SZ	fg_CEThrPana
			SET	fg_PLLPana

			MOV	A, 00AH
			MOV	a_ExIP0x81_B0, A
			JMP	PPT_TactiveCheck
		PPT_TactivePID_Cal:	
			SZ	fg_VinLow
			JMP	PPT_TactiveCheck

			;JMP	PPT_TactivePID_Cal0
		PPT_TactivePID_Cal0:
			CALL	PT_PIDandPWM
			JMP	PPT_TactiveCheck
		PPT_TactiveNoPID:
			JMP	Status_PowerDown
		PPT_TactiveCheck:	
			CLR WDT
			SNZ	fg_TimeOut
			JMP	Status_PowerDown
	PPT_Tsettle:
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF (STM)
			MOV	A, c_IniPowTrTsettleMutipleTimeL	; Tsettle min = 3ms
			MOV	a_MutipleTimeLCTM, A
			MOV	A, c_IniPowTrTsettleMutipleTimeH
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM

			CALL	DelayTimer
	PPT_NextPac:
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF (STM)
			SET	fg_TimeOut
			CALL	SetTimer2
			SET	TM0C0.3					; TM0C0[3] (T0ON-bit) = 1 as TM0 ON (STM)
			SET	fg_DemoDetect
	PPT_NextPac1:
			CLR	WDT
			SZ	fg_CEinput
			CALL	PT_ReceiPowerCNT
	PPT_DetectVin:
			CALL	DetectVin
	;;~~~Enable INT for Demodulation SW ~~~			
	PPT_DemoVI1I2sw3:
			CLR 	WDT			
			CALL	DemoVI1I2swEN
			CALL	ReciPackageDataUnitPreee1
			SZ	fg_DemoDetectTimeOut
			JMP	PPT_DemoVI1I2sw4

			SNZ	fg_TimeOut
			JMP	Status_PowerDown

			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			SET	fg_TimeOut
			CALL	SetTimer2
			SET	TM0C0.3					; TM0C0[3] (T0ON-bit) = 1 as TM0 ON;
			CALL	ReciPackageDataUnit
	;;~~~disenable INT for Demodulation SW ~~~			
	PPT_DemoVI1I2sw4:
			CALL	DemoVI1I2swDisEN
			SZ	fg_DemoDetectTimeOut
			JMP	PPT_DemoVI1I2Select2

			SNZ	fg_TimeOut
			JMP	Status_PowerDown

			CALL	ExtractPacData
	PPT_ErrDataCheck2:
			SZ	fg_DataByteCNTFull
			JMP	PPT_ErrDataCheck3
			
			SZ	fg_PacDataOK
			JMP	PPT_DemoVI1I2Select2_1
			
			SET	fg_PacDataOK
	PPT_ErrDataCheck3:
			CLR	fg_DataByteCNTFull
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			SET	fg_TimeOut
			JMP	PPT_Command2
				
	;;~~~Demodulation SW~~~
	PPT_DemoVI1I2Select2:
			CLR	fg_DemoDetectTimeOut
			CALL	DemoVI1I2Select
			JMP	PPT_DemoVI1I2sw3
	
	PPT_DemoVI1I2Select2_1:
			CALL	DemoVI1I2Select
			JMP	PPT_NextPac
				
	PPT_Command2:
			CALL	PT_DecodeCommand
			CLR	fg_DemoDetectTimeOut
			SNZ	fg_0x02PowDownReconfigure
			JMP	PPT_Command21

			SNZ	fg_VinLow
			JMP	Phase_IdentConfi

			JMP	Status_PowerDown
	PPT_Command21:
			SZ	fg_FODTemp60					; Temp 60 Check
			JMP	Status_PowerDown

			SZ	fg_EndPowDown
			JMP	Status_PowerDown
			
			SZ	fg_FODEfficLow			
			JMP	Status_PowerDown
	Phase_PowerTransEnd:		
			JMP	PPT_Nor


;---------------------Qi Power Down Status-------------------Go Back to Selection and Power OFF 
	Status_DetectNoise:
			CLR WDT
			CALL	Delay1
			MOV	A, 050H
			MOV	PWMC, A
			CLR	INTC0.2					; DEME-bit = 0 as Demodulation OFF
			CLR	DEMC0					; Demodulation OFF
			CLR	INTC0.5
			MOV	A, 008H
			MOV	a_r_DetectCNT, A
			CLR	CKGEN.7					; 1 as VCO OFF
			CLR	INTC0.0					; 0 as EMI OFF
			HALT
	Status_PowerDown:
			SET	PA.5
			MOV	A, 03EH
			MOV	PLLFL, A
			MOV	A, 003H
			MOV	PLLFH, A
			MOV	A, c_IniPIDMutilpleTimeL
			MOV	a_MutipleTimeLCTM, A
			MOV	A, c_IniPIDMutilpleTimeH
			MOV	a_MutipleTimeHCTM, A
			SZ	a_MutipleTimeHCTM
			SET	fg_MutipleTimeHflagCTM

			CALL	DelayTimer
			CLR WDT
			MOV	A, 050H					;  PWM output OFF
			MOV	PWMC, A
			CLR	INTC0.2					; DEME-bit = 0 as Demodulation OFF
			CLR	DEMC0					; Demodulation OFF
			CLR	INTC0.5
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			SET	fg_TimeOut
			CALL	Delay1
			SZ	fg_0x02PowDownChargeComplete
			JMP	PD_AbnormalLight
			
			SZ	fg_0x02PowDownNoResponse
			JMP	PD_AbnormalLight
			
			SZ	fg_0x02PowDownReconfigure
			JMP	PD_AbnormalLight
			
			SZ	fg_FODTemp60
			JMP   	PD_AbnormalLight
			
			SZ	fg_FODEfficLow
			JMP	PD_AbnormalLight	

			JMP	PD_PWMDown
	PD_AbnormalLight:
			SZ	fg_0x02PowDownReconfigure
			JMP	PD_PowerDownEnd
						
			SZ	fg_0x02PowDownNoResponse
			JMP	PD_PowerDownEnd
			
			CALL	LightDark			
			JMP	PD_PowerDownEnd
	PD_PWMDown:
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			SET	fg_TimeOut
	PD_LightWarningEnd:
			CLR WDT
			CLR	PB.3					;; Red LED
			SET	PB.2					;; Green LED
			CALL	Delay3
			CALL	Delay3
			SZ	fg_Ping
			JMP	PP_Repeat	
	PD_PowerDownEnd:
			CLR WDT
			CLR	PB.3					;; Red LED
			SET	PB.2					;; Green LED

			;;Detect Object to leave
			SZ	fg_0x02PowDownChargeComplete
			CALL	ObjectDetectLeave
			
			SZ	fg_0x02PowDownReconfigure
			CALL	ObjectDetectLeave
			
			SZ	fg_0x02PowDownNoResponse
			CALL	ObjectDetectLeave

			CLR	CKGEN					; 0 as VCO OFF
			CLR	INTC0.0					; 0 as EMI OFF
			MOV	A, 007H
			MOV	WDTC, A
	PP_Repeat:
			MOV	A, 008H
			MOV	a_r_DetectCNT, A
			CALL	DemoVI1I2Select
			SET	INTC0.5
			CLR	CKGEN.7					; 1 as VCO OFF
			CLR	INTC0.0					; 0 as EMI OFF
			HALT

;========================================================
;Function : LightDark
;Note     : Call Function Type for Light dark
;		input = No Need

;		output = No Need
;Presetting:
;		(1) Setting WDTC reg. for Period Timing
;		(2) Setting c_IniDetectMutipleTimeH/L
;		(3) Setting OCP INT ON/OFF
;========================================================
	LightDark:
			MOV	A, 005H;;003h
			MOV	a_com1, A
	PS_LightDarkRepeat:		
			CLR	WDT    
			SZ	fg_0x02PowDownChargeComplete
			JMP	LightDarkGreen0
	LightDarkBoth0:
			CLR	PB.3					;;Red LED
			CLR	PB.2					;;Green LED
			JMP	LightDarkend0
	LightDarkGreen0:
			CLR	PB.2					;;Green LED
		;	CLR	PB.3					;;Red LED
	LightDarkend0:
			CALL	Delay3
			SZ	fg_0x02PowDownChargeComplete
			JMP	LightDarkGreen1
	LightDarkBoth1:
			SET	PB.3					;;Red LED
			SET	PB.2					;;Green LED
			JMP	LightDarkend1
	LightDarkGreen1:
			SET	PB.2					;;Green LED
	LightDarkend1:
			CALL	Delay3
			
			SDZ	a_com1
			JMP	PS_LightDarkRepeat
			
			CLR	a_com1
			RET


;========================================================
;Function : ISR 
;Note     : 
;========================================================
	;---------------------OCP---------------------
	ISR_OCP:
			MOV	A, 050H
			MOV	PWMC, A
			NOP
			RETI
			
	;-----------Demodulation Interrupt------------
	ISR_DeMod:
			CLR WDT
			CLR	fg_FlagDemo
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 0 as TM1 OFF		
			RETI
			
	;------------External Interrupt 0-------------
	ISR_ExInt0:
			CLR	fg_INT0
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 0 as TM1 OFF
			CLR 	WDT
			RETI
				
	;--------MultiFunction0 Interrupt for TM0(STM)------
	ISR_MultiFun_TM0:
			CLR	MFI0.5					; MFI0[5] (T0AF-bit) = 0 as clear A match interrupt request flag
			CLR	fg_BaseTimeSTM				; TM0(STM) basetime flag reset
			CLR	TM0C0.3					; TM0C0[3] (T0ON-bit) = 0 as TM0 OFF
			CALL	TimeOutTimer
			SNZ	fg_0x04OutReceiPowTime
			RETI
		
			CLR	fg_TimeOut
			RETI

	
	;--------MultiFunction1 Interrupt for TM1(CTM)------
	ISR_MultiFun_TM1:
			CLR	MFI1.5					; MFI1[5] (T1AF-bit) = 0 as clear A match interrupt request flag
			CLR	fg_BaseTimeCTM				; TM1(CTM) basetime flag reset
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 0 as TM1 OFF
			CLR 	WDT
			RETI
	
	;---MultiFunction2 Interrupt for LVD / EEPROM---
	ISR_MultiFun_LVD_EEP:
			RETI
	
	;------------------ADC Interrupt----------------
	ISR_ADC:
			CLR	fg_INT_AD
			CLR 	WDT
			RETI
				
	;------------------IIC Interrupt----------------
	ISR_IIC:
			RETI
				
	;--------------Time Base 0 Interrupt------------
	ISR_TimeBase0:
			CLR	TBC0.7					;; Time Base0 OFF
			RETI
				
	;--------------Time Base 1 Interrupt------------
	ISR_TimeBase1:
			RETI
				
	;--------------External Interrupt 1-------------
	ISR_ExInt1:
			CLR	fg_INT1
			CLR	TM1C0.3					; TM1C0[3] (T1ON-bit) = 0 as TM1 OFF
			CLR 	WDT
			RETI


end
