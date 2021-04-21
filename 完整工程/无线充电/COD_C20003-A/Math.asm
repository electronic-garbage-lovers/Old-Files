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
PUBLIC		sum_ADC_value
PUBLIC		avg_ADC_value
PUBLIC		SignedSub_8Bit
PUBLIC		bin_add_8
PUBLIC		SignedAdd_16Bit
PUBLIC		SignedSub_16Bit
PUBLIC		bin_add_16
PUBLIC		SignedMul_16Bit
PUBLIC		unbin_mul_16
PUBLIC		SignedAdd_24Bit
PUBLIC		SignedSub_24Bit
PUBLIC		SignedMul_24Bit
PUBLIC		unbin_mul_24
PUBLIC		SignedDiv_24Bit
PUBLIC		unbin_div_24
PUBLIC		CLRMath

EXTERN		a_com1					:	byte			
EXTERN		a_com2				        :	byte
EXTERN		a_com3				        :	byte
EXTERN		a_com4					:	byte
EXTERN		a_data0					:	byte
EXTERN		a_data1				        :	byte
EXTERN		a_data2					:	byte
EXTERN		a_data3					:	byte
EXTERN		a_data4					:	byte
EXTERN		a_data5				        :	byte
EXTERN		a_data6					:	byte
EXTERN		a_data7					:	byte
EXTERN		a_to0					:	byte
EXTERN		a_to1				        :	byte
EXTERN		a_to2                                   :	byte
EXTERN		a_to3                                   :	byte
EXTERN		a_to4                           	:	byte
EXTERN		a_to5                           	:	byte
EXTERN		a_to6                           	:	byte
EXTERN		a_to7                                   :	byte
EXTERN		a_count0				:	byte
EXTERN		a_temp2                         	:	byte
EXTERN		a_temp1                                 :	byte
EXTERN		a_temp0                                 :	byte
EXTERN		fg_adc_avg_cnt				:	bit


;*******************************************************************************************
;*****	                            Program Body	                               *****
;*******************************************************************************************
Math		.Section 	'code'
;=================================================================;
; Function Name  : sum_ADC_value
; Input          : adc_value[0..1],adc_sum[0..2], fg_adc_avg_cnt
; Output         : adc_sum[0..2],adc_max[0..1],adc_min[0..1]
; Description    : delet max and min and sum others
;=================================================================;
	sum_ADC_value:		
	       		CLR WDT
	       		mov	a,r0					; low byte
	        	addm	a,a_to0
	        	mov	a,r1					; high byte
	        	adcm	a,a_to1
	        	mov	a,00h
	        	adcm	a,a_to2		
			SZ	fg_adc_avg_cnt
			jmp	det_ADC_MaxMin
	rst_ADC_MaxMin:
			mov	a,r0					; low byte
			mov	a_to3,a
			mov	a_to5,a
			mov	a,r1					; high byte
			mov	a_to4,a
			mov	a_to6,a
			SET	fg_adc_avg_cnt
			ret
	det_ADC_MaxMin:
	det_ADC_Max:
			; adc_value - adc_max 
			clr	a_temp0
			mov	a, r0					; low byte
			sub	a, a_to3
			mov	a_to7, a
			mov	a, r1					; high byte
			sbc	a, a_to4
			mov	a_temp1, a
			mov	a, 00h
			sbcm	a, a_temp0
			sz	a_temp0		
			jmp	det_ADC_Min
	update_ADC_Max:
			mov	a,r0					; low byte
			mov	a_to3, a
			mov	a,r1					; high byte
			mov	a_to4, a
			ret			
	det_ADC_Min:
			; adc_min - adc_value
			clr	a_temp0
			mov	a, a_to5
			SUB	a,r0	 				; low byte
			mov	a_to7, a
			mov	a, a_to6
			SBC	a,r1					; high byte
			mov	a_temp1, a
			mov	a, 00h
			sbcm	a, a_temp0
			sz	a_temp0		
			ret			
	update_ADC_Min:
			mov	a,r0					; low byte
			mov	a_to5,a
			mov	a,r1					; high byte
			mov	a_to6,a
			ret
;=================================================================;
; Function Name  : avg_ADC_value
; Input          : adc_sum[0..2],adc_max[0..1],adc_min[0..1]
; Output         : adc_temp[0..2]
; Description    : Sum_ADC_Value /8
;=================================================================;
	avg_ADC_value:		
			; adc_sum - adc_max
			CLR WDT
			clr	a_temp0
			mov	a, a_to0				;;Sum_Low
			sub	a, a_to3				;;Max_Low
			mov	a_to7, a				;;Rol_Low
			mov	a, a_to1				;;Sum_Mid
			sbc	a, a_to4				;;Max_High
			mov	a_temp1, a				;;Rol_High
			mov	a, 00h
			sbcm	a,a_temp0
			; adc_sum - adc_max - adc_min
			mov	a, a_to7				;;Rol_Low
			sub	a, a_to5				;;Min_Low
			mov	a_to7, a				;;TRol_Low
			mov	a, a_temp1				;;Rol_High
			sbc	a, a_to6				;;Min_High
			mov	a_temp1, a				;;TRol_High
			mov	a, 00h
			sbcm	a, a_temp0
			; /8=2e3 
			clr	c
			rrc	a_temp1
			rrc	a_to7	
			clr	c
			rrc	a_temp1
			rrc	a_to7
			clr	c
			rrc	a_temp1
			rrc	a_to7		
			ret		


;========================================================
;Function : SignedSub_8Bit(16us @20MHz)
;Note     : Call Function Type for Math of Substration  
;input    : a_data0
;	  : a_data4
;output   : a_to1(H)_to0(L)
;========================================================
	SignedSub_8Bit:
			CLR 	WDT					;a_data0-a_data4
	        	clr	a_com3	
			cpl	a_data4
			mov	a, 01h
			addm	a, a_data4
	        	mov	a, 80h		
	        	sub	a, a_data4
	        	sz	acc
	        	jmp	begins
	        	
	        	mov	a, 7fh
	        	mov	a_data4, a
	        	inc	a_com3
	begins:
	 		call	bin_add_8
	 		mov	a, a_com3
	 		addm	a, a_to0
	        	mov	a, 00h
	        	adcm	a, a_to1
			ret 	

;========================================================
;Function : bin_add_8
;Note     : Call Function Type for Math of Addtion
;input    : a_data0
;	  : a_data4
;output   : a_to1(H)_to0(L)
;========================================================
	bin_add_8:
			clr	a_com1					;a_data0+a_data4
			clr	a_com2
			sz	a_data0.7          
			set	a_com1
			sz	a_data4.7
			set	a_com2
			mov	a, a_data0
			add	a, a_data4
	        	mov	a_to0, a
			mov	a, a_com1
			adc	a, a_com2
	        	mov	a_to1, a
	        	CLR 	WDT
			ret


;========================================================
;Function : SignedAdd_16Bit
;Note     : Call Function Type for Math of Addtion
;		input = a_data1(H)_data0(L)
;			a_data5(H)_data4(L)
;		output = a_to2(H)_to1(M)_to0(L)
;========================================================
	SignedAdd_16Bit:
	     		CLR WDT
	     		clr	a_com1					;data0data1+data4data5
	     		clr	a_com2
	    		sz	a_data1.7
			set	a_com1
	     		sz	a_data5.7
			set	a_com2
			mov	a, a_data0
			add	a, a_data4
	    		mov	a_to0, a
	    		mov	a, a_data1
	    		adc	a, a_data5
	    		mov	a_to1, a
	     		mov	a, a_com1
	      		adc	a, a_com2
	        	mov	a_to2, a
			ret


;========================================================
;Function : SignedSub_16Bit
;Note     : Call Function Type for Math of Substration
;input    : a_data1(H)_data0(L)
;	  : a_data5(H)_data4(L)
;output   : a_to2(H)_to1(M)_to0(L)
;========================================================
	SignedSub_16Bit:
			CLR WDT
			clr	a_com3					;data0data1-data4data5
			cpl	a_data4
	        	cpl	a_data5    
			mov	a, 01h
			addm	a, a_data4
	        	mov	a, 00h
	        	adcm	a, a_data5
	        	
	        	mov	a, 80h		
	        	sub	a, a_data5
	        	sz	acc
	        	jmp	begins16
	        	
	        	mov	a, 00h
	        	sub	a, a_data4
	        	sz	acc
	        	jmp	begins16
	        	
	        	mov	a, 0ffh
	        	mov	a_data4, a
	        	mov	a, 7fh
	        	mov	a_data5, a
	        	inc	a_com3
	begins16:
	 		call	bin_add_16
	        	mov	a, a_to0
	        	add	a, a_com3
	        	mov	a_to0, a
	        	mov	a, 00h
	        	adcm	a, a_to1
	        	adcm	a, a_to2
			ret

;========================================================
;Function : bin_add_16
;Note     : Call Function Type for Math
;input    : a_data1(H)_data0(L)
;	  : a_data5(H)_data4(L)
;output   : a_to2(H)_to1(M)_to0(L)
;========================================================
	bin_add_16:
	     		clr	a_com1					;data0data1+data4data5
	     		clr	a_com2
	    		sz	a_data1.7
			set	a_com1
	     		sz	a_data5.7
			set	a_com2
			mov	a, a_data0
			add	a, a_data4
	    		mov	a_to0, a
	    		mov	a, a_data1
	    		adc	a, a_data5
	    		mov	a_to1, a
	     		mov	a, a_com1
	      		adc	a, a_com2
	        	mov	a_to2, a
	        	CLR 	WDT
			ret


;========================================================
;Function : SignedMul_16Bit(66us@20MHz)
;Note     : Call Function Type for Math of Multiple
;input 	  : a_data1(H)_data0(L)
;	  : a_data5(H)_data4(L)
;output   : a_to3(H)_to2(M2)_to1(M1)_to0(L)
;========================================================
	SignedMul_16Bit:
			CLR WDT
	        	clr	a_com1					;data0data1*data4data5
	        	clr	a_com2		
	        	clr	[0Ah].0
	        	rlca	a_data1
	        	rlc	a_com1
	        	snz	a_com1.0
	        	jmp	chu16
	        	
	        	cpl	a_data0
	        	cpl	a_data1
	        	mov	a, 01h
	        	addm	a, a_data0
	        	mov	a, 00h
	        	adcm	a, a_data1  
	chu16:  
			clr	[0Ah].0
	        	rlca	a_data5
	        	rlc	a_com2
	        	snz	a_com2.0
	        	jmp	unmul16
	        	
	        	cpl	a_data4
	        	cpl	a_data5
	        	mov	a, 01h
	        	addm	a, a_data4
	        	mov	a, 00h
	        	adcm	a, a_data5
	unmul16:
			call	unbin_mul_16	
	        	mov	a, a_com1
	        	or	a, a_com2
	        	snz	acc.0
	        	jmp	dismul16	
	        	
	        	mov	a, a_com1
	        	and	a, a_com2
	       		sz	acc.0
	       		jmp	dismul16	
	        	
	        	cpl	a_to0		
	        	cpl	a_to1
	        	cpl	a_to2
	        	cpl	a_to3
	        	mov	a, 01h
	        	addm	a, a_to0
	        	mov	a, 00h
	        	adcm	a, a_to1
	        	adcm	a, a_to2
	        	adcm	a, a_to3
	dismul16:
			ret


;========================================================
;Function : unbin_mul_16
;Note     : Call Function Type for Math
;input    : a_data1(H)_data0(L)
;	  : a_data5(H)_data4(L)
;output   : a_to3(H)_to2(M2)_to1(M1)_to0(L)
;========================================================
	unbin_mul_16:
			CLR WDT
			mov	a, 10h					;data0data1*data4data5
			mov	a_count0, a    
	    		clr	[0ah].0  
	rradd16:
	        	rrc	a_to3
	        	rrc	a_to2
	        	rrc	a_data5         
	        	rrc	a_data4
	        	snz	[0ah].0      
	        	jmp	rr116
	        	
	        	mov	a, a_data0
	        	addm	a, a_to2
	        	mov	a, a_data1
	        	adcm	a, a_to3
	rr116:
			sdz	a_count0
	        	jmp	rradd16     
	        	
	        	rrc	a_to3
	        	rrc	a_to2
	        	rrc	a_data5
	        	rrc	a_data4
	        	mov	a, a_data4
	        	mov	a_to0, a
	        	mov	a, a_data5
	        	mov	a_to1, a
			ret


;========================================================
;Function : SignedAdd_24Bit
;Note     : Call Function Type for Math of Addtion
;input    : a_data2(H)_data1(M)_data0(L)
;	  : a_data6(H)_data5(M)_data4(L)
;output   : a_to3(H)_to2(M2)_to1(M1)_to0(L)
;========================================================
	SignedAdd_24Bit:
		        CLR WDT
		        mov	a, 00h    				;data0data1data2+data4data5data6
		        mov	a_com1, a
		     	mov	a_com2, a
		    	sz	a_data2.7
		    	mov	a, 0ffh

			mov	a_com1, a
			mov	a, 00h
		     	sz	a_data6.7
			mov	a, 0ffh

			mov	a_com2, a
			mov	a, a_data0
			add	a, a_data4
		        mov	a_to0, a
		        mov	a, a_data1
		        adc	a, a_data5
		        mov	a_to1, a
		        mov	a, a_data2
		        adc	a, a_data6
		        mov	a_to2, a
		     	mov	a, a_com1
		      	adc	a, a_com2
		        mov	a_to3, a
			ret


;========================================================
;Function : SignedSub_24Bit(20us@20MHz)
;Note     : Call Function Type for Math of Substration          
;input    : a_data2(H)_data1(M)_data0(L)
;	  : a_data6(H)_data5(M)_data4(L)
;output   : a_to3(H)_to2(M2)_to1(M1)_to0(L)
;========================================================
	SignedSub_24Bit:
			CLR WDT						;data0data1data2-data4data5data6
			mov	a, 00h
	        	mov	a_com3, a
			cpl	a_data4
	        	cpl	a_data5
	        	cpl	a_data6    
			mov	a, 01h
			addm	a, a_data4
	        	mov	a, 00h
	        	adcm	a, a_data5
	        	adcm	a, a_data6
	        	
	        	mov	a, 80h        
			sub	a, a_data6
	        	sz	acc
	        	jmp	begins24
	        	
	        	mov	a, 00h
	        	sub	a, a_data5
	        	sz	acc
	        	jmp	begins24
	        	
	        	mov	a, 00h
	        	sub	a, a_data4   
	        	sz	acc
	        	jmp	begins24                  
	        	
	        	mov	a, 0ffh
	        	mov	a_data4, a
	        	mov	a_data5, a
	        	mov	a, 07fh
	        	mov	a_data6, a
	        	inc	a_com3
	begins24:
			call	SignedAdd_24Bit
	        	mov	a, a_to0
	        	add	a, a_com3
	        	mov	a_to0, a
	        	mov	a, 00h
	        	adcm	a, a_to1
	        	adcm	a, a_to2
	        	adcm	a, a_to3
			ret


;========================================================
;Function : SignedMul_24Bit(78us@20MHz)
;Note     : Call Function Type for Math of Multiple	
;input 	  : a_data2(H)_data1(M)_data0(L)
;	  : a_data6(H)_data5(M)_data4(L)
;output   : a_to5(H)_to4(M3)_to3(M2)_to2(M1)_to1(M0)_to0(L)
;========================================================
	SignedMul_24Bit:
	        	mov	a, 00h					;data0data1data2*data4data5data6
	        	mov	a_com1, a	
	        	mov	a_com2, a
	        	clr	[0Ah].0
	        	rlca	a_data2
	        	rlc	a_com1
	        	snz	a_com1.0
	        	jmp	chu24
	        	
	        	cpl	a_data0
	        	cpl	a_data1
	        	cpl	a_data2
	        	mov	a, 01h
	        	addm	a, a_data0
	        	mov	a, 00h
	        	adcm	a, a_data1
	        	adcm	a, a_data2 
	chu24:  
			CLR WDT
			clr	[0Ah].0
	        	rlca	a_data6
	        	rlc	a_com2
	        	snz	a_com2.0
	        	jmp	unmul24
	        	
	        	cpl	a_data4
	        	cpl	a_data5
	        	cpl	a_data6
	        	mov	a, 01h
	        	addm	a, a_data4
	        	mov	a, 00h
	        	adcm	a, a_data5
	        	adcm	a, a_data6
	unmul24:
			call	unbin_mul_24
	        	mov	a, a_com1
	        	or	a, a_com2
	        	snz	acc.0
	        	jmp	dismul24	
	        	
	        	mov	a, a_com1
	        	and	a, a_com2
	       		sz	acc.0
	       		jmp	dismul24	
	        	
	        	cpl	a_to0		
	        	cpl	a_to1
	        	cpl	a_to2
	        	cpl	a_to3
	        	cpl	a_to4
	        	cpl	a_to5
	        	mov	a, 01h
	        	addm	a, a_to0
	        	mov	a, 00h
	        	adcm	a, a_to1
	        	adcm	a, a_to2
	        	adcm	a, a_to3
	        	adcm	a, a_to4
	        	adcm	a, a_to5
	dismul24:
			ret

;========================================================
;Function : unbin_mul_24
;Note     : Call Function Type for Math of Multiple	
;input    : a_data2(H)_data1(M)_data0(L)
; 	  : a_data6(H)_data5(M)_data4(L)
;output   : a_to5(H)_to4(M3)_to3(M2)_to2(M1)_to1(M0)_to0(L)
;========================================================
	unbin_mul_24:
			mov	a, 18h					;data0data1data2*data4data5data6
			mov	a_count0, a    
	    		clr	[0ah].0  
	rradd24:
			CLR WDT
			rrc	a_to5
	        	rrc	a_to4
	        	rrc	a_to3
	        	rrc	a_data6
	        	rrc	a_data5         
	        	rrc	a_data4
	        	snz	[0ah].0      
	        	jmp	rr124
	        	
	        	mov	a, a_data0
	        	addm	a, a_to3
	        	mov	a, a_data1
	        	adcm	a, a_to4
	        	mov	a, a_data2
	        	adcm	a, a_to5
	rr124: 
	 		sdz	a_count0
	        	jmp	rradd24
	        	
	        	rrc	a_to5     
	        	rrc	a_to4
	        	rrc	a_to3
	        	rrc	a_data6
	        	rrc	a_data5
	        	rrc	a_data4
	        	mov	a, a_data4
	        	mov	a_to0, a
	        	mov	a, a_data5
	        	mov	a_to1, a
	        	mov	a, a_data6
	        	mov	a_to2, a
			ret


;========================================================
;Function : SignedDiv_24Bit(20us@20MHz)
;Note     : Call Function Type for Math of Substration   	
;input    : a_data2(H)_data1(M)_data0(L)
;	  : a_data6(H)_data5(M)_data4(L)
;output   : a_to2(H)_to1(M)_to0(L)
;========================================================
	SignedDiv_24Bit:
	        	mov	a, 00h					;data0data1data2/data4data5data6
	        	mov	a_com1, a	
	        	mov	a_com2, a 
	        	clr	[0Ah].0
	        	rlca	a_data2
	        	rlc	a_com1
	        	snz	a_com1.0
	        	jmp	chu124
	        	cpl	a_data0
	        	cpl	a_data1
	        	cpl	a_data2
	        	mov	a, 01h
	        	addm	a, a_data0
	        	mov	a, 00h
	        	adcm	a, a_data1 
	        	adcm	a, a_data2
	chu124: 
			CLR WDT
			clr	[0Ah].0
	        	rlca	a_data6
	        	rlc	a_com2
	        	snz	a_com2.0
	        	jmp	undiv24
	        	cpl	a_data4
	        	cpl	a_data5
	        	cpl	a_data6
	        	mov	a, 01h
	        	addm	a, a_data4
	        	mov	a, 00h
	        	adcm	a, a_data5
	        	adcm	a, a_data6
	undiv24:
			call unbin_div_24
	        	mov	a, a_com1
	        	or	a, a_com2
	        	snz	acc.0
	        	jmp	disdiv24	
	        	mov	a, a_com1
	        	and	a, a_com2
	        	sz	acc.0
	        	jmp	disdiv24	
	        	
	        	cpl	a_to0		
	        	cpl	a_to1
	        	cpl	a_to2
	        	cpl	a_to3
	        	mov	a, 01h
	        	addm	a, a_to0
	        	mov	a, 00h
	        	adcm	a, a_to1
	        	adcm	a, a_to2
	        	adcm	a, a_to3
	disdiv24: 
			ret


;========================================================
;Function : unbin_div_24
;Note     : Call Function Type for Math of Substration   	
;input    : a_data2(H)_data1(M)_data0(L)
;	  : a_data6(H)_data5(M)_data4(L)
;output   : a_to2(H)_to1(M)_to0(L)
;========================================================
	unbin_div_24:
			CLR 	WDT					;data0data1data2/data4data5data6
	        	mov	a,18h	
	        	mov	a_count0, a 
	        	sz	a_data6	
	        	jmp	start24
	        	
	        	sz	a_data5
	        	jmp	start24
	        	
	        	sz	a_data4           
	        	jmp	start24
	        	
	        	jmp	over24
	start24:
			sz	a_data2	
	        	jmp	div24
	        	
	        	sz	a_data1
	        	jmp	div24
	        	
	        	sz	a_data0
	        	jmp	div24
	        	
	        	jmp	dispa24
	div24:  
			clr	[0Ah].0	
	        	rlc	a_data0
	        	rlc	a_data1
	        	rlc	a_data2
	        	rlc	a_to4
	        	rlc	a_to5  
	        	rlc	a_to6	
	        	mov	a, a_to4	
	        	sub	a, a_data4
	        	mov	a_com3, a
	        	mov	a, a_to5
	        	sbc	a, a_data5
	        	mov	a_com4, a
	        	mov	a, a_to6
	        	sbc	a, a_data6
	        	snz	[0Ah].0        
	        	jmp	next24	
	        	
	        	mov	a_to6, a
	        	mov	a, a_com3
	        	mov	a_to4, a
	        	mov	a, a_com4
	        	mov	a_to5, a	
	        	mov	a, 01h
	        	addm	a, a_data0
	        	mov	a, 00h
	        	adcm	a, a_data1
	        	adcm	a, a_data2
	next24:  
			sdz	a_count0
	        	jmp	div24
	dispa24:
			mov	a, a_data0
	        	mov	a_to0, a 
	        	mov	a, a_data1
	        	mov	a_to1, a   
	        	mov	a, a_data2
	        	mov	a_to2, a              
			mov	a, 00h
			mov	a_to3, a
	      		ret
	over24:
		       	ret	


;========================================================
;Function : CLRMath 
;Note     : 
;========================================================
		CLRMath:
			CLR	a_com1
			CLR	a_com2
			CLR	a_com3
			CLR	a_com4
			
			CLR	a_data0
			CLR	a_data1
			CLR	a_data2
			CLR	a_data3
			CLR	a_data4
			CLR	a_data5
			CLR	a_data6
			CLR	a_data7

			CLR	a_to0
			CLR	a_to1
			CLR	a_to2
			CLR	a_to3
			CLR	a_to4
			CLR	a_to5
			CLR	a_to6
			CLR	a_to7

			CLR	a_count0
			CLR 	WDT
			RET

END
