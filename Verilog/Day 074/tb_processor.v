`timescale 1ns / 1ps
module tb_processor();

    reg clk, reset_p;
    reg [3:0] key_value;
    reg key_valid;
    
    wire [7:0] outreg_data;
    wire [3:0] kout;

    processor DUT(
        .clk(clk), .reset_p(reset_p),
        .key_value(key_value),
        .key_valid(key_valid),
        .outreg_data(outreg_data),
        .kout(kout)
    );
    
    initial begin
        clk = 0; reset_p = 1;
        key_value = 0;
        key_valid = 0;
    end
    
    always #4 clk = ~clk;
    
    initial begin
        #8;
        reset_p = 0; #8;
        key_value = 5; key_valid = 1; #10_000;
        key_value = 0; key_valid = 0; #10_000;
        key_value = 14; key_valid = 1; #10_000;
        key_value = 0; key_valid = 0; #10_000;
        key_value = 7; key_valid = 1; #10_000;
        key_value = 0; key_valid = 0; #10_000;
        key_value = 4'b1111; key_valid = 1; #10_000;
        key_value = 0; key_valid = 0; #10_000;
        $stop;
    end

endmodule






























