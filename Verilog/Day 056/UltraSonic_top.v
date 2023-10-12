`timescale 1ns / 1ps
module UltraSonic_top(
    input wire clk,
    input wire reset_p,
    input wire echo,
    output wire trigger,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire [3:0] led
    );
    wire [8:0] w_distime;
    wire [15:0] w_bcd_distime;
    UltraSonic(.clk(clk),.reset_p(reset_p),.echo(echo),.trigger(trigger),.dis_time(w_distime), .led(led));
    bin_to_dec btd_dis(.bin({3'b000, w_distime}),.bcd(w_bcd_distime));
    FND_4digit_ctrl fnd_cntr( .clk(clk), .rst_p(reset_p),.value(w_bcd_distime), .com(an), .seg_7(seg));
endmodule
