`timescale 1ns / 1ps


module tb_block_alu_acc();

    reg clk, reset_p, acc_high_reset_p;
    reg rd_en, acc_in_select;
    reg [3:0] bus_data;
    reg [1:0] acc_high_select, acc_low_select;
    wire [7:0] acc_data;

    reg op_add, op_sub, op_mul, op_div, op_and;
    reg [3:0] bus_reg_data;
    wire sign_flag, zero_flag;


    block_alu_acc DUT(
    clk, reset_p, acc_high_reset_p,
    rd_en, acc_in_select,
    bus_data, 
    acc_high_select, acc_low_select,
    acc_data,

    op_add, op_sub, op_mul, op_div, op_and,
    bus_reg_data,
    sign_flag, zero_flag
    );

    initial begin
        clk = 0; reset_p = 1; acc_high_reset_p = 0;
        rd_en = 1; acc_in_select = 0;
        bus_data = 4'b0111; bus_reg_data = 4'b0010;
        acc_high_select = 0; acc_low_select = 0;
        op_add = 0; op_sub = 0; op_mul = 0; op_div = 0; op_and = 0;
    end

    always #5 clk = ~clk;

    //test multiplex
     initial begin
         #10;
         reset_p = 0; #10;
         acc_in_select = 1; acc_high_select = 2'b11; #10;    //load bus_data to acc high 4-bit
         acc_in_select = 0; acc_high_select = 2'b00; acc_low_select = 2'b11; #10;    //load acc high 4-bit to acc low 4-bit
         acc_low_select = 2'b00; acc_high_reset_p = 1; #10;  //clear acc high 4-bit
         acc_high_reset_p = 1'b0; op_mul = 1; #10;    //load bus register to acc high 4-bit
         op_mul = 0; acc_low_select = 2'b01; acc_high_select = 2'b01; #10; //shift right acc 8-bit
         op_mul = 1; acc_low_select = 2'b00; #10; 
         op_mul = 0; acc_low_select = 2'b01; acc_high_select = 2'b01; #10; //shift right acc 8-bit
         op_mul = 1; acc_low_select = 2'b00; #10;
         op_mul = 0; acc_low_select = 2'b01; acc_high_select = 2'b01; #10; //shift right acc 8-bit
         op_mul = 1; acc_low_select = 2'b00; #10;
         op_mul = 0; acc_low_select = 2'b01; acc_high_select = 2'b01; #10; //shift right acc 8-bit
         acc_low_select = 2'b00; acc_high_select = 2'b00; #10;
         $stop;
     end

//    initial begin
//        #10;
//        reset_p = 0; #10;
//        acc_in_select = 1; acc_high_select = 2'b11; #10;
//        acc_in_select = 0; acc_high_select = 2'b00; acc_low_select = 2'b11; #10;
//        acc_low_select = 2'b00; acc_high_reset_p = 1; #10;
//        acc_high_reset_p = 0;
//        acc_low_select = 2'b10; acc_high_select = 2'b10; #10;
//        acc_low_select = 2'b00; op_div = 1; #10;
//        op_div = 0;
//        acc_low_select = 2'b10; acc_high_select = 2'b10; #10;
//        acc_low_select = 2'b00; op_div = 1; #10;
//        op_div = 0;
//        acc_low_select = 2'b10; acc_high_select = 2'b10; #10;
//        acc_low_select = 2'b00; op_div = 1; #10;
//        op_div = 0;
//        acc_low_select = 2'b10; acc_high_select = 2'b10; #10;
//        acc_low_select = 2'b00; op_div = 1; #10;
//        op_div = 0;
//        acc_low_select = 2'b10; acc_high_select = 2'b00; #10;
//        acc_low_select = 2'b00; #10;
//        $stop;
//    end

endmodule
