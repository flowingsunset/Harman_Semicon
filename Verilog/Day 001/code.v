`timescale 1ns / 1ps

module and_gate(
    input A,
    input B,
    output F
    );
	
	and(F, A, B);
endmodule

module half_adder_structural(
	input A, B,
	output S, C
	);

	xor(S, A, B);
	and(C, A, B);
	
endmodule

module half_adder_dataflow(
	input A, B,
	output S, C
	);

	assign C = A&B;
	assign S = A^B;
	
endmodule
	
module half_adder_behaviaral(
	input A, B,
	output reg S, C
	);

	always@(A,B) begin
		case({A,B})
			2'b00: begin S=0; C = 0; end
			2'b01: begin S=1; C = 0; end
			2'b10: begin S=1; C = 0; end
			2'b11: begin S=0; C = 1; end
		endcase
	end
	
endmodule

module full_adder_structural(
	input A, B, C_i,
	output S, C_o
	);
	
	wire s_0, c_0, c_1;
	
	half_adder ha0(A, B, s0, c_0);
	half_adder ha1(s0, C_i, S, c_1);
	assign C_o = c_0|c_1;
endmodule

module full_adder_dataflow(
	input A, B, C_i,
	output S, C_o
	);
	
	assign S = A^B^C_i;
	assign C_o = (C_i&(A^B))|(A&B);
endmodule

module full_adder_4bit(
	input [3:0] A, B,
	output [3:0] S,
	output C_o
	);
	
	wire [2:0]C;
	
	full_adder_dataflow fa0(A[0], B[0], 1'b0, S[0], C[0]);
	full_adder_dataflow fa1(A[1], B[1], C[0], S[1], C[1]);
	full_adder_dataflow fa2(A[2], B[2], C[1], S[2], C[2]);
	full_adder_dataflow fa3(A[3], B[3], C[2], S[3], C_o);
	
endmodule

module full_adder_4bit_dataflow(
	input [3:0] A, B,
	input 		C_i,
	output [3:0] S,
	output C_o
	);
	
	assign {C_o, S} = A+B+C_i;
endmodule
