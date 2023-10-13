`timescale 1ns / 1ps

module tb_acc();


    reg clk, reset_p, acc_high_reset_p;
    reg fill_value, rd_en, acc_in_select;
    reg [1:0] acc_high_select, acc_low_select;
    reg [3:0] bus_data, alu_data;

    wire [3:0] acc_high_data2bus, acc_high_register_data;
    wire [3:0] acc_low_data2bus, acc_low_register_data;


    acc DUT(clk, reset_p, acc_high_reset_p,fill_value, rd_en, acc_in_select, acc_high_select, acc_low_select,
            bus_data, alu_data, acc_high_data2bus, acc_high_register_data, acc_low_data2bus, acc_low_register_data);

    initial begin
        clk = 0; reset_p = 1; acc_high_reset_p = 0;     //reset system
        fill_value = 0; rd_en = 1; acc_in_select = 0;   //data2bus == register_data, acc_high_data == alu_data
        acc_high_select = 0; acc_low_select = 0; //hold current data
        bus_data = 4'b0101; alu_data = 4'b0010; // data from bus & alu
    end

    always #5 clk = ~clk;

    initial begin
        #10;
        reset_p = 0; #10;               //end reset
        acc_high_select = 2'b11; #10;   //load high 4-bit data from alu_data
        acc_high_select = 2'b00; #10;   //hold data

        acc_in_select = 1;              //connect acc_high_data from alu data to bus_data
        acc_high_select = 2'b11; #10;   //load high 4-bit data from bus_data
        acc_high_select = 2'b00; #10;   //hold data

        acc_low_select = 2'b11; #10;    //load low 4-bit data from acc_high_register_data
        acc_low_select = 2'b00; #10;    //hold data

        //shift right 1 bit
        acc_high_select = 2'b01;
        acc_low_select = 2'b01; #10;
        acc_high_select = 2'b00;
        acc_low_select = 2'b00; #10;

        //shift left 1 bit
        acc_high_select = 2'b10;
        acc_low_select = 2'b10; #10;
        acc_high_select = 2'b00;
        acc_low_select = 2'b00; #10;

        //shift left 1 bit
        acc_high_select = 2'b10;
        acc_low_select = 2'b10; #10;
        acc_high_select = 2'b00;
        acc_low_select = 2'b00; #10;

        //clear high 4-bit
        acc_high_reset_p = 1; #10;
        acc_high_reset_p = 0; #10;

        $stop;
    end

endmodule
