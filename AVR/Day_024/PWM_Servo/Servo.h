/*
 * Servo.h
 *
 * Created: 2023-07-20 오후 3:38:03
 *  Author: USER
 */ 


#ifndef SERVO_H_
#define SERVO_H_


#include <avr/io.h>
void servoInit();	//PB5 및 Timercounter1 초기화
void servoStop();	//PWM이 출력되지 않게 함
void servoRun(uint8_t degree);	//각도에 맞는 PWM 파형을 내보냄




#endif /* SERVO_H_ */