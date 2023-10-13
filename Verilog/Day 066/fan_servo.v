`timescale 1ns / 1ps

module fan_servo(
    input wire clk,
    input wire reset_p,
    output wire pwm,
    //analog input
    input vauxp6, vauxn6
    );


    reg[9:0] duty;

    //wire for ADC
    wire [4:0]channel_out;
    wire eoc_out;
    wire [15:0] do_out;

    //XADC structure
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
    
    wire eoc_out_pedge;
    reg [9:0] adc_value;
    edge_detector_p edn1(.clk(clk),.cp_in(eoc_out),.reset_p(reset_p),
                         .p_edge(eoc_out_pedge),. n_edge());
    always @(posedge clk, posedge reset_p) begin
        if(reset_p) adc_value <= 0;
        else if (eoc_out_pedge) begin
            if(do_out[15:9] < 25) adc_value <= 25;
            else adc_value <= {3'b000, do_out[15:9]}; //restric value 25~128
        end
    end

    pwm_1000 survo(.clk(clk), .reset_p(reset_p),  .duty(adc_value), .pwm_freq(50), .pwm_1000pc(pwm) );
endmodule
