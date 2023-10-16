`timescale 1ns / 1ps

module program_addr_counter(
    input clk, reset_p,
    input pc_inc, load_pc, pc_rd_en,
    input [7:0] pc_in,
    output [7:0] pc_out
    );
    
    wire [7:0] sum, next_addr, cur_addr;
    half_adder_N_bit #(.N(8)) ha8bit(
        .inc(pc_inc), .load_data(cur_addr), .sum(sum));
        
    assign next_addr = load_pc ? pc_in : sum;
    
    register_Nbit_p #(.N(8)) pc_reg(
        .d(next_addr), .clk(clk), .reset_p(reset_p), .wr_en(1'b1), 
        .rd_en(pc_rd_en), .register_data(cur_addr),
        .q(pc_out)
    );
endmodule
