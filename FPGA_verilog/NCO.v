//=============================================================================
// Design Name:		Numerically Controlled Oscillator
// File Name:		NCO.v
// Author:			RM Schaub
// Function:		Implements an NCO that points to an address in a wavetable
//					RAM
//=============================================================================

module NCO(
    i_clock, 
    i_reset,
    i_input_latch_write_enable, 
    i_input,
    o_waveram_address
);

    // inputs and outputs
    // the input latch is 24 bits wide, with the lowest 16 being for wave pitch
    // assignment, the next 2 are for "upper octave select," and the last 6 bits
    // being for wave select. "Upper octave select" just instructs the
    // wavesample address counter to skip some steps to keep the sample rates
    // within the realm of the sane
    input i_clock;
    input i_reset;
    input i_input_latch_write_enable;
    input [26:0] i_input;
    
    output [12:0] o_waveram_address;
    
    // registers and wires
    reg [15:0] r_pa_multiplier;         // multiplier for the phase accum.
    reg [1:0] r_octave_select;
    reg [5:0] r_wave_select;
    reg [17:0] r_phase_accumulator;
    reg [6:0] r_wavesample_address;     // 128 samples per wave
    reg [5:0] r_wave_address;           // 64 waves per wavetable

    wire [12:0] o_waveram_address;      // 8192 unique samples in RAM
    
    // read the input and set the latched registers
    always @(negedge i_clock) begin
        if (i_input_latch_write_enable) begin
            r_pa_multiplier <= i_input[15:0];
            r_octave_select <= i_input[17:16];
            r_wave_select <= i_input[23:18];
        end
    end

    always @(posedge i_clock) begin
        if (i_reset) begin
            r_phase_accumulator <= 0;
            r_wave_address <= 0;
            r_wavesample_address <= -1;		//the register will not actually 
                                            //reset to zero unless this is "-1."
                                            //i don't get it either...
        end else begin
        	// increment the phase accumulator by the multiplier portion of the 
            // input for every clock pulse
        	r_phase_accumulator <= r_phase_accumulator + r_pa_multiplier;
        	// limit changing waves within the wavetable to moments when there 
            // are known zero crossings in the wave. we can only be 100% of a 
            // zero at the very first wavesample (and at the "middle" 
            // wavesample as well?)
        	if (r_wavesample_address == 0) begin
            		r_wave_address <= r_wave_select;
	    	end
	    end
    end
    
    // if the most significant bit of the phase accumulator transitions from 0
    // to 1, that signals an overflow and the wavesample address should be
    // incremented. the octave select register determines by how much the 
    // wavesample address is incremented. as the desired output pitch raises, 
    // some wavesamples must be "skipped" to keep the sample rate down
    always @(negedge r_phase_accumulator[17]) begin
        if (r_octave_select == 0) begin
            r_wavesample_address <= r_wavesample_address + 1;
        end else if (r_octave_select == 1) begin
            r_wavesample_address <= r_wavesample_address + 2;
        end else if (r_octave_select == 2) begin
            r_wavesample_address <= r_wavesample_address + 4;
        end else if (r_octave_select == 3) begin
            r_wavesample_address <= r_wavesample_address + 8;
        end
    end
    
	assign o_waveram_address = {r_wave_address, r_wavesample_address};
    
endmodule