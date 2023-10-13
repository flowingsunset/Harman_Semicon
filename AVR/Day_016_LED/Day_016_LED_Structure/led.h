/*
 * led.h
 *
 * Created: 2023-07-10 오후 3:36:33
 *  Author: USER
 */ 


#ifndef LED_H_
#define LED_H_
#include <stdint.h>

#define LED_COUNT	8
typedef struct{
	volatile uint8_t *port;	//	LED가 연결된 포트, 컴파일러가 주소값을 최적화 하여 다른 값으로 변하는 것을 막기 위해 volatile로 선언
	uint8_t pin;			//	LED가 연결된 핀번호
	}LED;

void ledInit(LED *led); // 	포트에 해당하는 핀을 출력 0번핀
void ledOn(LED *led); 	//	해당핀을 high로 설정
void ledOff(LED *led); 	//	해당핀을 low로 설정


#endif /* LED_H_ */