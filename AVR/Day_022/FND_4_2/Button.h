#ifndef BUTTON_H_
#define BUTTON_H_



#define BUTTON_DDR		DDRD
#define BUTTON_PIN		PIND
#define BUTTON_ON		0
#define BUTTON_OFF		1
#define BUTTON_RESET	2

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