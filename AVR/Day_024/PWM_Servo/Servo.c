/*
 * Servo.c
 *
 * Created: 2023-07-20 오후 3:31:06
 *  Author: USER
 */ 

#include "Servo.h"

void servoInit()
{
	DDRB = 1<<PORTB5;	//portb5 출력
	TCCR1A |= (1<<COM1A1)|(1<<WGM11);	//non-inverting mode
	TCCR1B |= (1<<CS11)|(1<<CS10);	//64분주
	TCCR1B |= (1<<WGM13)|(1<<WGM12);	//Fast PWM with TOP at ICR1
	TCCR1C = 0;
	
	//OCR1A = 250;	//	duty = OCR1A / ICR1 = 5% -> 1ms
	//  125 at 0degree, 625 at 180 degree
	ICR1 = 4999;	// 4999분주 => 50Hz
}

void servoStop()
{
	//PWM이 출력되지 않도록
	TCCR1A &= ~((1<<COM1A1)|(1<<COM1A0));
}

void servoRun(uint8_t degree)
{
	//0도 125, 180도 625
	uint16_t degreeValue;
	TCCR1A |= (1<<COM1A1);	//출력으로 바뀜
	if(degree<0)
	{
		degree = 0;
	}
	else if(degree > 180)
	{
		degree = 180;
	}
	degreeValue = (uint16_t)((degree/180.0)*500+125);
	OCR1A = degreeValue;
}