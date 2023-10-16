`timescale 1ns / 1ps
module processor(
    input clk, reset_p,
    input [3:0] key_value,
    input key_valid,
    output [7:0] outreg_data,
    output [3:0] kout
    );
    
    wire [7:0] int_bus, mar_data, rom_data, ir_data;
    wire mar_inen, mdr_inen, mdr_oen, ir_inen, pc_inc, load_pc, pc_oen;
    
    program_addr_counter pc(
        .clk(clk), .reset_p(reset_p),
        .pc_inc(pc_inc), .load_pc(load_pc), .pc_rd_en(pc_oen),
        .pc_in(int_bus),
        .pc_out(int_bus));
    
    register_Nbit_p #(.N(8)) mar (
        .d(int_bus), .clk(clk), .reset_p(reset_p), .wr_en(mar_inen), .rd_en(1'b1),
        .register_data(mar_data));
    
    register_Nbit_p #(.N(8)) mdr (
        .d(rom_data), .clk(clk), .reset_p(reset_p), .wr_en(mdr_inen), .rd_en(mdr_oen),
        .q(int_bus));
    
    register_Nbit_p #(.N(8)) ir (
        .d(int_bus), .clk(clk), .reset_p(reset_p), .wr_en(ir_inen), .rd_en(1'b1),
        .register_data(ir_data));
    
    wire [3:0] bus_reg_data;
    wire breg_inen, tmpreg_inen, tmpreg_oen, creg_inen, creg_oen; 
    wire dreg_inen, dreg_oen, rreg_inen, rreg_oen;
    
    register_Nbit_p #(.N(4)) breg (
        .d(int_bus[7:4]), .clk(clk), .reset_p(reset_p), .wr_en(breg_inen), .rd_en(1'b1),
        .register_data(bus_reg_data));
    
    register_Nbit_p #(.N(4)) tmpreg (
        .d(int_bus[7:4]), .clk(clk), .reset_p(reset_p), .wr_en(tmpreg_inen), .rd_en(tmpreg_oen),
        .q(int_bus[7:4]));
        
    register_Nbit_p #(.N(4)) creg (
        .d(int_bus[7:4]), .clk(clk), .reset_p(reset_p), .wr_en(creg_inen), .rd_en(creg_oen),
        .q(int_bus[7:4]));
        
    register_Nbit_p #(.N(4)) dreg (
        .d(int_bus[7:4]), .clk(clk), .reset_p(reset_p), .wr_en(dreg_inen), .rd_en(dreg_oen),
        .q(int_bus[7:4]));
    
    register_Nbit_p #(.N(4)) rreg (
        .d(int_bus[7:4]), .clk(clk), .reset_p(reset_p), .wr_en(rreg_inen), .rd_en(rreg_oen),
        .q(int_bus[7:4]));
    
    wire acc_high_reset_p, acc_oen, acc_in_select;
    wire [1:0] acc_high_select, acc_low_select;
    wire op_add, op_sub, op_mul, op_div, op_and;
    wire sign_flag, zero_flag;
    
    
    block_alu_acc alu_acc(
    .clk(clk), .reset_p(reset_p), .acc_high_reset_p(acc_high_reset_p),
    .rd_en(acc_oen), .acc_in_select(acc_in_select),
    .bus_data(int_bus[7:4]), .bus_reg_data(bus_reg_data),
    .acc_high_select(acc_high_select), .acc_low_select(acc_low_select),
    .op_add(op_add), .op_sub(op_sub), .op_mul(op_mul), .op_div(op_div), .op_and(op_and),
    .sign_flag(sign_flag), .zero_flag(zero_flag),
    .acc_data(int_bus));
    
    wire inreg_oen, keych_oen, keyout_inen, outreg_inen;
    
    register_Nbit_p #(.N(4)) inreg (
        .d(key_value), .clk(clk), .reset_p(reset_p), .wr_en(1'b1), .rd_en(inreg_oen),
        .q(int_bus[7:4]));
        
    register_Nbit_p #(.N(4)) keych_reg (
        .d({4{key_valid}}), .clk(clk), .reset_p(reset_p), .wr_en(1'b1), .rd_en(keych_oen),
        .q(int_bus[7:4]));
        
    register_Nbit_p #(.N(4)) keyout_reg (
        .d(int_bus[7:4]), .clk(clk), .reset_p(reset_p), .wr_en(keyout_inen), .rd_en(1'b1),
        .register_data(kout));
    
    register_Nbit_p #(.N(8)) outreg (
        .d(int_bus), .clk(clk), .reset_p(reset_p), .wr_en(outreg_inen), .rd_en(1'b1),
        .register_data(outreg_data));
        
    wire rom_en;
    //ROM
    dist_mem_gen_0 rom(.a(mar_data), .qspo_ce(rom_en), .spo(rom_data));
        
    control_block cb(
        .clk(clk), .reset_p(reset_p),
        .ir_data(ir_data),
        .zero_flag(zero_flag), .sign_flag(sign_flag),
        .mar_inen(mar_inen), .mdr_inen(mdr_inen), .mdr_oen(mdr_oen), .ir_inen(ir_inen), .pc_inc(pc_inc), .load_pc(load_pc), . pc_oen(pc_oen),
        .breg_inen(breg_inen), .tmpreg_inen(tmpreg_inen), .tmpreg_oen(tmpreg_oen), .creg_inen(creg_inen), .creg_oen(creg_oen), 
        .dreg_inen(dreg_inen), .dreg_oen(dreg_oen), .rreg_inen(rreg_inen), .rreg_oen(rreg_oen), 
        .acc_high_reset_p(acc_high_reset_p), .acc_oen(acc_oen), .acc_in_select(acc_in_select),
        .op_add(op_add), .op_sub(op_sub), .op_mul(op_mul), .op_div(op_div), .op_and(op_and),
        .inreg_oen(inreg_oen), .keych_oen(keych_oen), .keyout_inen(keyout_inen), .outreg_inen(outreg_inen), .rom_en(rom_en),
        .acc_high_select(acc_high_select), .acc_low_select(acc_low_select)
    );
    
    
endmodule





























