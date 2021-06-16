
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8/000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x50,0x49,0x4E,0x41,0x2E,0x30,0x3D,0x30
	.DB  0x0,0x50,0x49,0x4E,0x41,0x2E,0x30,0x3D
	.DB  0x31,0x0,0x50,0x49,0x4E,0x41,0x2E,0x31
	.DB  0x3D,0x30,0x0,0x50,0x49,0x4E,0x41,0x2E
	.DB  0x31,0x3D,0x31,0x0,0x50,0x49,0x4E,0x41
	.DB  0x2E,0x32,0x3D,0x30,0x0,0x50,0x49,0x4E
	.DB  0x41,0x2E,0x32,0x3D,0x31,0x0,0x50,0x49
	.DB  0x4E,0x41,0x2E,0x33,0x3D,0x30,0x0,0x50
	.DB  0x49,0x4E,0x41,0x2E,0x33,0x3D,0x31,0x0
	.DB  0x50,0x49,0x4E,0x41,0x2E,0x34,0x3D,0x30
	.DB  0x0,0x50,0x49,0x4E,0x41,0x2E,0x34,0x3D
	.DB  0x31,0x0,0x50,0x49,0x4E,0x41,0x2E,0x35
	.DB  0x3D,0x30,0x0,0x50,0x49,0x4E,0x41,0x2E
	.DB  0x35,0x3D,0x31,0x0,0x50,0x49,0x4E,0x41
	.DB  0x2E,0x36,0x3D,0x30,0x0,0x50,0x49,0x4E
	.DB  0x41,0x2E,0x36,0x3D,0x31,0x0,0x50,0x49
	.DB  0x4E,0x41,0x2E,0x37,0x3D,0x30,0x0,0x50
	.DB  0x49,0x4E,0x41,0x2E,0x37,0x3D,0x31,0x0
	.DB  0x50,0x49,0x4E,0x42,0x2E,0x31,0x3D,0x30
	.DB  0x0,0x50,0x49,0x4E,0x42,0x2E,0x31,0x3D
	.DB  0x31,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

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
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 22/02/2021
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8/000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;// Declare your global variables here
;
;bit a0,a1,a2,a3,a4,a5,a6,a7,b1;
;
;// This flag is set on USART Receiver buffer overflow
;
;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0025 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
; 0000 0026 
; 0000 0027 }
	RETI
; .FEND
;
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// SPI functions
;#include <spi.h>
;
;void main(void)
; 0000 0032 {
_main:
; .FSTART _main
; 0000 0033 // Declare your local variables here
; 0000 0034 
; 0000 0035 // Input/Output Ports initialization
; 0000 0036 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0037 DDRB.0=0xFF;
	SBI  0x17,0
; 0000 0038 DDRB.1=0x00;
	CBI  0x17,1
; 0000 0039 // Timer/Counter 1 initialization
; 0000 003A // Clock source: System Clock
; 0000 003B // Clock value: Timer1 Stopped
; 0000 003C // Mode: Normal top=0xFFFF
; 0000 003D // OC1A output: Disconnected
; 0000 003E // OC1B output: Disconnected
; 0000 003F // Noise Canceler: Off
; 0000 0040 // Input Capture on Falling Edge
; 0000 0041 // Timer1 Overflow Interrupt: Off
; 0000 0042 // Input Capture Interrupt: Off
; 0000 0043 // Compare A Match Interrupt: Off
; 0000 0044 // Compare B Match Interrupt: Off
; 0000 0045 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0046 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0047 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0048 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0049 ICR1H=0x00;
	OUT  0x27,R30
; 0000 004A ICR1L=0x00;
	OUT  0x26,R30
; 0000 004B OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 004C OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 004D OCR1BH=0x00;
	OUT  0x29,R30
; 0000 004E OCR1BL=0x00;
	OUT  0x28,R30
; 0000 004F 
; 0000 0050 // Timer/Counter 2 initialization
; 0000 0051 // Clock source: System Clock
; 0000 0052 // Clock value: Timer2 Stopped
; 0000 0053 // Mode: Normal top=0xFF
; 0000 0054 // OC2 output: Disconnected
; 0000 0055 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0056 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0057 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0058 OCR2=0x00;
	OUT  0x23,R30
; 0000 0059 
; 0000 005A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 005B TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 005C 
; 0000 005D // External Interrupt(s) initialization
; 0000 005E // INT0: Off
; 0000 005F // INT1: Off
; 0000 0060 // INT2: Off
; 0000 0061 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0062 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0063 
; 0000 0064 // USART initialization
; 0000 0065 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0066 // USART Receiver: On
; 0000 0067 // USART Transmitter: On
; 0000 0068 // USART Mode: Asynchronous
; 0000 0069 // USART Baud Rate: 9600
; 0000 006A UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 006B UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 006C UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 006D UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 006E UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 006F 
; 0000 0070 // Analog Comparator initialization
; 0000 0071 // Analog Comparator: Off
; 0000 0072 // The Analog Comparator's positive input is
; 0000 0073 // connected to the AIN0 pin
; 0000 0074 // The Analog Comparator's negative input is
; 0000 0075 // connected to the AIN1 pin
; 0000 0076 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0077 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0078 
; 0000 0079 // ADC initialization
; 0000 007A // ADC disabled
; 0000 007B ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 007C 
; 0000 007D // SPI initialization
; 0000 007E // SPI Type: Slave
; 0000 007F // SPI Clock Rate: 2000/000 kHz
; 0000 0080 // SPI Clock Phase: Cycle Start
; 0000 0081 // SPI Clock Polarity: Low
; 0000 0082 // SPI Data Order: MSB First
; 0000 0083 SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(64)
	OUT  0xD,R30
; 0000 0084 SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0085 
; 0000 0086 // TWI initialization
; 0000 0087 // TWI disabled
; 0000 0088 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0089 
; 0000 008A // Global enable interrupts
; 0000 008B #asm("sei")
	sei
; 0000 008C   while(PINA.0!=1|PINA.1!=1|PINA.2!=1|PINA.3!=1|PINA.4!=1|PINA.5!=1|PINA.6!=1|PINA.7!=1)
_0x7:
	LDI  R26,0
	SBIC 0x19,0
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __NEB12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x19,1
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __NEB12
	OR   R30,R0
	BREQ _0x9
; 0000 008D   {
; 0000 008E    PORTB.0=1;
	SBI  0x18,0
; 0000 008F    delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL _delay_ms
; 0000 0090    PORTB.0=0;
	CBI  0x18,0
; 0000 0091    delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL _delay_ms
; 0000 0092   }
	RJMP _0x7
_0x9:
; 0000 0093   PORTB.0=1;
	SBI  0x18,0
; 0000 0094  while (1)
_0x10:
; 0000 0095  {
; 0000 0096 
; 0000 0097     if(PINA.0==0&&a0==0)
	SBIC 0x19,0
	RJMP _0x14
	SBRS R2,0
	RJMP _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 0098   {
; 0000 0099    a0=1;
	SET
	BLD  R2,0
; 0000 009A    putsf("PINA.0=0");
	__POINTW2FN _0x0,0
	CALL SUBOPT_0x1
; 0000 009B    putchar(13);
; 0000 009C   }
; 0000 009D     if(PINA.0==1&&a0==1)
_0x13:
	SBIS 0x19,0
	RJMP _0x17
	SBRC R2,0
	RJMP _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 009E   {
; 0000 009F    a0=0;
	CLT
	BLD  R2,0
; 0000 00A0    putsf("PINA.0=1");
	__POINTW2FN _0x0,9
	CALL SUBOPT_0x1
; 0000 00A1    putchar(13);
; 0000 00A2   }
; 0000 00A3     if(PINA.1==0&&a1==0)
_0x16:
	SBIC 0x19,1
	RJMP _0x1A
	SBRS R2,1
	RJMP _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 00A4   {
; 0000 00A5    a1=1;
	SET
	BLD  R2,1
; 0000 00A6    putsf("PINA.1=0");
	__POINTW2FN _0x0,18
	CALL SUBOPT_0x1
; 0000 00A7    putchar(13);
; 0000 00A8   }
; 0000 00A9     if(PINA.1==1&&a1==1)
_0x19:
	SBIS 0x19,1
	RJMP _0x1D
	SBRC R2,1
	RJMP _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 00AA   {
; 0000 00AB    a1=0;
	CLT
	BLD  R2,1
; 0000 00AC    putsf("PINA.1=1");
	__POINTW2FN _0x0,27
	CALL SUBOPT_0x1
; 0000 00AD    putchar(13);
; 0000 00AE   }
; 0000 00AF     if(PINA.2==0&&a2==0)
_0x1C:
	SBIC 0x19,2
	RJMP _0x20
	SBRS R2,2
	RJMP _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 00B0   {
; 0000 00B1    a2=1;
	SET
	BLD  R2,2
; 0000 00B2    putsf("PINA.2=0");
	__POINTW2FN _0x0,36
	CALL SUBOPT_0x1
; 0000 00B3    putchar(13);
; 0000 00B4   }
; 0000 00B5     if(PINA.2==1&&a2==1)
_0x1F:
	SBIS 0x19,2
	RJMP _0x23
	SBRC R2,2
	RJMP _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 00B6   {
; 0000 00B7    a2=0;
	CLT
	BLD  R2,2
; 0000 00B8    putsf("PINA.2=1");
	__POINTW2FN _0x0,45
	CALL SUBOPT_0x1
; 0000 00B9    putchar(13);
; 0000 00BA   }
; 0000 00BB     if(PINA.3==0&&a3==0)
_0x22:
	SBIC 0x19,3
	RJMP _0x26
	SBRS R2,3
	RJMP _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 00BC   {
; 0000 00BD    a3=1;
	SET
	BLD  R2,3
; 0000 00BE    putsf("PINA.3=0");
	__POINTW2FN _0x0,54
	CALL SUBOPT_0x1
; 0000 00BF    putchar(13);
; 0000 00C0   }
; 0000 00C1     if(PINA.3==1&a3==1)
_0x25:
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x28
; 0000 00C2   {
; 0000 00C3    a3=0;
	CLT
	BLD  R2,3
; 0000 00C4    putsf("PINA.3=1");
	__POINTW2FN _0x0,63
	CALL SUBOPT_0x1
; 0000 00C5    putchar(13);
; 0000 00C6   }
; 0000 00C7     if(PINA.4==0&&a4==0)
_0x28:
	SBIC 0x19,4
	RJMP _0x2A
	SBRS R2,4
	RJMP _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
; 0000 00C8   {
; 0000 00C9    a4=1;
	SET
	BLD  R2,4
; 0000 00CA    putsf("PINA.4=0");
	__POINTW2FN _0x0,72
	CALL SUBOPT_0x1
; 0000 00CB    putchar(13);
; 0000 00CC   }
; 0000 00CD     if(PINA.4==1&&a4==1)
_0x29:
	SBIS 0x19,4
	RJMP _0x2D
	SBRC R2,4
	RJMP _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
; 0000 00CE   {
; 0000 00CF    a4=0;
	CLT
	BLD  R2,4
; 0000 00D0    putsf("PINA.4=1");
	__POINTW2FN _0x0,81
	CALL SUBOPT_0x1
; 0000 00D1    putchar(13);
; 0000 00D2   }
; 0000 00D3     if(PINA.5==0&&a5==0)
_0x2C:
	SBIC 0x19,5
	RJMP _0x30
	SBRS R2,5
	RJMP _0x31
_0x30:
	RJMP _0x2F
_0x31:
; 0000 00D4   {
; 0000 00D5    a5=1;
	SET
	BLD  R2,5
; 0000 00D6    putsf("PINA.5=0");
	__POINTW2FN _0x0,90
	CALL SUBOPT_0x1
; 0000 00D7    putchar(13);
; 0000 00D8   }
; 0000 00D9     if(PINA.5==1&&a5==1)
_0x2F:
	SBIS 0x19,5
	RJMP _0x33
	SBRC R2,5
	RJMP _0x34
_0x33:
	RJMP _0x32
_0x34:
; 0000 00DA   {
; 0000 00DB    a5=0;
	CLT
	BLD  R2,5
; 0000 00DC    putsf("PINA.5=1");
	__POINTW2FN _0x0,99
	CALL SUBOPT_0x1
; 0000 00DD    putchar(13);
; 0000 00DE   }
; 0000 00DF     if(PINA.6==0&&a6==0)
_0x32:
	SBIC 0x19,6
	RJMP _0x36
	SBRS R2,6
	RJMP _0x37
_0x36:
	RJMP _0x35
_0x37:
; 0000 00E0   {
; 0000 00E1    a6=1;
	SET
	BLD  R2,6
; 0000 00E2    putsf("PINA.6=0");
	__POINTW2FN _0x0,108
	CALL SUBOPT_0x1
; 0000 00E3    putchar(13);
; 0000 00E4   }
; 0000 00E5     if(PINA.6==1&&a6==1)
_0x35:
	SBIS 0x19,6
	RJMP _0x39
	SBRC R2,6
	RJMP _0x3A
_0x39:
	RJMP _0x38
_0x3A:
; 0000 00E6   {
; 0000 00E7    a6=0;
	CLT
	BLD  R2,6
; 0000 00E8    putsf("PINA.6=1");
	__POINTW2FN _0x0,117
	CALL SUBOPT_0x1
; 0000 00E9    putchar(13);
; 0000 00EA   }
; 0000 00EB     if(PINA.7==0&&a7==0)
_0x38:
	SBIC 0x19,7
	RJMP _0x3C
	SBRS R2,7
	RJMP _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
; 0000 00EC   {
; 0000 00ED    a7=1;
	SET
	BLD  R2,7
; 0000 00EE    putsf("PINA.7=0");
	__POINTW2FN _0x0,126
	CALL SUBOPT_0x1
; 0000 00EF    putchar(13);
; 0000 00F0   }
; 0000 00F1     if(PINA.7==1&&a7==1)
_0x3B:
	SBIS 0x19,7
	RJMP _0x3F
	SBRC R2,7
	RJMP _0x40
_0x3F:
	RJMP _0x3E
_0x40:
; 0000 00F2   {
; 0000 00F3    a7=0;
	CLT
	BLD  R2,7
; 0000 00F4    putsf("PINA.7=1");
	__POINTW2FN _0x0,135
	CALL SUBOPT_0x1
; 0000 00F5    putchar(13);
; 0000 00F6   }
; 0000 00F7       if(PINB.1==0&&b1==0)
_0x3E:
	SBIC 0x16,1
	RJMP _0x42
	SBRS R3,0
	RJMP _0x43
_0x42:
	RJMP _0x41
_0x43:
; 0000 00F8   {
; 0000 00F9    b1=1;
	SET
	BLD  R3,0
; 0000 00FA    putsf("PINB.1=0");
	__POINTW2FN _0x0,144
	CALL SUBOPT_0x1
; 0000 00FB    putchar(13);
; 0000 00FC   }
; 0000 00FD       if(PINB.1==1&&b1==1)
_0x41:
	SBIS 0x16,1
	RJMP _0x45
	SBRC R3,0
	RJMP _0x46
_0x45:
	RJMP _0x44
_0x46:
; 0000 00FE   {
; 0000 00FF    b1=0;
	CLT
	BLD  R3,0
; 0000 0100    putsf("PINB.1=1");
	__POINTW2FN _0x0,153
	CALL SUBOPT_0x1
; 0000 0101    putchar(13);
; 0000 0102   }
; 0000 0103 
; 0000 0104  }
_0x44:
	RJMP _0x10
; 0000 0105 }
_0x47:
	RJMP _0x47
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
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
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	CALL __NEB12
	OR   R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x1:
	CALL _putsf
	LDI  R26,LOW(13)
	JMP  _putchar


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

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

;END OF CODE MARKER
__END_OF_CODE:
