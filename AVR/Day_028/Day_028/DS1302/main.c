/*
 * DS1302.c
 *
 * Created: 2023-07-26 오전 11:45:50
 * Author : USER
 */ 

#define F_CPU	16000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>
#include "DS1302.h"
#include "UART0.h"


//출력 스트림 설정 <stdio.h>에 있는 표준 입출력
//사용자가 정의한 버퍼를 출력 스트림으로 바꾸어 주는 코드
FILE OUTPUT = FDEV_SETUP_STREAM(UART0_Transmit, NULL, _FDEV_SETUP_WRITE);

int main(void)
{
	stdout = &OUTPUT;	//출력 스트림 지정
	UART0_Init();
	DS1302_Init();
	
	//RTC 시계칩에 날짜와 시간을 설정
	DS1302 myTime;
	myTime.year = 23;
	myTime.month = 7;
	myTime.date = 26;
	myTime.dayOfWeek = 3;//수요일
	myTime.hour = 14;
	myTime.min = 37;
	myTime.sec = 30;
	
	DS1302_SetTimeDate(myTime);
	
    while (1) 
    {
		DS1302_GetTime(&myTime);
		DS1302_GetDate(&myTime);
		
		printf("20%02d. %02d. %02d	%02d:%02d:%02d \n",
		myTime.year, myTime.month, myTime.date, myTime.hour, myTime.min, myTime.sec);
		_delay_ms(1000);
    }
}

