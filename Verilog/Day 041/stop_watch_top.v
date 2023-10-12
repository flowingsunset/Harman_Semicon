module stop_watch_top(
    input clk,
    input rst_p,
    input  btn,
    output [3:0] an,
    output [6:0] seg
    );
    reg[16:0] clk_div;
    wire start_stop_pedge, start_stop;
    always@(posedge clk or posedge rst_p) begin
	   if(rst_p) clk_div = 0;
	   else clk_div = clk_div + 1;
	end
	
    D_flip_flop_p dpp(btn, clk_div[16],  start_stop);
    wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk(.clk(clk), .reset_p(rst_p), .clk_usec(clk_usec));
    clock_msec msec_clk(.clk(clk), .clk_usec(clk_usec), .reset_p(rst_p), .clk_msec(clk_msec));
    clock_sec sec_clk(.clk(clk), .clk_msec(clk_msec), .reset_p(rst_p), .clk_sec(clk_sec));
    wire [3:0] sec1, sec10;
    counter_dec_60 cnt_60(.clk(clk), .reset_p(rst_p), .clk_time(clk_sec), .dec1(sec1), .dec10(sec10));
    FND_4digit_ctrl fnd_cntr( .clk(clk), .value({8'b0, sec10, sec1}), .com(an), .seg_7(seg));
    
    
endmodule
