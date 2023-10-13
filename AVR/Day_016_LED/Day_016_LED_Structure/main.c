/*
 * Day_016_LED_Structure.c
 *
 * Created: 2023-07-10 오후 3:35:45
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>

uint8_t ledArr[] = {
	0x80,
	0xc0,
	0xe0,
	0xf0,
	0xf8,
	0xfc,
	0xfe,
	0xff,
	0x7f,
	0x3f,
	0x1f,
	0x0f,
	0x07,
	0x03,
	0x01,
	0x00
};

int main(){
	DDRD = 0xff;
	while(1){
		for (int i = 0; i<sizeof(ledArr); i++)
		{
			PORTD = ledArr[i];
			_delay_ms(200);
		}
	}
}