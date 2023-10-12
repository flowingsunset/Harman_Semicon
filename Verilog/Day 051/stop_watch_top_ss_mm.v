`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 10:58:49
// Design Name: 
// Module Name: stop_watch_top_ss_mm
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


module stop_watch_ss_mm_top(
    input clk,
    input rst_p,
    input  [1:0]btn,
    output [3:0] an,
    output [6:0] seg,
    output [1:0] led
    );

    reg[16:0] clk_div;
    wire btn_start, start_stop;
    wire btn_lap, lap;
    wire w_clk_msec;
    wire w_clk_usec;
    wire clk_msec;
    wire w_clk_sec;
     wire clk_usec, clk_sec;
    wire [1:0] debounced_btn;
    wire [3:0] msec100, msec10;
    assign w_clk_msec = start_stop ? clk_msec : 0;
    assign led[0] = start_stop;
    assign led[1] = lap;

  always@(posedge clk or posedge rst_p) begin
	   if(rst_p) clk_div = 0;
	   else clk_div = clk_div + 1;
	end

	D_flip_flop_p dff1(.d(btn[0]),.clk(clk_div[16]),.rst_p(rst_p),.q(debounced_btn[0]));
	edge_detector_p edn_top1(.clk(clk), .cp_in(debounced_btn[0]), .rst_p(rst_p), .p_edge(btn_start), .n_edge());
    T_flip_flop_p tff1(.clk(clk), .t(btn_start), .rst_p(rst_p), .q(start_stop));
    
    D_flip_flop_p dff2(.d(btn[1]),.clk(clk_div[16]),.rst_p(rst_p),.q(debounced_btn[1]));
	edge_detector_p edn_top2(.clk(clk), .cp_in(debounced_btn[1]), .rst_p(rst_p), .p_edge(btn_lap), .n_edge());
    T_flip_flop_p tff2(.clk(clk), .t(btn_lap), .rst_p(rst_p), .q(lap));
    
    reg [15:0]lap_value;
    wire [15:0] value;
    wire [3:0] sec1, sec10;
    assign value = lap ? lap_value : {sec10, sec1, msec100, msec10};
    
    always@(posedge clk) begin
        if(rst_p)  lap_value <= 0;
        else if(btn_lap) lap_value <= {sec10, sec1, msec100, msec10};
    end
   
    clock_usec usec_clk(.clk(clk), .reset_p(rst_p), .clk_usec(w_clk_usec));
    clock_div_1000 msec_clk(.clk(clk), .clk_source(w_clk_usec), .reset_p(rst_p), .clk_div_1000(clk_msec));
    clock_div_1000 sec_clk(.clk(clk), .clk_source(w_clk_msec), .reset_p(rst_p), .clk_div_1000(w_clk_sec));
    
    counter_dec_60 cnt_60_sec(.clk(clk), .reset_p(rst_p), .clk_time(w_clk_sec), .dec1(sec1), .dec10(sec10));
    counter_dec_99 cnt_99_msec(.clk(clk), .reset_p(rst_p), .clk_msec(w_clk_msec), .msec100(msec100), .msec10(msec10));
    
    FND_4digit_ctrl fnd_cntr( .clk(clk), .rst_p(rst_p),.value(value), .com(an), .seg_7(seg));
    
    
endmodule
