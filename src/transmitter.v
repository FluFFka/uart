module transmitter #(
    parameter W = 8,
    parameter DIV = 3,
    parameter PAR = 0
) (
    input clk, input rst,
    input [W-1:0] d,
    input row,
    input [0:1] col,
    input [3:0] action,
    output reg tx,
    output reg busy,
    output [W-1:0] t_cell
);

    reg [W-1:0] matrix[0:1][0:3];

    assign t_cell = matrix[row][col];

    integer curr_bit;

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
            tx <= 1;
        end
        if (clk) begin
            if (busy == 0) begin
                if (action == 1) begin
                    matrix[row][col] <= d;
                    tx <= 1;
                end
                if (action == 2 || action == 3 || action == 4 || action == 5) begin
                    busy <= 1;
                    tx <= 0;    // start bit
                end
            end else begin
                if (action == 2) begin
                    if (curr_bit == W) begin
                        // parity check (and curr_bit == W + 1)
                        tx <= 1;    // stop bit
                        busy <= 0;
                        curr_bit <= 0;
                    end else begin
                        tx <= matrix[row][col][curr_bit];
                        curr_bit <= curr_bit + 1;
                    end
                end
            end
        end
    end

endmodule