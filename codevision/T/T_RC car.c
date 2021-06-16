/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 22/02/2021
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8/000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <delay.h>

// Declare your global variables here

bit a0,a1,a2,a3,a4,a5,a6,a7,b1;

// This flag is set on USART Receiver buffer overflow



// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{

}



// Standard Input/Output functions
#include <stdio.h>

// SPI functions
#include <spi.h>

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
DDRA=0x00;
DDRB.0=0xFF;
DDRB.1=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI Type: Slave
// SPI Clock Rate: 2000/000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
SPSR=(0<<SPI2X);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")
  while(PINA.0!=1|PINA.1!=1|PINA.2!=1|PINA.3!=1|PINA.4!=1|PINA.5!=1|PINA.6!=1|PINA.7!=1)
  {
   PORTB.0=1;
   delay_ms(400);
   PORTB.0=0;
   delay_ms(400);
  }
  PORTB.0=1;
 while (1)
 {

    if(PINA.0==0&&a0==0)
  { 
   a0=1;
   putsf("PINA.0=0");
   putchar(13);
  }
    if(PINA.0==1&&a0==1)
  {  
   a0=0;
   putsf("PINA.0=1");
   putchar(13);
  }
    if(PINA.1==0&&a1==0)
  {
   a1=1;
   putsf("PINA.1=0");
   putchar(13);
  }
    if(PINA.1==1&&a1==1)
  { 
   a1=0;
   putsf("PINA.1=1");
   putchar(13);
  }
    if(PINA.2==0&&a2==0)
  {
   a2=1;
   putsf("PINA.2=0");
   putchar(13);
  }
    if(PINA.2==1&&a2==1)
  { 
   a2=0;
   putsf("PINA.2=1");
   putchar(13);
  }
    if(PINA.3==0&&a3==0)
  { 
   a3=1;
   putsf("PINA.3=0");
   putchar(13);
  }
    if(PINA.3==1&a3==1)
  { 
   a3=0;
   putsf("PINA.3=1");
   putchar(13);
  }
    if(PINA.4==0&&a4==0)
  {
   a4=1;
   putsf("PINA.4=0");
   putchar(13);
  }
    if(PINA.4==1&&a4==1)
  {
   a4=0;
   putsf("PINA.4=1");
   putchar(13);
  }
    if(PINA.5==0&&a5==0)
  {  
   a5=1;
   putsf("PINA.5=0");
   putchar(13);
  }
    if(PINA.5==1&&a5==1)
  {
   a5=0;
   putsf("PINA.5=1");
   putchar(13);
  }
    if(PINA.6==0&&a6==0)
  { 
   a6=1;
   putsf("PINA.6=0"); 
   putchar(13);
  }
    if(PINA.6==1&&a6==1)
  {   
   a6=0;
   putsf("PINA.6=1");
   putchar(13);
  }   
    if(PINA.7==0&&a7==0)
  { 
   a7=1;
   putsf("PINA.7=0");
   putchar(13);
  }
    if(PINA.7==1&&a7==1)
  { 
   a7=0;
   putsf("PINA.7=1");
   putchar(13);
  }
      if(PINB.1==0&&b1==0)
  { 
   b1=1;
   putsf("PINB.1=0");
   putchar(13);
  }
      if(PINB.1==1&&b1==1)
  { 
   b1=0;
   putsf("PINB.1=1");
   putchar(13);
  }
  
 }
}
