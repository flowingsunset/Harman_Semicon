`timescale 1ns / 1ps
module ultrasonic_ref(
    input wire clk, reset_p,
    input wire echo,
    output reg trig,
    output reg [15:0] distance_cm,
    output reg [3:0] led
    );

    localparam S_IDLE = 4'b0001;
    localparam S_TRIG = 4'b0010;
    localparam S_WAIT_PEDGE = 4'b0100;
    localparam S_WAIT_NEDGE = 4'b1000;

    reg [16:0] r_count_usec;
    reg [16:0] r_old_usec;
    wire w_clk_usec;
    reg r_count_usec_e;
    clock_usec clk_usec(.clk(clk), .reset_p(reset_p), .clk_usec(w_clk_usec));
    always@(negedge clk or posedge reset_p) begin
        if(reset_p) r_count_usec <= 0;
        else begin
            if(w_clk_usec && r_count_usec_e) r_count_usec <= r_count_usec + 1;
            else if(!r_count_usec_e) r_count_usec <= 0;
        end
    end

    wire w_echo_pedge, w_echo_nedge;
    edge_detector_n edn1(.clk(clk),.cp_in(echo),.rst_p(reset_p),
                         .p_edge(w_echo_pedge),. n_edge(w_echo_nedge));

    reg [3:0] r_state, r_next_state;
    always @(negedge clk, posedge reset_p) begin
        if (reset_p) r_state <= S_IDLE;
        else r_state <= r_next_state;
    end

    reg [20:0] r_sum_value;
    reg [16:0] r_temp_value [15:0];
    reg [3:0] r_index;
    always @(posedge clk, posedge reset_p) begin
        if (reset_p) begin
            led <= 0;
            r_index <= 0;
            r_next_state <= S_IDLE;
            r_count_usec_e <= 0;
            trig <= 0;
            r_old_usec <= 0;
            r_temp_value[0] <= 0;
            r_temp_value[1] <= 0;
            r_temp_value[2] <= 0;
            r_temp_value[3] <= 0;
            r_temp_value[4] <= 0;
            r_temp_value[5] <= 0;
            r_temp_value[6] <= 0;
            r_temp_value[7] <= 0;
            r_temp_value[8] <= 0;
            r_temp_value[9] <= 0;
            r_temp_value[10] <= 0;
            r_temp_value[11] <= 0;
            r_temp_value[12] <= 0;
            r_temp_value[13] <= 0;
            r_temp_value[14] <= 0;
            r_temp_value[15] <= 0;
        end
        else begin
            case (r_state)
                S_IDLE: begin
                    if(r_count_usec<80_000)begin    //worst echo time = 82ms
                        r_next_state <= S_IDLE;     //from trigger negative edge to echo positive edge = 2.2ms
                         r_count_usec_e <= 1;       // => worst HC-SR04 frequency = 72.21ms
                         led[0] <= 1;               //maximum HC-SR04 frequency = 60ms
                    end
                    else begin
                        r_next_state <= S_TRIG;
                        r_count_usec_e <= 0;
                        led[0] <= 0;
                    end
                end 
                S_TRIG:begin
                    if(r_count_usec<10)begin
                        r_next_state <= S_TRIG;
                        r_count_usec_e <= 1;
                        led[1] <= 1;
                        trig <= 1;
                    end
                    else begin
                        r_next_state <= S_WAIT_PEDGE;
                        r_count_usec_e <= 0;
                        led[1] <= 0;
                        trig <= 0;
                    end
                end
                S_WAIT_PEDGE: begin
                    if(w_echo_pedge)begin
                        r_next_state <= S_WAIT_NEDGE;
                        r_count_usec_e <= 0;
                        r_old_usec <= r_count_usec;
                        led[2] <= 0;
                    end
                    else begin
                        if(r_count_usec < 80_000)begin
                            r_next_state <= S_WAIT_PEDGE;
                            r_count_usec_e <= 1;
                        end
                        else begin
                            r_next_state <= S_IDLE;
                            r_count_usec_e <= 0;
                        end
                        led[2] <= 1;
                    end
                end
                S_WAIT_NEDGE: begin
                    if(w_echo_nedge)begin
                        r_next_state <= S_IDLE;
                        r_count_usec_e <= 0;
                        led[3] <= 0;
                        r_temp_value[r_index] <= r_count_usec - r_old_usec;
                        r_index <= r_index + 1;
                    end
                    else begin
                        if(r_count_usec < 80_000) begin
                            r_next_state <= S_WAIT_NEDGE;
                            r_count_usec_e <= 1;
                        end
                        else begin
                            r_next_state <= S_IDLE;
                            r_count_usec_e <= 0;
                        end
                        led[3] <= 1;
                    end
                end
                default: r_next_state <= S_IDLE;
            endcase
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
