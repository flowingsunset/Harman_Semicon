/*
 * Interrupt_03.c
 *
 * Created: 2023-07-12 오후 3:17:27
 * Author : USER
 */ 

#define  F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

volatile uint8_t ledShift = 0xFE;
uint8_t buttonPressed = 0;

ISR(INT4_vect)	//버튼 입력 플래그 활성화
{
	buttonPressed = 1;
}

int main(void)
{
	DDRD = 0xff;		//LED를 출력으로 설정
	PORTD = ledShift;	//0xfe
	DDRE &= ~(1<<DDRE4);//E4번 핀을 입력으로 설정
	
	EICRB |= (1<<ISC41)|(0<<ISC40);	//falling edge(풀업이므로 버튼이 눌렸을 때)에서 동작하도록 인터럽트 설정
	EIMSK |= (1<<INT4);				//외부 인터럽트 4번을 사용하도록 설정
	sei();
	
    while (1) 
    {
		if(buttonPressed)	//버튼 인터럽트가 발생한 뒤
		{
			_delay_ms(50);	//디바운싱
			if (!(PINE &(1<<PINE4)))	//버튼이 여전히 눌려 있을 때
			{
				ledShift = (ledShift<<1)|0x01;	//왼쪽으로 밀고 빈자리에 1을 넣음
				if(ledShift == 0xff)	//0이 사라지면 0을 넣어줌
				{
					ledShift = 0xfe;
				}
				PORTD = ledShift;		//LED 출력
			}
			buttonPressed = 0;	//인터럽트가 다시 발생해야 동작함
		}
    }
}

