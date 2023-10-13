/*
 * FND_1.c
 *
 * Created: 2023-07-18 오전 9:17:24
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>


int main(void)
{
	uint8_t FND_Number[] = 
	{
		0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x27, 0x7f, 0x67	//0~9(a를 0번으로 연결함)
	};
	
	int count = 0;
	DDRA = 0xff;	//A포트를 출력으로 설정
    while (1) 
    {
		PORTA = FND_Number[count];
		count = (count+1)%10;
		
		_delay_ms(500);
    }
}

