/*
 * Btn_Structure.c
 *
 * Created: 2023-07-11 오후 2:50:39
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include "Button.h"


int main(void)
{
	LED_DDR = 0xff;
	Button btnOn;
	Button btnOff;
	Button btnTog;
	
	Button_init(&btnOn,&BUTTON_DDR, &BUTTON_PIN, BUTTON_ON);	//주소값 넘겨줌, 0번버튼(LED를 켜지게 함)
	Button_init(&btnOff,&BUTTON_DDR, &BUTTON_PIN, BUTTON_OFF);	//1번 버튼(LED를 꺼지게 함)
	Button_init(&btnTog,&BUTTON_DDR, &BUTTON_PIN, BUTTON_TOGGLE);	//2번버튼(LED의 상태를 반전시킴)
    while (1) 
    {
		if (BUTTON_getState(&btnOn) == ACT_PUSH)	//버튼이 눌렸을 때 불이 켜짐
		{
			LED_PORT = 0xff;
		}
		if (BUTTON_getState(&btnOff) == ACT_RELEASED)	//버튼이 떼졌을 때 불이 켜짐
		{
			LED_PORT = 0x00;
		}
		if (BUTTON_getState(&btnTog) == ACT_PUSH)	//버튼이 눌렸을 때 불이 켜짐
		{
			LED_PORT ^= 0xff;
		}
    }
}

