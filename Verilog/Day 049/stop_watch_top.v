module stop_watch_top(
    input clk,
    input rst_p,
    input  [1:0]btn,
    output [3:0] an,
    output [6:0] seg
    );
    reg[16:0] clk_div;
    wire btn_start, start_stop;
    wire btn_lap, lap;
    wire w_clk_msec;
    wire w_clk_usec;
    wire clk_msec;
    wire w_clk_sec;
    wire w_clk_min;
     wire clk_usec, clk_sec;
    wire [1:0] debounced_btn;
    
    assign w_clk_msec = start_stop ? clk_msec : 0;
    
    always@(posedge clk or posedge rst_p) begin
	   if(rst_p) clk_div = 0;
	   else clk_div = clk_div + 1;
	end
	
	D_flip_flop_p dff1(.d(btn[0]),.clk(clk_div[16]),.rst_p(rst_p),.q(debounced_btn[0]));
	edge_detector_p edn_top1(.clk(clk), .cp_in(debounced_btn[0]), .rst_p(rst_p), .p_edge(btn_start), .n_edge());
    T_flip_flop_p tff1(.clk(clk), .t(btn_start), .rst_p(rst_p), .q(start_stop));
    
    D_flip_flop_p dff2(.d(btn[1]),.clk(clk_div[16]),.rst_p(rst_p),.q(debounced_btn[1]));
	edge_detector_p edn_top2(.clk(clk), .cp_in(debounced_btn[1]), .rst_p(rst_p), .p_edge(btn_lap), .n_edge());
    T_flip_flop_p tff2(.clk(clk), .t(btn_lap), .rst_p(rst_p), .q(lap));
    
    reg [15:0]lap_value;
    wire [15:0] value;
    wire [3:0] sec1, sec10;
    wire [3:0] min1, min10;
    assign value = lap ? lap_value : {min10, min1, sec10, sec1};
    
    always@(posedge clk) begin
        if(rst_p)  lap_value <= 0;
        else if(btn_lap) lap_value <= {min10, min1, sec10, sec1};
    end
   
    clock_usec usec_clk(.clk(clk), .reset_p(rst_p), .clk_usec(w_clk_usec));
    clock_msec msec_clk(.clk(clk), .clk_usec(w_clk_usec), .reset_p(rst_p), .clk_msec(clk_msec));
    clock_sec sec_clk(.clk(clk), .clk_msec(w_clk_msec), .reset_p(rst_p), .clk_sec(w_clk_sec));
    clock_min min_clk(.clk(clk), .clk_sec(w_clk_sec), .reset_p(rst_p), .clk_min(w_clk_min));
   
    counter_dec_60 cnt_60_sec(.clk(clk), .reset_p(rst_p), .clk_time(w_clk_sec), .dec1(sec1), .dec10(sec10));
    counter_dec_60 cnt_60_min(.clk(clk), .reset_p(rst_p), .clk_time(w_clk_min), .dec1(min1), .dec10(min10));
    FND_4digit_ctrl fnd_cntr( .clk(clk), .rst_p(rst_p),.value(value), .com(an), .seg_7(seg));
    
    
endmodule
