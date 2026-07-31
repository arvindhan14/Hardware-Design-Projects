`timescale 1ns/1ns
`include "sync_fifo.v"

module fifo_tb;

    reg clk, rst, wr_en, rd_en;;
    reg [7:0] data_in;
    
    wire [7:0] data_out;
    wire full, empty;
    wire wr_valid, rd_valid;

    fifo dut (.clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en),
             .data_in(data_in), .data_out(data_out),
             .full(full), .empty(empty),
             .wr_valid(wr_valid), .rd_valid(rd_valid));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sync_fifo_tb.vcd");
        $dumpvars(0, fifo_tb);

        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 8'b0;

        #10;
        rst = 0;
        data_in = 8'hA1;
        wr_en = 1;

        #10;
        wr_en = 0;
        rd_en = 1;

        #10;
        rd_en = 0;

        $display("Finished testbench");
        $finish;

    end

endmodule
