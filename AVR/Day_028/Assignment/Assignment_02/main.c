/*
 * Assignment_02.c
 *
 * Created: 2023-07-26 오후 6:29:14
 * Author : USER
 */ 

#define F_CPU 16000000

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "UART0.h"

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
	DDRC = 0xff;	//LED 출력 포트
	PORTC = 0xff;	//LED 초기값
	UART0_Init();	//UART0 초기화
	sei();			//전역 인터럽트 활성화
    while (1) 
    {
		if (rxFlag == 1)	//문자열을 수신 받았을 때
		{
			rxFlag = 0;		//문자열 수신 플래그 초기화
			for (int i = 0; rxBuff[i]; i++)		//문자열 내 문자 하나마다
			{
				if (rxBuff[i] == 'R' || rxBuff[i] == 'r') PORTC = PORTC<<1;		//오른쪽으로 한 칸 이동
				else if(rxBuff[i] == 'L' || rxBuff[i] == 'l') PORTC = PORTC >> 1;	//왼쪽으로 한 칸 이동
				else if (rxBuff[i] == 'F' || rxBuff[i] == 'f') PORTC ^= 0xff;		//LED 반전
				else if (rxBuff[i] == 'B' || rxBuff[i] == 'b')	//LED 깜빡이기
				{
					PORTC = 0x00;		
					_delay_ms(300);
					PORTC = 0xff;
				}
				_delay_ms(300);		//눈으로 하나씩 확인하기 위한 딜레이
			}
			
		}
    }
}

