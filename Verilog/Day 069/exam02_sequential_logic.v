module half_adder(
	input A, B,
	output sum, carry
	);

	assign carry = A&B;
	assign sum = A^B;
	
endmodule

module half_adder_N_bit #(parameter N = 4) (
    input inc,
    input [N-1:0] load_data,
    output [N-1:0] sum
);
    wire [N-1:0] carry_out;
    half_adder hadd01(.A(inc), .B(load_data[0]), .sum(sum[0]), .carry(carry_out[0]));

    genvar i;
    generate
        for (i = 1; i<N; i=i+1) begin 
            half_adder hadd_loadable(.A(carry_out[i-1]), .B(load_data[i]), .sum(sum[i]), .carry(carry_out[i]));
        end
    endgenerate
    
endmodule

module full_add_sub_4bit(
	input [3:0] A, B,
	input s,
	output [3:0] S,
	output C_o
	);
	
	wire [4:0] temp;
	assign temp = s? A-B : A+B;
	assign S = temp[3:0];
	assign C_o = s? ~temp[4] : temp[4];
	
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




module counter_4digit_fnd_top(
	input clk, rst_p, btn1,
	output [6:0] seg,
	output [3:0] an
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
    edge_detector_n edn1(clk, up_down,rst_p, up_down_p);
    T_flip_flop_p tflip(clk, up_down_p, rst_p, up);
	
	up_down_counter_Nbit_p #(12) counter_fnd (clk_div[25], rst_p, up, count);
	wire [15:0] dec_value;
	bin_to_dec btd(count, dec_value);
	FND_4digit_ctrl fnd_cntr( clk, rst_p, dec_value, an, seg);

endmodule

module T_flip_flop_p(        //clock?? rising edge???? ????
    input clk,t, reset_p,
    output reg q
    );
    
    always@(posedge clk)begin
    if(reset_p) q=0;
    else if(t) q=~q;
    end
    
endmodule

module up_down_counter_Nbit_p#(parameter N = 4)(
    input clk, reset_p, up_down,
    output reg [N-1:0] count
);
   
    always@(posedge clk or posedge reset_p) begin
        if(reset_p)  count <= 0;
        else begin
            if(!up_down) begin
                if(count >=14'h270f) count <= 0;
                else count <= count+1;
            end
            else begin
                if(count == 0) count <= 14'h270f;
                else count <= count - 1;
            end
        end
    end
    
endmodule

module edge_detector_p(
    input clk,
    input cp_in,
    input reset_p,
    output p_edge,
    output n_edge
);
    reg cp_in_old, cp_in_cur;
    
    always@(posedge clk or posedge reset_p)begin
        if(reset_p) begin
            cp_in_old <= 0;
            cp_in_cur <= 0;
        end
        else begin
            cp_in_old <= cp_in_cur;
            cp_in_cur <= cp_in;
        end
    end
    
    assign p_edge = ~cp_in_old & cp_in_cur;
    assign n_edge = cp_in_old & ~cp_in_cur;
    

endmodule

module edge_detector_n(
    input clk,
    input cp_in,
    input reset_p,
    output p_edge,
    output n_edge
);
    reg cp_in_old, cp_in_cur;
    
    always@(negedge clk)begin
        if(reset_p) begin
            cp_in_old <= 0;
            cp_in_cur <= 0;
        end
        else begin
            cp_in_old <= cp_in_cur;
            cp_in_cur <= cp_in;
        end
    end
    
    assign p_edge = ~cp_in_old & cp_in_cur;
    assign n_edge = cp_in_old & ~cp_in_cur;
    

endmodule

module D_flip_flop_p(
    input d,
    input clk,
    input reset_p,
    output reg q
    );
    
    always@(posedge clk or posedge reset_p)begin
        if(reset_p) q = 0;
        else q=d;
    end
    
endmodule

module D_flip_flop_n(
    input d,
    input clk, rst_p,
    output reg q
    );
    
    always@(negedge clk or posedge rst_p)begin
        if(rst_p) q=0;        
        else q=d;
    end
    
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module shift_register_SISO_s(
    input d, clk, rst_p,
    output q
);

    wire [2:0] w;
    D_flip_flop_n dff1(d, clk,rst_p, w[2]);
    D_flip_flop_n dff2(w[2], clk, rst_p,w[1]);
    D_flip_flop_n dff3(w[1], clk, rst_p,w[0]);
    D_flip_flop_n dff4(w[0], clk, rst_p,q);

endmodule

module shift_register_SISO(
    input d, clk, rst_p,
    output reg q
);

    reg [3:0] r;
    always@(negedge clk or posedge rst_p) begin
        if(rst_p) r[3:0] <= 4'b0;
        else begin
            r[3]<= q;
            r[2] <= r[3];
            r[1] <= r[2];
            r[0] <= r[1];
            q <= r[0];
        end
    end

endmodule

module shift_register_PISO(
    input [3:0]d,
    input clk, rst_p, shift_load,
    output q
);

    reg [3:0] data;
    always@(negedge clk or posedge rst_p) begin
        if(rst_p) data[3:0] <= 4'b0;
        else if (shift_load) data <= {1'b0, data [3:1]};
        else data <= d;
    end
    assign q = data[0];

endmodule

module shift_register_SIPO_s (
    input d, clk, rst_p, rd_en,
    output [3:0] q
);
    wire [3:0] shift_register;
    D_flip_flop_n dff1(d, clk,rst_p,shift_register[3]);
    D_flip_flop_n dff2(shift_register[3], clk, rst_p,shift_register[2]);
    D_flip_flop_n dff3(shift_register[2], clk, rst_p,shift_register[1]);
    D_flip_flop_n dff4(shift_register[1], clk, rst_p,shift_register[0]);
    
    bufif1 (q[0], shift_register[0], rd_en);
    bufif1 (q[1], shift_register[1], rd_en);
    bufif1 (q[2], shift_register[2], rd_en);
    bufif1 (q[3], shift_register[3], rd_en);

endmodule

module shift_register_SIPO (
    input d, clk, rst_p, rd_en,
    output [3:0] q
);
    reg [3:0] shift_register;
    always@(negedge clk or posedge rst_p) begin
        if(rst_p) shift_register <= 0;
        else shift_register <= {d,shift_register[3:1]};
    end
    assign q = (rd_en) ? shift_register : 4'bz;
endmodule

module shift_register(
    input clk, rst_p, shift, load, sin,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    
    always@(posedge clk or posedge rst_p) begin
        if(rst_p) data_out <= 0;
        else if(shift) data_out <= {sin, data_out[7:1]};
        else if(load) data_out <= data_in;
        else data_out <= data_out;
    end

endmodule

module register_Nbit_p #(parameter N = 8)(
    input [N-1:0] d,
    input clk, reset_p, wr_en, rd_en,
    output [N-1:0] register_data,
    output [N-1:0] q
);

reg[N-1:0] register;

always@(posedge clk or posedge reset_p) begin
    if(reset_p) register = 0;
    else if (wr_en) register = d;
    else register = register;
end

assign q = (rd_en)?register:'bz;
assign register_data = register;

endmodule


module sram_8bit_1024(
    input clk, wr_en, rd_en,
    input [9:0] addr,
    inout [7:0] data
);

    reg [7:0] mem [0:1023];
    
    always @(posedge clk) if(wr_en) mem[addr] <= data;
    assign data = rd_en ? mem[addr] : 8'bz;

endmodule