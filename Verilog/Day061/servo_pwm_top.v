module servo_pwm_top (
    input wire clk, reset_p,
    input wire [15:0] sw,
    output wire sg90,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire [15:0]led
);
   wire [7:0] top, bottom;
   
    reg [22:0] r_clk_div;
    always @(posedge clk) begin
        if(reset_p) r_clk_div <= 0;
        else r_clk_div = r_clk_div + 1;
    end
    assign top = sw[15:8];
    assign bottom = sw[7:0];
    assign led = sw;
   reg [7:0] cnt;
   wire [15:0]w_cnt;
   always@(posedge clk, posedge reset_p)begin
       if(reset_p) begin
           cnt <= 0;
       end
       else begin
           if(r_clk_div == 23'h7f_ffff)begin
               if(cnt >= top) begin
                   cnt <= bottom;
               end
               else begin
                   cnt <= cnt+1;
                   
               end
           end
           
       end
   end
