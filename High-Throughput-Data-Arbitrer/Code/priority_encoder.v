module priority_encoder(
    input [3:0] req_i,
    output reg [3:0] grant_out,
    output reg [1:0] id,
    output reg valid
);

    always @(*) begin

        grant_out = 4'b0000;
        id = 2'b00;
        valid = 1'b0;

        casez (req_i)
            4'b???1: begin
                grant_out = 4'b0001;
                id = 2'b00;
                valid = 1;
            end

            4'b??10: begin
                grant_out = 4'b0010;
                id = 2'b01;
                valid = 1;
            end

            4'b?100: begin
                grant_out = 4'b0100;
                id = 2'b10;
                valid = 1;
            end

            4'b1000: begin
                grant_out = 4'b1000;
                id = 2'b11;
                valid = 1;
            end

            default: begin
                grant_out = 4'b0000;
                id = 2'b00;
                valid = 0;
            end

        endcase
    end

endmodule