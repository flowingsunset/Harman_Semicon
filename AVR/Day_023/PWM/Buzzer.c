/*
 * Buzzer.c
 *
 * Created: 2023-07-19 오전 11:39:04
 *  Author: USER
 */ 
#define __DELAY_BACKWARD_COMPATIBLE__
#define F_CPU 16000000ul
#define multi 1	//주파수 증폭을 위해 썼었던 파라미터
				//파워부저여서 주파수를 변경할 수 없었던 것 뿐이었음
#include <util/delay.h>
#include <avr/io.h>
#include "Buzzer.h"


void buzzerInit()
{
	DDRB |= (1<<5) ;	//PB5에서 타이머 1의 pwm이 나옴
	TCCR1B |= (0<<CS12) | (1<<CS11) | (0<< CS10);	//8분주
	TCCR1B |= (0<<WGM13) | (1<<WGM12);	//	4'b0100 : CTC모드(카운트 값이 OCR1A와 같을때 카운트가 초기화 됨)
	TCCR1A |= (0<<WGM11) | (0<<WGM10);
}

void noBuzzer()
{
	TCCR1A &= ~((1<<COM1A1) | (1<<COM1A0));	//미출력
}

void playBuzzer()
{
	TCCR1A |= (0<<COM1A1) | (1<<COM1A0);	//출력(출력핀의 값을 카운트와 OCR1A가 일치할 때 토글함)
}

void setBuzzer(int note)
{
	OCR1A = 1000000 / note;		// 숫자가 커질수록 고주파수의 소리가 나옴
}

void playhmm(int hmm, float tm)	//원하는 음과 지속시간을 넣으면 그대로 실행해줌
{
	playBuzzer();		//부저실행을 위한 출력 활성화
	setBuzzer(hmm);		//원하는 음 넣기
	_delay_ms(4000/tm);	//n분음표 만큼 지속함(2/4박자 기준으로 설계됨)
	noBuzzer();			
	_delay_ms(5);		//건반으로 누르는 듯한 느낌을 주기위해 잠깐 끊어줌
						//자연스럽진 않지만 그냥 이어지는거 보단 아주 좋음
}


void playTrout()	//슈베르트의 송어(세탁 끝날 때 소리)
					//괜히 음악이 중간에 끊어지는게 아님 뒤는 좀 재미 없음
{
	playhmm(so_4, 8);
	playhmm(do_5,8);
	playhmm(do_5,8);
	playhmm(mi_5,8);
	playhmm(mi_5,8);
	playhmm(do_5,4);
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(so_4,6);
	playhmm(so_4,16);
	playhmm(re_5,16);
	playhmm(do_5,16);
	playhmm(ti_4,16);
	playhmm(la_4,16);
	playhmm(so_4,4);
	_delay_ms(4000/8);
	playhmm(so_4,8);
	playhmm(do_5,8);
	playhmm(do_5,8);
	playhmm(mi_5,8);
	playhmm(mi_5,8);
	playhmm(do_5,4);
	playhmm(so_4,8);
	playhmm(do_5,8);
	playhmm(ti_4,8);
	playhmm(la_4,16);
	playhmm(ti_4,16);
	playhmm(do_5,8);
	playhmm(fa_4_sh, 8);
	playhmm(so_4,4);
	_delay_ms(4000/8);
	playhmm(so_4,8);
	playhmm(ti_4,8);
	playhmm(ti_4,8);
	playhmm(do_5,16);
	playhmm(ti_4,16);
	playhmm(la_4,16);
	playhmm(ti_4,16);
	playhmm(do_5,4);
	playhmm(so_4,8);
	playhmm(do_5,8);
	playhmm(ti_4,8);
	playhmm(ti_4,8);
	playhmm(ti_4,16);
	playhmm(fa_5,16);
	playhmm(re_5,16);
	playhmm(ti_4,16);
	playhmm(do_5,3);
	playhmm(do_5,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(do_5,8);
	playhmm(do_5,4);
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(so_4,6);
	playhmm(so_4,16);
	playhmm(re_5,8);
	playhmm(ti_4,8);
	playhmm(do_5,3);
	playhmm(mi_4,8);
	playhmm(mi_4,8);
	playhmm(mi_4,8);
	playhmm(mi_4,8);
	playhmm(ti_4,8);
	playhmm(do_5,4);
	playhmm(la_4,8);
	_delay_ms(4000/8);
	_delay_ms(4000/8);
	playhmm(mi_4,8);
	playhmm(mi_4,6);
	playhmm(ti_4,16);
	playhmm(do_5,3);
	_delay_ms(4000/16);
	_delay_ms(4000/16);
	playhmm(do_5,8);
	playhmm(do_5,8);
	playhmm(do_5,8);
	playhmm(do_5,8);
	playhmm(do_5,8);
	playhmm(do_5,8);
	playhmm(do_5,8);
	playhmm(do_5,4);
	playhmm(la_4,8);
	_delay_ms(4000/32);
	playhmm(la_4,16);
	playhmm(re_5,4);
	playhmm(re_5,16);
	playhmm(la_4,16);
	playhmm(fa_4_sh,16);
	playhmm(mi_4,16);
	playhmm(ti_4,4);
	_delay_ms(4000/16);
	playhmm(so_4,8);
	playhmm(do_5,6);
	playhmm(do_5,16);
	playhmm(ti_4,6);
	playhmm(ti_4,16);
	playhmm(mi_5,8);
	playhmm(la_4,8);
	_delay_ms(4000/16);
	playhmm(la_4,8);
	playhmm(re_5,4);
	playhmm(re_5_sh,8);
	playhmm(mi_5,8);
	playhmm(do_5,8);
	playhmm(ti_4,8);
	playhmm(re_5,8);
	playhmm(do_5,4);
	_delay_ms(4000/16);
	playhmm(do_5,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(do_5,8);
	playhmm(do_5,4);
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(so_4,6);
	playhmm(so_4,16);
	playhmm(re_5,8);
	playhmm(ti_4,8);
	playhmm(do_5,3);
	playhmm(do_5,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(do_5,8);
	playhmm(do_5,4);
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(so_4,6);
	playhmm(so_4,16);
	playhmm(re_5,8);
	playhmm(ti_4,8);
	playhmm(do_5,3);
	playhmm(do_5,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(do_5,8);
	playhmm(do_5,4);
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(so_4,6);
	playhmm(so_4,16);
	playhmm(re_5,8);
	playhmm(ti_4,8);
	playhmm(do_5,2);
}

void playSchoolBell()	//학교종이 땡땡땡
{
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(mi_4,4);
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(mi_4,8);
	playhmm(mi_4,8);
	playhmm(re_4,3);
	
	_delay_ms(4000/8);
	
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(la_4,8);
	playhmm(la_4,8);
	playhmm(so_4,8);
	playhmm(so_4,8);
	playhmm(mi_4,4);
	
	playhmm(so_4,8);
	playhmm(mi_4,8);
	playhmm(re_4,8);
	playhmm(mi_4,8);
	playhmm(do_4,3);
	
	
}