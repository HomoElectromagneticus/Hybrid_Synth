//=============================================================================
// Design Name:		Wavetable RAM
// File Name:		Wavetable_RAM.v
// Author:			RM Schaub
// Function:		A RAM module!
//=============================================================================

module Wavetable_RAM(
    i_clock, 
    i_address, 
    i_data_in, 
    i_write_enable, 
    o_data_out
);

    // inputs and outputs
    input 			i_clock;
    input [15:0]	i_address;
    input [7:0]		i_data_in;
    input			i_write_enable;
    
    output [7:0]	o_data_out;
    
    // registers and wires
    reg [7:0] 		memory [0:65535];	// 64kB of memory using 8 bit words
    reg [7:0]		o_data_out;
    
    // function
    always @(posedge i_clock) begin
        if (i_write_enable) begin
            memory[i_address] <= i_data_in;
        end
        o_data_out <= memory[i_address];
    end
    
endmodule