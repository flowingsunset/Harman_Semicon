`timescale 1ns / 1ps
module UltraSonic(
    input wire clk,
    input wire reset_p,
    input wire echo,
    output reg trigger,
    output reg [8:0] dis_time,
    output reg [3:0] led
    );

    //State Parameter
    localparam S_IDLE = 0;
    localparam S_TRIG = 1;
    localparam S_ECHO_1 = 2;
    localparam S_ECHO_2 = 3;

    //State Register
    reg [1:0] r_state, r_next_state;

    //usec Counter
    reg [19:0] r_count_usec;
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

    //Echo pin edge detector
    wire w_echo_pedge, w_echo_nedge;
    edge_detector_n edn1(.clk(clk),.cp_in(echo),.rst_p(reset_p),
                         .p_edge(w_echo_pedge),. n_edge(w_echo_nedge));

    //State machine
    always @(negedge clk, posedge reset_p) begin
        if (reset_p) begin
            r_state <= S_IDLE;
        end else begin
            r_state <= r_next_state;
        end
    end

    //Next state
    always @(posedge clk, posedge reset_p) begin
        if (reset_p) begin
            r_next_state <= S_IDLE;
            r_count_usec_e <= 0;
            trigger <= 0;
            dis_time <= 0;
            led <= 0;
        end else begin
            case (r_state)
                S_IDLE:  begin
                    //if(r_count_usec<=1_000_000)begin    //wait 1s
                    if(r_count_usec<=1_0)begin    //wait 10us for testbench
                        r_count_usec_e <= 1;
                        led[0] <= 1;
                    end
                    else begin
                        r_next_state <= S_TRIG;
                        r_count_usec_e <= 0;
                        led[0] <= 0;
                    end
                end
                S_TRIG: begin
                    if (r_count_usec <= 10) begin
                        trigger <= 1;
                        r_count_usec_e <= 1;
                        led[1] <= 1;
                    end else begin
                        trigger <= 0;
                        r_count_usec_e <= 0;
                        r_next_state <= S_ECHO_1;
                        led[1] <= 0;
                    end
                end
                S_ECHO_1: begin
                    if (w_echo_pedge) begin
                        r_next_state <= S_ECHO_2;
                        r_count_usec_e <= 0;
                        led[2] <= 0;
                    end
                    else if(r_count_usec >= 15'h5AA0)begin
                        r_next_state <= S_IDLE;
                        r_count_usec_e <= 0;
                        led[2] <= 0;
                    end
                    else begin
                        r_next_state <= S_ECHO_1;
                        r_count_usec_e <= 1;
                        led[2] <= 1;
                    end
                end
                S_ECHO_2: begin
                    if(w_echo_nedge) begin
                        r_next_state <= S_IDLE;
                        r_count_usec_e <= 0;
                        dis_time <= r_count_usec/58;
                        led[3] <= 0;
                    end
                    else if (r_count_usec >= 15'h5AA0)begin
                        r_next_state <= S_IDLE;
                        r_count_usec_e <= 0;
                        led[3] <= 0;
                    end
                    else begin
                        r_next_state <= S_ECHO_2;
                        r_count_usec_e <= 1;
                        led[3] <= 1;
                    end
                end
                default: r_next_state <= S_IDLE;
            endcase
        end
    end
endmodule
