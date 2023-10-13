/*
 * Assignment_01.c
 *
 * Created: 2023-07-26 오후 6:55:49
 * Author : USER
 */ 

//RTC -> ATmega128 -> LCD
#define F_CPU	16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>
#include <stdlib.h>
#include "DS1302.h"
#include "I2C.h"
#include "I2C_lcd.h"
#include "UART0.h"

DS1302 myTime;
char rxBuff[100] = {0, };	//수신 버퍼
uint8_t rxFlag = 0;			//수신 완료 플래그 설정

char *dayOfWeek[7] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
	
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
	//stdout = &OUTPUT;	//출력 스트림 지정
	UART0_Init();
	DS1302_Init();
	LCD_Init();
	sei();
	char buff1[30];
	char buff2[30];
	
	//RTC 시계칩에 날짜와 시간을 설정
	myTime.year = 33;
	myTime.month = 12;
	myTime.date = 13;
	myTime.dayOfWeek = 5;//수요일
	myTime.hour = 14;
	myTime.min = 37;
	myTime.sec = 30;
	
	DS1302_SetTimeDate(myTime);
	
	while (1)
	{
		if (rxFlag == 1)
		{
			rxFlag = 0;
			switch(rxBuff[2])
			{
				case 'Y':	myTime.year = (uint8_t)atoi(rxBuff); break;
							
				case 'M':	myTime.month = (uint8_t)atoi(rxBuff); break;
				case 'D':	myTime.date  = (uint8_t)atoi(rxBuff); break;
				case 'd':	myTime.dayOfWeek = (uint8_t)atoi(rxBuff); break;
				case 'h':   myTime.hour = (uint8_t)atoi(rxBuff); break;
				case 'm':   myTime.min = (uint8_t)atoi(rxBuff); break;
				case 's':   myTime.sec = (uint8_t)atoi(rxBuff); break;
			}
			DS1302_SetTimeDate(myTime);
		}
		DS1302_GetTime(&myTime);
		DS1302_GetDate(&myTime);
		
		sprintf(buff1, "20%02d. %02d. %02d", myTime.year, myTime.month, myTime.date);
		sprintf(buff2, "%s  %02d:%02d:%02d", dayOfWeek[myTime.dayOfWeek], myTime.hour, myTime.min, myTime.sec);
		LCD_WriteStringXY(0, 0, buff1);
		LCD_WriteStringXY(1, 0, buff2);
		
		_delay_ms(1000);
	}
}

