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

`timescale 1ns / 100ps

module tb_shift_register_PISO( );

reg [3:0] d = 0;
reg clk = 0;
reg rst_p = 0;
reg shift_load = 0;
wire q;

shift_register_PISO regi(d, clk, rst_p, shift_load, q);

initial begin
    d = 4'b1010;
    clk = 0;
    rst_p = 1;
    shift_load = 0;
end

always #4 clk = ~clk;

initial begin
    #8 rst_p = 0;
    #8 shift_load = 1;
    #32 d = 4'b1100;
    #8 shift_load = 0;
    #8 shift_load = 1;
    #32 $stop;
end

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
    input clk, rst_p, wr_en, rd_en,
    output q
);

reg[N-1:0] register;

always@(posedge clk or posedge rst_p) begin
    if(rst_p) register = 0;
    else if (wr_en) register = d;
    else register = register;
end

assign q = (rd_en)?register:'bz;

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

