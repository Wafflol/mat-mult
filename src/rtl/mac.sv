module mac #(
    parameter WIDTH = 8
) (
    input logic [WIDTH-1 : 0] a_in, b_in,
    input logic valid_in, reset, clk,
    output logic [WIDTH-1 : 0] a_out, b_out,
    output logic [WIDTH*4-1 : 0] acc_out,
    output logic valid_out
);

    logic [WIDTH*2-1 : 0] x;
    logic [WIDTH-1 : 0] a, b;
    logic valid0, valid1;

    always_ff @(posedge clk) begin : valid_shift_reg
        if (~reset) begin
            valid0 <= 0;
            valid1 <= 0;
            valid_out <= 0;
        end
        else begin
            valid0 <= valid_in;
            valid1 <= valid0;
            valid_out <= valid1;
        end
    end

    always_ff @(posedge clk) begin : pipeline
        if (~reset) begin
            a <= 0;
            b <= 0;
            x <= 0;
            acc_out <= 0;
        end
        else begin
            if (valid_in) begin
                a <= a_in;
                b <= b_in;
            end

            if (valid0)
                x <= a * b;

            if (valid1)
                acc_out <= acc_out + x;
        end
    end
endmodule
