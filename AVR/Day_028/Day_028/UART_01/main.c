/*
 * UART_01.c
 *
 * Created: 2023-07-26 오전 9:42:08
 * Author : USER
 */ 

#define  F_CPU 16000000
#include <avr/io.h>
#include <util/delay.h>

void UART0_Init();
void UART0_Transmit(char data);
unsigned UART0_Receive();

void UART0_Init()
{
	UBRR0H = 0;
	UBRR0L = 207;	//9600bps(U2X0 == 1일 때)
	
	UCSR0A = (1<<U2X0);//	2배속 모드
	//비동기, 8비트 데이터, 패리티비트 없음, 1비트stop bit
	UCSR0C |= 0x06;
	
	UCSR0B |= (1<<RXEN0);	//수신 가능
	UCSR0B |= (1<<TXEN0);	//송신 가능
}

void UART0_Transmit(char data)
{
	while(!(UCSR0A&(1<<UDRE0)));	//송신 가능 대기, UDR이 비어있는지?
	UDR0 = data;//데이터 전송
}

unsigned UART0_Receive()
{
	while(!(UCSR0A&(1<<RXC0)));	//데이터 수신 대기
	return UDR0;
}

int main(void)
{
	UART0_Init();	//0번 UART -> 초기화
    while (1) 
    {
		UART0_Transmit(UART0_Receive());
    }
}

