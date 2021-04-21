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
PUBLIC			ExtractPacData

EXTERN			DemoCLR					:	near

EXTERN			fg_ChecksumBit				:	bit
EXTERN			fg_PacDataOK				:	bit
EXTERN			a_DataByteCNTtemp			:	byte
EXTERN			a_AddrDataOUT				:	byte
EXTERN			a_HeadMessageCNT			:	byte
EXTERN			a_ContlDataMessag			:	byte
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
EXTERN			a_XORchecksum				:	byte


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
PackageData		.Section 	'code'
;========================================================
;Function : ExtractPacData
;Note     : Call Function Type for Packege format 
;		input =  (1) a_AddrDataOUT for a_DataOUT by IAR0 for Header, Message, checksum
;			 (2) a_DataByteCNTtemp
;			 (3) fg_ChecksumBit (Default=0, True(OK)=1)
;		output = (1)  a_DataHeader
;			 (2)  a_DataMessageB0
;			 (3)  a_DataMessageB1
;			 (4)  a_DataMessageB2
;			 (5)  a_DataMessageB3
;			 (6)  a_DataMessageB4
;			 (7)  a_DataMessageB5
;			 (8)  a_DataMessageB6
;			 (9)  a_DataMessageB7
;			 (10) a_DataChecksum
;			 (11) fg_PacDataOK (Default=1, True(OK)=0)
;========================================================
	ExtractPacData:
			CLR WDT
			CLR	a_XORchecksum
			SNZ	fg_ChecksumBit
			JMP	EPD_DataMessageEnd

			DEC	a_DataByteCNTtemp			
	EPD_DataMessageH:
			MOV	A, a_AddrDataOUT
			ADD	A, a_HeadMessageCNT
			MOV	MP0, A
			MOV	A, IAR0
			MOV	a_DataHeader, A				; Header Data(1)
			XORM	A, a_XORchecksum                	
			JMP	EPD_DataMessageAJ               	
	EPD_DataMessageB:                                       	
			MOV	A, a_AddrDataOUT                	
			ADD	A, a_HeadMessageCNT             	
			MOV	MP0, A                          	
			MOV	A, IAR0                         	
	EPD_DataMessageB0:                                      	
			SNZ	a_ContlDataMessag.0			; Message Data B0(2)
			JMP	EPD_DataMessageB1               	
			MOV	a_DataMessageB0, A              	
			XORM	A, a_XORchecksum                	
			JMP	EPD_DataMessageAJ               	
	EPD_DataMessageB1:                                      	
			SNZ	a_ContlDataMessag.1			; Message Data B1(3)
			JMP	EPD_DataMessageB2               	
			MOV	a_DataMessageB1, A              	
			XORM	A, a_XORchecksum                	
			JMP	EPD_DataMessageAJ               	
	EPD_DataMessageB2:                                      	
			SNZ	a_ContlDataMessag.2			; Message Data B2(4)
			JMP	EPD_DataMessageB3               	
			MOV	a_DataMessageB2, A              	
			XORM	A, a_XORchecksum                	
			JMP	EPD_DataMessageAJ               	
	EPD_DataMessageB3:                                      	
			SNZ	a_ContlDataMessag.3			; Message Data B3(5)
			JMP	EPD_DataMessageB4               	
			MOV	a_DataMessageB3, A              	
			XORM	A, a_XORchecksum                	
			JMP	EPD_DataMessageAJ               	
	EPD_DataMessageB4:                                      	
			SNZ	a_ContlDataMessag.4			; Message Data B4(6)
			JMP	EPD_DataMessageB5               	
			MOV	a_DataMessageB4, A              	
			XORM	A, a_XORchecksum                	
			JMP	EPD_DataMessageAJ               	
	EPD_DataMessageB5:                                      	
			SNZ	a_ContlDataMessag.5			; Message Data B5(7)
			JMP	EPD_DataMessageB6               	
			MOV	a_DataMessageB5, A              	
			XORM	A, a_XORchecksum                	
			JMP	EPD_DataMessageAJ               	
	EPD_DataMessageB6:                                      	
			SNZ	a_ContlDataMessag.6			; Message Data B6(8)
			JMP	EPD_DataMessageB7               	
			MOV	a_DataMessageB6, A              	
			XORM	A, a_XORchecksum                	
			JMP	EPD_DataMessageAJ               	
	EPD_DataMessageB7:                                      	
			SNZ	a_ContlDataMessag.7			; Message Data B7(9)
			JMP	EPD_DataChecksum
			MOV	a_DataMessageB7, A
			XORM	A, a_XORchecksum
	EPD_DataMessageAJ:		
			CLR WDT
			INC	a_HeadMessageCNT
			RL	a_ContlDataMessag
			MOV	A, a_HeadMessageCNT
			XOR	A, a_DataByteCNTtemp
			SNZ	STATUS.2 ;;1=True
			JMP	EPD_DataMessageB

			;JMP	EPD_DataChecksum
	EPD_DataChecksum:
			MOV	A, a_AddrDataOUT
			ADD	A, a_HeadMessageCNT
			MOV	MP0, A
			MOV	A, IAR0
			MOV	a_DataChecksum, A		; Checksum Data(10)
	EPD_DataCheck:		
			MOV	A, a_XORchecksum
			XOR	A, a_DataChecksum
			SNZ	STATUS.2
			JMP	EPD_DataMessageEnd

			CLR	fg_PacDataOK
	EPD_DataMessageEnd:
			CLR	a_HeadMessageCNT
			CLR	a_DataByteCNTtemp
			MOV	A, 080H
			MOV	a_ContlDataMessag, A
			CLR	a_XORchecksum
			CLR	fg_ChecksumBit
			CALL	DemoCLR
			CLR	a_AddrDataOUT
			RET

END