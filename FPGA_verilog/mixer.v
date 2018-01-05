//=============================================================================
// Design Name:		Digital Mixer
// File Name:		mixer.v
// Author:			RM Schaub
// Function:		This module implements a mixer of two 8-bit digital inputs
//					according to a set of control inputs
//=============================================================================

module mixer(
    i_clock,
    i_reset,
    i_sample_1, 
    i_sample_1_load,
    i_sample_2, 
    i_sample_2_load,
    i_sample_1_level, 
    i_sample_2_level,
    i_execute,
    o_output
);

    //inputs and outputs
    input i_clock;
    input i_reset;
    input [7:0]	i_sample_1;
    input i_sample_1_load;
    input [7:0] i_sample_2;
    input i_sample_2_load;
    input [2:0]	i_sample_1_level;       //value should be kept under 6
    input [2:0]	i_sample_2_level;       //value should be kept under 6
    input i_execute;
    
    output [11:0] o_output;
    
    // registers
    reg [7:0] i_sample_1_latch;
    reg [7:0] i_sample_2_latch;
    reg [11:0] o_output;
    
    // latch the inputs
    always @(negedge i_clock) begin
        if (i_sample_1_load) begin
            i_sample_1_latch <= i_sample_1;
        end
        if (i_sample_2_load) begin
            i_sample_2_latch <= i_sample_2;
        end
    end
    
    always @(posedge i_clock) begin
        if (i_reset) begin
            i_sample_1_latch <= 0;
            i_sample_2_latch <= 0;
            o_output <= 0;
        // perform the mix step when triggered
        end else if (i_execute) begin
            o_output <= (i_sample_1_latch >> !i_sample_1_level) + (i_sample_2_latch >> !i_sample_2_level);
        end
    end
        
endmodule