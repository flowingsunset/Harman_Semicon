/*
 * FND.h
 *
 * Created: 2023-07-18 오후 2:11:01
 *  Author: USER
 */ 


#ifndef FND_H_
#define FND_H_

#include <avr/io.h>
#include <avr/interrupt.h>

#define FND_DIGIT_1 0
#define FND_DIGIT_2 1
#define FND_DIGIT_3 2
#define FND_DIGIT_4 3

#define FND_DIGIT_DDR	DDRC
#define FND_DIGIT_PORT	PORTC
#define FND_DATA_DDR	DDRA
#define FND_DATA_PORT	PORTA

void FND_init();	//FND에 사용될 타이머카운터 및 4자리 FND 초기화
void FND_setFindDisplayData(uint16_t data);	//data를 4자리 FND에서 표기 가능한 9999까지로 제한하여 저장함
uint16_t FND_getFindDisplayData();			//저장한 FND용 데이터(10진수)를 가져옴
void FND_selectDigit(uint16_t digit);		//표시할 자리수에만 ON (0~3)
void FND_showNumber(uint16_t fndNumber);	//숫자 한자리 표시
void FND_off();								//FND 전체 끄는 함수
void FND_ISR_Display();						//타이머 인터럽트 발생시 FND표시 함수


#endif /* FND_H_ */