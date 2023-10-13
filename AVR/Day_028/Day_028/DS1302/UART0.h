/*
 * UART0.h
 *
 * Created: 2023-07-26 오전 10:33:15
 *  Author: USER
 */ 


#ifndef UART0_H_
#define UART0_H_

#include <avr/io.h>

void UART0_Init();
void UART0_Transmit(char data);
unsigned UART0_Receive();



#endif /* UART0_H_ */