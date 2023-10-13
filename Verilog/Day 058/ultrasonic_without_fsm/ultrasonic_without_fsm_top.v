module ultrasonic_without_fsm_top(
    input wire clk,
    input wire reset_p,
    input wire echo,
    output wire trigger,
    output wire [3:0]led,
    output wire [3:0] an,
    output wire [6:0] seg
    );

    wire [15:0] w_distance_cm, w_value;
    ultrasonic_without_fsm sr04(.clk(clk), .reset_p(reset_p),.echo(echo),.trig(trigger),.distance_cm(w_distance_cm),.led(led));
    bin_to_dec btd_dis(.bin( w_distance_cm[11:0]),.bcd(w_value));
    FND_4digit_ctrl fnd_cntr( .clk(clk), .rst_p(reset_p),.value(w_value), .com(an), .seg_7(seg));
endmodule
