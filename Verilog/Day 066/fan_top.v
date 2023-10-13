`timescale 1ns / 1ps

module fan_top(
    //general port
    input clk, reset_p,
    input [4:0]btn,
    output [15:0]led,

    //dht-11 port
    inout dht11_data,

    //ultrasonic port
    input echo,
    output trig,

    //pwm output
    output pwm_fan,
    output pwm_servo,

    //fnd output
    output [3:0] com,
    output [7:0] seg_7
    );

    wire w_toggle, w_toggle_pe;
    wire [6:0]w_duty_btn;
    wire [6:0]w_duty_humid;
    wire w_stop_sonic;

    //toggle button for select pwm generater
    button_cntr bcntr_set(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(w_toggle_pe), .btn_ne());
    T_flip_flop_p tff1(.clk(clk), .t(w_toggle_pe), .reset_p(reset_p), .q(w_toggle));

    //pwm signal 1 btn
    fan_btn fan_btn(.clk(clk), .reset_p(reset_p), .btn(btn[1]), led(led[3:0]), .duty(w_duty_btn));
    //pwm signal 2 humid
    

    //system stop signal 1 ultrasonic
    echo_safety_fan_speed_teamproject fan_sonic(.clk(clk), .reset_p(reset_p), .echo(echo), .trig(trig), .led_bar(led[15:8]), .stop_fan(w_stop_sonic));
    //system stop signal 2 timer


    //pwm control module
    fan_control fan_control(.toggle(w_toggle), .duty_btn(w_duty_btn), .duty_humid(w_duty_humid), .stop_sonic(w_stop_sonic),.duty_control(w_duty_control));
    //pwm generater
    pwm_100  fan_pwm(.clk(clk), .reset_p(reset_p), .duty(w_duty_control),.pwm_freq(100),.pwm_100pc(pwm_fan));

    //FND control module


    //servo signal
    fan_servo fan_servo(.clk(clk), .reset_p(reset_p), .pwm(pwm_servo), .vauxp6(vauxp6), .vauxn6(vauxn6));

    //light signal
    led_pwm_fan_teamproject led_pwm(.clk(clk), .reset_p(reset_p), .btn(btn[4]), .fan_led1(led[1]));

endmodule
