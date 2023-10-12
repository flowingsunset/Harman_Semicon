`timescale 1ns / 1ps
module button_cntr(
    input clk,
    input reset_p,
    input btn,
    output btn_pe, 
    output btn_ne
    );
    reg [16:0] clk_div;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) clk_div <= 0;
        else clk_div <= clk_div + 1;
    end

    wire debounced_btn;
    D_flip_flop_p dff1(.d(btn),.clk(clk_div[16]),.reset_p(reset_p),.q(debounced_btn));
	edge_detector_p edn_top1(.clk(clk), .cp_in(debounced_btn), .reset_p(reset_p), .p_edge(btn_pe), .n_edge(btn_ne));
    
endmodule

module D_flip_flop_p(
    input d,
    input clk,
    input reset_p,
    output reg q
    );
    
    always@(posedge clk or posedge reset_p)begin
        if(reset_p) q = 0;
        else q=d;
    end
    
endmodule

module edge_detector_p(
    input clk,
    input cp_in,
    input reset_p,
    output p_edge,
    output n_edge
);
    reg cp_in_old, cp_in_cur;
    
    always@(posedge clk or posedge reset_p)begin
        if(reset_p) begin
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
