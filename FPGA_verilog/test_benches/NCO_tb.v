`include "../NCO.v"
`timescale 1us/1ns

module NCO_tb();
    reg r_CLOCK = 1'b0;
    reg r_RESET = 1'b1;
    reg r_INPUT_LATCH_WRITE_ENABLE = 1'b1;
    reg [26:0] r_INPUT = 27'b000000000000000000000000000;
    
    wire [12:0] w_OUTPUT;

    // instantiate the unit under test
    NCO UUT(
        .i_clock(r_CLOCK),
        .i_reset(r_RESET),
        .i_input_latch_write_enable(r_INPUT_LATCH_WRITE_ENABLE),
        .i_input(r_INPUT),
        .o_waveram_address(w_OUTPUT)
    );

    always #1 r_CLOCK <= !r_CLOCK;

    initial begin
        #2
        r_RESET = 0;
        #5
        r_INPUT_LATCH_WRITE_ENABLE = 0;
	    #5
        r_INPUT = 27'b000000000000000001100110110;      //playing G0
        #10
        r_INPUT_LATCH_WRITE_ENABLE = 1;
        #5
        r_INPUT_LATCH_WRITE_ENABLE = 0;
        #5
        r_INPUT = 27'b000000000000010001001001011;      //playing C4
        #1000
        r_INPUT_LATCH_WRITE_ENABLE = 1;
        #5
        r_INPUT_LATCH_WRITE_ENABLE = 0;
        #5
        r_INPUT = 27'b000000001000111001101011000;      //playing A6
        #100
        r_INPUT_LATCH_WRITE_ENABLE = 1;
        #5
        r_INPUT_LATCH_WRITE_ENABLE = 0;
        #5
        r_INPUT = 27'b100000001000111001101011000;      //changing wave address
        #100
        r_INPUT_LATCH_WRITE_ENABLE = 1;
        #5
        r_INPUT_LATCH_WRITE_ENABLE = 0;
    end

endmodule