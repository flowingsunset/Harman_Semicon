/*
 * Day_016_LED.c
 *
 * Created: 2023-07-10 오전 11:36:51
 * Author : USER
 */ 

#define  F_CPU 16000000UL  //cpu의 속도가 16MHz임을 알려줌(UL = unsinged long)

#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <stdint.h>

int main(void)
{
	DDRC = 0xff;

    while (1) 
    {
		PORTC = 0xff;
		_delay_ms(500);
		PORTC = 0x00;
		_delay_ms(500);
    }
}

