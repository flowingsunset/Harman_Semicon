/*
 * FND_4.c
 *
 * Created: 2023-07-18 오전 10:33:07
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "FND_Timer.h"
int main(void)
{
	FND_DATA_DDR = 0xff;
	FND_SELECT_DDR = 0xff;
	FND_SELECT_PORT = 0x00;
	TCCR0 = (1<<CS02)|(0<<CS01)|(0<<CS00);	//64 분주
	TIMSK = (1<<TOIE0);	//타이머/카운터 인터럽트 활성화
	
	sei();
	
    while (1) {}
}

