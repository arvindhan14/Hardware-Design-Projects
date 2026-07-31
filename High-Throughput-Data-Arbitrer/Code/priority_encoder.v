module priority_encoder(
    input [15:0] req_i,
    output reg [15:0] grant_out,
    output reg [3:0] id,
    output reg valid
);

    integer i;
    reg done;
    always @(*) begin
        grant_out = 16'b0;
        done = 1'b0;
        id = 4'b0000;
        valid = 1'b0;
        for (i=0; i<16; i=i+1) begin
            if (!done) begin
                if (req_i[i]) begin
                    grant_out[i] = 1'b1;
                    done = 1'b1;
                    id = i;
                    valid = 1'b1;
                end
            end
        end
    end

endmodule