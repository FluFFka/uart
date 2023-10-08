module receiver #(
    parameter W = 8,
    parameter DIV = 3,
    parameter PAR = 0
) (
    input clk, input rst,
    input row,
    input [0:1] col,
    input [3:0] action,
    input rx,
    output reg busy,
    output [W-1:0] r_cell
);

    reg [W-1:0] matrix[0:1][0:3];

    assign r_cell = matrix[row][col];

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            matrix[0][0] <= 0;
            matrix[0][1] <= 0;
            matrix[0][2] <= 0;
            matrix[0][3] <= 0;
            matrix[1][0] <= 0;
            matrix[1][1] <= 0;
            matrix[1][2] <= 0;
            matrix[1][3] <= 0;
            busy <= 0;
        end
        if (clk) begin
            
        end
    end
endmodule