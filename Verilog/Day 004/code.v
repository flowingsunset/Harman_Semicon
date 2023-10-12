`timescale 1ms/1ps

module BCD_7_Segment(
	input [3:0] num,
	output [7:0] BCD
	);
	wire [6:0] bcd;
	assign bcd = (num == 0) ? 7'h01 :
				 (num == 1) ? 7'h4f :
				 (num == 2) ? 7'h12 :
				 (num == 3) ? 7'h06 :
				 (num == 4) ? 7'h4c :
				 (num == 5) ? 7'h24 :
				 (num == 6) ? 7'h20 :
				 (num == 7) ? 7'h0f :
				 (num == 8) ? 7'h00 :
				 (num == 9) ? 7'h0c :
				 (num == 10) ? 7'h08 :
				 (num == 11) ? 7'h60 :
				 (num == 12) ? 7'h72 :
				 (num == 13) ? 7'h42 :
				 (num == 14) ? 7'h30 :
				 (num == 15) ? 7'h38 : 7'h8f;
	assign BCD = {~bcd, 1'b0};
endmodule

module BCD_7_Segment_4(
	input  clk,
	output [6:0] seg_7,
	output reg [3:0] com = 4'b0001
	);
	
	wire clk_10ms;
	wire clk_1s;
	
	reg[15:0] cnt;
	wire [27:0] bcd;
	
	reg[26:0] clk_div;
	
	always@(posedge clk) clk_div<= clk_div+1;
	
	always@(posedge clk_div[18]) com <= {com[2:0], com[3]};

	always@(posedge clk_div[26]) cnt <= cnt+1;
	
	assign seg_7 = 	(com == 4'b1000) ? bcd[27:21] : 
					(com == 4'b0100) ? bcd[20:14] :
					(com == 4'b0010) ? bcd[13:7] : bcd[6:0];
	
	
	BCD_7_Segment dut11(cnt[15:12], bcd[27:21]);
	BCD_7_Segment dut21(cnt[11:8], bcd[20:14]);
	BCD_7_Segment dut31(cnt[7:4], bcd[13:7]);
	BCD_7_Segment dut41(cnt[3:0], bcd[6:0]);
	
	
endmodule
