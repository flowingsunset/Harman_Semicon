module D_flip_flop_p(
    input d,
    input clk,
    output reg q
    );
    
    always@(posedge clk)begin
        q=d;
    end
    
endmodule

module edge_detector_n(
    input clk,
    input cp_in,
    input rst_p,
    output p_edge,
    output n_edge
);
    reg cp_in_old, cp_in_cur;
    
    always@(negedge clk or posedge rst_p)begin
        if(rst_p) begin
            cp_in_old <= 0;
            cp_in_cur <= 0;
        end
        else begin
            cp_in_old <= cp_in_cur;
            cp_in_cur <= cp_in;
        end
    end
    
    assign p_edge = ~cp_in_old & cp_in_cur;
    assign n_edge = cp_in_old & ~cp_in_cur;
    

endmodule
