`include "priority_encoder.v"
`include "sync_fifo.v"

module arbiter(
    input clk, rst, rd_en,
    input [15:0] req_i,
    output [15:0] grant_out,
    output [3:0] data_out,
    output full, empty,
    output wr_valid, rd_valid
);

    wire encoder_valid;
    wire [3:0] encoder_id;

    wire [15:0] safe_req_i = full ? 16'b0 : req_i;

    priority_encoder p1 (safe_req_i, grant_out, encoder_id, encoder_valid);

    fifo #(.BIT_WIDTH(4)) f1 (
        clk, rst, encoder_valid, rd_en,
        encoder_id,
        data_out,
        full, empty,
        wr_valid, rd_valid
    );

endmodule