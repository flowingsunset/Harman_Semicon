module clock_usec(
    input clk, reset_p,
    output clk_usec
    );
    reg [6:0] cnt_10nsec;
    wire cp_usec;
    always@(posedge clk or posedge reset_p) begin
        if(reset_p) cnt_10nsec <= 0;
        else if(cnt_10nsec >= 99) cnt_10nsec <= 0;
        else cnt_10nsec <= cnt_10nsec+1;
    end
    
    assign cp_usec = cnt_10nsec < 49 ? 0 : 1;
    
    edge_detector_n edn0(clk, cp_usec,reset_p, clk_usec);
    
endmodule

module clock_msec(
    input clk, clk_usec, reset_p,
    output clk_msec
    );
    reg [8:0] cnt_usec;
    reg cp_msec;
    always@(posedge clk or posedge reset_p) begin
        if(reset_p) cnt_usec <= 0;
        else if(clk_usec) begin
            if(cnt_usec >= 499) begin
                cnt_usec <= 0;
                cp_msec <= ~cp_msec;
            end
            else cnt_usec <= cnt_usec+1;
        end
    end
    
    edge_detector_n edn1(clk, cp_msec,reset_p, clk_msec);
    
endmodule

module clock_sec(
    input clk, clk_msec, reset_p,
    output clk_sec
    );
    reg [8:0] cnt_msec;
    reg cp_sec;
    always@(posedge clk, posedge reset_p) begin
        if(reset_p) cnt_msec <= 0;
        else if(clk_msec) begin
            if(cnt_msec >= 499) begin
                cnt_msec <= 0;
                cp_sec <= ~cp_sec;
            end
            else cnt_msec <= cnt_msec+1;
        end
    end
    
    edge_detector_n edn2(clk, cp_sec,reset_p, clk_sec);
    
endmodule

module clock_min(
    input clk, clk_sec, reset_p,
    output clk_min
    );
    reg [5:0] cnt_sec;
    reg cp_min;
    always@(posedge clk, posedge reset_p) begin
        if(reset_p) cnt_sec <= 0;
            else if(clk_sec) begin
            if(cnt_sec >= 29) begin
                cnt_sec <= 0;
                cp_min <= ~cp_min;
            end
            else cnt_sec <= cnt_sec+1;
        end
    end
    
    edge_detector_n edn3(clk, cp_min,reset_p, clk_min);
    
endmodule

module counter_dec_60(
    input clk, reset_p,
    input clk_time,
    output reg[3:0] dec1, dec10
);

    always@(posedge clk, posedge reset_p) begin
        if(reset_p) begin
            dec1 <= 0;
            dec10 <= 0;
        end
        else if(clk_time) begin
            if(dec1 >= 9) begin
                dec1 <= 0;
                if(dec10 >= 5) dec10 <= 0;
                else dec10 <= dec10+1;
            end
            else dec1 = dec1 + 1;
        end
    end

endmodule
