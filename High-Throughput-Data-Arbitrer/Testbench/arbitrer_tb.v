`timescale 1ns / 1ps
`include "arbiter.v"

module tb_arbiter;

    // Inputs
    reg clk, rst, rd_en;
    reg [15:0] req_i;

    // Outputs
    wire [15:0] grant_out;
    wire [3:0] data_out;
    wire full, empty;
    wire wr_valid, rd_valid;

    // Instantiate the Unit Under Test (UUT)
    arbiter uut (
        .clk(clk), 
        .rst(rst), 
        .rd_en(rd_en), 
        .req_i(req_i), 
        .grant_out(grant_out), 
        .data_out(data_out), 
        .full(full), 
        .empty(empty), 
        .wr_valid(wr_valid), 
        .rd_valid(rd_valid)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("arbiter.vcd");
        $dumpvars(0, tb_arbiter);

        clk = 0;
        rst = 1;
        rd_en = 0;
        req_i = 16'b0;

        #15 rst = 0; 
        
        // TEST 1: Fill the FIFO and check 'full' flag
        $display("TEST 1: Holding request high to fill the FIFO...");
        @(posedge clk);
        req_i = 16'h0001; // Device 0 makes a continuous request
        
        // Wait 18 clock cycles (FIFO depth is 16, so it will definitely fill)
        repeat (18) @(posedge clk); 
        
        if (full) 
            $display("PASS: FIFO 'full' flag went high.");
        else 
            $display("FAIL: FIFO 'full' flag is not high.");
            
        if (grant_out == 16'b0) 
            $display("PASS: Arbiter safely dropped grant_out to 0 because FIFO is full!");
        else 
            $display("FAIL: Arbiter is still granting requests while full.");

        
        // TEST 2: Read from FIFO and check 'empty' flag
        $display("TEST 2: Reading all data to empty the FIFO...");
        req_i = 16'h0000; 
        rd_en = 1'b1;     
        
        // Wait 18 clock cycles to ensure all 16 items are read out
        repeat (18) @(posedge clk);
        
        rd_en = 1'b0;     
        
        if (empty) 
            $display("PASS: FIFO 'empty' flag went high.");
        else 
            $display("FAIL: FIFO 'empty' flag is not high.");

        $display("--- Simulation Complete ---");
        


    // TEST 3: Priority Logic Verification
    $display("TEST 3: Testing Priority Resolution...");
    @(posedge clk);
    req_i = 16'b0000_0000_0000_1010; // Assert bits 1 and 3 simultaneously
    
    #1; 
    if (grant_out == 16'b0000_0000_0000_0010)
        $display("PASS: Bit 1 won the priority over Bit 3.");
    else
        $display("FAIL: Priority logic failed. grant_out = %b", grant_out);
        
    @(posedge clk);
    req_i = 16'b0000_0000_0000_1000; // Device 1 drops request, Device 3 remains
    
    #1;
    if (grant_out == 16'b0000_0000_0000_1000)
        $display("PASS: Bit 3 is now granted.");
    else
        $display("FAIL: Priority logic failed after drop.");

    req_i = 16'b0; // Clear requests

    // End simulation
    #20 $finish;
    end
endmodule