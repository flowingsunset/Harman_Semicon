/*
 * PWM_test.c
 *
 * Created: 2023-07-20 오전 9:53:35
 * Author : USER
 */ 
//CTC mode
//Generate 1kHz
/*
#define F_CPU 16000000ul
#include <avr/io.h>

int main(void)
{
	DDRB = (1<<PORTB4);	//portb4 출력
	//WGM01,00 = 10 -> CTC mode
	//COM01,00 = 01 -> Toggle OC0 on compare match
	//CS02~00 =  100 -> 64 prescaling
	TCCR0 |= (1<<COM00)|(1<<WGM01)|(1<<CS02);
	//1000 = (16000000) / (2 * 64(prescaling) * (1+OCR0))  pg.97 참조
	//-> OCR0 == 124
	OCR0 = 124;
	while (1);
}
*/

//Normal PWM
//Generate 500Hz
/*
#define F_CPU 16000000ul
#include <avr/io.h>

int main(void)
{
	DDRF = 0xff;	//normal pwm은 출력을 원하는 곳으로 꽂을 수 있음
					//이를 위해 비어있는 portf로출력
	PORTF = 0;
	//WGM01~00 : 00 -> normal counter
	//CS02~00 : 101 -> 128 분주
	//COM01~00 : 0 ->  OC0 disconnected
	TCCR0 |= (1<<CS02)|(1<<CS00);
	//500 = 16000000/(2*128*(256-TCNT0))
	TCNT0 = 131;
	
	while (1)
	{
		while ((TIFR&(1<<TOV0)) == 0);	//카운터에 오버플로우 인터럽트가 걸렸을 때
		PORTF = ~PORTF;					//토글 출력을 위한 비트 반전
		TCNT0 = 131;					//500Hz를 계속 만들어내기 위해 TCNT0에 다시 131을 써줌
		TIFR = 0x01;					//오버플로우 인터럽트는 1을 다시 써줘야 초기화됨
	}
}
*/
//Fast PWM
//진폭이 점점 굵어짐
/*
#define F_CPU 16000000ul
#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
	DDRB = 1<<PORTB4;	//OC0이 출력되는 PORTB4 활성화
	//WGM01~00 : 11 -> Fast PWM
	//COM01~00 : 10 -> non-inverting mode
	//CS02~00 : 100 -> 64 prescaling
	//F_os0 = 16000000/(64*256) = 976.5625
	TCCR0 |= (1<<WGM01)|(1<<WGM00)|(1<<CS02)|(1<<COM01);
	while (1)
	{
		for (int i = 0; i<=255; i++) // duty가 점점 커짐
		{
			OCR0 = i;
			_delay_ms(10);
		}
	}
}
*/
//16 bit counter Fast PWM using Top with servo motor
/*
#define F_CPU 16000000ul
#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
	DDRB = 1<<PORTB5;	//portb5 출력
	TCCR1A |= (1<<COM1A1)|(1<<WGM11);	//non-inverting mode
	TCCR1B |= (1<<CS11)|(1<<CS10);		//64분주
	TCCR1B |= (1<<WGM13)|(1<<WGM12);	//Fast PWM with TOP at ICR1
	TCCR1C = 0;
	ICR1 = 4999;	// 50Hz = 16000000/(64*(ICR1+1))
	OCR1A = 250;	//	duty = OCR1A / (ICR1+1) = 5% -> 1ms
					//  125 at 0degree, 625 at 180 degree 
	
	
	while (1)
	{
		for (int i = 125; i<=625; i += 10)	//0 to 180 degree
		{
			OCR1A = i;
			_delay_ms(100);
		}
		
		for (int i = 625; i>=125; i -= 10)	//180 to 0 degree
		{
			OCR1A = i;
			_delay_ms(100);
		}
	}
}
*/