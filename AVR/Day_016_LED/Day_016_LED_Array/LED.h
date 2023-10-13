/*
 * LED.h
 *
 * Created: 2023-07-10 오후 2:40:45
 *  Author: USER
 */ 


#ifndef LED_H_
#define LED_H_

#include <avr/io.h>
#include <stdio.h>

#define LED_PORT	PORTD
#define LED_DDR		DDRD

void	ledInit();
void	GPIO_output(uint8_t data);
void	ledLeftShift(uint8_t *data);
void	ledRightShift(uint8_t *data);



#endif /* LED_H_ */