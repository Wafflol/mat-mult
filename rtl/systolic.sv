module systolic #(SIZE = 4) (
    input logic clk, reset, load_en, mult_en, acc_en,
    input logic [7:0] a_in [0:SIZE-1], b_in [0:SIZE-1],
    output logic [32-1:0] out [0:SIZE-1] [0:SIZE-1]
    );

    logic [7:0] a_out [0:SIZE-1] [0:SIZE-2];
    logic [7:0] b_out [0:SIZE-2] [0:SIZE-1];

    /*generate corners of the matrix*/
    mac topLeft(
        .a_in(a_in[0]),
        .b_in(b_in[0]),
        .a_out(a_out[0][0]),
        .b_out(b_out[0][0]),
        .acc_out(out[0][0]),
        .*
    )
    mac topRight(
        .a_in(a_out[0][SIZE-2]),
        .b_in(b_in[SIZE-1]),
        .a_out(),
        .b_out(b_out[0][SIZE-1]),
        .acc_out(out[0][SIZE-1]),
        .*
    )
    mac bottomLeft(
        .a_in(a_in[SIZE-1]),
        .b_in(b_out[SIZE-2][0]),
        .a_out(a_out[SIZE-1][0]),
        .b_out(),
        .acc_out(out[SIZE-1][0]),
        .*
    )
    mac bottomRight(
        .a_in(a_out[SIZE-2][SIZE-2]),
        .b_in(b_out[SIZE-2][SIZE-1]),
        .a_out(),
        .b_out(),
        .acc_out(out[SIZE-1][SIZE-1]),
        .*
    )

    genvar i,j;
    generate
        /* generate first and last row (excluding first MAC and last) */
        for (i = 1; i < SIZE-1; i = i + 1) begin : systolic_row
            mac row0MAC(
                .a_in(a_out[0][i-1]),
                .b_in(b_in[i]),
                .a_out(a_out[0][i]),
                .b_out(b_out[0][i]),
                .acc_out(out[0][i]),
                .*
            );
            mac rowLastMAC(
                .a_in(a_out[SIZE-1][i-1]),
                .b_in(b_out[SIZE-2][i]),
                .a_out(a_out[SIZE-1][i]),
                .b_out(),
                .acc_out(out[SIZE-1][i]),
                .*
            );
        end
        /* generate first and last column (excluding first and last instance of each)*/
        for (j = 1; j < SIZE-1; j = j + 1) begin : systolic_col
            mac col0MAC(
                .a_in(a_in[j]),
                .b_in(b_out[j-1][0]),
                .a_out(a_out[j][0]),
                .b_out(b_out[j][0]),
                .acc_out(out[j][0]),
                .*
            );
            mac colLastMAC(
                .a_in(a_out[i][SIZE-2]),
                .b_in(b_out[i-1][SIZE-1]),
                .a_out(),
                .b_out(b_out[i][SIZE-1]),
                .acc_out(out[i][SIZE-1]),
                .*
            );
        end

        /* generate everything in the center (not along the edges) */
        for (i = 1; i < SIZE - 1; i = i + 1) begin
            for (j = 1; j < SIZE - 1; j = j + 1) begin
                mac mainSystolic(
                    .a_in(a_out[i][j-1]),
                    .b_in(b_out[i-1][j]),
                    .a_out(a_out[i][j]),
                    .b_out(b_out[i][j]),
                    .acc_out(out[i][j]),
                    .*
                );
            end
        end
    endgenerate
endmodule
