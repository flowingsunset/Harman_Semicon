`timescale 1ns / 1ps///////////////////////////////////////////////////

module fan_project_timer(
    input clk, reset_p,
    input  btn,
    output [3:0] com,
    output [7:0] seg_7,
    output reg stop_timer                                                                                                                                                              
    );
    reg start_stop;
    wire timer;

    button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn), .btn_pe(timer));
    
    parameter S_IDLE = 0;
    parameter S_LOAD1 = 1;
    parameter S_COUNT1 = 2;
    parameter S_LOAD3 = 3;
    parameter S_COUNT3 = 4;
    parameter S_LOAD5 = 5;
    parameter S_COUNT5 = 6;
    parameter S_WAIT_COUNT = 7;
    parameter  S_LOAD0 = 8;
    
    reg [2:0] count = 0;
    reg [3:0] sec1_set = 0, sec10_set = 0, min1_set = 0, min10_set = 0;
    reg load_time;
    reg [3:0] state;

    wire [3:0] min1, min10;
    wire [3:0] sec1, sec10;
    wire [15:0] count_time = {min10, min1, sec10, sec1};
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            start_stop <= 0;
            load_time <= 0;
            min1_set <= 0;
            stop_timer <= 0;
            state <= S_IDLE;
        end
        else begin
            case (state)
                S_IDLE: begin
                    if(timer) begin
                        state <= S_LOAD1;
                    end
                end
                S_LOAD1: begin
                    min1_set <= 1;
                    load_time <= 1;
                    start_stop <= 0;
                    state <= S_COUNT1;
                end
                S_COUNT1: begin
                    min1_set <= 1;
                    load_time <= 0;
                    start_stop <= 1;
                    state <= S_WAIT_COUNT;
                end
                S_LOAD3: begin
                    min1_set <= 3;
                    load_time <= 1;
                    start_stop <= 0;
                    state <= S_COUNT3;
                end
                S_COUNT3: begin
                    min1_set <= 3;
                    load_time <= 0;
                    start_stop <= 1;
                    state <= S_WAIT_COUNT;
                end
                S_LOAD5: begin
                    min1_set <= 5;
                    load_time <= 1;
                    start_stop <= 0;
                    state <= S_COUNT5;
                end
                S_COUNT5: begin
                    min1_set <= 5;
                    load_time <= 0;
                    start_stop <= 1;
                    state <= S_WAIT_COUNT;
                end
                S_WAIT_COUNT: begin
                    if (!count_time) begin
                        min1_set <= 5;
                        load_time <= 0;
                        start_stop <= 0;
                        state <= S_IDLE;
                        stop_timer <= 1;
                    end
                    else if(timer)begin
                        case (min1_set)
                            1: state <= S_LOAD3;
                            3: state <= S_LOAD5;
                            5: state <= S_LOAD0;
                        endcase
                    end
                end
                S_LOAD0: begin
                    min1_set <= 0;
                    load_time <= 1;
                    start_stop <= 0;
                    state <= S_IDLE;
                end
            endcase
        end
    end
   
     wire clk_usec, clk_msec, clk_sec , clk_min;
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    clock_div_1000 msec_clk(.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    clock_div_1000 sec_clk(.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));
    
    wire clk_start, dec_clk;
    assign clk_start = (start_stop) ? clk_sec : 0;  
    
    
    loaderble_down_counter_dec_60 dc_sec(.clk(clk), .reset_p(reset_p), .clk_time(clk_start), .load_enable(load_time), 
        .set_value1(sec1_set), .set_value10(sec10_set), .dec1(sec1), .dec10(sec10), .dec_clk(dec_clk));
    
    
    loaderble_down_counter_dec_60 dc_min(.clk(clk), .reset_p(reset_p), .clk_time(dec_clk), .load_enable(load_time), 
        .set_value1(min1_set), .set_value10(min10_set), .dec1(min1), .dec10(min10));
        
    
   
    FND_4digit_cntr fnd_cntr (.clk(clk), .value(count_time), .com(com), .seg_7(seg_7));
    
    
endmodule
