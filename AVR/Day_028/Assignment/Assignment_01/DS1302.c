/*
 * DS1302.c
 *
 * Created: 2023-07-26 오전 11:46:39
 *  Author: USER
 */ 
#include "DS1302.h"

void DS1302_Init()
{
	//DS1302 초기화 함수
	//클럭핀, 데이터핀, 출력 설정
	//리셋핀 LOW로 설정
	DS1302_CLK_DDR |= (1<<DS1302_CLK);		//2
	DS1302_DATA_DDR |= (1<<DS1302_DATA);	//3
	DS1302_RST_DDR  |= (1<<DS1302_RST);		//4
	
	DS1302_CLK_PORT &= ~(1<<DS1302_CLK);	//초기값 LOW
	DS1302_DATA_PORT |= (1<<DS1302_DATA);	//초기값 High
	DS1302_RST_PORT &= ~(1<<DS1302_RST);	//초기값 LOW
}

void DS1302_Selected()
{
	DS1302_RST_PORT	|= (1<<DS1302_RST);	//CE핀 High
}

void DS1302_Deselected()
{
	DS1302_RST_PORT	&= ~(1<<DS1302_RST);//CE핀 Low
}

void DS1302_Clock()
{
	DS1302_CLK_PORT |= (1<<DS1302_CLK);		//High
	DS1302_CLK_PORT &= ~(1<<DS1302_CLK);	//Low
}

void DS1302_DataBitSet()
{
	DS1302_DATA_PORT |= (1<<DS1302_DATA);	//data 핀 High
}

void DS1302_DataBitReset()
{
	DS1302_DATA_PORT &= ~(1<<DS1302_DATA);	//data 핀 Low
}

void DS1302_Change_ReadMode()
{
	DS1302_DATA_DDR &= ~(1<<DS1302_DATA);	//데이터 포트를 읽기로 변경
}

void DS1302_Change_WriteMode()
{
	DS1302_DATA_DDR |= (1<<DS1302_DATA);	//데이터 포트를 쓰기로 변경
}

uint8_t decimal_to_bcd(uint8_t decimal)
{
	return (((decimal/10)<<4)|(decimal%10));
	//10진수를 2진수로 변환
	//4비트씩 묶어서 1의 자리와 10의 자리로
}

uint8_t bcd_to_decimal(uint8_t bcd)
{
	return(((bcd>>4)*10)+(bcd&0x0f));
	//bcd값을 4비트씩 묶어서 1자리와 10자리로 구분 -> 10진수로 변환
}

void DS1302_TxData(uint8_t txData)
{
	//데이터를 하위비트부터 상위비트 순으로 보내고
	//클럭신호를 발생시켜 데이터를 전송한다
	DS1302_Change_WriteMode();
	
	for (int i=0;i<8; i++)
	{
		//하위비트 -> 상위비트로
		//1비트 출력하고 클럭 올렸다 내리고
		if(txData & (1<<i)) DS1302_DataBitSet();
		else DS1302_DataBitReset();
		DS1302_Clock();
	}
}

void DS1302_WriteData(uint8_t address, uint8_t data)
{
	//주소와 데이터를 전송하고
	//RST 핀을 Low로 설정
	DS1302_Selected();	//RST pin High
	DS1302_TxData(address);	//address send
	DS1302_TxData(decimal_to_bcd(data));	//data send
	DS1302_Deselected();	//RST pin Low
}


void DS1302_SetTimeDate(DS1302 timeDate)
{
	DS1302_WriteData(ADDR_SEC, timeDate.sec);
	DS1302_WriteData(ADDR_MIN, timeDate.min);
	DS1302_WriteData(ADDR_HOUR, timeDate.hour);
	DS1302_WriteData(ADDR_DATE, timeDate.date);
	DS1302_WriteData(ADDR_MONTH, timeDate.month);
	DS1302_WriteData(ADDR_DAYOFWEEK, timeDate.dayOfWeek);
	DS1302_WriteData(ADDR_YEAR, timeDate.year);
}

uint8_t DS1302_RxData()
{
	//데이터를 하위비트부터 상위비트 순으로 읽고
	//클럭 신호를 발생시켜 데이터를 읽음
	uint8_t rxData = 0;
	DS1302_Change_ReadMode();
	
	for (int i=0; i<8; i++)
	{
		rxData |= (DS1302_DATA_PIN&(1<<DS1302_DATA)) ? (1<<i) : 0;
		if(i!=7) DS1302_Clock();
	}
	return rxData;
}

uint8_t DS1302_ReadData(uint8_t address)
{
	//지정된 주소의 데이터를 읽어옴
	uint8_t rxData = 0;	//수신된 데이터를 저장할 변수
	DS1302_Selected();
	DS1302_TxData(address+1);		//지정된 주소를 전송(Write에서 1더하면 Read주소)
	rxData = DS1302_RxData();		//수신된 데이터 읽음
	DS1302_Deselected();
	return bcd_to_decimal(rxData);
}

void DS1302_GetTime(DS1302 *timeDate)
{
	timeDate->sec = DS1302_ReadData(ADDR_SEC);
	timeDate->min = DS1302_ReadData(ADDR_MIN);
	timeDate->hour = DS1302_ReadData(ADDR_HOUR);
}

void DS1302_GetDate(DS1302 *timeDate)
{
	timeDate->date = DS1302_ReadData(ADDR_DATE);
	timeDate->month = DS1302_ReadData(ADDR_MONTH);
	timeDate->dayOfWeek = DS1302_ReadData(ADDR_DAYOFWEEK);
	timeDate->year = DS1302_ReadData(ADDR_YEAR);
}