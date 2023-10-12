`timescale 1ns / 1ps
module tb_UltraSonic();
reg clk, reset_p, echo;

wire trigger;
wire [8:0] dis_time;
wire [3:0] led;

UltraSonic dut(clk,reset_p,echo,trigger,dis_time,led);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset_p = 1;
    echo = 0;
    
    #10 reset_p = 0;
    wait(trigger);
    wait(!trigger);

    #200_000;

    echo = 1;
    #2_900_000 echo = 0;
    #1_000 $stop;

end

endmodule
