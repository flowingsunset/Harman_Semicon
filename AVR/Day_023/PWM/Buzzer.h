/*
 * Buzzer.h
 *
 * Created: 2023-07-19 오전 11:39:15
 *  Author: USER
 */ 


#ifndef BUZZER_H_
#define BUZZER_H_

//f_OCn = f_clk_i/o / (2*N*(1+OCR_n))
// -> 현실 주파수의 절반을 넣으면 원하는 음계가 나오게 했음
// 수동 부저를 사용하면 주파수를 맞춰서 원하는 음계를 만들어 낼 수 있음
// 파워 부저는 이미 음이 정해져있어서 불가능함
#define do_4	131 //도
#define re_4	147 //레
#define mi_4	165 //미
#define fa_4	175 //파
#define fa_4_sh 185 //파샾
#define so_4	196 //솔
#define la_4	220 //라
#define ti_4	247 //시
#define do_5	131*2
#define re_5	147*2
#define re_5_sh	311
#define mi_5	165*2
#define fa_5	175*2
#define so_5	196*2
#define la_5	220*2
#define ti_5	247*2


void buzzerInit();

void noBuzzer();

void playBuzzer();

void setBuzzer(int note);

void playTrout();

void playSchoolBell();



#endif /* BUZZER_H_ */