/*
 * I2c_COMM.c
 *
 * Created: 2023-07-25 오후 2:28:42
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include "I2C.h"
#include "I2C_lcd.h"


int main(void)
{
	uint16_t count = 0;
	char buff[30];
	
	LCD_Init( );
	//LCD_WriteStringXY(0, 0, "Hello ATmega128A");

    while (1) 
    {
		//sprintf(buff, "count : %-5d", count++);
		//LCD_WriteStringXY(1, 0, buff);
		//_delay_ms(200);
		LCD_WriteCommand(0x03);
		_delay_ms(200);
    }
}

