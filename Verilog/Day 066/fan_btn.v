`timescale 1ns / 1ps

module fan_btn(
    input wire clk, reset_p,
    input wire btn,
    output wire [3:0] led,
    output wire [6:0] duty
    );

    parameter S_PWM0 = 5'b00001;
    parameter S_PWM25 = 5'b00010;
    parameter S_PWM50 = 5'b00100;
    parameter S_PWM75 = 5'b01000;
    parameter S_PWM100 = 5'b10000;

    reg [4:0] state;
    wire w_btn_pedge;

    assign duty = (state == S_PWM0)  ? 0  :
                  (state == S_PWM25) ? 25 :
                  (state == S_PWM50) ? 50 :
                  (state == S_PWM75) ? 75 :
                  (state == S_PWM100)? 100 : 0;
    
    assign led[3:0] = state[4:1];
    always @(posedge clk, posedge reset_p) begin
        if(reset_p)begin
            state <= S_PWM0;
        end
        else begin
            if(w_btn_pedge) begin
                state <= {state[3:0], state[4]};
            end
        end
    end
    button_cntr bcntr_set(.clk(clk), .reset_p(reset_p), .btn(btn), .btn_pe(w_btn_pedge), .btn_ne());
    
endmodule
