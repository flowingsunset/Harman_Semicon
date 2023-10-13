/*
 * lcd_4bit.h
 *
 * Created: 2023-07-25 오후 12:15:18
 *  Author: USER
 */ 


#ifndef LCD_4BIT_H_
#define LCD_4BIT_H_

#define F_CPU 16000000
#include <avr/io.h>
#include <util/delay.h>

#define LCD_DATA_DDR	DDRC
#define LCD_DATA_PORT	PORTC
#define LCD_DATA_PIN	PINC
#define LCD_RS_DDR		DDRB
#define LCD_RW_DDR		DDRB
#define LCD_E_DDR		DDRB
#define LCD_RS_PORT		PORTB
#define LCD_RW_PORT		PORTB
#define LCD_E_PORT		PORTB
#define LCD_RS			5
#define LCD_RW			6
#define LCD_E			7

//COMMAND
#define COMMAND_DISPLAY_CLEAR	0x01 //글자 데이터 전부 삭제
#define COMMAND_DISPLAY_ON		0x0c //화면 온 커서 오프 커서점멸 오프
#define COMMAND_DISPLAY_OFF		0x08 //화면 오프 커서 오프 커서점멸 오프
#define COMMAND_ENTRY_MODE		0x06 //커서 우측이동 화면 이동 없음
#define COMMAND_8_BIT_MODE		0x38 //8비트 2열 5*8문자
#define COMMAND_4_BIT_MODE		0x28 //4비트 2열 5*8문자


void LCD_Data(uint8_t data);		//데이터를 데이터 포트에 넣음

void LCD_Data4bit(uint8_t data);	//데이터 포트의 상위 4비트에 8비트 데이터를
									//상위 4비트, 하위 4비트 순서로 넣고 LCD에 보냄

//void LCD_Data4bitInit(uint8_t data);

void LCD_EnablePin();				//LCD에 데이터 포트에 있는 값을 넣음

void LCD_WritePin();				//RW를 쓰기로 바꿈

void LCD_ReadPin();					//RW를 읽기로 바꿈

void LCD_WriteCommand(uint8_t commandData);	//RS를 0으로 두고 데이터를 데이터 포트에 넣고 LCD에 씀

void LCD_WriteData(uint8_t charData);		//RS를 1로 두고 데이터를 데이터 포트에 넣고 LCD에 씀

void LCD_goto_XY(uint8_t row, uint8_t col);	//커서를 원하는 행(0~1)과 열(0~15)에 놓음

void LCD_WriteString(char *string);			//문장을 한 글자씩 LCD에 써 넣음

void LCD_WriteStringXY(uint8_t row, uint8_t col, char *string);	//문장을 원하는 위치에서부터 한 글자씩 LCD에 써 넣음

void LCD_Init();					//LCD를 datasheet에서 요구한 순서대로 초기화함
									//자세한 내용은 datasheet 참조
#endif /* LCD_4BIT_H_ */