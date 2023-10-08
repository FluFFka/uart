module main #(
    parameter W = 8,
    parameter DIV = 3,
    parameter PAR = 0
) (
    input clk, input rst,
    input [W-1:0] d,
    input row,
    input [0:1] col,
    input [3:0] action,
    output t_busy, output r_busy,
    output [W-1:0] t_cell, output [W-1:0] r_cell    
);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            
        end
    end

    assign t_busy = clk;

endmodule