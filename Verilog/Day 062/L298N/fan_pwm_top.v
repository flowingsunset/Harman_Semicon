module fan_pwm_top (
    input wire clk, reset_p,
    input wire [8:0] sw,
    output wire sg90,
    output wire forward, backward,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire [8:0]led
);
    reg [22:0] r_clk_div;
    always @(posedge clk) begin
        if(reset_p) r_clk_div <= 0;
        else r_clk_div = r_clk_div + 1;
    end
    assign led = sw;
   reg [7:0] cnt;
   wire [15:0]w_cnt;
   always@(posedge clk, posedge reset_p)begin
       if(reset_p) begin
           cnt <= 0;
       end
       else begin
           if(r_clk_div == 23'h7f_ffff)begin
               cnt <= sw[7:0];
           end
           
       end
   end
  
   assign forward = sw[8];
   assign backward = !sw[8];
  
    bin_to_dec btd_humi(.bin({4'b0000, cnt}),.bcd(w_cnt));
    FND_4digit_ctrl fnd_cntr( .clk(clk), .reset_p(reset_p),.value(w_cnt), .com(an), .seg_7(seg));
    pwm_100 pwm01(.clk(clk), .reset_p(reset_p), .duty(cnt), .pwm_freq(100), .pwm_100pc(sg90));
endmodule
