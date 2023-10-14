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

    reg start_bit_state;
    integer ins_clk;
    reg curr_row;
    reg end_row;
    reg [0:1] curr_col;
    reg [0:1] start_col;
    reg [0:1] end_col;
    integer curr_bit;
    reg parity_check;

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
                if (action == 2) begin
                    curr_row <= row;
                    end_row <= row;
                    start_col <= col;
                    curr_col <= col;
                    end_col <= col;
                end
                if (action == 3) begin
                    curr_row <= row;
                    end_row <= row;
                    start_col <= 0;
                    curr_col <= 0;
                    end_col <= 3;
                end
                if (action == 4) begin
                    curr_row <= 0;
                    end_row <= 1;
                    start_col <= col;
                    curr_col <= col;
                    end_col <= col;
                end
                if (action == 5) begin
                    curr_row <= 0;
                    end_row <= 1;
                    start_col <= 0;
                    curr_col <= 0;
                    end_col <= 3;
                end
                if (action == 2 || action == 3 || action == 4 || action == 5) begin
                    curr_bit <= 0;
                    tx <= 0;    // start bit
                    parity_check <= 0;
                    ins_clk <= 0;
                    busy <= 1;
                    start_bit_state <= 1;
                end
            end else begin
                ins_clk <= (ins_clk + 1) % DIV;
                if (start_bit_state) begin  // start bit state
                    if (ins_clk == DIV - 1) begin
                        start_bit_state <= 0;
                    end
                end else if ((curr_bit == W || curr_bit == W + 1) && curr_row == end_row && curr_col == end_col) begin   // one of end bit states (parity check or stop)
                    if (PAR == 0) begin // stop bit state
                        tx <= 1;
                        if (ins_clk == DIV - 1) begin
                            busy <= 0;
                            curr_bit <= 0;
                        end
                    end else begin
                        if (curr_bit == W) begin    // parity_check bit state
                            if (PAR == 1) tx <= parity_check;
                            if (PAR == 2) tx <= ~parity_check;
                            if (ins_clk == DIV - 1) begin
                                curr_bit <= curr_bit + 1;
                            end
                        end else begin  // stop bit state
                            tx <= 1;
                            if (ins_clk == DIV - 1) begin
                                busy <= 0;
                            end
                        end
                    end
                end else begin      // transmit message state
                    tx <= matrix[curr_row][curr_col][curr_bit];
                    
                    if (ins_clk == DIV - 1) begin
                        parity_check <= parity_check ^ tx;
                        // next bit
                        if (curr_bit < W - 1) begin
                            curr_bit <= curr_bit + 1;
                        end else begin
                            if (curr_col != end_col) begin
                                curr_col <= curr_col + 1;
                                curr_bit <= 0;
                            end else if (curr_row != end_row) begin
                                curr_row <= curr_row + 1;
                                curr_col <= start_col;
                                curr_bit <= 0;
                            end else begin
                                curr_bit <= curr_bit + 1;   // curr_bit == W or curr_bit == W + 1
                            end
                        end
                    end
                end
            end
        end
    end

endmodule