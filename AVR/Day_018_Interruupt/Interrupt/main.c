/*
 * Interrupt.c
 *
 * Created: 2023-07-12 오후 2:02:58
 * Author : USER
 */ 

/*
Datasheet p.88 참조!
*/
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

ISR(INT4_vect)	//외부 인터럽트 INT4(PORTE4) ISR 정의
{
	PORTD ^=(1<<0);
}

ISR(INT5_vect)	//INT5
{
	PORTD ^=(1<<1);
}

int main(void)
{
	//INT4가 Falling edge 일때
	EICRB|=(1<<ISC41) |(0<<ISC40);
	//INT5가 Rising edge 일때
	EICRB|=(1<<ISC51)|(1<<ISC50);
	//INT4,5 인터럽트 활성화
	EIMSK |=(1<<INT5)|(1<<INT4);
	//버튼 입력 설정
	DDRE &= ~(1<<DDRE5)|~(1<<DDRE4);
	//출력 설정
	DDRD = 0xff;
	
	sei();
	
    while (1) 
    {
    }
}

