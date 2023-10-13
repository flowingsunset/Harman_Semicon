/*
 * CLCD_4bit.c
 *
 * Created: 2023-07-25 오후 12:29:24
 * Author : USER
 */ 

#define F_CPU 16000000
#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include "lcd_4bit.h"

int main(void)
{
	char buff[30];
	LCD_Init();
	sprintf(buff, "Hello Good");
	LCD_WriteStringXY(0,0,buff);
	uint16_t count = 65530;
	
	while(1)
	{
		sprintf(buff, "count : %u", count++);
		LCD_WriteStringXY(1,0,buff);
		_delay_ms(300);
		
	}
	
	
}

