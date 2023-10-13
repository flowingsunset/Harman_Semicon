module ultrasonic_without_fsm(

    input wire clk, reset_p,
    input wire echo,
    output reg trig,
    output reg [15:0] distance_cm,
    output reg [3:0] led
    );

    reg [16:0] r_count_usec;
    reg [16:0] r_old_usec;
    reg [20:0] r_sum_value;
    reg [16:0] r_temp_value [15:0];
    reg [3:0] r_index;
    wire w_clk_usec;
    clock_usec clk_usec(.clk(clk), .reset_p(reset_p), .clk_usec(w_clk_usec));
    always@(negedge clk or posedge reset_p) begin
        if(reset_p) begin
            r_count_usec <= 0;
            trig <= 0;
        end
        else begin
            if(w_clk_usec) begin
                if (r_count_usec < 85_000)begin
                //if (r_count_usec < 85_)begin   //for testbench
                    r_count_usec <= r_count_usec + 1;
                    if(r_count_usec <10)
                        trig <= 1;
                    else
                        trig <= 0;
                end 
                else  r_count_usec <= 0;
            end
        end
    end

    wire w_echo_pedge, w_echo_nedge;
    edge_detector_n edn1(.clk(clk),.cp_in(echo),.rst_p(reset_p),
                         .p_edge(w_echo_pedge),. n_edge(w_echo_nedge));


    always @(posedge clk or posedge reset_p) begin
        if (reset_p) begin
            r_old_usec <= 0;
            r_index <= 0;
            led <= 0;
        end else begin
            if (w_echo_pedge) begin
                r_old_usec <= r_count_usec;
                led[3:2] <= 0;
                led[1:0] <= 1;
                
            end
            else if(w_echo_nedge) begin
                r_temp_value[r_index] <= r_count_usec - r_old_usec;
                r_index <= r_index + 1;
                led[3:2] <= 1;
                led[1:0] <= 0;
            end
        end
    end

    reg [4:0] i ;
    always @(posedge w_clk_usec, posedge reset_p) begin
        if (reset_p) begin
            r_sum_value = 0;
            i = 0;
        end else begin
            r_sum_value = 0;
            for (i = 0;i<16 ;i=i+1 ) begin
                r_sum_value = r_sum_value + r_temp_value[i];
            end
        end
    end


    always @(posedge w_clk_usec, posedge reset_p) begin
        if (reset_p) distance_cm <= 0; 
        else distance_cm <= r_sum_value[20:4] / 58;
    end
endmodule
