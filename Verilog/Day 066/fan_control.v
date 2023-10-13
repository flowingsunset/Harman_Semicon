`timescale 1ns / 1ps

module fan_control(
    input wire toggle,
    input wire [6:0]duty_btn,
    input wire [6:0]duty_humid,
    input wire stop_sonic,
    output wire [6:0] duty_control
    );

    wire pwm_in;

    assign pwm_in = toggle ? pwm_btn : pwm_humid;
    assign pwm = stop_sonic ? 0 :
                 stop_timer ? 0 : pwm_in;
endmodule
