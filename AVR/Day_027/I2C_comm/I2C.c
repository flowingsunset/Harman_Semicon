/*
 * I2C.c
 *
 * Created: 2023-07-25 오후 2:28:55
 *  Author: USER
 */ 
#include "I2C.h"

void I2C_Init( )
{
	I2C_DDR |= (1 << I2C_SCL) | (1 << I2C_SDA);		//출력 설정
	TWBR = 72;			// 100KHz
//	TWBR = 32;			// 200KHz
//	TWBR = 12;			// 400KHz
//	I2C 통신 주파수 설정 공식은 데이터시트의 pg.198 확인
}

void I2C_Start( )
{
	TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);		// START 비트 설정
															// TWINT 에 1을 SET 하여 인터럽트를 발생시키는 것 같지만
															// 소프트웨어적으로 1을 SET 하여 FLAG를 클리어 함 !!
	while (!(TWCR & (1 << TWINT)));		// 하드웨어적으로 TWINT 시점을 결정
}

void I2C_STOP( )
{
	TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);		// STOP 비트 설정
}

void I2C_TxData( uint8_t data)				// data 1바이트 전송
{
	TWDR = data;	//전송할 1바이트 데이터
	TWCR = (1 << TWINT) | (1 << TWEN);	//I2C 전송 시작
	while(!(TWCR & (1 << TWINT)));		// 전송 완료 대기
}

void I2C_TxByte(uint8_t devAddrRW, uint8_t data)
{
	I2C_Start( );
	I2C_TxData(devAddrRW);
	I2C_TxData(data);
	I2C_STOP( );
}



















