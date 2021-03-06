#include <mega16a.h>
#include <delay.h>

// Declare your global variables here

unsigned char a,i=0;
char rx_data[20];

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
 a=rx_data[i]=UDR;
 i++;
}


// Standard Input/Output functions
#include <stdio.h>

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=P Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);


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

i=0;
// Global enable interrupts
#asm("sei")
PORTA.5=1;
PORTA.0=1;
PORTA.2=1;
delay_ms(600);
PORTA.5=0;
delay_ms(200);
PORTA.5=1;
delay_ms(200);
PORTA.5=0;
delay_ms(200);
PORTA.5=1;
delay_ms(200);
PORTA.5=0;
delay_ms(200);
PORTA.5=1;
delay_ms(200);
PORTA.5=0;
delay_ms(200);
PORTC.0=1;
delay_ms(200);
PORTC.0=0;
delay_ms(200);
PORTC.1=1;
delay_ms(200);
PORTC.1=0;
delay_ms(200);
PORTC.2=1;
delay_ms(200);
PORTC.2=0;
delay_ms(200);
PORTC.0=1;
PORTC.1=1;
PORTC.2=1;
delay_ms(200);
PORTC.0=0;
PORTC.1=0;
PORTC.2=0;

 while (1)
 {
  if(PIND.7==0)
  {
   PORTA.1=1;
  }          
  else
  {
   PORTA.1=0;
  }
  
  if(a==']')
  {      
   putsf("Ok");
   if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='0'&&rx_data[6]=='='&&rx_data[7]=='0')
   {
    PORTA.0=1;
    i=0;a=0;
   } 
   else
   { 
    if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='1'&&rx_data[6]=='='&&rx_data[7]=='0')
    {
     //PORTA.1=1;
     i=0;a=0;
    } 
    else
    { 
     if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='2'&&rx_data[6]=='='&&rx_data[7]=='0')
     {
      PORTA.2=1;
      i=0;a=0;
     } 
     else
     { 
      if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='3'&&rx_data[6]=='='&&rx_data[7]=='0')
      {
       PORTA.3=1;
       i=0;a=0;
      } 
      else
      { 
       if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='4'&&rx_data[6]=='='&&rx_data[7]=='0')
       {
        PORTA.4=1;
        i=0;a=0; 
       } 
       else
       { 
        if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='5'&&rx_data[6]=='='&&rx_data[7]=='0')
        {
         PORTA.5=1;
         i=0;a=0;
        }
        else
        {  
         if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='6'&&rx_data[6]=='='&&rx_data[7]=='0')
         {
          PORTA.6=1;
          i=0;a=0; 
         }  
         else
         {
          if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='7'&&rx_data[6]=='='&&rx_data[7]=='0')
          {
           PORTA.7=1;
           i=0;a=0; 
          }  
          else
          {
           if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='0'&&rx_data[6]=='='&&rx_data[7]=='1')
           {
            PORTA.0=0;
            i=0;a=0;
           }  
           else
           {  
            if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='1'&&rx_data[6]=='='&&rx_data[7]=='1')
            {
             //PORTA.1=0;
             i=0;a=0;
            }   
            else
            { 
             if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='2'&&rx_data[6]=='='&&rx_data[7]=='1')
             {
              PORTA.2=0;
              i=0;a=0; 
             }  
             else
             {  
              if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='3'&&rx_data[6]=='='&&rx_data[7]=='1')
              {
               PORTA.3=0;
               i=0;a=0;
              }   
              else
              { 
               if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='4'&&rx_data[6]=='='&&rx_data[7]=='1')
               {
                PORTA.4=0;
                i=0;a=0;
               }  
               else
               {  
                if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='5'&&rx_data[6]=='='&&rx_data[7]=='1')
                {
                 PORTA.5=0;
                 i=0;a=0;
                }  
                else
                {  
                 if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='6'&&rx_data[6]=='='&&rx_data[7]=='1')
                {
                 PORTA.6=0;
                 i=0;a=0;  
                }  
                else
                {  
                 if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='A'&&rx_data[4]=='.'&&rx_data[5]=='7'&&rx_data[6]=='='&&rx_data[7]=='1')
                 {
                  PORTA.7=0;
                  i=0;a=0;
                 }
                 else
                 {  
                  if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]=='0'&&rx_data[6]=='='&&rx_data[7]=='0')
                  {
                   PORTC.0=1;
                   i=0;a=0;             
                  }
                  else
                  {  
                   if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]=='1'&&rx_data[6]=='='&&rx_data[7]=='0')
                   {
                    PORTC.1=1;
                    i=0;a=0;
                   }
                   else
                   {  
                    if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]=='2'&&rx_data[6]=='='&&rx_data[7]=='0')
                    {
                     PORTC.2=1;
                     i=0;a=0;
                    }
                    else
                    {  
                     if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]=='0'&&rx_data[6]=='='&&rx_data[7]=='1')
                     {
                     PORTC.0=0;
                     i=0;a=0;             
                     }
                     else
                     {  
                      if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]=='1'&&rx_data[6]=='='&&rx_data[7]=='1')
                      {
                      PORTC.1=0;
                      i=0;a=0;
                      }
                      else
                      {  
                       if(rx_data[0]=='P'&&rx_data[1]=='I'&&rx_data[2]=='N'&&rx_data[3]=='C'&&rx_data[4]=='.'&&rx_data[5]=='2'&&rx_data[6]=='='&&rx_data[7]=='1')
                       {
                       PORTC.2=0;
                       i=0;a=0;
                       }
                       else
                       {
                        putsf("ER");
                        putchar(13);putchar(10); 
                        putchar(rx_data[0]);
                        i=0;a=0;
                       }
                      }
                     }
                    }
                   }
                  }
                 }
                }
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
     }
    }
   }
  }          
 }

 }
}
