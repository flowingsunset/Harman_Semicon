module stop_watch_ms_counter100_top_teach(
    input wire clk,
    input wire reset_p,
    input wire [4:0] btn, 
    output wire [3:0] com,
    output wire [7:0] seg_7
    );
    
    reg [16:0] clk_div;
    wire btn_start, start_stop;
    wire [3:0] debounced_btn;
    
    always @(posedge clk) clk_div = clk_div + 1;

    D_flip_flop_p dff0 (.d(btn[1]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[1]));

    edge_detector_n ed_start(
        .clk(clk), .cp_in(debounced_btn[1]),
        .reset_p(reset_p), .p_edge(btn_start));
    T_flip_flop_p (
        .clk(clk), .t(btn_start),
        .reset_p(reset_p), .q(start_stop)
    );
    

    wire lap, btn_lap;
    D_flip_flop_p dff1 (.d(btn[2]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[2]));
    edge_detector_n ed_lap(
        .clk(clk), .cp_in(debounced_btn[2]),
        .reset_p(reset_p), .p_edge(btn_lap));
    T_flip_flop_p (
        .clk(clk), .t(btn_lap),
        .reset_p(reset_p), .q(lap)
    );

    wire clk_usec, clk_msec, clk_sec, clk_min;
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
        
    wire clk_start;
    assign clk_start = start_stop ? clk_usec : 0;


    clock_div_1000 msec_clk(
        .clk(clk), .clk_source(clk_start) , 
        .reset_p(reset_p), .clk_div_1000(clk_msec));

        
    clock_div_1000 sec_clk(
        .clk(clk), .clk_source(clk_msec), 
        .reset_p(reset_p), .clk_div_1000(clk_sec));
       
    wire clk_10msec;    
    clock_div_10 msec10_clk(
        .clk(clk), .reset_p(reset_p), .clk_source(clk_msec), 
        .clk_div_10(clk_10msec)
    );    
  
    wire [3:0] csec1, csec10;
    counter_dec_100 csec(
        .clk(clk), .reset_p(reset_p),
        .clk_time(clk_10msec),
        .dec1(csec1), .dec10(csec10));

    wire [3:0] sec1, sec10;
    counter_dec_60 counter_sec(
        .clk(clk), .reset_p(reset_p),
        .clk_time(clk_sec), .dec1(sec1), .dec10(sec10));
        
    reg [15:0] cur_time;
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) cur_time = 0;
        else cur_time = {sec10, sec1, csec10, csec1};
    end
        
    reg [15:0] lap_value;
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) lap_value = 0;
        else if(btn_lap) lap_value = cur_time;
    end

// lap_value 異쒕젰    
    wire [15:0] value;
    assign value = lap ? lap_value : cur_time;

// FND 異쒕젰        
    FND_4digit_ctrl fnd_cntr (.clk(clk), .reset_p(reset_p), .value(value),
     .com(com), .seg_7(seg_7[7:1]));
        
endmodule

module counter_dec_100(
    input clk, reset_p,
    input clk_time,
    output reg [3:0]dec1, dec10
    );

    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
            dec1 = 0;
            dec10 = 0;
        end
        else if(clk_time)begin
            if(dec1 >= 9)begin
                dec1 = 0;
                if(dec10 >= 9) dec10 = 0;
                else dec10 = dec10 + 1;
            end
            else dec1 = dec1 + 1;
        end
    end

endmodule

module clock_div_10(
    input clk, reset_p, clk_source, 
    output clk_div_10
    );
    
    reg [2:0] cnt_clk_source;
    reg cp_div_10;
    
    always @(posedge clk or posedge reset_p)begin
        if(reset_p)cnt_clk_source = 0;
        else if(clk_source)begin
            if(cnt_clk_source >= 4)begin
                cnt_clk_source = 0;
                cp_div_10 = ~cp_div_10;
            end
            else cnt_clk_source = cnt_clk_source + 1;
        end
    end
    
    edge_detector_n ed0 (.clk(clk), .cp_in(cp_div_10), .reset_p(reset_p),
        .n_edge(clk_div_10));
endmodule
