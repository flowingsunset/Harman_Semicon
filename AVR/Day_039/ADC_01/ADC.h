/*
 * ADC.h
 *
 * Created: 2023-08-21 오후 3:41:26
 *  Author: USER
 */ 


#ifndef ADC_H_
#define ADC_H_

#include <avr/io.h>

void ADC_init()
{
	ADMUX |= (1<<REFS0);	//AVCC 기준 전압
	
	//ADCSRA |= 0x07;
	ADCSRA |= (1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);	//ADC 12.5kHz분주
	ADCSRA |= (1<<ADEN);		//ADC 사용 가능
	ADCSRA &= ~(1<<ADFR);		//단일 ADC 모드
}

int read_ADC(uint8_t channel)
{
	
	ADMUX = ((ADMUX & 0xe0)|channel);	//단일 입력 채널 선택
										//하위 5비트중에서 하위 3비트가 바로 F0~7로 연결됨
	ADCSRA |= (1<<ADSC);	//변환 시작
	while (!(ADCSRA & (1<<ADIF)));	//변환 종료 대기
	
	return ADC;	//10비트 값 반환
}



#endif /* ADC_H_ */