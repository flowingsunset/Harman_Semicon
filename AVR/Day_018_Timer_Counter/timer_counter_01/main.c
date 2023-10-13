/*
 * timer_counter_01.c
 *
 * Created: 2023-07-12 오전 10:56:19
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>

int cnt;	//카운트 값을 저장할 변수 선언

ISR(TIMER0_OVF_vect)	//타이머/카운터 0번의 오버플로우 인터럽트 서비스루틴
{
	cnt++;			//카운터 변수 1 증가
	TCNT0 = 131;	//약 2ms를 만들기 위한 초기값
	
	if (cnt == 500)	//500번째 인터럽트 발생시 LED출력을 변경함, 약 1초
	{
		PORTD =~PORTD;	// 출력 반전
		cnt = 0;
	}
}

int main(void)
{
	DDRD = 0xff;	//led를 출력
	PORTD = 0xaa;	//기본값 10101010
	
	TCCR0 = (1<<CS02)|(1<<CS01)|(0<<CS00);	//256 분주
	TIMSK = (1<<TOIE0);	//타이머/카운터 인터럽트 활성화
	
	sei();
	
    while (1) 
    {
		
    }
}

