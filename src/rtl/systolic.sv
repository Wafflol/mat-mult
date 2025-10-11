module systolic #(SIZE = 4) (
    input logic clk, reset,
    input logic [7:0] a_in [SIZE],
    input logic [7:0] b_in [SIZE],
    input logic valid_a [SIZE],
    input logic valid_b [SIZE],
    output logic [32-1:0] out [SIZE] [SIZE]
    );

    logic [7:0] a_out [SIZE] [SIZE-1];
    logic valid_a_out [SIZE] [SIZE-1];
    logic [7:0] b_out [SIZE-1] [SIZE];
    logic valid_b_out [SIZE-1] [SIZE];

    /*generate corners of the matrix*/
    mac topLeft(
        .a_in(a_in[0]),
        .valid_a(valid_a[0]),
        .b_in(b_in[0]),
        .valid_b(valid_b[0]),
        .a_out(a_out[0][0]),
        .valid_a_out(valid_a_out[0][0]),
        .b_out(b_out[0][0]),
        .valid_b_out(valid_b_out[0][0]),
        .acc_out(out[0][0]),
        .*
    );
    mac topRight(
        .a_in(a_out[0][SIZE-2]),
        .valid_a(valid_a_out[0][SIZE-2]),
        .b_in(b_in[SIZE-1]),
        .valid_b(valid_b[SIZE-1]),
        .a_out(),
        .valid_a_out(),
        .b_out(b_out[0][SIZE-1]),
        .valid_b_out(valid_b_out[0][SIZE-1]),
        .acc_out(out[0][SIZE-1]),
        .*
    );
    mac bottomLeft(
        .a_in(a_in[SIZE-1]),
        .valid_a(valid_a[SIZE-1]),
        .b_in(b_out[SIZE-2][0]),
        .valid_b(valid_b_out[SIZE-2][0]),
        .a_out(a_out[SIZE-1][0]),
        .valid_a_out(valid_a_out[SIZE-1][0]),
        .b_out(),
        .valid_b_out(),
        .acc_out(out[SIZE-1][0]),
        .*
    );
    mac bottomRight(
        .a_in(a_out[SIZE-1][SIZE-2]),
        .valid_a(valid_a_out[SIZE-1][SIZE-2]),
        .b_in(b_out[SIZE-2][SIZE-1]),
        .valid_b(valid_b_out[SIZE-2][SIZE-1]),
        .a_out(),
        .valid_a_out(),
        .b_out(),
        .valid_b_out(),
        .acc_out(out[SIZE-1][SIZE-1]),
        .*
    );

    genvar i,j, k, l;
    generate
        /* generate first and last row (excluding first MAC and last) */
        for (i = 1; i < SIZE-1; i = i + 1) begin : g_systolic_row
            mac row0MAC(
                .a_in(a_out[0][i-1]),
                .valid_a(valid_a_out[0][i-1]),
                .b_in(b_in[i]),
                .valid_b(valid_b[i]),
                .a_out(a_out[0][i]),
                .valid_a_out(valid_a_out[0][i]),
                .b_out(b_out[0][i]),
                .valid_b_out(valid_b_out[0][i]),
                .acc_out(out[0][i]),
                .*
            );
            mac rowLastMAC(
                .a_in(a_out[SIZE-1][i-1]),
                .valid_a(valid_a_out[SIZE-1][i-1]),
                .b_in(b_out[SIZE-2][i]),
                .valid_b(valid_b_out[SIZE-2][i]),
                .a_out(a_out[SIZE-1][i]),
                .valid_a_out(valid_a_out[SIZE-1][i]),
                .b_out(),
                .valid_b_out(),
                .acc_out(out[SIZE-1][i]),
                .*
            );
        end
        /* generate first and last column (excluding first and last instance of each)*/
        for (j = 1; j < SIZE-1; j = j + 1) begin : g_systolic_col
            mac col0MAC(
                .a_in(a_in[j]),
                .valid_a(valid_a[j]),
                .b_in(b_out[j-1][0]),
                .valid_b(valid_b_out[j-1][0]),
                .a_out(a_out[j][0]),
                .valid_a_out(valid_a_out[j][0]),
                .b_out(b_out[j][0]),
                .valid_b_out(valid_b_out[j][0]),
                .acc_out(out[j][0]),
                .*
            );
            mac colLastMAC(
                .a_in(a_out[j][SIZE-2]),
                .valid_a(valid_a_out[j][SIZE-2]),
                .b_in(b_out[j-1][SIZE-1]),
                .valid_b(valid_b_out[j-1][SIZE-1]),
                .a_out(),
                .valid_a_out(),
                .b_out(b_out[j][SIZE-1]),
                .valid_b_out(valid_b_out[j][SIZE-1]),
                .acc_out(out[j][SIZE-1]),
                .*
            );
        end

        /* generate everything in the center (not along the edges) */
        for (k = 1; k < SIZE - 1; k = k + 1) begin : g_center_row
            for (l = 1; l < SIZE - 1; l = l + 1) begin : g_center_col
                mac mainSystolic(
                    .a_in(a_out[k][l-1]),
                    .valid_a(valid_a_out[k][l-1]),
                    .b_in(b_out[k-1][l]),
                    .valid_b(valid_b_out[k-1][l]),
                    .a_out(a_out[k][l]),
                    .valid_a_out(valid_a_out[k][l]),
                    .b_out(b_out[k][l]),
                    .valid_b_out(valid_b_out[k][l]),
                    .acc_out(out[k][l]),
                    .*
                );
            end
        end
    endgenerate
endmodule
