/*
 * I2C.h
 *
 * Created: 2023-07-25 오후 2:29:05
 *  Author: USER
 */ 


#ifndef I2C_H_
#define I2C_H_

#include <avr/io.h>

#define I2C_DDR		DDRD
#define I2C_SCL		PORTD0
#define I2C_SDA		PORTD1

void I2C_Init( );	//I2C 통신에 필요한 레지스터 설정
void I2C_Start( );	//I2C 통신 시작을 위한 레지스터를 설정함
void I2C_STOP( );	//I2C 통신을 끝내기 위한 레지스터를 설정함
void I2C_TxData( uint8_t data);	//8비트 데이터를 slave에 보냄
void I2C_TxByte(uint8_t devAddrRW, uint8_t data);	//I2C통신을 시작하고, 슬레이브 주소를 보내고, 1바이트를 보내고, 통신을 끝냄.

#endif /* I2C_H_ */