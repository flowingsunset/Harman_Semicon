/*
 * FND_4_2.c
 *
 * Created: 2023-07-18 오후 2:10:47
 * Author : USER
 */ 
#define  F_CPU	16000000UL
#include <avr/io.h>
#include "FND.h"
#include <avr/interrupt.h>
#include "Button.h"
#include <util/delay.h>

enum {STOP, RUN, RESET};

ISR(TIMER0_OVF_vect)
{
	FND_ISR_Display();	//FND 출력
	TCNT0 = 6;
}

int main(void)
{
	
	FND_init();
	sei();
	uint16_t counter = 0;
	uint8_t counterState = STOP;
	Button btnRunStop;
	Button btnReset;
	
	Button_init(&btnRunStop, &BUTTON_DDR, &BUTTON_PIN, BUTTON_ON);
	Button_init(&btnReset, &BUTTON_DDR, &BUTTON_PIN, BUTTON_OFF);
    while (1) 
    {	
		switch(counterState)
		{
			case STOP:
			if(BUTTON_getState(&btnRunStop) == ACT_PUSH)
			{
				counterState = RUN;
			}
			else if (BUTTON_getState(&btnReset) == ACT_PUSH)
			{
				counterState = RESET;
			}
			break;
			
			case RUN:
			if (BUTTON_getState(&btnRunStop) == ACT_PUSH)
			{
				counterState = STOP;
			}
			break;
		}
		switch(counterState)
		{
			case STOP:
			FND_setFindDisplayData(counter);
			break;
			
			case RUN:
			FND_setFindDisplayData(counter++);
			_delay_ms(100);
			break;
			
			case  RESET:
			FND_setFindDisplayData(counter);
			counter = 0;
			counterState = STOP;
			break;
		}
		
    }
}

