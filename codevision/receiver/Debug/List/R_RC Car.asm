
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8/000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _a=R5
	.DEF _i=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x0:
	.DB  0x4F,0x6B,0x0,0x45,0x52,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x04
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;// Declare your global variables here
;
;unsigned char a,i=0;
;char rx_data[20];
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 000B {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 000C  a=rx_data[i]=UDR;
	MOV  R26,R4
	LDI  R27,0
	SUBI R26,LOW(-_rx_data)
	SBCI R27,HIGH(-_rx_data)
	IN   R30,0xC
	ST   X,R30
	MOV  R5,R30
; 0000 000D  i++;
	INC  R4
; 0000 000E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;void main(void)
; 0000 0015 {
_main:
; .FSTART _main
; 0000 0016 // Declare your local variables here
; 0000 0017 
; 0000 0018 // Input/Output Ports initialization
; 0000 0019 // Port A initialization
; 0000 001A // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 001B DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 001C // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 001D PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 001E 
; 0000 001F // Port B initialization
; 0000 0020 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0021 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0022 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0023 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0024 
; 0000 0025 // Port C initialization
; 0000 0026 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0027 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0028 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0029 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 002A 
; 0000 002B // Port D initialization
; 0000 002C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 002D DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 002E // State: Bit7=P Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 002F PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(128)
	OUT  0x12,R30
; 0000 0030 
; 0000 0031 
; 0000 0032 // USART initialization
; 0000 0033 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0034 // USART Receiver: On
; 0000 0035 // USART Transmitter: On
; 0000 0036 // USART Mode: Asynchronous
; 0000 0037 // USART Baud Rate: 9600
; 0000 0038 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0039 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 003A UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 003B UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 003C UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 003D 
; 0000 003E i=0;
	CLR  R4
; 0000 003F // Global enable interrupts
; 0000 0040 #asm("sei")
	sei
; 0000 0041 PORTA.5=1;
	SBI  0x1B,5
; 0000 0042 PORTA.0=1;
	SBI  0x1B,0
; 0000 0043 PORTA.2=1;
	SBI  0x1B,2
; 0000 0044 delay_ms(600);
	LDI  R26,LOW(600)
	LDI  R27,HIGH(600)
	CALL SUBOPT_0x0
; 0000 0045 PORTA.5=0;
; 0000 0046 delay_ms(200);
; 0000 0047 PORTA.5=1;
; 0000 0048 delay_ms(200);
	CALL SUBOPT_0x0
; 0000 0049 PORTA.5=0;
; 0000 004A delay_ms(200);
; 0000 004B PORTA.5=1;
; 0000 004C delay_ms(200);
	CALL SUBOPT_0x0
; 0000 004D PORTA.5=0;
; 0000 004E delay_ms(200);
; 0000 004F PORTA.5=1;
; 0000 0050 delay_ms(200);
	CALL _delay_ms
; 0000 0051 PORTA.5=0;
	CBI  0x1B,5
; 0000 0052 delay_ms(200);
	CALL SUBOPT_0x1
; 0000 0053 PORTC.0=1;
	SBI  0x15,0
; 0000 0054 delay_ms(200);
	CALL SUBOPT_0x1
; 0000 0055 PORTC.0=0;
	CBI  0x15,0
; 0000 0056 delay_ms(200);
	CALL SUBOPT_0x1
; 0000 0057 PORTC.1=1;
	SBI  0x15,1
; 0000 0058 delay_ms(200);
	CALL SUBOPT_0x1
; 0000 0059 PORTC.1=0;
	CBI  0x15,1
; 0000 005A delay_ms(200);
	CALL SUBOPT_0x1
; 0000 005B PORTC.2=1;
	SBI  0x15,2
; 0000 005C delay_ms(200);
	CALL SUBOPT_0x1
; 0000 005D PORTC.2=0;
	CBI  0x15,2
; 0000 005E delay_ms(200);
	CALL SUBOPT_0x1
; 0000 005F PORTC.0=1;
	SBI  0x15,0
; 0000 0060 PORTC.1=1;
	SBI  0x15,1
; 0000 0061 PORTC.2=1;
	SBI  0x15,2
; 0000 0062 delay_ms(200);
	CALL SUBOPT_0x1
; 0000 0063 PORTC.0=0;
	CBI  0x15,0
; 0000 0064 PORTC.1=0;
	CBI  0x15,1
; 0000 0065 PORTC.2=0;
	CBI  0x15,2
; 0000 0066 
; 0000 0067  while (1)
_0x2F:
; 0000 0068  {
; 0000 0069   if(PIND.7==0)
	SBIC 0x10,7
	RJMP _0x32
; 0000 006A   {
; 0000 006B    PORTA.1=1;
	SBI  0x1B,1
; 0000 006C   }
; 0000 006D   else
	RJMP _0x35
_0x32:
; 0000 006E   {
; 0000 006F    PORTA.1=0;
	CBI  0x1B,1
; 0000 0070   }
_0x35:
; 0000 0071 
; 0000 0072   if(a==']')
	LDI  R30,LOW(93)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x38
; 0000 0073   {
; 0000 0074    putsf("Ok");
	__POINTW2FN _0x0,0
	CALL _putsf
; 0000 0075    if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='0'&&rx_data[6]== ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x3A
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x3A
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x3A
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x3A
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x3A
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x30)
	BRNE _0x3A
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x3A
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
; 0000 0076    {
; 0000 0077     PORTA.0=1;
	SBI  0x1B,0
; 0000 0078     i=0;a=0;
	RJMP _0xBA
; 0000 0079    }
; 0000 007A    else
_0x39:
; 0000 007B    {
; 0000 007C     if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='1'&&rx_data[6]= ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x40
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x40
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x40
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x40
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x40
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x31)
	BRNE _0x40
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x40
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 007D     {
; 0000 007E      //PORTA.1=1;
; 0000 007F      i=0;a=0;
	RJMP _0xBA
; 0000 0080     }
; 0000 0081     else
_0x3F:
; 0000 0082     {
; 0000 0083      if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='2'&&rx_data[6] ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x44
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x44
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x44
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x44
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x44
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x32)
	BRNE _0x44
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x44
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
; 0000 0084      {
; 0000 0085       PORTA.2=1;
	SBI  0x1B,2
; 0000 0086       i=0;a=0;
	RJMP _0xBA
; 0000 0087      }
; 0000 0088      else
_0x43:
; 0000 0089      {
; 0000 008A       if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='3'&&rx_data[6 ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x4A
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x4A
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x4A
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x4A
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x4A
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x33)
	BRNE _0x4A
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x4A
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x4B
_0x4A:
	RJMP _0x49
_0x4B:
; 0000 008B       {
; 0000 008C        PORTA.3=1;
	SBI  0x1B,3
; 0000 008D        i=0;a=0;
	RJMP _0xBA
; 0000 008E       }
; 0000 008F       else
_0x49:
; 0000 0090       {
; 0000 0091        if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='4'&&rx_data[ ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x50
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x50
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x50
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x50
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x50
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x34)
	BRNE _0x50
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x50
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 0092        {
; 0000 0093         PORTA.4=1;
	SBI  0x1B,4
; 0000 0094         i=0;a=0;
	RJMP _0xBA
; 0000 0095        }
; 0000 0096        else
_0x4F:
; 0000 0097        {
; 0000 0098         if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='5'&&rx_data ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x56
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x56
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x56
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x56
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x56
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x35)
	BRNE _0x56
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x56
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x57
_0x56:
	RJMP _0x55
_0x57:
; 0000 0099         {
; 0000 009A          PORTA.5=1;
	SBI  0x1B,5
; 0000 009B          i=0;a=0;
	RJMP _0xBA
; 0000 009C         }
; 0000 009D         else
_0x55:
; 0000 009E         {
; 0000 009F          if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='6'&&rx_dat ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x5C
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x5C
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x5C
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x5C
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x5C
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x36)
	BRNE _0x5C
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x5C
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
; 0000 00A0          {
; 0000 00A1           PORTA.6=1;
	SBI  0x1B,6
; 0000 00A2           i=0;a=0;
	RJMP _0xBA
; 0000 00A3          }
; 0000 00A4          else
_0x5B:
; 0000 00A5          {
; 0000 00A6           if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='7'&&rx_da ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x62
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x62
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x62
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x62
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x62
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x37)
	BRNE _0x62
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x62
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x63
_0x62:
	RJMP _0x61
_0x63:
; 0000 00A7           {
; 0000 00A8            PORTA.7=1;
	SBI  0x1B,7
; 0000 00A9            i=0;a=0;
	RJMP _0xBA
; 0000 00AA           }
; 0000 00AB           else
_0x61:
; 0000 00AC           {
; 0000 00AD            if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='0'&&rx_d ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x68
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x68
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x68
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x68
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x68
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x30)
	BRNE _0x68
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x68
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0x69
_0x68:
	RJMP _0x67
_0x69:
; 0000 00AE            {
; 0000 00AF             PORTA.0=0;
	CBI  0x1B,0
; 0000 00B0             i=0;a=0;
	RJMP _0xBA
; 0000 00B1            }
; 0000 00B2            else
_0x67:
; 0000 00B3            {
; 0000 00B4             if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='1'&&rx_ ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x6E
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x6E
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x6E
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x6E
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x6E
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x31)
	BRNE _0x6E
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x6E
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0x6F
_0x6E:
	RJMP _0x6D
_0x6F:
; 0000 00B5             {
; 0000 00B6              //PORTA.1=0;
; 0000 00B7              i=0;a=0;
	RJMP _0xBA
; 0000 00B8             }
; 0000 00B9             else
_0x6D:
; 0000 00BA             {
; 0000 00BB              if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='2'&&rx ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x72
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x72
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x72
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x72
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x72
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x32)
	BRNE _0x72
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x72
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 00BC              {
; 0000 00BD               PORTA.2=0;
	CBI  0x1B,2
; 0000 00BE               i=0;a=0;
	RJMP _0xBA
; 0000 00BF              }
; 0000 00C0              else
_0x71:
; 0000 00C1              {
; 0000 00C2               if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='3'&&r ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x78
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x78
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x78
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x78
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x78
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x33)
	BRNE _0x78
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x78
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0x79
_0x78:
	RJMP _0x77
_0x79:
; 0000 00C3               {
; 0000 00C4                PORTA.3=0;
	CBI  0x1B,3
; 0000 00C5                i=0;a=0;
	RJMP _0xBA
; 0000 00C6               }
; 0000 00C7               else
_0x77:
; 0000 00C8               {
; 0000 00C9                if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='4'&& ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x7E
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x7E
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x7E
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x7E
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x7E
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x34)
	BRNE _0x7E
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x7E
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0x7F
_0x7E:
	RJMP _0x7D
_0x7F:
; 0000 00CA                {
; 0000 00CB                 PORTA.4=0;
	CBI  0x1B,4
; 0000 00CC                 i=0;a=0;
	RJMP _0xBA
; 0000 00CD                }
; 0000 00CE                else
_0x7D:
; 0000 00CF                {
; 0000 00D0                 if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='5'& ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x84
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x84
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x84
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x84
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x84
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x35)
	BRNE _0x84
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x84
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0x85
_0x84:
	RJMP _0x83
_0x85:
; 0000 00D1                 {
; 0000 00D2                  PORTA.5=0;
	CBI  0x1B,5
; 0000 00D3                  i=0;a=0;
	RJMP _0xBA
; 0000 00D4                 }
; 0000 00D5                 else
_0x83:
; 0000 00D6                 {
; 0000 00D7                  if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='6' ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x8A
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x8A
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x8A
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x8A
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x8A
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x36)
	BRNE _0x8A
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x8A
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
; 0000 00D8                 {
; 0000 00D9                  PORTA.6=0;
	CBI  0x1B,6
; 0000 00DA                  i=0;a=0;
	RJMP _0xBA
; 0000 00DB                 }
; 0000 00DC                 else
_0x89:
; 0000 00DD                 {
; 0000 00DE                  if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='7' ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x90
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x90
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x90
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x41)
	BRNE _0x90
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x90
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x37)
	BRNE _0x90
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x90
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0x91
_0x90:
	RJMP _0x8F
_0x91:
; 0000 00DF                  {
; 0000 00E0                   PORTA.7=0;
	CBI  0x1B,7
; 0000 00E1                   i=0;a=0;
	RJMP _0xBA
; 0000 00E2                  }
; 0000 00E3                  else
_0x8F:
; 0000 00E4                  {
; 0000 00E5                   if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]=='0 ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x96
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x96
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x96
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x43)
	BRNE _0x96
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x96
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x30)
	BRNE _0x96
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x96
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x97
_0x96:
	RJMP _0x95
_0x97:
; 0000 00E6                   {
; 0000 00E7                    PORTC.0=1;
	SBI  0x15,0
; 0000 00E8                    i=0;a=0;
	RJMP _0xBA
; 0000 00E9                   }
; 0000 00EA                   else
_0x95:
; 0000 00EB                   {
; 0000 00EC                    if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]==' ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0x9C
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0x9C
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0x9C
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x43)
	BRNE _0x9C
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0x9C
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x31)
	BRNE _0x9C
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0x9C
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 00ED                    {
; 0000 00EE                     PORTC.1=1;
	SBI  0x15,1
; 0000 00EF                     i=0;a=0;
	RJMP _0xBA
; 0000 00F0                    }
; 0000 00F1                    else
_0x9B:
; 0000 00F2                    {
; 0000 00F3                     if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]== ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0xA2
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0xA2
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0xA2
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x43)
	BRNE _0xA2
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0xA2
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x32)
	BRNE _0xA2
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0xA2
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x30)
	BREQ _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
; 0000 00F4                     {
; 0000 00F5                      PORTC.2=1;
	SBI  0x15,2
; 0000 00F6                      i=0;a=0;
	RJMP _0xBA
; 0000 00F7                     }
; 0000 00F8                     else
_0xA1:
; 0000 00F9                     {
; 0000 00FA                      if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]= ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0xA8
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0xA8
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0xA8
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x43)
	BRNE _0xA8
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0xA8
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x30)
	BRNE _0xA8
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0xA8
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0xA9
_0xA8:
	RJMP _0xA7
_0xA9:
; 0000 00FB                      {
; 0000 00FC                      PORTC.0=0;
	CBI  0x15,0
; 0000 00FD                      i=0;a=0;
	RJMP _0xBA
; 0000 00FE                      }
; 0000 00FF                      else
_0xA7:
; 0000 0100                      {
; 0000 0101                       if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5] ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0xAE
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0xAE
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0xAE
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x43)
	BRNE _0xAE
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0xAE
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x31)
	BRNE _0xAE
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0xAE
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0xAF
_0xAE:
	RJMP _0xAD
_0xAF:
; 0000 0102                       {
; 0000 0103                       PORTC.1=0;
	CBI  0x15,1
; 0000 0104                       i=0;a=0;
	RJMP _0xBA
; 0000 0105                       }
; 0000 0106                       else
_0xAD:
; 0000 0107                       {
; 0000 0108                        if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5 ...
	LDS  R26,_rx_data
	CPI  R26,LOW(0x50)
	BRNE _0xB4
	__GETB2MN _rx_data,1
	CPI  R26,LOW(0x49)
	BRNE _0xB4
	__GETB2MN _rx_data,2
	CPI  R26,LOW(0x4E)
	BRNE _0xB4
	__GETB2MN _rx_data,3
	CPI  R26,LOW(0x43)
	BRNE _0xB4
	__GETB2MN _rx_data,4
	CPI  R26,LOW(0x2E)
	BRNE _0xB4
	__GETB2MN _rx_data,5
	CPI  R26,LOW(0x32)
	BRNE _0xB4
	__GETB2MN _rx_data,6
	CPI  R26,LOW(0x3D)
	BRNE _0xB4
	__GETB2MN _rx_data,7
	CPI  R26,LOW(0x31)
	BREQ _0xB5
_0xB4:
	RJMP _0xB3
_0xB5:
; 0000 0109                        {
; 0000 010A                        PORTC.2=0;
	CBI  0x15,2
; 0000 010B                        i=0;a=0;
	RJMP _0xBA
; 0000 010C                        }
; 0000 010D                        else
_0xB3:
; 0000 010E                        {
; 0000 010F                         putsf("ER");
	__POINTW2FN _0x0,3
	CALL _putsf
; 0000 0110                         putchar(13);putchar(10);
	LDI  R26,LOW(13)
	RCALL _putchar
	LDI  R26,LOW(10)
	RCALL _putchar
; 0000 0111                         putchar(rx_data[0]);
	LDS  R26,_rx_data
	RCALL _putchar
; 0000 0112                         i=0;a=0;
_0xBA:
	CLR  R4
	CLR  R5
; 0000 0113                        }
; 0000 0114                       }
; 0000 0115                      }
; 0000 0116                     }
; 0000 0117                    }
; 0000 0118                   }
; 0000 0119                  }
; 0000 011A                 }
; 0000 011B                }
; 0000 011C               }
; 0000 011D              }
; 0000 011E             }
; 0000 011F            }
; 0000 0120           }
; 0000 0121          }
; 0000 0122         }
; 0000 0123        }
; 0000 0124       }
; 0000 0125      }
; 0000 0126     }
; 0000 0127    }
; 0000 0128   }
; 0000 0129  }
; 0000 012A 
; 0000 012B  }
_0x38:
	RJMP _0x2F
; 0000 012C }
_0xB9:
	RJMP _0xB9
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
; .FEND
_putsf:
; .FSTART _putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000006:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000008
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2000006
_0x2000008:
	LDI  R26,LOW(10)
	RCALL _putchar
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_rx_data:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	CALL _delay_ms
	CBI  0x1B,5
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x1B,5
	LDI  R26,LOW(200)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
