/*
 * ULTRASONIC.h
 *
 * Created: 2023-08-21 오후 2:04:21
 *  Author: USER
 */ 


#ifndef ULTRASONIC_H_
#define ULTRASONIC_H_

#define F_CPU 16000000UL
#define ULTRASONIC_DDR  DDRA
#define ULTRASONIC_PORT  PORTA
#define ULTRASONIC_PIN  PINA
#define PRESCALER 1024

#include <avr/io.h>



void Timer_init()
{
	//16비트 타이머 1번, 분주비 1024 설정
	TCCR1B |= (1<<CS12) | (1<<CS10);
}

void ultrasonic_init()
{
	ULTRASONIC_DDR |= 0x02; //트리거핀 출력 설정
	ULTRASONIC_DDR &= 0xfe;	//에코핀 입력 설정
}

uint8_t measure_distance(void)
{
	// 트리거 핀으로 펄스 출력
	ULTRASONIC_PORT &= ~(1<<1);	// LOW 시작
	_delay_us(1);			//1us 대기
	ULTRASONIC_PORT |= (1<<1);	//HIGH 출력
	_delay_us(10);			//10us 대기
	ULTRASONIC_PORT &= ~(1<<1);	// LOW 끝
	
	// 에코핀이 High가 될때까지 대기
	TCNT1 = 0;
	while(!(ULTRASONIC_PIN & 0x01));
	if (TCNT1 > 65000) return 0;	//장애물이 없는 경우
	
	// 에코핀이 LOW가 될때까지 시간 측정
	TCNT1 = 0;
	while(ULTRASONIC_PIN&0x01){
		if(TCNT1 > 65000){
			TCNT1 = 0;
			break;
		}
	}
	
	//에코핀의 펄스폭을 마이크로초로 계산
	double pulse_width = 1000000.0*TCNT1*PRESCALER / F_CPU;
	
	//계산된 펄스의 폭을 cm로 변환
	return pulse_width / 58;
}



#endif /* ULTRASONIC_H_ */