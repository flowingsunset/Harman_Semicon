module adc_ch6_top(
    input wire clk, reset_p,
    input wire vauxp6, vauxn6,
    output wire [3:0] an,
    output wire [6:0] seg
    );
    wire [4:0]channel_out;
    wire eoc_out;
    wire [15:0] do_out;
    xadc_wiz_0 adc_ch6
          (
          .daddr_in({2'b0, channel_out}),            // Address bus for the dynamic reconfiguration port
          .dclk_in(clk),             // Clock input for the dynamic reconfiguration port
          .den_in(eoc_out),              // Enable Signal for the dynamic reconfiguration port
        //   di_in,               // Input data bus for the dynamic reconfiguration port
        //   dwe_in,              // Write Enable for the dynamic reconfiguration port
          .reset_in(0),            // Reset signal for the System Monitor control logic
          .vauxp6(vauxp6),              // Auxiliary channel 6
          .vauxn6(vauxn6),
          //busy_out,            // ADC Busy signal
          .channel_out(channel_out),         // Channel Selection Outputs
          .do_out(do_out),              // Output data bus for dynamic reconfiguration port
        //  drdy_out,            // Data ready signal for the dynamic reconfiguration port
          .eoc_out(eoc_out)             // End of Conversion Signal
        //  eos_out,             // End of Sequence Signal
        //  alarm_out,           // OR'ed output of all the Alarms    
        //  vp_in,               // Dedicated Analog Input Pair
        //  vn_in
        );
    wire [15:0] bcd_adc;
    wire eoc_out_pedge;
    reg [11:0] adc_value ;
    edge_detector_p edn1(.clk(clk),.cp_in(eoc_out),.reset_p(reset_p),
                         .p_edge(eoc_out_pedge),. n_edge());
    always @(posedge clk, posedge reset_p) begin
        if(reset_p) adc_value <= 0;
        else if (eoc_out_pedge) begin
            adc_value <= {2'b00, do_out[15:6]};
        end
    end

    bin_to_dec btd_humi(.bin(adc_value),.bcd(bcd_adc));
    FND_4digit_ctrl fnd_cntr( .clk(clk), .reset_p(reset_p),.value(bcd_adc), .com(an), .seg_7(seg));
endmodule
