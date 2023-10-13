/*
 * FND_Timer.c
 *
 * Created: 2023-07-18 오전 11:58:35
 *  Author: USER
 */ 
#include "FND_Timer.h"

uint16_t cnt = 0;	//인터럽트 카운터
uint16_t count = 0;	//시간 카운터

ISR(TIMER0_OVF_vect)	//타이머/카운터 0번의 오버플로우 인터럽트 서비스루틴(1ms마다 인터럽트 발생)
{
	cnt++;			//카운터 변수 1 증가
	TCNT0 = 6;	//약 1ms를 만들기 위한 초기값
	
	FND_Display(count);
	if (cnt == 100)	//100번째 인터럽트 발생시 count 증가함, 약 100ms
	{
		if(count == 9999) count = 0;
		else count++;
		cnt = 0;
	}
}

void FND_Display(uint16_t data)
{
	static uint8_t position = 0;
	uint8_t fndData[] = {
		0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x27, 0x7f, 0x67
	};
	switch(position)
	{
		case 0:
		// 첫번째 자리-> 0번핀 LOW, 1,2,3 High
		FND_SELECT_PORT |= (1<<1)|(1<<2)|(1<<3);
		FND_SELECT_PORT &= ~(1<<0);
		FND_DATA_PORT = fndData[data/1000];
		break;
		case 1:
		// 두번째 자리-> 0번핀 LOW, 0,2,3 High
		FND_SELECT_PORT |= (1<<0)|(1<<2)|(1<<3);
		FND_SELECT_PORT &= ~(1<<1);
		FND_DATA_PORT = fndData[data/100%10];
		break;
		case 2:
		// 세번째 자리-> 0번핀 LOW, 1,0,3 High
		FND_SELECT_PORT |= (1<<1)|(1<<0)|(1<<3);
		FND_SELECT_PORT &= ~(1<<2);
		FND_DATA_PORT = fndData[data/10%10];
		break;
		case 3:
		// 네번째 자리-> 0번핀 LOW, 1,2,0 High
		FND_SELECT_PORT |= (1<<1)|(1<<2)|(1<<0);
		FND_SELECT_PORT &= ~(1<<3);
		FND_DATA_PORT = fndData[data%10];
		break;
	}
	position++;;
	position = position%4;
}