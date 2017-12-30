//=============================================================================
// Design Name:		Digital Mixer
// File Name:		Mixer.v
// Author:			RM Schaub
// Function:		This module implements a mixer of two 8-bit digital inputs
//					according to a set of control inputs
//=============================================================================

module mixer(
	i_sample_1, 
	i_sample_1_store,
	i_sample_2, 
	i_sample_2_store,
	i_sample_1_level, 
	i_sample_2_level,
	i_execute,
	o_output
);

	//inputs and outputs
	input [7:0]		i_sample_1;
	input			i_sample_1_load;
	input [7:0]		i_sample_2;
	input			i_sample_2_load;
	input [2:0]		i_sample_1_level;
	input [2:0]		i_sample_2_level;
	input			i_execute;
	
	output [11:0]	o_output;
	
	// registers and wires
	reg [7:0]		i_sample_1_latch;
	reg [7:0]		i_sample_2_latch;
	reg [11:0]		o_output;
	
	// latch the inputs
	always @(i_sample_1_load) begin
		if (i_sample_1_load) begin
			i_sample_1_latch <= i_sample_1;
		end
	end
	
	always @(i_sample_2_load) begin
		if (i_sample_2_load) begin
			i_sample_2_latch <= i_sample_2;
		end
	end
	
	// perform the mix step when triggered (there has got to be a better way...)
	always @(i_execute) begin
		if (i_execute) begin
			o_output <= (i_sample_1_latch >> !i_sample_1_level) + (i_sample_2_latch >> !i_sample_2_level);
		end
	end
		
endmodule