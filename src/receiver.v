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
    
    reg start_bit_state;
    integer ins_clk;
    integer curr_row;
    integer end_row;
    integer curr_col;
    integer start_col;
    integer end_col;
    integer curr_bit;
    reg parity_check;
    reg [3:0] action_was;

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
        end
        if (clk) begin
            if (busy == 0) begin
                if (rx == 0) begin
                    busy <= 1;
                    parity_check <= 0;
                    ins_clk <= 0;
                    start_bit_state <= 1;
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
                        action_was <= action;
                    end
                end
            end else begin
                ins_clk <= (ins_clk + 1) % DIV;
                if (ins_clk == DIV / 2) begin
                    if (start_bit_state) begin
                        // nothing to do
                    end else if ((curr_bit == W || curr_bit == W + 1) && curr_row == end_row && curr_col == end_col) begin   // one of end bit states (parity check or stop)
                        if (curr_bit == W && PAR != 0) begin    // parity_check state
                            if (is_msg_correct) begin
                                if (action_was == 2) matrix[row][col] <= received[row][col];
                                if (action_was == 3) begin
                                    matrix[row][0] <= received[row][0];
                                    matrix[row][1] <= received[row][1];
                                    matrix[row][2] <= received[row][2];
                                    matrix[row][3] <= received[row][3];
                                end
                                if (action_was == 4) begin
                                    matrix[0][col] <= received[0][col];
                                    matrix[1][col] <= received[1][col];
                                end
                                if (action_was == 5) begin
                                    matrix[0][0] <= received[0][0];
                                    matrix[0][1] <= received[0][1];
                                    matrix[0][2] <= received[0][2];
                                    matrix[0][3] <= received[0][3];
                                    matrix[1][0] <= received[1][0];
                                    matrix[1][1] <= received[1][1];
                                    matrix[1][2] <= received[1][2];
                                    matrix[1][3] <= received[1][3];
                                end
                            end
                            curr_bit <= curr_bit + 1;
                        end else if (curr_bit == W + 1 || (curr_bit == W && PAR == 0)) begin    // stop bit state
                            busy <= 0;
                        end
                    end else begin  // receive bit state
                        received[row][col][curr_bit] <= rx;
                        parity_check <= parity_check ^ rx;
                        
                        // next bit
                        if (curr_bit != W) begin
                            curr_bit <= curr_bit + 1;
                        end else begin
                            if (curr_col != end_col) begin
                                curr_col <= curr_col + 1;
                                curr_bit <= 0;
                            end else begin
                                curr_row <= curr_row + 1;
                                curr_col <= start_col;
                                curr_bit <= 0;
                            end
                        end
                    end
                end
            end
        end
    end
endmodule