
#define F_CPU 16000000
#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include "lcd.h"
int main(void)
{
	char buff[30];
	LCD_Init();
	sprintf(buff, "Hello AVR");
	LCD_WriteStringXY(0, 0, buff);
	int count = 0;
	while(1)
	{
		sprintf(buff, "count: %d", count++);
		LCD_WriteStringXY(1,0,buff);
		_delay_ms(300);
	}
	
	return 0;
}
