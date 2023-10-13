#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include "Button.h"

void Button_init(Button *button, volatile uint8_t *ddr, volatile uint8_t *pin, uint8_t pinNum)
{
	button->ddr = ddr;
	button->pin = pin;
	button->btnPin = pinNum;
	button->prevState = RELEASED;	//초기화 아무것도 안누른 상태
	*button->ddr &= ~(1<<button->btnPin);	//버튼 핀을 입력으로 설정(간접 연산자가 참조 연산자보다 우선 실행됨)
}

uint8_t BUTTON_getState(Button *button)
{
	uint8_t curState = *button->pin & (1<<button->btnPin);	//버튼 상태 읽어옴
	if((curState==PUSHED)&&(button->prevState==RELEASED))	//버튼을 안누른 상태에서 눌렀다면
	{
		_delay_ms(50);		//디바운스
		button->prevState = PUSHED;	//버튼 상태를 누른 상태로 변환
		return ACT_PUSH;		//버튼이 눌렸음을 반환
	}
	else if ((curState != PUSHED)&&(button->prevState==PUSHED))
	{
		_delay_ms(50);		//디바운스
		button->prevState = RELEASED;	//버튼 상태를 땐 상태로 변환
		return ACT_RELEASED;		//버튼이 땠음을 반환
	}
	return NO_ACT;	//아무 일도 벌어지지 않음
}