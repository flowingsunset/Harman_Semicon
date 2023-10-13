module tb_ultrasonic_without_fsm();

    reg clk, reset_p;
    reg echo;
    wire trig;
    wire [15:0]distance_cm;
    wire [3:0] led;

    ultrasonic_without_fsm dut(clk, reset_p,echo,trig,distance_cm,led);

    localparam data1 = 58*10*1000;
    localparam data2 = 58*23*1000;

    initial begin
        clk = 0; reset_p = 1;
        echo = 0;
    end

    always #5 clk = ~clk;

    integer i;
    initial begin
        #10; reset_p = 0; #10;
        for ( i=0 ; i<16; i=i+1) begin
            wait(trig);
            wait (!trig);
            #28000;
            echo = 1; #data1;
            echo = 0;
        end
        for ( i=0 ; i<16; i=i+1) begin
            wait(trig);
            wait (!trig);
            #28000;
            echo = 1; #data2;
            echo = 0;
        end

        #28000; $stop;
    end

endmodule
