`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 14:10:32
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input clk, reset_p,
    input op_add, op_sub, op_mul, op_div, op_and,   //from control block
    input alu_lsb,      
    input [3:0] acc_high_data, //from ACC
    input [3:0] bus_reg_data,   //from BREG
    output [3:0] alu_out,   //to ACC
    output zero_flag, sign_flag, carry_flag, cout   //status flag
    );

    //Arithmetic
    wire [3:0] sum;
    full_add_sub_4bit faad(.A(acc_high_data), .B(bus_reg_data), .s(op_sub||op_div),  //add: s = 0, sub: s = 1
                           .S(sum), .C_o(cout));

    //Logic and Output
    assign alu_out = (op_and) ? acc_high_data & bus_reg_data : sum;

    //zero flag
    wire zero_sum = ~(|sum);
    register_Nbit_p #(.N(1)) zero_F(.d(zero_sum), .clk(clk), .reset_p(reset_p), .wr_en(op_sub), .rd_en(1'b1), .q(zero_flag));

    //sign flag
    register_Nbit_p #(.N(1)) sign_f(.d(~cout), .clk(clk), .reset_p(reset_p), .wr_en(op_sub), .rd_en(1'b1), .q(sign_flag));

    //carry flag
    register_Nbit_p #(.N(1)) carry_f(.d(cout&(op_add|(op_mul&alu_lsb)|op_div)), .clk(clk), .reset_p(reset_p), .wr_en(1'b1), .rd_en(1'b1), .q(carry_flag));
endmodule

module half_acc (
    input clk, reset_p,
    input load_msb, load_lsb,   //between acc
    input rd_en,    //from control block
    input [1:0]s,   //from control block
    input [3:0] data_in,    //upper 4-bit : from ALU, lower 4-bit : from bus
    output [3:0] data2bus, register_data
);
    reg [3:0] d;
    always @(*) begin
        case (s)
            2'b00: d = register_data;
            2'b01: d = {load_msb, register_data[3:1]};
            2'b10: d = {register_data[2:0], load_lsb};
            2'b11: d = data_in;
        endcase
    end

    register_Nbit_p #(.N(4)) h_acc(.d(d), .clk(clk), .reset_p(reset_p), .wr_en(1'b1), .rd_en(rd_en),
                      .register_data(register_data), .q(data2bus));
endmodule

module acc (
    input clk, reset_p, acc_high_reset_p,
    input fill_value, rd_en, acc_in_select,
    input [1:0] acc_high_select, acc_low_select,
    input [3:0] bus_data, alu_data,
    output [3:0] acc_high_data2bus, acc_high_register_data,
    output [3:0] acc_low_data2bus, acc_low_register_data
);

    wire [3:0] acc_high_data;
    assign acc_high_data = acc_in_select ? bus_data : alu_data;

    half_acc acc_high(
    .clk(clk), .reset_p(reset_p | acc_high_reset_p),
    .load_msb(fill_value), .load_lsb(acc_low_register_data[3]),   //between acc
    .rd_en(rd_en),    //from control block
    .s(acc_high_select),   //from control block
    .data_in(acc_high_data),    //upper 4-bit : from ALU or bus
    .data2bus(acc_high_data2bus), .register_data(acc_high_register_data)
    );

    half_acc acc_low(
    .clk(clk), .reset_p(reset_p),
    .load_msb(acc_high_register_data[0]), .load_lsb(fill_value),   //between acc
    .rd_en(rd_en),    //from control block
    .s(acc_low_select),   //from control block
    .data_in(acc_high_register_data),    //lower 4-bit : from upper 4-bit acc
    .data2bus(acc_low_data2bus), .register_data(acc_low_register_data)
    );

endmodule


module block_alu_acc (
    input clk, reset_p, acc_high_reset_p,
    input rd_en, acc_in_select,
    input [3:0] bus_data, 
    input [1:0] acc_high_select, acc_low_select,
    output [7:0] acc_data,

    input op_add, op_sub, op_mul, op_div, op_and,
    input [3:0] bus_reg_data,
    output sign_flag, zero_flag
    );

    wire [1:0] acc_high_select, acc_low_select;
    wire [3:0] alu_data;
    wire [3:0] acc_high_data2bus, acc_high_register_data;
    wire [3:0] acc_low_data2bus, acc_low_register_data;
    wire carry_flag, cout;
    wire [1:0] acc_high_select_mul_div;

    assign acc_high_select_mul_div[0] = (op_mul || op_div) ? (op_mul & acc_low_register_data[0]) | (op_div & cout): acc_high_select[0];
    assign acc_high_select_mul_div[1] = (op_mul || op_div) ? (op_mul & acc_low_register_data[0]) | (op_div & cout): acc_high_select[1];

    acc U_acc(.clk(clk), .reset_p(reset_p), .acc_high_reset_p(acc_high_reset_p),
              .fill_value(carry_flag), .rd_en(rd_en), .acc_in_select(acc_in_select),
              .acc_high_select(acc_high_select_mul_div), .acc_low_select(acc_low_select),
              .bus_data(bus_data), .alu_data(alu_data),
              .acc_high_data2bus(acc_high_data2bus), .acc_high_register_data(acc_high_register_data),
              .acc_low_data2bus(acc_low_data2bus), .acc_low_register_data(acc_low_register_data)
              );

    assign acc_data = {acc_high_data2bus, acc_low_data2bus};
    
    alu U_alu(
    .clk(clk), .reset_p(reset_p),
    .op_add(op_add), .op_sub(op_sub), .op_mul(op_mul), .op_div(op_div), .op_and(op_and),   //from control block
    .alu_lsb(acc_high_register_data[0]),      
    .acc_high_data(acc_high_register_data), //from ACC
    .bus_reg_data(bus_reg_data),   //from BREG
    .alu_out(alu_data),   //to ACC
    .zero_flag(zero_flag), .sign_flag(sign_flag), .carry_flag(carry_flag), .cout(cout)   //status flag
    );

endmodule