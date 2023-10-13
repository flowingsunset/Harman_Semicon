/*
 * I2C_lcd.h
 *
 * Created: 2023-07-25 오후 3:07:00
 *  Author: USER
 */ 


#ifndef I2C_LCD_H_
#define I2C_LCD_H_

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include "I2C.h"

#define LCD_RS				0
#define LCD_RW				1
#define LCD_E					2
#define LCD_BACKLIGHT		3

#define LCD_DEV_ADDR		(0x27 << 1)		// I2C LCD 주소 0x27, <<1 은 LSB를 0으로 해야 Write 모드

#define  COMMAND_DISPLAY_CLEAR	0x01	// Clear All Display
#define  COMMAND_DISPLAY_ON		0x0C	// 화면 ON, 커서 OFF, 커서점멸 OFF
#define  COMMAND_DISPLAY_OFF		0x08	// 화면 OFF, 커서 OFF, 커서점멸 OFF
#define  COMMAND_4_BIT_MODE		0x28	// 4BIT, 화면2행, 5*8 Font
#define  COMMAND_ENTRY_MODE		0x06	// 커서 우측 이동, 화면이동 없음

void LCD_Data4bit(uint8_t data);		//8비트 데이터를 상위 4비트, 하위 4비트 순으로 상위 4비트에 실어서 I2C로 보냄
										//상위 4비트는 데이터 전송에 사용되며
										//하위 4비트는 상위부터 각각 LCD_BACKLIGHT, LCD_E, LCD_RW, LCD_RS로 정해져 있음.
void LCD_EnablePin( );					//2번 비트(LCD_E)를 1로 만든 데이터를 한번, 0으로 만든 데이터를 한번 보내서 LCD에 값을 써줌
void LCD_WriteCommand(uint8_t commandData);	//RS를 0(명령어), RW를 0(쓰기)으로 둔 후 commandData를 LCD_Data4bit으로 보냄
void LCD_WriteData(uint8_t charData);		//RS를 1(명령어), RW를 0(쓰기)으로 둔 후 commandData를 LCD_Data4bit으로 보냄
void LCD_BackLightOn( );				//3번 비트(LCD_BACKLIGHT)를 1로 만든 후 현재의 데이터를 한번 보냄.
void LCD_GotoXY(uint8_t row, uint8_t col);	//원하는 행(0~1)과 열(0~15)로 커서를 옮기는 명령어를 보냄
void LCD_Writestring(char *string);			//문장을 한 글자씩 LCD에 씀
void LCD_WriteStringXY(uint8_t row, uint8_t col, char *string);	//문장을 원하는 위치에서부터 한 글자씩 LCD에 씀
void LCD_Init( );		//LCD를 데이터시트에서 요구하는 순서로 진행함

#endif /* I2C_LCD_H_ */