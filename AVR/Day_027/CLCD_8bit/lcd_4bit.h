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

#define LCD_DATA_DDR		DDRC
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
#define COMMAND_DISPLAY_CLEAR	0x01
#define COMMAND_DISPLAY_ON		0x0c //화면 온 커서 오프 커서점멸 오프
#define COMMAND_DISPLAY_OFF		0x08 //화면 오프 커서 오프 커서점멸 오프
#define COMMAND_ENTRY_MODE		0x06 //커서 우측이동 화면 이동 없음
#define COMMAND_8_BIT_MODE		0x38 //8비트 2열 5*8문자
#define COMMAND_4_BIT_MODE		0x28 //4비트 2열 5*8문자


void LCD_Data(uint8_t data);

void LCD_Data4bit(uint8_t data);

void LCD_EnablePin();

void LCD_WritePin();

void LCD_ReadPin();

void LCD_WriteCommand(uint8_t commandData);

void LCD_WriteData(uint8_t charData);

void LCD_goto_XY(uint8_t row, uint8_t col);

void LCD_WriteString(char *string);

void LCD_WriteStringXY(uint8_t row, uint8_t col, char *string);

void LCD_Init();



#endif /* LCD_4BIT_H_ */