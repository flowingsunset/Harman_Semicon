/*
 * PWM_Servo.c
 *
 * Created: 2023-07-20 오후 3:30:19
 * Author : USER
 */ 
#define  F_CPU 16000000ul
#include <avr/io.h>
#include <util/delay.h>
#include "Servo.h"


int main(void)
{
	servoInit();
    while (1) 
    {
		servoRun(0);
		_delay_ms(2000);
		servoRun(45);
		_delay_ms(2000);
		servoRun(90);
		_delay_ms(2000);
		servoRun(135);
		_delay_ms(2000);
		servoRun(180);
		_delay_ms(2000);
    }
}

