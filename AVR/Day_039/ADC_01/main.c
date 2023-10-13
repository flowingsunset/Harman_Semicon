/*
 * ADC_01.c
 *
 * Created: 2023-08-21 오후 2:34:50
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>
#include "I2C.h"
#include "I2C_lcd.h"
#include "ADC.h"

int main(void)
{
    int read;
	char buff1[30], buff2[30];
	UART0_Init();
	LCD_Init();
	ADC_init();
    while (1) 
    {
		read = read_ADC(0);
		sprintf(buff1, "channel 0 : %4d", read);
		LCD_WriteStringXY(0,0, buff1);
		read = read_ADC(1);
		sprintf(buff2, "channel 1 : %4d", read);
		LCD_WriteStringXY(1,0, buff2);
		
		_delay_ms(500);
    }
}

