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
PUBLIC			Sensoring10_8
PUBLIC			PreCarry
PUBLIC			PostCarry
PUBLIC			DemoCLR 
PUBLIC			ADCData 

EXTERN			sum_ADC_value				:	near
EXTERN			avg_ADC_value				:	near

EXTERN			a_StatusCntInt1				:	byte
EXTERN			a_DataOUT				:	byte
EXTERN			a_DataHeader				:	byte
EXTERN			a_DataMessageB0				:	byte
EXTERN			a_DataMessageB1             	        :	byte
EXTERN			a_DataMessageB2             	        :	byte
EXTERN			a_DataMessageB3             	        :	byte
EXTERN			a_DataMessageB4             	        :	byte
EXTERN			a_DataMessageB5             	        :	byte
EXTERN			a_DataMessageB6             	        :	byte
EXTERN			a_DataMessageB7             	        :	byte
EXTERN			a_DataChecksum				:	byte
EXTERN			fg_INT_AD				:	bit
EXTERN			a_com1					:	byte
EXTERN			a_com2				        :	byte
EXTERN			a_com3				        :	byte
EXTERN			a_com4				        :	byte
EXTERN			a_data0					:	byte
EXTERN			a_data1				        :	byte
EXTERN			a_data2					:	byte
EXTERN			a_data3					:	byte				
EXTERN			a_data4					:	byte
EXTERN			a_data5				        :	byte
EXTERN			a_to0					:	byte
EXTERN			a_to1				        :	byte
EXTERN			a_to2                                   :	byte
EXTERN			a_to3                                   :	byte
EXTERN			a_to4                           	:	byte
EXTERN			a_to5                           	:	byte
EXTERN			a_to6                           	:	byte
EXTERN			a_to7                                   :	byte
EXTERN			fg_adc_avg_cnt				:	bit
EXTERN		    	a_Carry					:	byte


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
Other		.Section 	'code'	
;========================================================
;Function 	: Sensoring10_8
;Note     	: Call Function Type for AD Sensor
;========================================================
	Sensoring10_8:
			CLR	a_DataHeader				;M1H
			CLR	a_DataMessageB0				;M1L
			CLR	a_DataMessageB1				;M2H
			CLR	a_DataMessageB2				;M2L
			CLR	a_DataMessageB3				;M3H
			CLR	a_DataMessageB4				;M3L
			CLR	a_DataMessageB5				;M4H
			CLR	a_DataMessageB6				;M4L
			CLR	a_DataMessageB7				;M5H
			CLR	a_DataChecksum				;M5L
			CLR	a_com1					;M6
			CLR	a_com2                  		
			CLR	a_com3					;M7
			CLR	a_com4                  		
			CLR	a_data0					;M8
			CLR	a_data1                 		
			CLR	a_data2					;M9
			CLR	a_data3                 		
			CLR	a_data4					;M10
			CLR	a_data5                 		
			CLR	a_to0					;M11
			CLR	a_to1                   		
			CLR	a_to2					;M12
			CLR	a_to3                   		
			CLR	a_to4					;M13
			CLR	a_to5                   		
			CLR	a_to6					;M14
			CLR	a_to7
	PID_Isen65sensoring:
			CALL	ADCData
			MOV	A, ADRH
			MOV	a_DataHeader, A				;M1
			MOV	A, ADRL                 		
			MOV	a_DataMessageB0, A      		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_DataMessageB1, A			;M2
			MOV	A, ADRL                 		
			MOV	a_DataMessageB2, A      		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_DataMessageB3, A			;M3
			MOV	A, ADRL                 		
			MOV	a_DataMessageB4, A      		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_DataMessageB5, A			;M4
			MOV	A, ADRL                 		
			MOV	a_DataMessageB6, A      		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_DataMessageB7, A			;M5
			MOV	A, ADRL                 		
			MOV	a_DataChecksum, A       		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_com1, A				;M6
			MOV	A, ADRL                 		
			MOV	a_com2, A               		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_com3, A				;M7
			MOV	A, ADRL                 		
			MOV	a_com4, A               		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_data0, A				;;M8
			MOV	A, ADRL                 		
			MOV	a_data1, A              		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_data2, A				;;M9
			MOV	A, ADRL                 		
			MOV	a_data3, A              		
                                                        		
			CALL	ADCData                 		
			MOV	A, ADRH                 		
			MOV	a_data4, A				;;M10
			MOV	A, ADRL
			MOV	a_data5, A

	;;;~~~Sum_ADC_value~~~
	PID_Isen65_Sum_ADC:
			CLR	fg_adc_avg_cnt
			; 1st data					
			mov	A, offset a_DataHeader			; point high byte of M1
			mov	mp1l, A                         	
			mov	A, offset a_DataMessageB0		; point low byte of M1
			mov	mp0, A                          	
			call	sum_ADC_value                   	
			; 2nd data						
			mov	A, offset a_DataMessageB1		; point high byte of M2
			mov	mp1l, A                         	
			mov	a, offset a_DataMessageB2		; point low byte of M2
			mov	mp0, A                          	
			call	sum_ADC_value                   	
			; 3th data						
			mov	A, offset a_DataMessageB3		; point high byte of M3
			mov	mp1l, A                         	
			mov	a, offset a_DataMessageB4		; point low byte of M3
			mov	mp0, a                          	
			call	sum_ADC_value                   	
			; 4th data						
			mov	a, offset a_DataMessageB5		; point high byte of M4
			mov	mp1l, a                         	
			mov	a, offset a_DataMessageB6		; point low byte of M4
			mov	mp0, a                          	
			call	sum_ADC_value                   	
			; 5th data						
			mov	a, offset a_DataMessageB7		; point high byte of M5
			mov	mp1l, a                         	
			mov	a, offset a_DataChecksum		; point low byte of M5
			mov	mp0, a                          	
			call	sum_ADC_value                   	
			; 6th data						
			mov	a, offset a_com1			; point high byte of M6
			mov	mp1l, a                         	
			mov	a, offset a_com2			; point low byte of M6
			mov	mp0, a                          	
			call	sum_ADC_value                   	
			; 7th data						
			mov	a, offset a_com3			; point high byte of M7
			mov	mp1l, a                         	
			mov	a, offset a_com4			; point low byte of M7
			mov	mp0, a
			call	sum_ADC_value
			; 8th data					
			mov	a, offset a_data0			; point high byte of M8
			mov	mp1l, a                 		
			mov	a, offset a_data1			; point low byte of M8
			mov	mp0, a                  		
			call	sum_ADC_value           		
			; 9th data							
			mov	a, offset a_data2			; point high byte of M9
			mov	mp1l, a                 		
			mov	a, offset a_data3			; point low byte of M9
			mov	mp0, a                  		
			call	sum_ADC_value           		
			; 10th data							
			mov	a, offset a_data4			; point high byte of M10
			mov	mp1l, a                 		
			mov	a, offset a_data5			; point low byte of M10
			mov	mp0, a
			call	sum_ADC_value
		
	;;;~~~Avg_ADC_value=Sum_ADC_value /8~~~
	PID_Isen65_Avg_ADC:
			CLR 	WDT
			call	avg_ADC_value
			RET


;========================================================
;Function 	: PreCarry  (  us)
;Note     	: Call Function Type for FOD Isen 
;input  	: 	
;output 	: 	
;parameter	: 	
;Setting	:
;========================================================
	PreCarry:
			CLR 	WDT
			CLR	a_Carry
			RET

;========================================================
;Function 	: PostCarry  (  us)
;Note     	: Call Function Type for FOD Isen 
;input  	: 	
;output 	: 	
;parameter	: 	
;Setting	:
;========================================================
	PostCarry:
			MOV	A, 000H
			SBCM	A, a_Carry
			RET


;;========================================================
;;Function : DemoCLR
;;Note     : Call Function Type for  
;;input    : 
;;output   :
;;========================================================
	DemoCLR:
			MOV	A, 009H
			MOV	a_StatusCntInt1, A
			MOV	A, offset a_DataOUT
			MOV	MP0, A
	LOOP_CLR1:
			CLR WDT
			CLR	IAR0
			INC	MP0
			SDZ	a_StatusCntInt1
			JMP	LOOP_CLR1
			
			RET			


;========================================================
;Function : ADCData  
;Note     : Call Function Type for Isence
;		input = No need
;		output = ADRH(H) + ADRL(L)
;========================================================
	ADCData:
			CLR	START
			SET	START
			CLR	START
	AD_Wait:
			CLR WDT
			SZ	fg_INT_AD
			JMP	AD_Wait

			SET	fg_INT_AD
	ADCDataEnd:
			RET

