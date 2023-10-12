module watch_top(
    input wire clk,
    input wire reset_p,
    input wire [2:0] btn,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire [1:0]led
    );
    
    wire  w_set_pe, w_set, w_inc_sec, w_inc_min;
    wire w_clk_usec, w_clk_msec, w_clk_sec, w_clk_min;
    wire w_or_sec;
    wire [3:0] w_sec1_now, w_sec10_now, w_min1_now, w_min10_now;
    wire [3:0] w_sec1_set, w_sec10_set, w_min1_set, w_min10_set;
    wire [15:0] w_value;

    assign w_or_sec = w_set? w_inc_sec : w_clk_sec;
    assign led = w_set ? 2'b11 : 2'b0;
    
    button_cntr bcntr_set(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(w_set_pe), .btn_ne());
    T_flip_flop_p tff1(.clk(clk), .t(w_set_pe), .rst_p(reset_p), .q(w_set));
    button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_pe(w_inc_sec), .btn_ne());
    button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_pe(w_inc_min), .btn_ne());

    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(w_clk_usec));
    clock_div_1000 msec_clk(.clk(clk), .clk_source(w_clk_usec), .reset_p(reset_p), .clk_div_1000(w_clk_msec));
    clock_div_1000 sec_clk(.clk(clk), .clk_source(w_clk_msec), .reset_p(reset_p), .clk_div_1000(w_clk_sec));
    clock_min   min_clk(.clk(clk), .clk_sec(w_or_sec), .reset_p(reset_p), .clk_min(w_clk_min));

    assign w_value = w_set ? {w_min10_set, w_min1_set, w_sec10_set, w_sec1_set} : {w_min10_now, w_min1_now, w_sec10_now, w_sec1_now};

    loadable_up_counter_dec_60 uc_sec_now(
    .clk(clk), .reset_p(reset_p), .clk_time(w_clk_sec),
    .load_enable(w_set_pe), .set_value1(w_sec1_set), .set_value10(w_sec10_set), .dec1(w_sec1_now), .dec10(w_sec10_now));
    loadable_up_counter_dec_60 uc_min_now(
    .clk(clk), .reset_p(reset_p), .clk_time(w_clk_min),
    .load_enable(w_set_pe), .set_value1(w_min1_set), .set_value10(w_min10_set), .dec1(w_min1_now), .dec10(w_min10_now), .dec_clk()
    );
    loadable_up_counter_dec_60 uc_sec_set(
    .clk(clk), .reset_p(reset_p), .clk_time(w_inc_sec),
    .load_enable(w_set_pe), .set_value1(w_sec1_now), .set_value10(w_sec10_now), .dec1(w_sec1_set), .dec10(w_sec10_set));
    loadable_up_counter_dec_60 uc_min_set(
    .clk(clk), .reset_p(reset_p), .clk_time(w_inc_min),
    .load_enable(w_set_pe), .set_value1(w_min1_now), .set_value10(w_min10_now), .dec1(w_min1_set), .dec10(w_min10_set), .dec_clk()
    );
    FND_4digit_ctrl fnd_cntr( .clk(clk), .rst_p(reset_p),.value(w_value), .com(an), .seg_7(seg));
endmodule
