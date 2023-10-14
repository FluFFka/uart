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

    wire x;
    
    transmitter #(
        .W(W), .DIV(DIV), .PAR(PAR)
    ) t_sch (
        .clk(clk), .rst(rst), .d(d), .row(row), .col(col), .action(action),
        .tx(x), .busy(t_busy), .t_cell(t_cell)
    );

    receiver #(
        .W(W), .DIV(DIV), .PAR(PAR)
    ) r_sch (
        .clk(clk), .rst(rst), .row(row), .col(col), .action(action), .rx(x),
        .busy(r_busy), .r_cell(r_cell)
    );

endmodule