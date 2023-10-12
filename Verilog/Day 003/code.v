//4비트 전가감산기를 조건연산자로 생성

`timescale 1ns/1ps
module full_add_sub_4bit(
	input [3:0] A, B,
	input s,
	output [3:0] S,
	output C_o
	);
	
	assign {C_o, S[3:0]} = s?A - B: A + B;
	
endmodule

`timescale 1ns / 1ps
module tb_full_add_sub_4bit();

reg [3:0] A, B;
reg s;
wire [3:0] S;
wire C_o;

full_add_sub_4bit dut(A[3:0], B[3:0], s, S[3:0], C_o);

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
        #20;
        if(!s&&(A+B)!=={C_o, S}) $display("error %d + %d = %d but %d", A, B, A+B, {C_o, S});
        else if (s&&(A-B)!==S) $display("error %d + %d = %d but %d", A, B, A-B, S); // 빼기에서는 캐리를 고려하지 않아도 됨, 캐리가 발생했다면 A가 B보다 크거나 같다.(0인데 캐리가 발생했다면 0이 맞다)
                                                                                          // 0-(-8)이 -8인 이유는 
    end
    A = 4'b1111; B= 4'b1111; s = 1'b1; #10
    $stop;

end

endmodule
