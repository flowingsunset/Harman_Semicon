module Project_cook_timer(
    input clk, reset_p,
    input [4:0] btn,
    output buzzer,
    output [3:0] com,
    output [7:0] seg_7, led_bar
    );
    
    wire start, incsec, incmin, start_stop;
    wire timeout, alarm_start, alarm_off;
    
    wire t_start_stop;
    assign t_start_stop = start ? 1 : (alarm_start ? 1 : 0);
    
    button_cntr btntr_start(.clk(clk), .reset_p(reset_p), .btn(btn[4]), .btn_pe(start));
    T_flip_flop_p tff_start(.clk(clk), .t(t_start_stop), .reset_p(reset_p), .q(start_stop));
    
    button_cntr btntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_pe(incsec));
    button_cntr btntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_pe(incmin));
    
    wire [3:0] sec1_set, sec10_set;
    counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(incsec), .dec1(sec1_set), .dec10(sec10_set));
    
    wire [3:0] min1_set, min10_set;
    counter_dec_100 up_min(.clk(clk), .reset_p(reset_p), .clk_time(incmin), .dec1(min1_set), .dec10(min10_set));
    
    reg [15:0] set_time;
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) set_time = 0;
        else set_time = {min10_set, min1_set, sec10_set, sec1_set};
    end
    
    wire clk_usec, clk_msec, clk_sec, clk_min;
    
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    clock_div_1000 msec_clk(.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    clock_div_1000 sec_clk(.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));
    
    wire clk_start, load_enable, dec_clk;
    wire [3:0] sec1, sec10, min1, min10;
    assign clk_start = start_stop ? clk_sec : 0;
    assign load_enable = ~start_stop ? start : 0;
    
    loadable_down_counter_dec_60 dc_sec(.clk(clk), .reset_p(reset_p),.clk_time(clk_start),
                                        .load_enable(load_enable), .set_value1(sec1_set), .set_value10(sec10_set),
                                        .dec1(sec1), .dec10(sec10), .dec_clk(dec_clk));
    loaderble_down_counter_dec_100 dc_min(.clk(clk), .reset_p(reset_p),.clk_time(dec_clk),
                                        .load_enable(load_enable), .set_value1(min1_set), .set_value10(min10_set),
                                        .dec1(min1), .dec10(min10));                                        
    
    reg [15:0] count_time;
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) count_time = 0;
        else count_time = {min10, min1, sec10, sec1};
    end
    
    assign timeout = |count_time;
    edge_detector_n ed_timeout(.clk(clk), .cp_in(timeout), .reset_p(reset_p), .n_edge(alarm_start));
    
    wire alarm;
    assign alarm_off = |{btn, reset_p};
    T_flip_flop_p tff_on_off(.clk(clk), .t(alarm_start), .reset_p(alarm_off), .q(alarm));
    assign led_bar[0] = alarm;
    assign buzzer = alarm;
    
    wire [15:0] value;
    assign value = start_stop ? count_time : set_time;    
    
    FND_4digit_ctrl fnd_cntr(.clk(clk), .value(value), .com(com), .seg_7(seg_7[7:1]));
    
endmodule

module loaderble_down_counter_dec_100(
    input clk, reset_p,
    input clk_time, load_enable,
    input [3:0] set_value1, set_value10,
    output reg [3:0]dec1, dec10,
    output reg dec_clk
    );

    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
            dec1 = 0;
            dec10 = 0;
            dec_clk = 0;
        end
        else if (load_enable)begin
            dec1 = set_value1;
            dec10 = set_value10;
        end
        else if(clk_time)begin
            if(dec1 == 0)begin
                dec1 = 9;
                if(dec10 == 0)begin
                    dec10 = 9;
                    dec_clk = 1;
                end
                else dec10 = dec10 - 1;
            end
            else dec1 = dec1 - 1;
        end
        else dec_clk = 0;
    end

endmodule
