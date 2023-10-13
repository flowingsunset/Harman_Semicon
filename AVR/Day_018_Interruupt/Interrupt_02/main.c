/*
 * Interrupt_02.c
 *
 * Created: 2023-07-12 오후 2:42:43
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

uint8_t ledShift = 0xFE;
ISR(INT4_vect)	//버튼이 눌렸을 때
{
	ledShift = ledShift << 1;	//led 한칸 왼쪽으로 밈
	ledShift |= 1<<0;		//빈자리에 1 넣음
	if(ledShift == 0xff){		//0이 없어지면 0을 넣어줌
		ledShift = 0xFE;
	}
	PORTD = ledShift;		//출력
}


int main(void)
{
	DDRD = 0xff;		//led 출력
	DDRE &= ~(0x10);	//버튼 입력
	PORTD = 0xfe;		//led 초기값
	//INT4가 both edge 일때
	EICRB|=(0<<ISC41) |(1<<ISC40);
	//INT4 인터럽트 활성화
	EIMSK |=(1<<INT4);
	
	sei();
    while (1) 
    {
		
    }
}

