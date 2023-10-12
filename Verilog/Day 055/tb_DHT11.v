module tb_DHT11();

reg clk, reset_p;
tri1 dht11_data;    //  tri1 : act as pull-up wire. only use in simulation(tri0 act as pull-down wire)
wire [7:0] humidity,temperature;
integer i=0;

DHT11 dut(clk,reset_p,dht11_data,humidity, temperature);

parameter [7:0] humi_value = 8'd80;
parameter [7:0] temp_value = 8'd25;
parameter [7:0] check_sum = humi_value + temp_value;
parameter [39:0] data = {humi_value, {8{1'b0}}, temp_value, {8{1'b0}}, check_sum};

reg dout, wr;
assign dht11_data = wr ? dout : 1'bz;
//assign dht11_data = dout;
initial begin
    clk = 0;
    reset_p = 1;
    wr = 0;
    dout = 0;
end

always #5 clk =  ~clk;

initial begin
    #8;
    reset_p = 0; #8;
    wait(!dht11_data);
    wait(dht11_data);
    #20000;
    dout = 0; wr= 1;#80000;
    dout = 1; wr = 1;#80000;
    for(i=0; i<40; i=i+1)begin
        dout = 0; #50000;
        if(data[39-i])begin
            dout = 1; wr = 1; #70000;
        end
        else begin
            dout = 1; wr = 1; #27000;
        end
    end
    dout = 0; #8;
    wr = 0; #10000;
    $stop;
end

endmodule
