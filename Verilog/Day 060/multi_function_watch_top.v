module multi_function_watch_top(
    input wire clk,
    input wire reset_p,
    input wire [4:0] btn,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire [15:6]led,
    output wire buzzer
    );

    //mode selection register
    reg [2:0] r_mode;

    //wire declaration for connection between modules and input/output
    wire [4:0] w_btn_watch, w_btn_stop, w_btn_cook;
    wire [3:0] w_an_watch, w_an_stop, w_an_cook;
    wire [7:0] w_seg_watch, w_seg_stop, w_seg_cook;
    wire [15:9] w_led_watch;
    
    //output buzzer
    wire w_buzzer;

    //posetive edge of mode selection signal
    wire w_mode_pe;

    //reset wire for stopwatch
    wire w_reset_stopwatch;
    assign w_reset_stopwatch = (r_mode == 3'b010) ? reset_p||btn[2] : reset_p;
    
    //mode change
    always @(posedge clk, posedge reset_p) begin
        if(reset_p) r_mode <= 3'b001;
        else if(w_mode_pe) r_mode <= {r_mode[1:0], r_mode[2]};
    end

    //assignment between input button and module
    assign w_btn_watch[2:0] = (r_mode == 3'b001) ?  btn[3:1] : 0;
    assign {w_btn_stop[1],w_btn_stop[3], w_btn_stop[2]} = (r_mode == 3'b010) ? {btn[4], btn[2:1]} : 0;
    assign w_btn_cook[4:0] = (r_mode == 3'b100) ? btn[4:0] : 0;

    //assignment between output com,seg and module
    assign an = (r_mode == 3'b001) ? w_an_watch :
                (r_mode == 3'b010) ? w_an_stop : 
                (r_mode == 3'b100) ? w_an_cook : 0;
    assign seg =(r_mode == 3'b001) ? w_seg_watch[7:1] :
                (r_mode == 3'b010) ? w_seg_stop[7:1] : 
                (r_mode == 3'b100) ? w_seg_cook[7:1] : 0;

    //assignment between led and module
    assign led[15:9] =   (r_mode == 3'b001) ? w_led_watch : 0;
    
    //mode notification
    assign led[8:6] = r_mode;
    
    //mode change edge detection
    button_cntr bcntr_set(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(w_mode_pe), .btn_ne());
    
    //watch
    project_watch watch(
    .clk(clk),
    .reset_p(reset_p),
    .btn(w_btn_watch[2:0]),
    .an(w_an_watch),
    .seg(w_seg_watch[7:1]),
    .led(w_led_watch)
    );

    //stop watch
    stop_watch_ms_counter100_top_teach stop_watch(
    .clk(clk),
    .reset_p(w_reset_stopwatch),
    .btn(w_btn_stop),
    .com(w_an_stop),
    .seg_7(w_seg_stop)
    );
    
    //cook timer
    Project_cook_timer cook_timer(
    .clk(clk),
    .reset_p(reset_p),
    .btn(w_btn_cook),
    .buzzer(buzzer),
    .com(w_an_cook),
    .seg_7(w_seg_cook), 
    .led_bar()
    );
endmodule
