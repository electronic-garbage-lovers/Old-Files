	AREA |nesasm|, CODE, READONLY;, ALIEN=2 ；指定后面的指令为4字节对齐
	;AREA  伪代码也是需要语法的，AREA  后面跟着段名标号，然后是属性，CODE 表示这是一 
	;个代码段，READONLY 表示这个段是只读的
	;|.text|系统默认的代码段名   
	;ENTRY  ;这个伪代码是用来定义入口点
	THUMB	 ;Thumb是ARM体系结构中一种16位的指令集
;	REQUIRE8  ;REQUIRE8 指令指定当前文件要求堆栈八字节对齐。 它设置 REQ8 编译属性以通知链接器。
;	PRESERVE8 ;PRESERVE8 指令指定当前文件保持堆栈八字节对齐。 它设置 PRES8 编译属性以通知链接器。
			  ;如果您省略 PRESERVE8 和 PRESERVE8 {FALSE}，汇编程序会检查修改 sp 的指令，
			  ;以决定是否设置 PRES8 编译属性。 ARM 建议明确指定 PRESERVE8。
			  ; ARM使用r0作为返回值
			  ;参数传递ARM：寄存器到堆栈，首先将参数赋给r0, r1等

;1)寄存器的使用规则
;子程序之间通过寄存器r0~r3来传递参数，当参数个数多于4个时，使用堆栈来传递参数。
;此时r0~r3可记作A1~A4。
;在子程序中，使用寄存器r4~r11保存局部变量。因此当进行子程序调用时要注意对这些寄存器的保存和恢复。
;此时r4~r11可记作V1~V8。
;寄存器r12用于保存堆栈指针SP，当子程序返回时使用该寄存器出栈，记作IP。
;寄存器r13用作堆栈指针，记作SP。寄存器r14称为链接寄存器，记作LR。该寄存器用于保存子程序的返回地址。
;寄存器r15称为程序计数器，记作PC。
;2)堆栈的使用规则
;ATPCS规定堆栈采用满递减类型(FD,Full Descending)，即堆栈通过减小存储器地址而向下增长，
;堆栈指针指向内含有效数据项的最低地址。
;3)参数的传递规则
;整数参数的前4个使用r0~r3传递，其他参数使用堆栈传递；浮点参数使用编号最小且能够满足需要的一组
;连续的FP寄存器传递参数。
;子程序的返回结果为一个32位整数时，通过r0返回；返回结果为一个64位整数时，通过r0和r1返回；
;依此类推。结果为浮点数时，通过浮点运算部件的寄存器F0、D0或者S0返回	


;a_reg RN r0
;a123 RN r1	   ;定义寄存器名
;COEF RN r2
;VLO RN r0
;VHI RN r3

	IMPORT ram6502	 ;声明c语言中的全局变量
	IMPORT PPU_RegRead 	;读PPU，声明将要调用的C语言函数；通过BL指令来调用C函数
;读取6502存储器		  
;int get6502memory(WORD addr)//没0x2000递增
get6502memory1 PROC		 ;PROC定义标号
	EXPORT get6502memory1	 ;EXPORT 伪代码为我们完成了符号导出的的工作
	stmfd sp!, {r4-r11, r14}	;将R4-r11,R14这几个寄存器中的值保存到堆栈中			 
	sub sp, sp, #8				;保存PC指针
			 
	mov r7,r0
	and r7,#0xE000				;addr & 0xE000
	cmp r7,#0x0000				;比较	
	beq ram1			   ;判断，相等跳转，不等执行下一条
	cmp r7,#0x1000				;比较	
	beq ram1			   ;判断，相等跳转，不等执行下一条
	cmp r7,#0x2000				;比较	
	beq ppu1			   ;判断，相等跳转，不等执行下一条


	 					 
ram1
	ldr r6,=ram6502	 ;读全局变量地址到寄存器	数组指针
	mov r5,#0x07FF
	and r0,r5				;addr & 0x7FF
	ldr r0,[r6,R0]	 ;读r0地址偏移3的数据到寄存器  r0=r0[3]
	b   over1
ppu1
	bl 	PPU_RegRead	 ;调用C函数

over1 
	add sp, sp, #8			  ; 恢复pc指针
	ldmfd sp!, {r4-r11, pc}	  ;恢复堆栈

	ENDP



nop65021 PROC		 ;PROC定义标号
	EXPORT nop65021	 ;EXPORT 伪代码为我们完成了符号导出的的工作
	
	ENDP

	END



















