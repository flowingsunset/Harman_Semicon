/*
 * UART_02.c
 *
 * Created: 2023-07-26 오전 10:32:19
 * Author : USER
 */ 

#define F_CPU 16000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>
#include "UART0.h"

//출력 스트림 설정 <stdio.h>에 있는 표준 입출력
//사용자가 정의한 버퍼를 출력 스트림으로 바꾸어 주는 코드
FILE OUTPUT = FDEV_SETUP_STREAM(UART0_Transmit, NULL, _FDEV_SETUP_WRITE);

char rxBuff[100] = {0, };	//수신 버퍼
uint8_t rxFlag = 0;			//수신 완료 플래그 설정

ISR(USART0_RX_vect)	//수신 인터럽트 핸들러
{
	static uint8_t rxHead = 0;	//수신 데이터 인덱스
	uint8_t rxData = UDR0;		//수신된 데이터
	if(rxData == '\n'||rxData=='\r')	//수신 데이터가 개행이나 리턴이면
	{
		rxBuff[rxHead] = '\0';	//수신된 문자열 마지막에 NULL 추가
		rxHead = 0; //인덱스 초기화
		rxFlag = 1; //문자열 수신 플래그 설정
	}
	else    //개행이나 리턴이 아니면
	{
		rxBuff[rxHead] = rxData;	//버퍼에 수신된 데이터 추가
		rxHead++;					//인덱스 증가
	}
}

int main(void)
{	
	UART0_Init();
	uint8_t rxData; //수신 데이터
	stdout = &OUTPUT;	//출력 스트림 지정
	sei();
    while (1) 
    {
		if (rxFlag == 1)	//문자열이 수신 완료되면
		{
			rxFlag = 0;
			printf(rxBuff);
		}
    }
}

