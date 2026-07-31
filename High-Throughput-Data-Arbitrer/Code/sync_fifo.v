module fifo #(
    parameter BIT_WIDTH = 4
)(
    input clk, rst, wr_en, rd_en,
    input [BIT_WIDTH-1:0] data_in,
    output reg [BIT_WIDTH-1:0] data_out,
    output full, empty,
    output reg wr_valid, rd_valid
);

 /*   function [3:0] increment (input [3:0] ptr);
        begin
          if (ptr == 4'b1111) increment = 4'b0000;
          else increment = ptr + 4'b1;
        end
    endfunction
    */

    reg [BIT_WIDTH-1:0] mem [0:15];
    reg [4:0] data_counter;

    reg [3:0] wr_ptr, rd_ptr;

    always @(posedge clk) begin
        if (rst) begin
          wr_ptr <= 4'b0;
          rd_ptr <= 4'b0;
          data_counter <= 5'b0;
          data_out <= 0;
          wr_valid <= 1'b0;
          rd_valid <= 1'b0;
        end

        else begin
            // When both write and read enable are high
            if (wr_en & rd_en & ~empty) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 4'b1;
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 4'b1; 
                data_counter <= data_counter;  
                wr_valid <= 1'b1;
                rd_valid <= 1'b1;
            end

            // When write enable is high and FIFO is not full
            else if (wr_en & ~full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 4'b1;
                data_counter <= data_counter + 5'b1;
                wr_valid <= 1'b1;
                rd_valid <= 1'b0;
            end

            // When read enable is high and FIFO is not empty
            else if (rd_en & ~empty) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 4'b1;
                data_counter <= data_counter - 5'b1;
                wr_valid <= 1'b0;
                rd_valid <= 1'b1;
            end

            // Default case
            else begin
                wr_ptr <= wr_ptr;
                rd_ptr <= rd_ptr;
                data_counter <= data_counter;
                {wr_valid, rd_valid} <= 2'b00;
            end
        end
    end

    //Full and empty flags
    assign full = (data_counter == 5'b10000);
    assign empty = (data_counter == 5'b00000);
    
endmodule
