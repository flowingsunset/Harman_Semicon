module DHT11(
    input wire clk,
    input wire reset_p,
    inout wire dht11_data,
    output reg [7:0] humidity, temperature,
    output reg [7:0] led    //  check state
    );
    
    //State Parameter
    localparam S_IDLE = 6'b000001;
    localparam S_LOW_18MS = 6'b000010;
    localparam S_HIGH_20US = 6'b000100;
    localparam S_LOW_80US = 6'b001000;
    localparam S_HIGH_80US = 6'b010000;
    localparam S_READ_DATA = 6'b100000;
    
    //Data receive state parameter
    localparam S_WAIT_PEDGE = 2'b01;
    localparam S_WAIT_NEDGE = 2'b10;
    
    //Counter for state
    reg [21:0] r_count_usec;
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

    //Edge Detecter to check Data
    wire w_dht_pedge, w_dht_nedge;
    edge_detector_n edn1(.clk(clk),.cp_in(dht11_data),.rst_p(reset_p),. p_edge(w_dht_pedge),. n_edge(w_dht_nedge));

    //State register
    reg [5:0] r_state, r_next_state;
    reg [1:0] r_read_state;

    //next state
    always @(negedge clk or posedge reset_p) begin
        if(reset_p) r_state <= S_IDLE;
        else r_state <= r_next_state;
    end

    //buffer for inout wire dht11_data
    reg r_dht11_buffer;
    assign dht11_data = r_dht11_buffer;


    //store 40bit data and count data bit
    //8bit integral RH data + 8bit decimal RH data + 8bit integral T data + 8bit decimal T data + 8bit check sum = 40bit
    //r_temp_data[39-:8]+r_temp_data[31-:8]+r_temp_data[23-:8]+r_temp_data[15-:8] == r_temp_data[7:0]
    reg [39:0] r_temp_data;
    reg [5:0] r_data_count;

    //FSM
    always @(posedge clk or posedge reset_p) begin
        //initial state
        if (reset_p) begin
            r_count_usec_e <= 0;
            r_next_state <= S_IDLE;
            r_dht11_buffer <= 1'bz;
            r_read_state <= S_WAIT_PEDGE;
            r_data_count <= 0;
            humidity <= 0;
            temperature <= 0;
            r_temp_data <= 0;
            led <= 8'h00;
        end
        else begin
            case (r_state)
                //IDLE state
                S_IDLE: begin
                    if(r_count_usec < 22'd3_000_000) begin  //wait 3s for sensor booting
                    //if(r_count_usec < 22'd3_0) begin  //for testbench
                        r_next_state <= S_IDLE;
                        r_count_usec_e <= 1;
                        r_dht11_buffer <= 1'bz;
                        led[0] <= 1;
                    end
                    else begin
                        r_next_state <= S_LOW_18MS;
                        r_count_usec_e <= 0;
                        r_dht11_buffer <= 0;
                        //led[0] <= 0;
                    end
                end
                S_LOW_18MS: begin
                    if(r_count_usec < 22'd20_000) begin     //take 20ms not 18ms for safety
                        r_next_state <= S_LOW_18MS;
                        r_count_usec_e <= 1;
                        r_dht11_buffer <= 0;    //set wire low for start signal
                        led[1] <= 1;
                    end
                    else begin
                        r_next_state <= S_HIGH_20US;
                        r_count_usec_e <= 0;
                        r_dht11_buffer <= 1'bz;
                        //led[1] <= 0;
                    end
                end
                S_HIGH_20US: begin
                    led[2] <= 1;
                    if (r_count_usec < 22'd90) begin   //initial wait time 20us, but wait more longer for safety
                        r_dht11_buffer <= 1'bz;     // let wire high impedance to make wire high because of pull up register
                        r_count_usec_e <= 1;
                        if(w_dht_nedge) begin       //  sensor send start signal to master
                            r_next_state <= S_LOW_80US;
                            r_count_usec_e <= 0;
                            //led[2] <= 0;
                        end
//                        else begin
//                            r_next_state <= S_HIGH_20US;
//                            r_count_usec_e <= 1;
//                            led[2] <= 1;
//                        end
                    end
                    else begin      //no ack from sensor for 90us
                        r_next_state <= S_IDLE;
                        r_count_usec_e <= 0;
                        //r_dht11_buffer <= 1'bz;
                        //led[2] <= 0;
                    end
                end
                S_LOW_80US: begin
                    led[3] <= 1;
                    if (r_count_usec < 90) begin    //wait 90us until sensor send high bit to ready for send data
                        if(w_dht_pedge)begin    // sensor is ready to send data
                            r_next_state <= S_HIGH_80US;
                            r_count_usec_e <= 0;
                            //r_dht11_buffer <= 1'hz;
                            //led[3] <= 0;
                        end
                        else begin      //waiting
                            r_next_state <= S_LOW_80US;
                            r_count_usec_e <= 1;
                            //r_dht11_buffer <= 1'hz;
                            
                        end
                    end
                    else begin  //sensor is not sending ready signal
                        r_next_state <= S_IDLE;
                        r_count_usec_e <= 0;
                        //r_dht11_buffer <= 1'hz;
                        //led[3] <= 0;
                    end
                end
                S_HIGH_80US: begin
                    led[4] <= 1;
                    if (r_count_usec < 90) begin    //ready 90us for first data bit
                        if(w_dht_nedge)begin    // data transmit start
                            r_next_state <= S_READ_DATA;
                            r_count_usec_e <= 0;
                            //r_dht11_buffer <= 1'hz;
                            //led[4] <= 0;
                        end
                        else begin  //waiting
                            r_next_state <= S_HIGH_80US;
                            r_count_usec_e <= 1;
                            //r_dht11_buffer <= 1'hz;
                        end
                    end else begin
                        r_next_state <= S_IDLE;
                        r_count_usec_e <= 0;
                        //r_dht11_buffer <= 1'hz;
                        //led[4] <= 0;
                    end
                end
                S_READ_DATA: begin
                    led[5] <= 1;
                   case (r_read_state)
                        S_WAIT_PEDGE: begin 
                            led[6] <= 1;
                            if (w_dht_pedge) begin  //data bit is transmitting
                                r_read_state <= S_WAIT_NEDGE;
                                r_count_usec_e <= 1;
                            end else begin
                                //r_read_state <= S_WAIT_PEDGE;
                                r_count_usec_e <= 0;
                            end
                        end 
                        S_WAIT_NEDGE: begin
                            led[7] <= 0;
                            if(w_dht_nedge) begin //check time to recognize data bit
                                r_read_state <= S_WAIT_PEDGE;
                                r_data_count <= r_data_count + 1;
                                //r_count_usec_e <= 0;
                                if (r_count_usec < 50) begin
                                    r_temp_data <= {r_temp_data[38:0], 1'b0};
                                end
                                else begin
                                    r_temp_data <= {r_temp_data[38:0], 1'b1};
                                end
                            end
                            else begin
                                r_read_state <= S_WAIT_NEDGE;
                                r_count_usec_e <= 1;
                            end
                        end
                        default: r_read_state = S_WAIT_PEDGE;
                   endcase 
                   if(r_data_count >= 40) begin //end transmit 40bit data
                        r_next_state <= S_IDLE;
                        r_data_count <= 0;
                        //led[5] <= 0;
                        if(r_temp_data[39-:8]+r_temp_data[31-:8]+r_temp_data[23-:8]+r_temp_data[15-:8] == r_temp_data[7:0]) begin   //data check using sum
                            humidity <= r_temp_data[39-:8];
                            temperature <= r_temp_data[23-:8];
                        end
                   end
                end
                default : r_next_state <= S_IDLE;
            endcase
        end
    end
    
endmodule
