`timescale 1ns/1ps


module mux_8_1(
	input [7:0] d,
	input [2:0]s,
	output f
	);
	
	assign f = d[s];

	
endmodule

module demux_1_4(
	input d,
	input[1:0] s,
	output [3:0] f
	);

	// always@* begin
		// f=0;
		// f[s] = d;
	// end
	
	assign f = (s == 2'b00) ? {3'b000, d} :// 비트수가 맞지 않을 때 상위 비트들이 Z 또는 X가 된다.
			   (s == 2'b01) ? {2'b00, d, 1'b0} :
			   (s == 2'b10) ? {1'b0, d, 2'b00} : {d, 3'b000};
endmodule

module mux_test_top(
    input [7:0] d,
    input [2:0] s_mux,
    input [1:0] s_demux,
    output [3:0] f
);

    wire w;
    
    mux_8_1 mux (d, s_mux, w);
    demux_1_4 demux(w, s_demux, f);

endmodule


`timescale 1ns / 1ps

module tb_mux();

    reg [7:0] d;
    reg [2:0] s_mux;
    reg [1:0] s_demux;
    wire [3:0] f;
    
	reg clk_100Mhz, clk_50Mhz, clk_25Mhz, clk_12500Khz, clk_6250Khz, clk_3125Khz, clk_1562Khz, clk_781Khz;
	
    mux_test_top test({clk_100Mhz, clk_50Mhz, clk_25Mhz, clk_12500Khz, clk_6250Khz, clk_3125Khz, clk_1562Khz, clk_781Khz}, s_mux, s_demux, f);
    
	always #5 clk_100Mhz =~clk_100Mhz;
	always #10 clk_50Mhz =~clk_50Mhz;
	always #20 clk_25MhzMhz =~clk_25MhzMhz5Mhz;
	always #40 clk_12500Khz =~clk_12500Khz;
	always #80 clk_6250Khz =~clk_6250Khz;
	always #160 clk_3125Khz =~clk_3125Khz;
	always #320 clk_1562Khz =~clk_1562Khz;
	always #640 clk_781Khz =~clk_781Khz;
	
    initial begin
    clk_100Mhz =0;
	clk_50Mhz =0;
	clk_25Mhz = 0;
	clk_12500Khz =0;
	clk_6250Khz =0;
	clk_3125Khz =0;
	clk_1562Khz =0;
	clk_781Khz =0;
    end
	
	initial begin
		#10_000;
		s_mux = 3'b011;
		s_demux = 2'b01;
		#10_000;
		s_mux = 3'b100;
		s_demux = 2'b11;
		#10_000;
		$stop;
		
	end
    
endmodule


module bin_to_dec(
	input [11:0] bin,
	output reg [15:0] bcd
	);
	
	reg [3:0] i;
	
	always@(bin) begin
		bcd = 0;
		for(i=0;i<12;i=i+1)begin
			bcd = {bcd[14:0], bin[11-i]};
			if(i<11&&bcd[3:0]>4) bcd[3:0] = bcd[3:0] + 3;	
			if(i<11&&bcd[7:4]>4) bcd[7:4] = bcd[7:4] + 3;
			if(i<11&&bcd[11:8]>4) bcd[11:8] = bcd[11:8] + 3;
			if(i<11&&bcd[15:12]>4) bcd[15:12] = bcd[15:12] + 3; //10은 1010이며 이는 상위 3비트가 5, 10 이상은 항상 상위 3비트가 5 이상
																//10~16은 6을 더했을 때 4자리씩 끊으면 그대로 10진수로 표현이 가능함 (ex/ 13+6 = 19 = 5'h13)
																//좌측 쉬프트는 수를 2배 하는 효과가 있으므로 미리 5이상인 수에 3을 더하면
																//10이상인 수에 6을 더하는 것과 같은 효과
		end
	end
	
endmodule

`timescale 1ns/1ps

module tb_bin_to_dec();
reg [11:0] bin = 0;
wire [15:0] bcd;

bin_to_dec dut (bin, bcd);
integer j;
initial begin
    for(j=0;j<12'hfff;j=j+1)begin
        #100 bin = bin+1;
    end
    $stop;
    
end

endmodule

`timescale 1ns/1ps

module SR_latch(
    input R, S,
    output Q, Qbar
    );

nor(Q, R, Qbar);
nor(Qbar, S, Q);

endmodule

module SR_latch_en(
    input R, S,en,
    output Q, Qbar
    );

wire w_r, w_s;

and(w_r, R, en);
and(w_s, S, en);

nor(Q, w_r, Qbar);
nor(Qbar, w_s, Q);

endmodule

module D_flip_flop_n(
    input d,
    input clk,
    output reg q
    );
    
    always@(negedge clk)begin
        q=d;
    end
    
endmodule

module D_flip_flop_p(
    input d,
    input clk,
    output reg q
    );
    
    always@(posedge clk)begin
        q=d;
    end
    
endmodule

module T_flip_flop(
    input clk,
    output reg q
    );
    
    wire d;
    assign d = ~q;
    
    always @(negedge clk) begin
        q=d;
    end
    
endmodule
