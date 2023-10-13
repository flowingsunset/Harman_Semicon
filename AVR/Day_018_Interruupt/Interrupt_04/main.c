/*
 * Interrupt_04.c
 *
 * Created: 2023-07-12 오후 4:04:41
 * Author : USER
 */ 

#define  F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

volatile uint8_t decimal = 0;
uint8_t buttonPressed = 0;
enum{zero, one, two, three, four, five, six, seven, eight, nine, ten};	//0~9
uint8_t fnd[] = {0xfc, 0x60, 0xda, 0xf2, 0x66, 0xb6, 0xbe,0xe0,0xfe,0xf6};//0~9
ISR(INT4_vect)
{
	buttonPressed = 1;	//버튼 눌림 플래그
}

int main(void)
{
	DDRA = 0xff;		//fnd를 출력으로 사용
	PORTA = fnd[zero];	//초기값 0을 넣어줌
	DDRE &= ~(1<<DDRE4);//버튼 입력핀 E4를 입력으로 사용
	
	EICRB |= (1<<ISC41)|(0<<ISC40);	//falling edge(버튼을 눌렸을 때) 동작
	EIMSK |= (1<<INT4);				//외부 인터럽트 4번을 사용
	sei();
	
	while (1)
	{
		if(buttonPressed)	//버튼 인터럽트 동작 후
		{
			_delay_ms(50);	//디바운싱
			if (!(PINE &(1<<PINE4)))	//버튼이 여전히 눌려 있을 때
			{
				decimal++;		//숫자 증가
				if(decimal == ten)	//0~9까지만 표현
				{
					decimal = zero;
				}
				PORTA = fnd[decimal];	//fnd에 decimal 코드 입력
			}
			buttonPressed = 0;	//버튼 플래그 해제
		}
	}
}

