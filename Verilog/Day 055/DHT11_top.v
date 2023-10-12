module DHT11_top(
    input wire clk, reset_p,
    inout wire dht11_data,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire [7:0] led
    );

    wire [7:0] w_humidity, w_temperature;
    wire [15:0] w_bcd_humi, w_bcd_temp;
    wire [15:0] value;
    DHT11 dht (.clk(clk), .reset_p(reset_p), .dht11_data(dht11_data), .humidity(w_humidity), .temperature(w_temperature), .led(led));
    bin_to_dec btd_humi(.bin({4'b0000, w_humidity}),.bcd(w_bcd_humi));
    bin_to_dec btd_temp(.bin({4'b0000, w_temperature}),.bcd(w_bcd_temp));
    assign value = {w_bcd_humi[7:0], w_bcd_temp[7:0]};
    FND_4digit_ctrl fnd_cntr( .clk(clk), .rst_p(reset_p),.value(value), .com(an), .seg_7(seg));
endmodule
