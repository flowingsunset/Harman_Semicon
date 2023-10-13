/*
 * FND.c
 *
 * Created: 2023-07-18 오후 2:16:42
 *  Author: USER
 */ 
#include "FND.h"

uint16_t fndDisplayData = 0;			//7세그먼트에 표시할 데이터 변수

void FND_init()
{
	TCCR0 |= (1<<CS02)|(0<<CS01)|(0<<CS00);	//64분주
	TIMSK |= (1<<TOIE0);
	TCNT0 = 6;
	FND_DIGIT_DDR |= (1<<FND_DIGIT_1)|(1<<FND_DIGIT_2)|(1<<FND_DIGIT_3)|(1<<FND_DIGIT_4);
	FND_DATA_DDR  = 0xff;
}
void FND_setFindDisplayData(uint16_t data)	//FND에 표시할 데이터 함수
{
	if(data >= 10000)	// FND가 4자리 9999까지 가능
	{
		data = 9999;
		fndDisplayData = data;
	}
	else fndDisplayData = data;
}
uint16_t FND_getFindDisplayData()			//FND에 표시된 데이터를 가져오는 함수
{
	return fndDisplayData;
}
void FND_selectDigit(uint16_t digit)		//표시할 Digit 선택 함수
{
	FND_DIGIT_PORT |= 0x0f;					//모든 자릿수 HIGH 설정
	FND_DIGIT_PORT = ~(1<<digit);			//선택한 자리만 LOW 서정
}
void FND_showNumber(uint16_t fndNumber)		//숫자 표시 함수
{
	uint8_t fndData[] = {0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x27, 0x7f, 0x67	};
	FND_DATA_PORT = fndData[fndNumber];
}
void FND_off()								//FND 전체 끄는 함수
{
	FND_DIGIT_PORT |= 0xff;
}
void FND_ISR_Display()
{
	static uint8_t fndDigitPosition = 0;
	uint16_t displayData = FND_getFindDisplayData(); //출력할 데이터 가져오기
	
	fndDigitPosition = (fndDigitPosition+1)%4;		//다음 출력 자리 변경
	FND_off();
	switch(fndDigitPosition)
	{
		case 0:
			FND_showNumber(displayData%10);	//1의 자리 출력
			FND_selectDigit(FND_DIGIT_4);	//1의 자리 디지트 선택
			break;
		case 1:
			FND_showNumber(displayData/10%10);	//10의 자리 출력
			FND_selectDigit(FND_DIGIT_3);	//10의 자리 디지트 선택
			break;
		case 2:
			FND_showNumber(displayData/100%10);	//100의 자리 출력
			FND_selectDigit(FND_DIGIT_2);	//100의 자리 디지트 선택
			break;
		case 3:
			FND_showNumber(displayData/1000%10);	//1000의 자리 출력
			FND_selectDigit(FND_DIGIT_1);	//1000의 자리 디지트 선택
			break;
	}
}