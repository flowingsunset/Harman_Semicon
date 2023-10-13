module FND_4digit_ctrl(
    input clk,
    input reset_p,
    input [15:0] value,
    output [3:0] com,
    output [6:0] seg_7
);

    reg [16:0] clk_1ms;
    always@(posedge clk or posedge reset_p) begin
        if(reset_p) clk_1ms <= 0;
        else clk_1ms = clk_1ms+1;
    end
    ring_counter_fnd ring_ctrl(.clk(clk_1ms[16]), .reset_p(reset_p), .com(com));
    
    reg [3:0] hex_value;
    BCD_7_Segment BCD(hex_value, seg_7);
    
    always@(posedge clk or posedge reset_p) begin
        if(reset_p) hex_value = 7'h01;
        case(com)
            4'b1110: hex_value = value[3:0];
            4'b1101: hex_value = value[7:4];
            4'b1011: hex_value = value[11:8];
            4'b0111: hex_value = value[15:12];
            //default hex_value = hex_value;
        endcase
    end

endmodule

module ring_counter_fnd(
    input clk,
    input reset_p,
    output [3:0] com
    );

    reg[3:0] temp;
    always@(posedge clk, posedge reset_p) begin
        if(reset_p) temp <= 0;
        else begin
            if(!((temp ==4'b1110) | (temp == 4'b1011) | (temp == 4'b1101) | (temp == 4'b0111)) ) temp <= 4'b1110;
            else temp <= {temp[2:0], temp[3]};
        end
    end
    assign com = temp;
endmodule

module BCD_7_Segment(
	input [3:0] num,
	output [6:0] BCD
	);
	assign BCD = (num == 0) ? 7'h01 :
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
endmodule

module bin_to_dec(
        input [11:0] bin,
        output reg [15:0] bcd
    );

    reg [3:0] i;
    
    always @(bin) begin
        bcd = 0;
        for (i=0;i<12;i=i+1)begin
            bcd = {bcd[14:0], bin[11-i]};
            if(i < 11 && bcd[3:0] > 4) bcd[3:0] = bcd[3:0] + 3;
            if(i < 11 && bcd[7:4] > 4) bcd[7:4] = bcd[7:4] + 3;
            if(i < 11 && bcd[11:8] > 4) bcd[11:8] = bcd[11:8] + 3;
            if(i < 11 && bcd[15:12] > 4) bcd[15:12] = bcd[15:12] + 3;
        end
    end
endmodule