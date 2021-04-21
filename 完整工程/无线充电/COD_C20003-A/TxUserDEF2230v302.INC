;*******************************************************************************************
;*****	                    Customized Parameters Define                               *****
;*******************************************************************************************
;;==========================================================================================
;;Function :  Detect Vin for Min Threshold Claim
;;Note     : 
;;==========================================================================================
;;-----------To detect Vin of USB Power in Initialization
#DEFINE	c_IniVinMinL				00FH
#DEFINE	c_IniVinMinH				00BH		; @5v,VREF=2.08v, DetectVin=B0Fh = 4.5v*(47k/(100k+47K))=1.438v, ADC=FFFh*1.438/2.08v=B0Fh
                                        	
#DEFINE	c_IniVinMaxL				075H
#DEFINE	c_IniVinMaxH				00DH		; @5v,VREF=2.08v, DetectVin=D75h = 5.5v*(47k/(100k+47K))=1.75v, ADC=FFFh*1.75/2.08v=D75h
																				
;;-----------To Detect Vin of USB Power in Power Transfer Phase
#DEFINE	c_IniPTVinMinL				013H
#DEFINE	c_IniPTVinMinH				00AH		; @5v,VREF=2.08v, DetectVin=A13h = 4.1v*(47k/(100k+47K))=1.31v, ADC=FFFh*1.31/2.08v=A13h
                                        	
#DEFINE	c_IniPTVinLowL				0B0H
#DEFINE	c_IniPTVinLowH				00BH		; @5v,VREF=2.08v, DetectVin=BB0h = 4.75v*(47k/(100k+47K))=1.52v, ADC=FFFh*1.52/2.08v=BB0h



;;==========================================================================================
;;Function :  Temperture Deviation Claim
;;Note     : 
;;	      Temperture Sensor 10k@25, 3k@60, 1.6k@80, 188k@-40
;;	      HW Temperture = Temperture 10k@25 + 1k(+-1%) in 5V
;;	      ADC IVref=2.08v
;;	      Vtemp = 1.92v = 1k / ( 1k +   1.6k) x 5v @+80
;;	      Vtemp = 1.25v = 1k / ( 1k +   3.0k) x 5v @+60
;;	      Vtemp = 0.45v = 1k / ( 1k +  10.0k) x 5v @+25
;;	      Vtemp = 0.03v = 1k / ( 1k + 188.0k) x 5v @-40
;;            
;;	      Vtemp = 1.84v = 1k / ( 1k +   1.6k) x 4.8v @+80
;;	      Vtemp = 1.20v = 1k / ( 1k +   3.0k) x 4.8v @+60
;;	      Vtemp = 0.43v = 1k / ( 1k +  10.0k) x 4.8v @+25
;;	      Vtemp = 0.03v = 1k / ( 1k + 188.0k) x 4.8v @-40
;;  	      
;;	      Vtemp = 1.73v = 1k / ( 1k +   1.6k) x 4.5v @+80
;;	      Vtemp = 1.13v = 1k / ( 1k +   3.0k) x 4.5v @+60
;;	      Vtemp = 0.41v = 1k / ( 1k +  10.0k) x 4.5v @+25
;;	      Vtemp = 0.02v = 1k / ( 1k + 188.0k) x 4.5v @-40
;;==========================================================================================
;;OK for 1mm Space
;;-------small load status
#DEFINE	c_IniT60LDL0				05AH
#DEFINE	c_IniT60LDH0				005H
;;-------Big load status
#DEFINE	c_IniT60LDL1				04AH
#DEFINE	c_IniT60LDH1				005H
;;-------Temperature Rise status
#DEFINE	c_IniT60LDL2				04EH		; 880H=1.1v, C4EH=1.5v
#DEFINE	c_IniT60LDH2				00CH
;;-------Temperature Rise Threshold
#DEFINE	c_IniTempDeL				046H		; 150mV=0.150*4096/2.08=295=127h
#DEFINE	c_IniTempDeH				000H		; 100mV=0.100*4096/2.08=196= C4h
								;  50mV=0.050*4096/2.08= 98= 62h
								;  47mV=0.047*4096/2.08= 93= 5Dh
								;  36mV=0.036*4096/2.08= 70= 46h
								;  25mV=0.025*4096/2.08= 49= 31h
								;  23mV=0.023*4096/2.08= 45= 2Dh


;;==========================================================================================
;;Function :  Isen Threshhold Claim
;;Note     :  Isen(mA) = ADC_Thr
;;==========================================================================================
;;-------Small Isen Threshold
#DEFINE	c_IniIsenSmallTh_L			09EH			; 158mA(09Eh)
#DEFINE	c_IniIsenSmallTh_H			000H			; 142mA(08Eh)

;;-------Big Isen Threshold
#DEFINE	c_IniIsenBigTh_L			020H			; 900mA(384h) 
#DEFINE	c_IniIsenBigTh_H			003H			; 700mA(2BCh)
									; 500mA(1F4h)
									; 800mA(320h)


;;==========================================================================================
;;Function :  FOD Isen Threshhold Claim
;;Note     :  Isen(mA) = ADC_Thr
;;==========================================================================================
#DEFINE	c_IniIsenFODTh1_L			033H			; 307mA(133h)
#DEFINE	c_IniIsenFODTh1_H			001H

#DEFINE	c_IniIsenFODTh2_L			091H			; 414mA(191h)
#DEFINE	c_IniIsenFODTh2_H			001H

#DEFINE	c_IniIsenFODTh3_L			030H			; 560mA(230h)
#DEFINE	c_IniIsenFODTh3_H			002H

#DEFINE	c_IniIsenFODTh4_L			08DH			; 653mA(28Dh)
#DEFINE	c_IniIsenFODTh4_H			002H

#DEFINE	c_IniIsenFODTh5_L			0F2H			; 754mA(1CDh)
#DEFINE	c_IniIsenFODTh5_H			002H

#DEFINE	c_IniIsenFODTh6_L			04CH			; 844mA(34Ch)
#DEFINE	c_IniIsenFODTh6_H			003H

#DEFINE	c_IniIsenFODTh7_L			0A4H			; 932mA(3A4h)
#DEFINE	c_IniIsenFODTh7_H			003H

#DEFINE	c_IniIsenFODTh8_L			005H			; 1029mA(405h)
#DEFINE	c_IniIsenFODTh8_H			004H

#DEFINE	c_IniIsenFODTh9_L			06BH			; 1131mA(46Bh)
#DEFINE	c_IniIsenFODTh9_H			004H

#DEFINE	c_IniIsenFODThA_L			0CDH			; 1229mA(4CDh)
#DEFINE	c_IniIsenFODThA_H			004H

#DEFINE	c_IniIsenFODThB_L			0AFH			; 1455mA(5AFh)
#DEFINE	c_IniIsenFODThB_H			005H

#DEFINE	c_IniIsenFODThC_L			010H			; 1552mA(610h)
#DEFINE	c_IniIsenFODThC_H			006H

#DEFINE	c_IniIsenFODThD_L			07FH			; 1663mA(67Fh)
#DEFINE	c_IniIsenFODThD_H			006H

#DEFINE	c_IniIsenFODThE_L			0F7H			; 1783mA(6F7h)
#DEFINE	c_IniIsenFODThE_H			006H

#DEFINE	c_IniIsenFODThF_L			08FH			; 1935mA(78Fh)
#DEFINE	c_IniIsenFODThF_H			007H


;;==========================================================================================
;;Function :  FOD Efficiency Threshhold Claim
;;Note     :  
;;==========================================================================================
#DEFINE	c_IniFODEffiBasic			029H			; 50=32H, 41=29H
#DEFINE	c_IniFODEffi_26_1Ah_Per 		01AH
#DEFINE	c_IniFODEffi_22_16h_Per 		016H
#DEFINE	c_IniFODEffi_20_14h_Per			014H
#DEFINE	c_IniFODEffi_17_11h_Per  		011H
#DEFINE	c_IniFODEffi_16_10h_Per  		010H
#DEFINE	c_IniFODEffi_15_Fh_Per			00FH
#DEFINE	c_IniFODEffi_14_Eh_Per			00EH			; 12=CH
#DEFINE	c_IniFODEffi_13_Dh_Per			00DH
#DEFINE	c_IniFODEffi_12_Ch_Per			00CH			; 12=CH
#DEFINE	c_IniFODEffi_10_Ah_Per			00AH			; 10=AH
#DEFINE	c_IniFODEffi_4_4h_Per			004H			; 4=4H
#DEFINE	c_IniFODEffi_5_5h_Per			005H			; 5=5H
#DEFINE	c_IniFODEffi_6_6h_Per			006H			; 6=6H
#DEFINE	c_IniFODEffi_7_7h_Per			007H			; 7=7H
#DEFINE	c_IniFODEffi_8_8h_Per			008H			; 8=8H
#DEFINE	c_IniFODEffi_9_9h_Per			009H			; 9=9H
                                        	
                                        	
;;Highest Efficiency (Curve 1)
#DEFINE	c_IniFODEffThr11			027H			; 37=25H
#DEFINE	c_IniFODEffThr12			03BH			; 57=39H
#DEFINE	c_IniFODEffThr13			043H			; 65=41H
#DEFINE	c_IniFODEffThr14			049H			; 71=47H
#DEFINE	c_IniFODEffThr15			04AH			; 72=48H
#DEFINE	c_IniFODEffThr16			04DH			; 75=4BH
#DEFINE	c_IniFODEffThr17			04DH			; 76=4CH
#DEFINE	c_IniFODEffThr18			04DH			; 77=4DH
#DEFINE	c_IniFODEffThr19			04DH			; 78=4EH
#DEFINE	c_IniFODEffThr1A			04DH			; 79=4FH
#DEFINE	c_IniFODEffThr1B			04EH			; 80=50H
#DEFINE	c_IniFODEffThr1C			04EH			; 80=50H
#DEFINE	c_IniFODEffThr1D			04FH			; 81=51H
#DEFINE	c_IniFODEffThr1E			04FH			; 81=51H
#DEFINE	c_IniFODEffThr1F			050H			; 82=52H
#DEFINE	c_IniFODEffThr1G			04FH			; 80=50H
                                        	
                                        	
;;Lowest Efficiency (Curve 2)
#DEFINE	c_IniFODEffThr21			013H			; 21=15H
#DEFINE	c_IniFODEffThr22			015H			; 34=22H
#DEFINE	c_IniFODEffThr23			017H			; 44=2CH
#DEFINE	c_IniFODEffThr24			018H			; 52=34H
#DEFINE	c_IniFODEffThr25			020H			; 52=34H
#DEFINE	c_IniFODEffThr26			020H			; 53=35H
#DEFINE	c_IniFODEffThr27			020H			; 54=36H
#DEFINE	c_IniFODEffThr28			020H			; 54=36H
#DEFINE	c_IniFODEffThr29			037H			; 55=37H
#DEFINE	c_IniFODEffThr2A			036H			; 54=36H
#DEFINE	c_IniFODEffThr2B			036H			; 54=36H
#DEFINE	c_IniFODEffThr2C			036H			; 54=36H
#DEFINE	c_IniFODEffThr2D			036H			; 54=36H
#DEFINE	c_IniFODEffThr2E			036H			; 54=36H
#DEFINE	c_IniFODEffThr2F			036H			; 54=36H
#DEFINE	c_IniFODEffThr2G			031H			; 49=31H


;;==========================================================================================
;;Function :  FOD Pd Threshhold Claim
;;Note     :  
;;==========================================================================================
#DEFINE	c_IniFOD128Pin0_L			0B3H			; 179=0B3h
#DEFINE	c_IniFOD128Pin0_H			000H

#DEFINE	c_IniFOD128Pin1_L			0DAH			; 218=0DAh
#DEFINE	c_IniFOD128Pin1_H			000H

#DEFINE	c_IniFOD128Pin2_L			00DH			; 269=10Dh
#DEFINE	c_IniFOD128Pin2_H			001H

#DEFINE	c_IniFOD128Pin3_L			05AH			; 346=15Ah
#DEFINE	c_IniFOD128Pin3_H			001H

#DEFINE	c_IniFOD128Pin4_L			08DH			; 397=18Dh
#DEFINE	c_IniFOD128Pin4_H			001H

#DEFINE	c_IniFOD128Pin5_L			0CDH			; 461=1CDh
#DEFINE	c_IniFOD128Pin5_H			001H

#DEFINE	c_IniFOD128Pin6_L			0F3H			; 499=1F3h
#DEFINE	c_IniFOD128Pin6_H			001H

#DEFINE	c_IniFOD128Pin7_L			01AH			; 538=21Ah
#DEFINE	c_IniFOD128Pin7_H			002H

#DEFINE	c_IniFOD128Pin8_L			04DH			; 589=24Dh
#DEFINE	c_IniFOD128Pin8_H			002H

#DEFINE	c_IniFOD128Pin9_L			080H			; 640=280h
#DEFINE	c_IniFOD128Pin9_H			002H
				
#DEFINE	c_IniFOD128PinA_L			0B3H			; 691=2B3h
#DEFINE	c_IniFOD128PinA_H			002H

#DEFINE	c_IniFOD128PinB_L			000H			; 768=300h
#DEFINE	c_IniFOD128PinB_H			003H

#DEFINE	c_IniFOD128PinC_L			033H			; 819=333h
#DEFINE	c_IniFOD128PinC_H			003H

#DEFINE	c_IniFOD128PinD_L			073H			; 883=373h
#DEFINE	c_IniFOD128PinD_H			003H

#DEFINE	c_IniFOD128PinE_L			09AH			; 992=39Ah
#DEFINE	c_IniFOD128PinE_H			003H

#DEFINE	c_IniFOD128PinF_L			0CDH			; 973=3CDh
#DEFINE	c_IniFOD128PinF_H			003H
													

;;==========================================================================================
;;Function :  Detect Object for Min Threshold Claim
;;Note     : 
;;==========================================================================================
;-------Detect Object Min Threshold
#DEFINE	c_IniDetObjMinL				010H		; 0145h @ V=5v, VREF=2.08v
#DEFINE	c_IniDetObjMinH				001H

;-------Detect Object Min Threshold for D type Rx
#DEFINE	c_IniDetObjRXDMinL			050H		; 0145h @ V=5v, VREF=2.08v
#DEFINE	c_IniDetObjRXDMinH			000H

;-------Detect Object Max Threshold for Leaving
#DEFINE	c_IniDetObjLeaMaxL			0A0H		; 0145h @ V=5v, VREF=2.08v
#DEFINE	c_IniDetObjLeaMaxH			000H


;;==========================================================================================
;;Function :  TM1(CTM) Timer Function Claim
;;Note     : 
;;==========================================================================================
;-------CTM Time Base 0
#DEFINE	c_IniCTMTimeBaseL			032H	;@ Fsys/4 = 20MHz/4 = 5MHz = 0.2us, Time Base = 0.2us x 250 = 0.2us x FAh = 50us
#DEFINE	c_IniCTMTimeBaseH			000H    ;@ Fsys/4 = 20MHz/4 = 5MHz = 0.2us, Time Base = 0.2us x  50 = 0.2us x 32h = 10us

;-------CTM Mutiple Time for VCO
#DEFINE	c_IniWVCOMutipleTimeL			0C8H	;Time Base = 50us, 50us x 3E8h = 50us x 1000 = 50ms
#DEFINE	c_IniWVCOMutipleTimeH			000H	;Time Base = 10us, 10us x 1388h = 10us x 5000 = 50ms

;-------CTM Mutiple Time for Detection
#DEFINE	c_IniDetectMutipleTimeL			007H	;Time Base = 10us, 10us x 0007h = 10us x 7 = 70us
#DEFINE	c_IniDetectMutipleTimeH			000H

;-------CTM Mutiple Time for Detect Rx D-Type
#DEFINE	c_IniDetectRXDMutipleTimeL		050H	;Time Base = 10us, 10us x 023h = 10us x 35 = 350us Lab
#DEFINE	c_IniDetectRXDMutipleTimeH		000H	;LAB 

;-------CTM Time Base 1
#DEFINE	c_IniCTMTimeBaseL1			0FAH	;@ Fsys/4 = 20MHz/4 = 5MHz = 0.2us, Time Base = 0.2us x 250 = 0.2us x FAh = 50us
#DEFINE	c_IniCTMTimeBaseH1			000H    ;@ Fsys/4 = 20MHz/4 = 5MHz = 0.2us, Time Base = 0.2us x  50 = 0.2us x 32h = 10us

;-------CTM Mutiple Time for Preamble of Communication
#DEFINE	c_IniComBy0MutipleTimeL			002H	;Time Base = 50us, 50us x 2h = 50us x 2 = 100us
#DEFINE	c_IniComBy0MutipleTimeH			000H	;Time Base = 10us, 10us x Ah = 10us x 10 = 100us

;-------CTM Mutiple Time for Preamble of Communication
#DEFINE	c_IniComByMutipleTimeL0			005H	;Time Base = 50us, 50us x 7h = 50us x 7 = 350us
#DEFINE	c_IniComByMutipleTimeH0			000H    ;Time Base = 50us, 50us x 8h = 50us x 8 = 400us

;-------CTM Mutiple Time for Data of Communication
#DEFINE	c_IniComByMutipleTimeL			007H	;Time Base = 50us, 50us x 7h = 50us x 7 = 350us
#DEFINE	c_IniComByMutipleTimeH			000H    ;Time Base = 50us, 50us x 8h = 50us x 8 = 400us

;-------CTM Mutiple Time for settle timing
#DEFINE	c_IniPowTrTsettleMutipleTimeL 		078H	;Time Base = 50us, 50us x 0064h = 50us x 100 = 5ms (3ms <= Tsettle <= 7ms)
#DEFINE	c_IniPowTrTsettleMutipleTimeH		000H	;Time Base = 50us, 50us x 003Ch = 50us x 60 = 3ms (3ms <= Tsettle <= 7ms)
							;Time Base = 50us, 50us x 0078h = 50us x 120 = 6ms (3ms <= Tsettle <= 7ms)
;-------CTM Mutiple Time for termination timing
#DEFINE	c_IniTtermiMutipleTimeL 		0F4H	;Time Base = 50us, 50us x 21Ch = 50us x 540 = 27ms (Tterminate <= 28ms)
#DEFINE	c_IniTtermiMutipleTimeH			001H

;-------CTM Mutiple Time for Light
#DEFINE	c_IniPowDownLight1MutilpleTimeL		0E8H	;Time Base = 50us, 50us x 03E8h = 50us x 1000 = 50ms 
#DEFINE	c_IniPowDownLight1MutilpleTimeH		003H

;-------CTM Mutiple Time for Power Down
#DEFINE	c_IniPIDMutilpleTimeL			00AH	;Time Base = 50us, 50us x 000Ah = 50us x 10 = 500us = 0.5ms
#DEFINE	c_IniPIDMutilpleTimeH			000H	;Time Base = 50us, 50us x 0004h = 50us x 4 = 0.2ms 
							;Time Base = 50us, 50us x 000Ch = 50us x 12 = 0.6ms 

;;==========================================================================================
;;Function :  TM0(STM) Timer Function Claim
;;Note     : 
;;==========================================================================================
;-------CTM Time Base 0
#DEFINE	c_IniSTMTimeBaseL			0FAH	;@ Fsys/4 = 20MHz/4 = 5MHz = 0.2us, Time Base = 0.2us x 250 = 0.2us x FAh = 50us
#DEFINE	c_IniSTMTimeBaseH			000H

;-------CTM Mutiple Time for Ping Timing
#DEFINE	c_IniDiPingMutipleTimeL			025H	;Time Base = 50us, 50us x 578h = 50us x 1400 = 70ms (Tping <= 70ms)
#DEFINE	c_IniDiPingMutipleTimeH			005H	;Time Base = 50us, 50us x 550h = 50us x 1360 = 68ms (Tping <= 70ms)

;-------CTM Mutiple Time for First Packet Timing
#DEFINE	c_IniPingTfirstMutipleTimeL		008H	;Time Base = 50us, 50us x 190h = 50us x 400 = 20.0ms (Tfirst <= 20ms)
#DEFINE	c_IniPingTfirstMutipleTimeH		002H	;Time Base = 50us, 50us x 1B8h = 50us x 440 = 23.2ms (Tfirst <= 20ms)
							;Time Base = 50us, 50us x 1D0h = 50us x 464 = 23.2ms (Tfirst <= 20ms)
							;Time Base = 50us, 50us x 208h = 50us x 520 = 26.0ms (Tfirst <= 20ms)
							
;-------CTM Mutiple Time for Next Packet Timing
#DEFINE	c_IniIdeConTnextMutipleTimeL 		01AH	;Time Base = 50us, 50us x 1A4h = 50us x 420 = 21ms (Tnext <= 21ms)
#DEFINE	c_IniIdeConTnextMutipleTimeH		001H	;Time Base = 50us, 50us x 190h = 50us x 400 = 20ms (Tnext <= 21ms)

;-------CTM Mutiple Time for Maximun Packet Timing
#DEFINE	c_IniIdeConTmaxMutipleTimeL 		034H	;Time Base = 50us, 50us x D48h = 50us x 3400 = 170ms (Tmax <= 170ms)
#DEFINE	c_IniIdeConTmaxMutipleTimeH		00DH	;Time Base = 50us, 50us x D34h = 50us x 3380 = 169ms (Tmax <= 170ms)

;-------CTM Mutiple Time for CE Packet Timing 0
#DEFINE	c_IniPowTrTtimeoutMutipleTimeL 		030H	;Time Base = 50us, 50us x 84D0h = 50us x 34000 = 1700ms (Ttimeout <= 1800ms)
#DEFINE	c_IniPowTrTtimeoutMutipleTimeH		080H

;-------CTM Mutiple Time for CE Packet Timing 1
#DEFINE	c_IniPowTrTtioutMutipleTimeL 		07FH	;Time Base = 50us, 50us x 84D0h = 50us x 34000 = 1700ms (Ttimeout <= 1800ms, Ttiout=Ttimeout-T(unknown))
#DEFINE	c_IniPowTrTtioutMutipleTimeH		080H

;-------CTM Mutiple Time for Power Control Active Timing
#DEFINE	c_IniPowTrTactMutipleTimeL 		0A4H	;Time Base = 50us, 50us x 01A4h = 50us x 420 = 21ms (Tactive <= 21ms)
#DEFINE	c_IniPowTrTactMutipleTimeH		001H	;Time Base = 50us, 50us x 0190h = 50us x 400 = 20ms (Tactive <= 21ms)


;;==========================================================================================
;;Function :  INT1 Function Claim
;;Note     : 
;;==========================================================================================
;------- No Preamble Counter
#DEFINE	c_IniNoPreambleCNT			010H


;;==========================================================================================
;;Function :  Sv Paramenter of PID Claim
;;Note     : 
;;==========================================================================================
;;for New MOS 4226, Gate Resistance 10ohm
#DEFINE	c_IniSv181_205S           		032H	; Sv*10=5.0*10=50=32H
#DEFINE	c_IniSv181_205N		  		032H	; Sv*10=5.0*10=50=32H

#DEFINE	c_IniSv161_180S0			01EH	; Sv*10=3.0*10=30=1EH
#DEFINE	c_IniSv161_180S1			01DH	; Sv*10=2.9*10=29=1DH
#DEFINE	c_IniSv161_180N0			01EH	; Sv*10=3.0*10=30=1EH
#DEFINE	c_IniSv161_180N1			01DH	; Sv*10=2.9*10=29=1DH
#DEFINE	c_IniSv161_180B0			012H	; Sv*10=1.8*10=18=12H
#DEFINE	c_IniSv161_180B1			00DH	; Sv*10=1.3*10=13= DH
#DEFINE	c_IniSv161_180B11			011H	; Sv*10=1.7*10=17=11H
#DEFINE	c_IniSv161_180B111			00EH	; Sv*10=1.4*10=14= EH

#DEFINE	c_IniSv141_160N00			014H	; Sv*10=2.0*10=20=14H
#DEFINE	c_IniSv141_160N1			009H	; Sv*10=0.9*10= 9= 9H
#DEFINE	c_IniSv141_160S0			012H	; Sv*10=1.8*10=18=12H
#DEFINE	c_IniSv141_160S1			010H	; Sv*10=1.6*10=16=10H
#DEFINE	c_IniSv141_160B0			010H	; Sv*10=1.6*10=16=10H
#DEFINE	c_IniSv141_160B1			007H	; Sv*10=0.7*10= 7= 7H
#DEFINE	c_IniSv141_160B11			006H	; Sv*10=0.7*10= 7= 6H
#DEFINE	c_IniSv141_160B111			004H    ; Sv*10=0.4*10= 4= 4H
#DEFINE	c_IniSv131_140N00			013H	; Sv*10=0.9*10= 9= 9H

#DEFINE	c_IniSv131_140N1			009H	; Sv*10=0.9*10= 9= 9H
#DEFINE	c_IniSv131_140S0			008H	; Sv*10=0.8*10= 8= 8H
#DEFINE	c_IniSv131_140S1			007H	; Sv*10=0.7*10= 7= 7H
#DEFINE	c_IniSv131_140B0			008H	; Sv*10=0.8*10= 8= 8H
#DEFINE	c_IniSv131_140B1			004H	; Sv*10=0.4*10= 4= 4H
#DEFINE	c_IniSv131_140B11			003H	; Sv*10=0.3*10= 3= 3H
#DEFINE	c_IniSv131_140B111			002H	; Sv*10=0.2*10= 2= 2H

#DEFINE	c_IniSv121_130N00			011H	; Sv*10=1.7*10=17=11H
#DEFINE	c_IniSv121_130N1			006H	; Sv*10=0.6*10= 6= 6H
#DEFINE	c_IniSv121_130S0			008H	; Sv*10=0.8*10= 8= 8H
#DEFINE	c_IniSv121_130S1			007H	; Sv*10=0.7*10= 7= 7H
#DEFINE	c_IniSv121_130B0			005H	; Sv*10=0.5*10= 5= 5H
#DEFINE	c_IniSv121_130B1			003H	; Sv*10=0.3*10= 3= 3H
#DEFINE	c_IniSv121_130B11			002H	; Sv*10=0.2*10= 2= 2H
#DEFINE	c_IniSv121_130B111			001H	; Sv*10=0.1*10= 1= 1H

#DEFINE	c_IniSv110_120N0			002H	; Sv*10=0.2*10= 2= 2H
#DEFINE	c_IniSv110_120N1			001H	; Sv*10=0.1*10= 1= 1H
#DEFINE	c_IniSv110_120B0			002H	; Sv*10=0.2*10= 2= 2H
#DEFINE	c_IniSv110_120B1			001H	; Sv*10=0.1*10= 1= 1H
#DEFINE	c_IniSv110_120B11			001H	; Sv*10=0.1*10= 1= 1H
                                                        	
#DEFINE	c_IniReceiPowCNTL			060H	; 24000ms/250ms=96=60h
#DEFINE	c_IniReceiPowCNTH			000H

;;========================================================
;;Function :  Protection for Resonant Frequency_max/min
;;Note     : 
;;========================================================
;-------PLL max Threshold
#DEFINE	c_IniPLLFmaxL110			064H	; 110kHz=064H
#DEFINE	c_IniPLLFmaxH110			000H

;-------PLL min Threshold
#DEFINE	c_IniPLLFminL205			01AH	; 205kHz=41AH
#DEFINE	c_IniPLLFminH205			004H

;-------PLL max Threshold in dead time control
#DEFINE	c_IniPLLFL162				06CH	; 162kHz=26CH
#DEFINE	c_IniPLLFH162				002H


