/*
 * FND_Timer.h
 *
 * Created: 2023-07-18 오전 11:58:51
 *  Author: USER
 */ 


#ifndef FND_TIMER_H_
#define FND_TIMER_H_

#include <avr/io.h>
#include <avr/interrupt.h>
#define FND_DATA_DDR	DDRA	//데이터 포트 (7핀)
#define FND_SELECT_DDR	DDRC	//셀렉트 포트(자릿수 선택) (4핀)
#define FND_DATA_PORT	PORTA	//0~7
#define FND_SELECT_PORT	PORTC	//0~3

//	디스플레이함수 선언
void FND_Display(uint16_t data);	//4자리



#endif /* FND_TIMER_H_ */