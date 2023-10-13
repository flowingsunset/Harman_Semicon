/*
 * LED.c
 *
 * Created: 2023-07-10 오후 2:40:14
 *  Author: USER
 */ 
#include "LED.h"

void	ledInit(){
	LED_DDR = 0xff;
}
void	GPIO_output(uint8_t data){
	LED_PORT = data;
}
void	ledLeftShift(uint8_t *data){
	*data = (*data >> 7) | (*data << 1);
	GPIO_output(*data);
}
void	ledRightShift(uint8_t *data){
	*data = (*data << 7) | (*data >> 1);
	GPIO_output(*data);
}
