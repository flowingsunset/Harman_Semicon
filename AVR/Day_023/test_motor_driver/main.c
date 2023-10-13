/*
 * test_motor_driver.c
 *
 * Created: 2023-07-19 오후 2:24:08
 * Author : USER
 */ 
#define	F_CPU	16000000ul
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

int main(void)
{
    DDRG |= (1<<0)|(1<<1);		//모터 드라이버에서는 핀을 두개 끌어서 
								//00: 정지, 01: 역방향, 10: 정방향, 11: 브레이크로 사용함
    while (1) 
    {
		PORTG &= ~((1<<1)|1<<0);	// 정지
		_delay_ms(2000);
		PORTG &= ~((1<<1)|0<<0);	// 역방향
		PORTG |= (0<<1)|(1<<0);
		_delay_ms(2000);
		PORTG &= ~((0<<1)|1<<0);	// 정방향 cw
		PORTG |= (1<<1)|(0<<0);
		_delay_ms(2000);
		PORTG &= ~((0<<1)|0<<0);	// 브레이크
		PORTG |= (1<<1)|(1<<0);
		_delay_ms(2000);
    }
}

