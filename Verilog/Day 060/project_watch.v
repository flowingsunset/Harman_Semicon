module project_watch(
    input wire clk,
    input wire reset_p,
    input wire [2:0] btn,
    output wire [3:0] an,
    output wire [6:0] seg,
    output reg [15:9]led
    );
    
    //wire declaration for connection between modules
    wire  w_set_pe, w_set, w_inc_min, w_inc_hr;
    wire w_clk_usec, w_clk_msec, w_clk_sec, w_clk_min, w_clk_hr;
    wire w_sel_min;
    wire [3:0] w_min1_now, w_min10_now, w_hr1_now, w_hr10_now;
    wire [3:0] w_min1_set, w_min10_set, w_hr1_set, w_hr10_set;
    wire [15:0] w_value;

    //at clock setting mode, minute input replaced by button
    assign w_sel_min = w_set? w_inc_min : w_clk_min;

    //btn0 for select mode(setting or normal)
    button_cntr bcntr_set(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(w_set_pe), .btn_ne());
    T_flip_flop_p tff1(.clk(clk), .t(w_set_pe), .reset_p(reset_p), .q(w_set));

    //button 1,2 for increase hour and minute at setting mode
    button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_pe(w_inc_min), .btn_ne());
    button_cntr bcntr_inchr(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_pe(w_inc_hr), .btn_ne());

    //clock divider
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(w_clk_usec));
    clock_div_1000 msec_clk(.clk(clk), .clk_source(w_clk_usec), .reset_p(reset_p), .clk_div_1000(w_clk_msec));
    clock_div_1000 sec_clk(.clk(clk), .clk_source(w_clk_msec), .reset_p(reset_p), .clk_div_1000(w_clk_sec));
    clock_min   min_clk(.clk(clk), .clk_sec(w_clk_sec), .reset_p(reset_p), .clk_min(w_clk_min));
    
    //hour clock divider get different clk_source at setting mode
    clock_min   hr_clk(.clk(clk), .clk_sec(w_sel_min), .reset_p(reset_p), .clk_min(w_clk_hr));

    //second indicater
    reg [5:0] r_cnt;
    always @(posedge clk, posedge reset_p) begin
        if(reset_p) begin
            led <= 0;
            r_cnt <= 0;
        end
        else if(w_clk_sec)begin
            led[10] <= ~ led[10];
            if(r_cnt >= 59) begin
                r_cnt <= 0;
                led[15:11] <= 0;
            end
            else r_cnt <= r_cnt + 1;
        end
        else begin
            if(r_cnt>9)led[10+(r_cnt/10)] <= 1;
            if(w_set) led[9] <= 1;
            else led[9] <= 0;
        end
    end


    //FND output selection 
    assign w_value = w_set ? {w_hr10_set, w_hr1_set, w_min10_set, w_min1_set} : {w_hr10_now, w_hr1_now, w_min10_now, w_min1_now};

    //time counter
    loadable_up_counter_dec_60 uc_min_now(
    .clk(clk), .reset_p(reset_p), .clk_time(w_clk_min),
    .load_enable(w_set_pe), .set_value1(w_min1_set), .set_value10(w_min10_set), .dec1(w_min1_now), .dec10(w_min10_now));
    loadable_up_counter_dec_24 uc_hr_now(
    .clk(clk), .reset_p(reset_p), .clk_time(w_clk_hr),
    .load_enable(w_set_pe), .set_value1(w_hr1_set), .set_value10(w_hr10_set), .dec1(w_hr1_now), .dec10(w_hr10_now), .dec_clk()
    );

    //set counter
    loadable_up_counter_dec_60 uc_min_set(
    .clk(clk), .reset_p(reset_p), .clk_time(w_inc_min),
    .load_enable(w_set_pe), .set_value1(w_min1_now), .set_value10(w_min10_now), .dec1(w_min1_set), .dec10(w_min10_set));
    loadable_up_counter_dec_24 uc_hr_set(
    .clk(clk), .reset_p(reset_p), .clk_time(w_inc_hr),
    .load_enable(w_set_pe), .set_value1(w_hr1_now), .set_value10(w_hr10_now), .dec1(w_hr1_set), .dec10(w_hr10_set), .dec_clk()
    );

    //FND output
    FND_4digit_ctrl fnd_cntr( .clk(clk), .reset_p(reset_p),.value(w_value), .com(an), .seg_7(seg));
endmodule
