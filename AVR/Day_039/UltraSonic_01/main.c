/*
 * UltraSonic_01.c
 *
 * Created: 2023-08-21 오전 9:29:29
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>
#include "UART0.h"
#include "I2C.h"
#include "I2C_lcd.h"
#include "Ultrasonic.h"

//출력 스트림 설정 <stdio.h>에 있는 표준 입출력
//사용자가 정의한 버퍼를 출력 스트림으로 바꾸어 주는 코드
FILE OUTPUT = FDEV_SETUP_STREAM(UART0_Transmit, NULL, _FDEV_SETUP_WRITE);

#define PRESCALER 1024



int main(void)
{
    uint8_t distance;
	
	stdout = &OUTPUT;
	UART0_Init();
	
	
	ultrasonic_init();
	Timer_init();
	I2C_Init();
	LCD_Init();
	char buff[30];
	
    while (1) 
    {
		distance = measure_distance();	//거리측정
		//printf("Distance : %d cm\r\n", distance);
		sprintf(buff, "Distance: %3d cm", distance);
		LCD_WriteStringXY(0,0,buff);
		_delay_ms(1000);
    }
}

