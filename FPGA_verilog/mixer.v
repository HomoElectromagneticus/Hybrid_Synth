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
    i_sample, 
    i_sample_1_load,
    i_sample_2_load,
    i_sample_1_level, 
    i_sample_2_level,
    i_execute,
    o_output
);

    //inputs and outputs
    input i_clock;
    input i_reset;
    input [7:0]	i_sample;
    input i_sample_1_load;
    input i_sample_2_load;
    input [2:0]	i_sample_1_level;       //value should be kept under 6
    input [2:0]	i_sample_2_level;       //value should be kept under 6
    input i_execute;
    
    output [11:0] o_output;
    
    // registers
    reg [7:0] r_sample_1_latch;
    reg [7:0] r_sample_2_latch;
    reg [2:0] r_sample_1_level_latch;
    reg [2:0] r_sample_2_level_latch;
    reg [11:0] o_output;
    
    // latch the inputs to protect against mid-execution input stage change
    // weirdness
    always @(negedge i_clock) begin
        if (i_sample_1_load) begin
            r_sample_1_latch <= i_sample;
            r_sample_1_level_latch <= i_sample_1_level;
        end
        if (i_sample_2_load) begin
            r_sample_2_latch <= i_sample;
            r_sample_2_level_latch <= i_sample_2_level;
        end
    end
    
    always @(posedge i_clock) begin
        if (i_reset) begin
            r_sample_1_latch <= 0;
            r_sample_2_latch <= 0;
            o_output <= 0;
        // perform the mix step when triggered
        end else if (i_execute) begin
            o_output <= (r_sample_1_latch >> !r_sample_1_level_latch) + (r_sample_2_latch >> !r_sample_2_level_latch);
        end
    end
        
endmodule