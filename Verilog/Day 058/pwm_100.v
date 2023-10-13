module pwm_100(
    input wire clk, reset_p,
    input wire [6:0] duty,
    input wire [13:0] pwm_freq,
    output reg pwm_100pc    //100%
    );

    localparam sys_clk_freq = 100_000_000;

    reg [26:0] r_cnt;
    reg r_clk_freqX100;

    always @(posedge clk, posedge reset_p) begin
        if (reset_p)  begin
            r_cnt <= 0;
            r_clk_freqX100 <= 0; 
        end
        else begin
            if(r_cnt > (sys_clk_freq/pwm_freq/200)-1) begin
                r_cnt <= 0;
                r_clk_freqX100 <= ~r_clk_freqX100;
            end
            else r_cnt <= r_cnt + 1;
        end
    end

    wire w_clk_freqX100_ne;
    edge_detector_p edn1(.clk(clk),.cp_in(r_clk_freqX100),.rst_p(reset_p),
                         .p_edge(),. n_edge(w_clk_freqX100_ne));

    reg [6:0] r_cnt_duty;
    always @(posedge clk, posedge reset_p) begin
        if(reset_p) begin
            r_cnt_duty <= 0;
            pwm_100pc <= 0;
        end
        else begin
            if(w_clk_freqX100_ne) begin
                if(r_cnt_duty >=99) r_cnt_duty <= 0;
                else r_cnt_duty <= r_cnt_duty + 1;
    
                if(r_cnt_duty < duty) pwm_100pc <= 1;
                else pwm_100pc <= 0;
            end
        end
    end

endmodule
