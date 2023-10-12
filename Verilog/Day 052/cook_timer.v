`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 09:13:53
// Design Name: 
// Module Name: cook_timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cook_timer(
    input clk,
    input reset_p,
    input [3:0] btn,
    output [3:0] an,
    output [6:0] seg,
    output alarm
    );

    wire w_start, w_incsec, w_incmin ;
    wire w_start_stop;
    wire timeout, alarm_start, t_start_stop;
    assign t_start_stop = w_start ? 1 :
                      alarm_start ? 1 : 0;

    button_cntr bcntr_start(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(w_start), .btn_ne());
    button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_pe(w_incsec), .btn_ne());
    button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_pe(w_incmin), .btn_ne());
    T_flip_flop_p tff1(.clk(clk), .t(t_start_stop), .rst_p(reset_p), .q(w_start_stop));

   

    wire [3:0] w_sec1_set, w_sec10_set;
    wire [3:0] w_min1_set, w_min10_set;
    counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(w_incsec), .dec1(w_sec1_set), .dec10(w_sec10_set));
    counter_dec_60 up_min(.clk(clk), .reset_p(reset_p), .clk_time(w_incmin), .dec1(w_min1_set), .dec10(w_min10_set));

    reg [15:0] set_time;
    always @(posedge clk) begin
        if(reset_p) set_time <= 0;
        else set_time <= {w_min10_set, w_min1_set, w_sec10_set, w_sec1_set};
    end

    wire w_clk_usec, w_clk_msec, w_clk_sec;
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(w_clk_usec));
    clock_div_1000 msec_clk(.clk(clk), .clk_source(w_clk_usec), .reset_p(reset_p), .clk_div_1000(w_clk_msec));
    clock_div_1000 sec_clk(.clk(clk), .clk_source(w_clk_msec), .reset_p(reset_p), .clk_div_1000(w_clk_sec));

    wire w_load_enable;
    wire w_dec_clk;
    wire [3:0] w_sec1, w_sec10;
    wire [3:0] w_min1, w_min10;
    wire w_clk_start;
    assign w_clk_start = w_start_stop ? w_clk_sec : 0;
    assign w_load_enable = !w_start_stop ? w_start : 0;
    
    loadable_down_counter_dec_60 dc_sec(
    .clk(clk), .reset_p(reset_p), .clk_time(w_clk_start),
    .load_enable(w_load_enable), .set_value1(w_sec1_set), .set_value10(w_sec10_set), .dec1(w_sec1), .dec10(w_sec10), .dec_clk(w_dec_clk)
    );
    
    loadable_down_counter_dec_60 dc_min(
    .clk(clk), .reset_p(reset_p), .clk_time(w_dec_clk),
    .load_enable(w_load_enable), .set_value1(w_min1_set), .set_value10(w_min10_set), .dec1(w_min1), .dec10(w_min10), .dec_clk()
    );

    reg [15:0] count_time;
    always @(posedge clk) begin
        if(reset_p) count_time <= 0;
        else count_time <= {w_min10, w_min1, w_sec10, w_sec1};
    end
    
    
    assign timeout = |count_time;
    wire alarm_off;
    assign alarm_off = |{btn[3:0], reset_p};
    edge_detector_n tmout(.clk(clk), .cp_in(timeout), .rst_p(reset_p), .p_edge(), .n_edge(alarm_start));
    T_flip_flop_p tff_on_off(.clk(clk), .t(alarm_start), .rst_p(alarm_off), .q(alarm));

    wire [15:0] value;
    assign value = w_start_stop ? count_time: set_time;

    FND_4digit_ctrl fnd_cntr( .clk(clk), .rst_p(reset_p),.value(value), .com(an), .seg_7(seg));

endmodule
