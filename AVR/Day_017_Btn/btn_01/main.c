/*
 * btn_01.c
 *
 * Created: 2023-07-11 오전 11:12:26
 * Author : USER
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>


//int main(void)
//{
    //DDRD = 0xff;		//LED 연결된 포트 출력 사용
	//DDRC &= ~(1<<0);	// 버튼 연결된 0번핀 입력으로 설정
	////PORTC |= (1<<0);	//포트C의 0번핀 내부 풀업저항 활성화(Datasheet의 Configuring the Pin 참조)
    //while (1) 
    //{
		//if(PINC&(1<<0))	//0번 핀이 안눌리면
		//{
			//PORTD &= ~(1<<0);
		//}
		//else
		//{
			//PORTD |= (1<<0);	
		//}
			//
    //}
//}

//int main()
//{
	//DDRD = 0xff;			//LED 출력
	//DDRC &= ~(1<<PINC0);	//버튼 3개를 입력으로
	//DDRC &= ~(1<<PINC1);
	//DDRC &= ~(1<<PINC2);
	//
	//while(1)
	//{
		//if(!(PINC&(1<<PINC0))|!(PINC&(1<<PINC1))|!(PINC&(1<<PINC2))) // 버튼이 하나라도 눌렸을 때
		//{
			//PORTD = 0x0f&(~PINC);	//상위 4비트를 0, 하위 4비트를 눌린 핀으로 넣어줌
		//}
		//else
		//{
			//PORTD &= ~((1<<PINC0)|(1<<PINC1)|(1<<PINC2));	//하위 3비트를 0을 써줌
		//}
	//}
//}

int main()
{
	DDRD = 0xff;
	DDRC &= ~((1<<PINC0));
	
	uint8_t ledData = 0x01;
	uint8_t buttonData;
	int flag = 0;
	PORTD = 0x00;
	
	while(1)
	{
		buttonData = PINC;
		if ((buttonData &(1<<0)) == 0)
		{
			ledData = (ledData >> 7) | (ledData << 1);
			PORTD = ledData;
			_delay_ms(100);
			
		}
		if ((buttonData &(1<<1)) == 0)
		{
			ledData = (ledData >> 1) | (ledData << 7);
			PORTD = ledData;
			_delay_ms(100);
		}
		if ((buttonData &(1<<2)) == 0)
		{
			flag = 1;
		}
		if ((buttonData &(1<<3)) == 0)
		{
			PORTD = 0xff;
			_delay_ms(200);
			PORTD = 0x00;
			_delay_ms(200);
			if ((buttonData &(1<<3)) == 0)
			{
				flag = 0;
			}
		}
				
	}
	
}

