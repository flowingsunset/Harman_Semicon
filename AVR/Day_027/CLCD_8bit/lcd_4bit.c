﻿/*
 * lcd_4bit.c
 *
 * Created: 2023-07-25 오후 12:15:07
 *  Author: USER
 */ 
#include "lcd_4bit.h"

void LCD_Data(uint8_t data)
{
	LCD_DATA_PORT = data;	//데이터 핀에 데이터 출력
}

void LCD_Data4bit(uint8_t data)
{
	LCD_DATA_PORT = (LCD_DATA_PORT & 0x0f) | (data & 0xf0); //상위 4비트 출력
	LCD_EnablePin();
	LCD_DATA_PORT = (LCD_DATA_PORT & 0x0f) | ((data & 0x0f)<<4); //하위 4비트 출력
	LCD_EnablePin();
}

void LCD_EnablePin()
{
	//LCD_E_PORT &= ~(1<<LCD_E); //E 핀을 LOW 설정
	LCD_E_PORT |= (1<<LCD_E); // High 동작 신호 전송
	_delay_us(1);
	LCD_E_PORT &= ~(1<<LCD_E);
	_delay_ms(2);
}

void LCD_WritePin()
{
	LCD_RW_PORT &= ~(1<<LCD_RW);	// RW 핀을 LOW로 설정하여 쓰기 모드
}

void LCD_ReadPin()
{
	LCD_RW_PORT |= (1<<LCD_RW);	// RW 핀을 High로 설정하여 읽기 모드
}

void LCD_WriteCommand(uint8_t commandData)
{
	LCD_RS_PORT &= ~(1<<LCD_RS);	//RS핀을 LOW로 설정해서 명령어 모드 설정
	LCD_WritePin();					//데이터 쓰기 함수 호출
	LCD_Data4bit(commandData);			//명령어 데이터를 데이터 핀에 출력
	//LCD_EnablePin();				//LCD 동작 신호 전송
}

void LCD_WriteData(uint8_t charData)
{
	LCD_RS_PORT |= (1<<LCD_RS);		// RS 핀을 High로 설정, 문자 데이터 모드설정
	LCD_WritePin();
	LCD_Data4bit(charData);
	//LCD_EnablePin();
}

void LCD_goto_XY(uint8_t row, uint8_t col)
{
	col %= 16;	//열 인덱스를 0부터 15로 제한
	row %= 2;	//행 인덱스를 0부터 1로 제한
	
	uint8_t address = (0x40*row) + col;	//주소 계산
	uint8_t command = 0x80 + address;	//command 값 계산
	LCD_WriteCommand(command);			//주소 설정 command를 LCD에 전달
}

void LCD_WriteString(char *string)
{
	for (uint8_t i = 0; string[i]; i++)
	{
		LCD_WriteData(string[i]);	//문자열의 각 문자를 LCD에 출력
	}
}


void LCD_WriteStringXY(uint8_t row, uint8_t col, char *string)
{
	LCD_goto_XY(row, col);
	LCD_WriteString(string);
}

void LCD_Init()
{
	LCD_DATA_DDR = 0xff;
	LCD_RS_DDR |= (1<<LCD_RS);
	LCD_RW_DDR |= (1<<LCD_RW);
	LCD_E_DDR |= (1<<LCD_E);
	
	_delay_ms(20);
	LCD_WriteCommand(0x03);
	_delay_ms(10);
	LCD_WriteCommand(0x03);
	_delay_ms(1);
	LCD_WriteCommand(0x03);
	LCD_WriteCommand(0x02);
	LCD_WriteCommand(COMMAND_4_BIT_MODE);
	LCD_WriteCommand(COMMAND_DISPLAY_OFF);
	LCD_WriteCommand(COMMAND_DISPLAY_CLEAR);
	LCD_WriteCommand(COMMAND_DISPLAY_ON);
	LCD_WriteCommand(COMMAND_ENTRY_MODE);	//입력모드 설정
}