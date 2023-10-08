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
    reg [W-1:0] received[0:1][0:3];

    assign r_cell = matrix[row][col];
    
    integer curr_bit;
    reg parity_check;

    wire is_msg_correct = (PAR == 1) ? parity_check == rx : ~parity_check == rx;

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
            parity_check <= 0;
        end
        if (clk) begin
            if (busy == 0) begin
                if (rx == 0) begin
                    busy <= 1;
                end
            end else begin
                if (action == 2) begin
                    if ((curr_bit == W && PAR == 0) || (curr_bit == W + 1 && PAR != 0)) begin
                        busy <= 0;
                        curr_bit <= 0;
                    end if (curr_bit == W && PAR != 0) begin
                        if (is_msg_correct) begin
                            matrix[row][col] <= received[row][col];
                        end
                        curr_bit <= curr_bit + 1;
                    end else begin
                        received[row][col][curr_bit] <= rx;
                        parity_check <= parity_check ^ rx;
                        curr_bit <= curr_bit + 1;
                    end
                end
            end
        end
    end
endmodule