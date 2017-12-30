//=============================================================================
// Design Name:		16bit wide, 16x1 multiplexer
// File Name:		16b_16x1_mux.v
// Author:			RM Schaub
// Function:		A 16 bit wide, 16x1 multiplexer
//=============================================================================

module sixteen_bit_16x1_mux(
    i_select,
    i_0,
    i_1,
    i_2,
    i_3,
    i_4,
    i_5,
    i_6,
    i_7,
    i_8,
    i_9,
    i_A,
    i_B,
    i_C,
    i_D,
    i_E,
    i_F,
    o_output
);

    // inputs and outputs
    input [3:0]		i_select;
    input [15:0]	i_0;
    input [15:0]	i_1;
    input [15:0]	i_2;
    input [15:0]	i_3;
    input [15:0]	i_4;
    input [15:0]	i_5;
    input [15:0]	i_6;
    input [15:0]	i_7;
    input [15:0]	i_8;
    input [15:0]	i_9;
    input [15:0]	i_A;
    input [15:0]	i_B;
    input [15:0]	i_C;
    input [15:0]	i_D;
    input [15:0]	i_E;
    input [15:0]	i_F;
    
    output [15:0]	o_output;

    // registers and wires
    reg [15:0]	o_output;
    
    // function
    always @(i_select) begin
        case(i_select)
            4'h0: o_output <= i_0;
            4'h1: o_output <= i_1;
            4'h2: o_output <= i_2;
            4'h3: o_output <= i_3;
            4'h4: o_output <= i_4;
            4'h5: o_output <= i_5;
            4'h6: o_output <= i_6;
            4'h7: o_output <= i_7;
            4'h8: o_output <= i_8;
            4'h9: o_output <= i_9;
            4'hA: o_output <= i_A;
            4'hB: o_output <= i_B;
            4'hC: o_output <= i_C;
            4'hD: o_output <= i_D;
            4'hE: o_output <= i_E;
            4'hF: o_output <= i_F;
        endcase
    end

endmodule