//0~9를 올라가거나 내려가거나 세기 
module up_down_counter_BCD_p(
    input clk, rst_p, up_down,
    output reg [3:0] count
);
    
    always@(posedge clk or posedge rst_p) begin
        if(rst_p)  count = 0;
        else begin
			if(up_down) begin
				if(count>=9)count = 0;
				else count = count+1;
			end
			else begin
				if(count == 0) count = 9;
				else count = count - 1;
			end
		end
    end
endmodule

//7-segment의 4자리 전체에 0~9를 올리거나 내리면서 세기.
module counter_fnd_BCD_top(
	input clk, rst_p, up_down,
	output [6:0] seg_7,
	output [3:0] com
);

	wire [3:0] count;
	assign com = 4'h0;
	
	reg[25:0] clk_div;
	
	always@(posedge clk) clk_div = clk_div + 1;
	
	up_down_counter_BCD_p counter_fnd (clk_div[25], rst_p, up_down, count);
	
	BCD_7_Segment BCD(count, seg_7);

endmodule

//0~4095(12'hfff)까지 버튼 입력에 따라 올리거나 내리면서 세기
module counter_4digit_fnd_top(
	input clk, rst_p, btn1,
	output [7:0] seg_7,
	output [3:0] com
);

	wire [11:0] count;
	reg[25:0] clk_div;
	wire up_down, up;
	
	always@(posedge clk or posedge rst_p) begin
	   if(rst_p) clk_div = 0;
	   else clk_div = clk_div + 1;
	end
	
	wire up_down_p;
    D_flip_flop_p dflip1(btn1, clk_div[16],  up_down);
    edge_detector_n edge_detec(clk, up_down,rst_p, up_down_p);
    T_flip_flop_p tflip(clk, up_down_p, rst_p, up);
	
	up_down_counter_Nbit_p #(12) counter_fnd (clk_div[25], rst_p, up, count);
	wire [15:0] dec_value;
	bin_to_dec btd(count, dec_value);
	FND_4digit_ctrl fnd_cntr( clk, dec_value, com, seg_7);

endmodule

