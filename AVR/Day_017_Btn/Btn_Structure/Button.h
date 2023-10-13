/*
 * Button.h
 *
 * Created: 2023-07-11 오후 3:36:57
 *  Author: USER
 */ 


#ifndef BUTTON_H_
#define BUTTON_H_


#define LED_DDR			DDRD
#define LED_PORT		PORTD
#define BUTTON_DDR		DDRC
#define BUTTON_PIN		PINC
#define BUTTON_ON		0
#define BUTTON_OFF		1
#define BUTTON_TOGGLE	2

enum{PUSHED, RELEASED};					//{0,1}로 정의됨
enum{NO_ACT, ACT_PUSH, ACT_RELEASED};	//{0,1,2}로 정의됨

typedef struct _button{
	volatile uint8_t *ddr;
	volatile uint8_t *pin;
	uint8_t btnPin;
	uint8_t prevState;
}Button;

void Button_init(Button *button, volatile uint8_t *ddr, volatile uint8_t *pin, uint8_t pinNum);

uint8_t BUTTON_getState(Button *button);


#endif /* BUTTON_H_ */