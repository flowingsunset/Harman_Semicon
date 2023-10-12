//특정 비트를 0/1로 바꾸기
//0으로 만들기 위해선 특정 비트만 0, 나머지를 1로 만든 비트열을 &연산
//1으로 만들기 위해선 특정 비트만 1, 나머지를 0으로 만든 비트열을 |연산

//특정 비트를 뒤집기 위해선 특정비트 자리만 1, 나머지는 0으로 한 뒤 ^연산

module full_adder_dataflow(
	input A, B, C_i,
	output S, C_o
	);
	
	assign S = A^B^C_i;
	assign C_o = (C_i&(A^B))|(A&B);
endmodule

module full_add_sub_4bit_structural(
	input [3:0] A, B,
	input s,
	output [3:0] S,
	output C_o
	);
	
	wire [2:0]C;
	wire [3:0] B_xor;
	assign B_xor[3:0] = B[3:0]^{4{s}};
	
	full_adder_dataflow fa0(A[0], B_xor[0], s, S[0], C[0]);
	full_adder_dataflow fa1(A[1], B_xor[1], C[0], S[1], C[1]);
	full_adder_dataflow fa2(A[2], B_xor[2], C[1], S[2], C[2]);
	full_adder_dataflow fa3(A[3], B_xor[3], C[2], S[3], C_o);
	
endmodule

`timescale 1ns / 1ps
module tb_full_add_sub_4bit_structural();

reg [3:0] A, B;
reg s;
wire [3:0] S;
wire C_o;

full_add_sub_4bit_structural dut(A[3:0], B[3:0], s, S[3:0], C_o);

initial begin
// 양수와 음수를 따로 계산함
//    A = 4'b1111; B= 4'b0001; s = 1'b0; #10
//    for({A,B} = 0; {A,B}<8'b1111_1111;{A,B}={A,B}+1)begin
//        #10;
//        if((A+B)!=={C_o, S}) $display("error %d + %d = %d but %d", A, B, A+B, {C_o, S});
//    end
//    A = 4'b1111; B= 4'b1111; s = 1'b0; #10
    
//    A = 4'b1111; B= 4'b0001; s = 1'b1; #10
//    for({A,B} = 0; {A,B}<8'b1111_1111;{A,B}={A,B}+1)begin
//        #10;
//        if((A+B)!=={C_o, S}) $display("error %d + %d = %d but %d", A, B, A+B, {C_o, S});
//    end
//    A = 4'b1111; B= 4'b1111; s = 1'b1; #10

// 양수와 음수를 한번에 계산
    for({s,A,B} = 0; {s,A,B}<9'b1_1111_1111;{s,A,B}={s,A,B}+1)begin
        #10;
        if(!s&&(A+B)!=={C_o, S}) $display("error %d + %d = %d but %d", A, B, A+B, {C_o, S});
        else if (s&&(A-B)!==S) $display("error %d + %d = %d but %d", A, B, A-B, S); // 빼기에서는 캐리를 고려하지 않아도 됨, 캐리가 발생했다면 A가 B보다 크거나 같다.(0인데 캐리가 발생했다면 0이 맞다)
                                                                                    // 0-(-8)이 -8인 이유는 
    end
    A = 4'b1111; B= 4'b1111; s = 1'b1; #10
    $stop;

end

endmodule
