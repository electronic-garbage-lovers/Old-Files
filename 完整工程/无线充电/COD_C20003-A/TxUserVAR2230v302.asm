;*******************************************************************************************
;*****	                          Parameters Claim                                     *****
;*******************************************************************************************
User_Data_Ram	.Section	at 080H		'data'		;HT66FW2230
;===========================================================================================
;Function :   PLL claim
;Note     : 	0 bit, 2 byte
;===========================================================================================
			a_ParPLLFH				DB	?
			a_ParPLLFL				DB	?
	

;===========================================================================================
;Function :   CTM claim
;Note     : 	2 bit, 2 byte
;===========================================================================================
			fg_BaseTimeCTM				DBIT
			fg_MutipleTimeHflagCTM			DBIT
			a_MutipleTimeLCTM			DB	?
			a_MutipleTimeHCTM			DB	?

;===========================================================================================
;Function :   STM claim
;Note     : 	3 bit, 2 byte
;===========================================================================================
			fg_BaseTimeSTM				DBIT
			fg_MutipleTimeHflagSTM			DBIT
			fg_TimeOut				DBIT
			a_MutipleTimeLSTM			DB	?
			a_MutipleTimeHSTM			DB	?

;===========================================================================================
;Function :   Demodulation claim
;Note     : 	1 bit, 0 byte
;===========================================================================================
			fg_FlagDemo				DBIT
			a_DemoV_I1_I2				DB	?
			
;===========================================================================================
;Function :   INT1_Demodulation claim
;Note     : 	16 bit, 34 byte
;===========================================================================================
			fg_INT1					DBIT
			fg_INT0					DBIT
			fg_DUDataStart				DBIT
			fg_DU					DBIT
			fg_StartBit				DBIT
			fg_ParityBit				DBIT
			fg_ParityErr				DBIT
			fg_StopBit				DBIT
			fg_WaitDataOut				DBIT
			fg_StopBitPre				DBIT
			fg_DataFirst				DBIT
			fg_Preamble				DBIT
			fg_ChecksumBit				DBIT

			fg_PacDataOK				DBIT
			fg_StartReci				DBIT

			fg_DataByteCNTFull			DBIT
			                                	
			a_StatusCntInt1				DB	?

			a_DataOUTtemp				DB	?
			a_DataParityCNT				DB	?
			a_TimeOutCNT				DB	?
			a_DataOUT				DB	10	dup (?)

			a_DataCNT				DB	?
			                                	
			a_Preamble4BitCNT			DB	?
			a_Preamble25BitCNT			DB	?
			                                	
			a_NoToggleCNT				DB	?
			a_DataByteCNT				DB	?
			a_DataByteCNTtemp			DB	?
			a_AddrDataOUT				DB	?
			a_HeadMessageCNT			DB	?
			a_ContlDataMessag			DB	?



			a_DataHeader				DB	?       ;;Sensor Primary Coil Current Data
			a_DataMessageB0				DB	?       ;;Sensor Primary Coil Current Data
			a_DataMessageB1             		DB	?       ;;Sensor Primary Coil Current Data
			a_DataMessageB2             		DB	?       ;;Sensor Primary Coil Current Data
			a_DataMessageB3             		DB	?	;;Sensor Primary Coil Current Data
			a_DataMessageB4             		DB	?	;;Sensor Primary Coil Current Data 
			a_DataMessageB5             		DB	?	;;Sensor Primary Coil Current Data 
			a_DataMessageB6             		DB	?	;;Sensor Primary Coil Current Data 
			a_DataMessageB7             		DB	?	;;Sensor Primary Coil Current Data 
			a_DataChecksum				DB	?	;;Sensor Primary Coil Current Data
			                                	
			a_XORchecksum				DB	?


;===========================================================================================
;Function :   AD claim
;Note     : 	1 bit, 2 byte
;===========================================================================================
			fg_INT_AD				DBIT
			                                	
			a_ADRHbuffer				DB	?
			a_ADRLbuffer				DB	?

;===========================================================================================
;Function :   Math claim
;Note     : 	0 bit, 24 byte
;===========================================================================================
			a_com1					DB	?
			a_com2					DB	?
			a_com3					DB	?
			a_com4					DB	?
			;a_com5					DB	?
			
			a_data0					DB	?
			a_data1					DB	?
			a_data2					DB	?
			a_data3					DB	?
			a_data4					DB	?
			a_data5					DB	?
			a_data6					DB	?
			a_data7					DB	?

			a_to0					DB	?
			a_to1					DB	?
			a_to2                                   DB	?
			a_to3                                   DB	?
			a_to4                                   DB	?
			a_to5                                   DB	?
			a_to6                                   DB	?
			a_to7                                   DB	?
			a_count0				DB	?
			;a_temp3				DB	?
			a_temp2                                 DB	?
			a_temp1                                 DB	?
			a_temp0                                 DB	?
			
			
;===========================================================================================
;Function :   PID claim
;Note     : 	4 bit, 11 byte
;===========================================================================================
			fg_PIDIni				DBIT
			fg_start				DBIT
			fg_IterationStart			DBIT
			fg_FODTemp60				DBIT
			a_IL              	   		DB	?
			a_IM0                 			DB	?
			a_IM1                 			DB	?
			;a_IH					DB	?
			a_VL					DB	?
			a_VM0					DB	?
			a_VM1					DB	?
			;a_VH					DB	?
			a_EL					DB	?
			a_EM					DB	?
			a_EH					DB	?
			a_Sv					DB	?
			a_LoopIteration				DB	?
					
;===========================================================================================
;Function :   Phase claim
;Note     : 	42 bit, 38 byte
;===========================================================================================
			;fg_0x02PowDownUnknown			DBIT
			fg_0x02PowDownChargeComplete        	DBIT
			;fg_0x02PowDownInternalFault         	DBIT
			;fg_0x02PowDownOverTemp              	DBIT
			;fg_0x02PowDownOverVoltage           	DBIT
			;fg_0x02PowDownOverCurrent           	DBIT
			;fg_0x02PowDownBatteryFail           	DBIT
			fg_0x02PowDownReconfigure           	DBIT
			fg_0x02PowDownNoResponse            	DBIT
			;fg_0x02PowDownReserved              	DBIT
			fg_ExIdet0x81				DBIT
			fg_Idet					DBIT
			fg_Tdelay				DBIT
			fg_0x04OutReceiPowTime			DBIT
			fg_0x51PowClass				DBIT
			fg_0x51NonPID				DBIT
			fg_EndPowDown				DBIT
			fg_CEinput				DBIT
			fg_0x04ReceiPowCNTHflag			DBIT
			fg_PSVin				DBIT
			fg_PCH0x06Abnor				DBIT
			fg_RecodeRPpre				DBIT
			fg_RPNoStable				DBIT
			fg_adc_avg_cnt				DBIT
		    	fg_RXCoilD				DBIT
		    	fg_NoChange				DBIT
		    	fg_IsenSmall				DBIT
		    	fg_IsenBig				DBIT
		    	fg_WaitNextCE				DBIT
		    	fg_CEThr				DBIT
		    	fg_CEThrPana				DBIT
			fg_IsenFirst				DBIT
			fg_PLLDown				DBIT
			fg_PLLPana				DBIT
			fg_DetectVin				DBIT
			fg_VinLow				DBIT
			fg_PLL205				DBIT
			fg_DTCPR				DBIT
			fg_DTCPRmin				DBIT
			fg_PLLThr				DBIT
			fg_Ping					DBIT
			fg_FODEfficLow				DBIT
			fg_ReCordTemp				DBIT
			fg_CalTempTimeHigh			DBIT
			fg_PowOver5wLEDsw			DBIT
			fg_DemoDetect				DBIT
			fg_DemoDetectTimeOut			DBIT
   			fg_RxTI					DBIT
    			fg_RxPana				DBIT
			a_SSP0x01_B0				DB	?
			a_CSP0x05_B0				DB	?
			a_PCHO0x06_B0				DB	?
			a_Config0x51_B0				DB	?
			a_Config0x51_B2                 	DB	?
			a_Config0x51_B3                 	DB	?
			a_IP0x71_B0				DB	?
			a_IP0x71_B1				DB	?
			a_IP0x71_B2				DB	?
			a_IP0x71_B3				DB	?
			a_IP0x71_B4				DB	?
			a_IP0x71_B5				DB	?
			a_IP0x71_B6				DB	?
			a_ExIP0x81_B0				DB	?
			a_ExIP0x81_B1				DB	?
			a_ExIP0x81_B2                   	DB	?
			a_ExIP0x81_B3                   	DB	?
			a_ExIP0x81_B4                   	DB	?
			a_ExIP0x81_B5                   	DB	?
			a_ExIP0x81_B6                   	DB	?
			a_ExIP0x81_B7                   	DB	?
			a_0x03ContlErr				DB	?
			a_0x04ReceivedPow			DB	?
			a_0x04ReceivedPowPre			DB	?
			a_0x06TdelayML				DB	?
			a_0x06TdelayMH				DB	?
			a_StatusEndPower			DB	?
			a_OptConfiCNT				DB	?
			a_0x51PowMax				DB	?
			a_0x04ReceiPowCNTH			DB	?
			a_0x04ReceiPowCNTL			DB	?
			a_ParPLLFHpre				DB	?		;;(Record for Isen)
			a_ParPLLFLpre				DB	?		;;(Record for Isen)
		    	a_Carry					DB	?
		    	a_r_DetectCNT				DB	?
		    	a_r_RPowCNT				DB	?
		    	a_TempH					DB	?
		    	a_TempL					DB	?


;===========================================================================================
;Function :   PUBLIC
;Note     :
;===========================================================================================
PUBLIC			a_ParPLLFH			
PUBLIC			a_ParPLLFL			
PUBLIC			fg_BaseTimeCTM			
PUBLIC			fg_MutipleTimeHflagCTM		
PUBLIC			a_MutipleTimeLCTM		
PUBLIC			a_MutipleTimeHCTM		
PUBLIC			fg_BaseTimeSTM			
PUBLIC			fg_MutipleTimeHflagSTM		
PUBLIC			fg_TimeOut			
PUBLIC			a_MutipleTimeLSTM		
PUBLIC			a_MutipleTimeHSTM		
PUBLIC			fg_FlagDemo			
PUBLIC			a_DemoV_I1_I2			
PUBLIC			fg_INT1				
PUBLIC			fg_INT0				
PUBLIC			fg_DUDataStart			
PUBLIC			fg_DU				
PUBLIC			fg_StartBit			
PUBLIC			fg_ParityBit			
PUBLIC			fg_ParityErr			
PUBLIC			fg_StopBit			
PUBLIC			fg_WaitDataOut			
PUBLIC			fg_StopBitPre			
PUBLIC			fg_DataFirst			
PUBLIC			fg_Preamble			
PUBLIC			fg_ChecksumBit			
PUBLIC			fg_PacDataOK			
PUBLIC			fg_StartReci			
PUBLIC			fg_DataByteCNTFull		
PUBLIC			a_StatusCntInt1			
PUBLIC			a_DataOUTtemp			
PUBLIC			a_DataParityCNT			
PUBLIC			a_TimeOutCNT			
PUBLIC			a_DataOUT			
PUBLIC			a_DataCNT			
PUBLIC			a_Preamble4BitCNT		
PUBLIC			a_Preamble25BitCNT		
PUBLIC			a_NoToggleCNT			
PUBLIC			a_DataByteCNT			
PUBLIC			a_DataByteCNTtemp		
PUBLIC			a_AddrDataOUT			
PUBLIC			a_HeadMessageCNT		
PUBLIC			a_ContlDataMessag		
PUBLIC			a_DataHeader			
PUBLIC			a_DataMessageB0			
PUBLIC			a_DataMessageB1             	
PUBLIC			a_DataMessageB2             	
PUBLIC			a_DataMessageB3             	
PUBLIC			a_DataMessageB4             	
PUBLIC			a_DataMessageB5             	
PUBLIC			a_DataMessageB6             	
PUBLIC			a_DataMessageB7             	
PUBLIC			a_DataChecksum			
PUBLIC			a_XORchecksum			
PUBLIC			fg_INT_AD			
PUBLIC			a_ADRHbuffer			
PUBLIC			a_ADRLbuffer			
PUBLIC			a_com1				
PUBLIC			a_com2				
PUBLIC			a_com3				
PUBLIC			a_com4				
PUBLIC			a_data0				
PUBLIC			a_data1				
PUBLIC			a_data2				
PUBLIC			a_data3				
PUBLIC			a_data4				
PUBLIC			a_data5				
PUBLIC			a_data6				
PUBLIC			a_data7				
PUBLIC			a_to0				
PUBLIC			a_to1				
PUBLIC			a_to2                           
PUBLIC			a_to3                           
PUBLIC			a_to4                           
PUBLIC			a_to5                           
PUBLIC			a_to6                           
PUBLIC			a_to7                           
PUBLIC			a_count0			
PUBLIC			a_temp2                         
PUBLIC			a_temp1                         
PUBLIC			a_temp0                         
PUBLIC			fg_PIDIni			
PUBLIC			fg_start			
PUBLIC			fg_IterationStart		
PUBLIC			fg_FODTemp60
PUBLIC			a_IL              	   	
PUBLIC			a_IM0                 		
PUBLIC			a_IM1                 		
PUBLIC			a_VL				
PUBLIC			a_VM0				
PUBLIC			a_VM1				
PUBLIC			a_EL				
PUBLIC			a_EM				
PUBLIC			a_EH				
PUBLIC			a_Sv				
PUBLIC			a_LoopIteration			
PUBLIC			fg_0x02PowDownChargeComplete    
PUBLIC			fg_0x02PowDownReconfigure       
PUBLIC			fg_0x02PowDownNoResponse        
PUBLIC			fg_ExIdet0x81			
PUBLIC			fg_Idet				
PUBLIC			fg_Tdelay			
PUBLIC			fg_0x04OutReceiPowTime		
PUBLIC			fg_0x51PowClass			
PUBLIC			fg_0x51NonPID			
PUBLIC			fg_EndPowDown			
PUBLIC			fg_CEinput			
PUBLIC			fg_0x04ReceiPowCNTHflag		
PUBLIC			fg_PSVin			
PUBLIC			fg_PCH0x06Abnor			
PUBLIC			fg_RecodeRPpre			
PUBLIC			fg_RPNoStable			
PUBLIC			fg_adc_avg_cnt			
PUBLIC		    	fg_RXCoilD			
PUBLIC		    	fg_NoChange			
PUBLIC		    	fg_IsenSmall			
PUBLIC		    	fg_IsenBig			
PUBLIC		    	fg_WaitNextCE			
PUBLIC		    	fg_CEThr			
PUBLIC		    	fg_CEThrPana			
PUBLIC			fg_IsenFirst			
PUBLIC			fg_PLLDown			
PUBLIC			fg_PLLPana			
PUBLIC			fg_DetectVin			
PUBLIC			fg_VinLow			
PUBLIC			fg_PLL205			
PUBLIC			fg_DTCPR			
PUBLIC			fg_DTCPRmin			
PUBLIC			fg_PLLThr			
PUBLIC			fg_Ping				
PUBLIC			fg_FODEfficLow			
PUBLIC			fg_ReCordTemp			
PUBLIC			fg_CalTempTimeHigh		
PUBLIC			fg_PowOver5wLEDsw		
PUBLIC			fg_DemoDetect			
PUBLIC			fg_DemoDetectTimeOut		
PUBLIC           	fg_RxTI				
PUBLIC           	fg_RxPana			
PUBLIC			a_SSP0x01_B0			
PUBLIC			a_CSP0x05_B0			
PUBLIC			a_PCHO0x06_B0			
PUBLIC			a_Config0x51_B0			
PUBLIC			a_Config0x51_B2                 
PUBLIC			a_Config0x51_B3                 
PUBLIC			a_IP0x71_B0			
PUBLIC			a_IP0x71_B1			
PUBLIC			a_IP0x71_B2			
PUBLIC			a_IP0x71_B3			
PUBLIC			a_IP0x71_B4			
PUBLIC			a_IP0x71_B5			
PUBLIC			a_IP0x71_B6			
PUBLIC			a_ExIP0x81_B0			
PUBLIC			a_ExIP0x81_B1			
PUBLIC			a_ExIP0x81_B2                   
PUBLIC			a_ExIP0x81_B3                   
PUBLIC			a_ExIP0x81_B4                   
PUBLIC			a_ExIP0x81_B5                   
PUBLIC			a_ExIP0x81_B6                   
PUBLIC			a_ExIP0x81_B7                   
PUBLIC			a_0x03ContlErr			
PUBLIC			a_0x04ReceivedPow		
PUBLIC			a_0x04ReceivedPowPre		
PUBLIC			a_0x06TdelayML			
PUBLIC			a_0x06TdelayMH			
PUBLIC			a_StatusEndPower		
PUBLIC			a_OptConfiCNT			
PUBLIC			a_0x51PowMax			
PUBLIC			a_0x04ReceiPowCNTH		
PUBLIC			a_0x04ReceiPowCNTL		
PUBLIC			a_ParPLLFHpre			
PUBLIC			a_ParPLLFLpre			
PUBLIC		    	a_Carry				
PUBLIC		    	a_r_DetectCNT			
PUBLIC		    	a_r_RPowCNT			
PUBLIC		    	a_TempH				
PUBLIC		    	a_TempL				
   

END    	
			