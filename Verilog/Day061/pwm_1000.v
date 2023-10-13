module pwm_1000(
    input wire clk, reset_p,
    input wire [9:0] duty,
    input wire [13:0] pwm_freq,
    output reg pwm_1000pc    //100.0%
    );

    localparam sys_clk_freq = 100_000_000;

    reg [26:0] r_cnt;
    reg r_clk_freqX1000;

    always @(posedge clk, posedge reset_p) begin
        if (reset_p)  begin
            r_cnt <= 0;
            r_clk_freqX1000 <= 0; 
        end
        else begin
            if(r_cnt > (sys_clk_freq/pwm_freq/2000)) begin
                r_cnt <= 0;
                r_clk_freqX1000 <= ~r_clk_freqX1000;
            end
            else r_cnt <= r_cnt + 1;
        end
    end

    wire w_clk_freqX1000_ne;
    edge_detector_p edn1(.clk(clk),.cp_in(r_clk_freqX1000),.reset_p(reset_p),
                         .p_edge(),. n_edge(w_clk_freqX1000_ne));

    reg [9:0] r_cnt_duty;
    always @(posedge clk, posedge reset_p) begin
        if(reset_p) begin
            r_cnt_duty <= 0;
            pwm_1000pc <= 0;
        end
        else begin
            if(w_clk_freqX1000_ne) begin
                if(r_cnt_duty >=999) r_cnt_duty <= 0;
                else r_cnt_duty <= r_cnt_duty + 1;
    
                if(r_cnt_duty < duty) pwm_1000pc <= 1;
                else pwm_1000pc <= 0;
            end
        end
    end

endmodule
