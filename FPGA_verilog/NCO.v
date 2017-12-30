//=============================================================================
// Design Name:		Numerically Controlled Oscillator
// File Name:		NCO.v
// Author:			RM Schaub
// Function:		Implements an NCO that points to an address in a wavetable
//					RAM
//=============================================================================

module NCO(
    i_clock, 
    i_input_latch_write_enable, 
    i_input,
    o_wavesample_address
);

    // inputs and outputs
    // the input latch is 28 bits wide, with the lowest 18 being for wave pitch
    // assignment, the next 3 are for "upper octave select," and the last 7 bits
    // being for wave select. "Upper octave select" just instructs the
    // wavesample address counter to skip some steps to keep the sample rates
    // within the realm of the sane
    input 			i_clock;
    input			i_input_latch_write_enable;
    input [27:0]	i_input;
    
    output [14:0]	o_waveram_address;
    
    // registers and wires
    reg [27:0]		r_input_latch;
    reg [17:0]		r_phase_accumulator;
    reg [7:0]		r_wavesample_address;
    wire [14:0]		o_waveram_address;
    
    // read the input and set the input latch
    always @(negedge i_clock) begin
        if (i_input_latch_write_enable) begin
            r_input_latch <= i_input;
        end
    end

    // increment the phase accumulator by the multiplier portion of the input
    // for every clock pulse
    always @(posedge i_clock) begin
        r_phase_accumulator <= r_phase_accumulator + r_input_latch[17:0];
    end
    
    // if the most significant bit of the phase accumulator transitions from 0
    // to 1, that signals an overflow and the wavesample address should be
    // incremented. the octave select register determines by how much the 
    // wavesample address is incremented. as the desired output pitch raises, 
    // some wavesamples must be "skipped" to keep the sample rate down
    always @(negedge r_phase_accumulator[17]) begin
        if (r_input_latch[20:18] == 0) begin
            r_wavesample_address <= r_wavesample_address + 1;
        end else if (r_input_latch[20:18] == 1) begin
            r_wavesample_address <= r_wavesample_address + 2;
        end else if (r_input_latch[20:18] == 2) begin
            r_wavesample_address <= r_wavesample_address + 4;
        end else if (r_input_latch[20:18] == 3) begin
            r_wavesample_address <= r_wavesample_address + 8;
        end else if (r_input_latch[20:18] == 4) begin
            r_wavesample_address <= r_wavesample_address + 16;
        end else if (r_input_latch[20:18] == 5) begin
            r_wavesample_address <= r_wavesample_address + 32;
        end else if (r_input_latch[20:18] == 6) begin
            r_wavesample_address <= r_wavesample_address + 64;
        end
    end
    
    assign o_waveram_address = {r_input_latch[27:21], r_wavesample_address};
    
endmodule