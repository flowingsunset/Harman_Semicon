/*
 * DS1302.h
 *
 * Created: 2023-07-26 오전 11:46:50
 *  Author: USER
 */ 


#ifndef DS1302_H_
#define DS1302_H_

#include <avr/io.h>

#define DS1302_CLK_DDR	DDRF
#define DS1302_CLK_PORT	PORTF

#define DS1302_DATA_DDR DDRF
#define DS1302_DATA_PORT PORTF
#define DS1302_DATA_PIN PINF

#define DS1302_RST_DDR DDRF
#define DS1302_RST_PORT PORTF

#define DS1302_CLK	2
#define DS1302_DATA 3
#define DS1302_RST	4

#define ADDR_SEC		0x80
#define ADDR_MIN		0x82
#define ADDR_HOUR		0x84
#define ADDR_DATE		0x86
#define ADDR_MONTH		0x88
#define ADDR_DAYOFWEEK	0x8A
#define ADDR_YEAR		0x8C

typedef struct _ds1302
{
	uint8_t sec;
	uint8_t min;
	uint8_t hour;
	uint8_t date;
	uint8_t month;
	uint8_t dayOfWeek;
	uint8_t year;	
}DS1302;

void DS1302_Init();			//초기화
void DS1302_Selected();		//RST H
void DS1302_Deselected();	//RST L
void DS1302_Clock();		//Clock
void DS1302_DataBitSet();	//bit H
void DS1302_DataBitReset();	//bit L
void DS1302_Change_ReadMode();			//read set
void DS1302_Change_WriteMode();			//write set
uint8_t decimal_to_bcd(uint8_t decimal);
uint8_t bcd_to_decimal(uint8_t bcd);
void DS1302_TxData(uint8_t txData);		//RTC data send
void DS1302_WriteData(uint8_t address, uint8_t data);	//특정 주소에 data write
void DS1302_SetTimeDate(DS1302 timeDate);	//date, time set
uint8_t DS1302_RxData();					//data receive
uint8_t DS1302_ReadData(uint8_t address);	//특정주소에서 data read
void DS1302_GetTime(DS1302 *timeDate);		//RTC의 time get
void DS1302_GetDate(DS1302 *timeDate);		//RTC의 date get

#endif /* DS1302_H_ */