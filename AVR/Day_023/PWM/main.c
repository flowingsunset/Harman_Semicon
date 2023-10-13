/*
 * main.c
 *
 * Created: 2023-07-19 오전 11:30:29
 * Author : USER
 */ 
#define F_CPU 16000000ul
#include <avr/io.h>
#include <util/delay.h>
#include "Buzzer.h"

int main(void)
{
    buzzerInit();	//PB5의 16비트 타이머로 파워부저를 사용하기 위한 초기화
	TCCR0 |= (0<<CS02) | (1<<CS01) | (0<<CS00);	// 8분주
	TCCR0 |= (1<<WGM01) | (1<<WGM00);			//Fast PWM 모드
	TCCR0 |= (1<<COM01) | (0<<COM00);			//숫자가 같아지면 0, 숫자가 0이되면 1로 만듬(기본 pwm)
	OCR0 = 100;			//초기 비교값
	DDRB |= (1<<4);		//PB4에서 타이머 0번의 비교 pwm 값이 나옴
	playTrout();
	playSchoolBell();
	
    while (1) 
    {
		OCR0 +=5;	//점점 소리가 커짐
		if (OCR0 >= 250)
		{
			OCR0 = 100;	//작으면 안들려서 초기값을 높게 줌
		}
		_delay_ms(100);
    }
}

