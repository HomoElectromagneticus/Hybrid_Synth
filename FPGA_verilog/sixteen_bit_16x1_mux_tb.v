`include "sixteen_bit_16x1_mux.v"
`timescale 1us/1ns

module sixteen_bit_16x1_mux_tb();
    reg r_CLOCK = 1'b0;
    reg [3:0] r_SELECT = 4'b000;
    reg [15:0] r_0 = 16'h0000;
    reg [15:0] r_1 = 16'h1111;
    reg [15:0] r_2 = 16'h2222;
    reg [15:0] r_3 = 16'h3333;
    reg [15:0] r_4 = 16'h4444;
    reg [15:0] r_5 = 16'h5555;
    reg [15:0] r_6 = 16'h6666;
    reg [15:0] r_7 = 16'h7777;
    reg [15:0] r_8 = 16'h8888;
    reg [15:0] r_9 = 16'h9999;
    reg [15:0] r_A = 16'hAAAA;
    reg [15:0] r_B = 16'hBBBB;
    reg [15:0] r_C = 16'hCCCC;
    reg [15:0] r_D = 16'hDDDD;
    reg [15:0] r_E = 16'hEEEE;
    reg [15:0] r_F = 16'hFFFF;
    wire [15:0] w_OUTPUT;

    // instantiate the unit under test
    sixteen_bit_16x1_mux UUT
    (
        .i_select(r_SELECT),
        .i_0(r_0),
        .i_1(r_1),
        .i_2(r_2),
        .i_3(r_3),
        .i_4(r_4),
        .i_5(r_5),
        .i_6(r_6),
        .i_7(r_7),
        .i_8(r_8),
        .i_9(r_9),
        .i_A(r_A),
        .i_B(r_B),
        .i_C(r_C),
        .i_D(r_D),
        .i_E(r_E),
        .i_F(r_F),
        .o_output(w_OUTPUT)
    );

    initial begin
        repeat (16) begin
            #20
            r_SELECT = r_SELECT + 1;
        end
    end

endmodule