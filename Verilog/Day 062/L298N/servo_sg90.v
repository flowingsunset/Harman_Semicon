module servo_sg90(
    input clk, reset_p,
    output sg90,
    output [1:0] led,
    output [3:0] an,
    output [6:0] seg
    );
    
    reg[9:0] duty;
    pwm_1000 survo(.clk(clk), .reset_p(reset_p),  .duty(duty), .pwm_freq(50), .pwm_1000pc(sg90) );
    
    reg [21:0] clk_div;
    always@(posedge clk) clk_div <= clk_div + 1;
    wire clk_div_21_ne;
    edge_detector_p edn1(.clk(clk),.cp_in(clk_div[21]),.reset_p(reset_p),
                         .p_edge(),. n_edge(clk_div_21_ne));
    reg down_up;
    parameter UP = 0;
    parameter DOWN = 1;
    always@(posedge clk, posedge reset_p)begin
        if(reset_p) begin
            duty <= 500;
            down_up <= 0;
        end
        else if(clk_div_21_ne) begin
            if(down_up) begin
                if(duty < 500) begin 
                    down_up <= UP;
                end
                else duty <= duty - 1;
            end
            else begin
                if(duty > 1000) begin
                    down_up <= DOWN;
                end
                else duty <= duty + 1;
            end
        end
    end
    wire [15:0] w_duty;
    bin_to_dec btd_humi(.bin({2'b00, duty}),.bcd(w_duty));
    FND_4digit_ctrl fnd_cntr( .clk(clk), .reset_p(reset_p),.value(w_duty), .com(an), .seg_7(seg));
    
endmodule
