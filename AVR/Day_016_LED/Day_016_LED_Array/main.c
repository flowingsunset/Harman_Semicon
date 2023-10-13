#define  F_CPU 16000000UL  //cpu의 속도가 16MHz임을 알려줌(UL = unsinged long)

#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include "LED.h"

#define LED_PORT	PORTD
#define LED_DDR		DDRD

int main(void)
{
    LED_DDR = 0xff;
	while(1){
		for (uint8_t i = 0; i < 4; i++)
		{
			LED_PORT = ((0x01 << i) | (0x80>>i));
			_delay_ms(200);
		}
		for (uint8_t i = 0; i < 4; i++)
		{
			LED_PORT = ((0x08 >> i) | (0x10<<i));
			_delay_ms(200);
		}
	}
}

unsigned char L = 0x01;
unsigned char R = 0x80;

while (1)
{
	PORTD = L|R;
	L<<=1;
	if (L==0)
	{
		L = 0x01;
	}
	R>>=1;
	if (R==0)
	{
		R = 0x80;
	}
	_delay_ms(200);
}

