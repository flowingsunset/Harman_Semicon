module T_flip_flop_n(         //clock의 falling edge에서 동작
    input clk, rst_p,
    output reg q
    );
    
    always@(negedge clk or posedge rst_p)begin
    if(rst_p) q=0;
    else q=~q;
    end
    
endmodule

module T_flip_flop_p(        //clock의 rising edge에서 동작
    input clk, rst_p,
    output reg q
    );
    
    always@(posedge clk or posedge rst_p)begin
    if(rst_p) q=0;
    else q=~q;
    end
    
endmodule

module up_counter(
    input clk, rst_p,
    output reg [3:0] count
);

    always@(posedge clk or posedge rst_p) begin
        if(rst_p) count = 0;
        else count = count+1;
    end

endmodule

module down_counter(
    input clk, rst_p,
    output reg [3:0] count
);

    always@(posedge clk or posedge rst_p) begin
        if(rst_p) count = 0;
        else count = count-1;
    end

endmodule

module up_down_counter(
    input clk, rst_p, up_down,
    output reg [3:0] count
);
    
    always@(posedge clk or posedge rst_p) begin
        if(rst_p)  count = 0;
        else begin
        if(up_down)count = count+1;
        else count = count-1;
        end
    end
endmodule

module counter_fnd_top(
	input clk, rst_p, up_down,
	output [6:0] seg_7,
	output [3:0] com
);

	wire [3:0] count;
	assign com = 4'hf;
	
	reg[25:0] clk_div;
	
	always@(posedge clk) clk_div = clk_div + 1;
	
	up_down_counter counter_fnd (clk_div[25], rst_p, up_down, count);
	
	BCD_7_Segment BCD(count, seg_7);

endmodule

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

module counter_fnd_BCD_top(
	input clk, rst_p, up_down,
	output [6:0] seg_7,
	output [3:0] com
);

	wire [3:0] count;
	assign com = 4'hf;
	
	reg[25:0] clk_div;
	
	always@(posedge clk) clk_div = clk_div + 1;
	
	up_down_counter_BCD_p counter_fnd (clk_div[25], rst_p, up_down, count);
	
	BCD_7_Segment BCD(count, seg_7);

endmodule


//매 클럭마다 4비트 중 하나를 켜둠
//FND_4digit_crtl에서 1ms 클럭을 제공함
module ring_counter_fnd(
    input clk, rst_p,
    output [3:0] com
    );

    reg[3:0] temp = 4'b0001;
    always@(posedge clk or posedge rst_p) begin
        if(rst_p) temp = 4'b0001;
        else temp = {temp[2:0], temp[3]};
    end
    assign com = temp;
endmodule

//ring_counter_fnd의 신호에 맞춰서 16비트 수를 4비트 잘라서
//7-segment에 맞게 수정 후, 같이 7-segment로 내보냄.
module FND_4digit_ctrl(
    input clk, rst_p,
    input [15:0] value,
    output [3:0] com,
    output [6:0] seg_7
);

    reg [16:0] clk_1ms;
    always@(posedge clk or posedge rst_p) begin
       if(rst_p)clk_1ms = 0;
       else  clk_1ms = clk_1ms+1;
    end
    ring_counter_fnd ring_ctrl(clk_1ms[16],rst_p, com);
    
    reg [3:0] hex_value;
    BCD_7_Segment BCD(hex_value, seg_7);
    
    always@(posedge clk) begin
        case(com)
            4'b0001: hex_value = value[3:0];
            4'b0010: hex_value = value[7:4];
            4'b0100: hex_value = value[11:8];
            4'b1000: hex_value = value[15:12];
            default hex_value = hex_value;
        endcase
    end

endmodule

//12비트를 up_down 신호에 맞춰서 카운트 함
module up_down_counter_12bit_p(
    input clk, rst_p, up_down,
    output reg [11:0] count
);
    
    always@(posedge clk or posedge rst_p) begin
        if(rst_p)  count = 0;
        else begin
            if(up_down) count = count+1;
            else count = count - 1;
        end
    end
endmodule

//12비트를 up/down 카운트하고 4자리 7-segment에 출력함
module counter_4digit_fnd_top(
	input clk, rst_p, up_down,
	output [6:0] seg_7,
	output [3:0] com
);

	wire [11:0] count;
	
	reg[25:0] clk_div;
	
	always@(posedge clk or posedge rst_p) begin
	   if(rst_p) clk_div = 0;
	   else clk_div = clk_div + 1;
	end
	
	up_down_counter_12bit_p counter_fnd (clk_div[25], rst_p, up_down, count);
	
	FND_4digit_ctrl fnd_cntr( clk, rst_p, {4'b0000,count}, com, seg_7);

endmodule


