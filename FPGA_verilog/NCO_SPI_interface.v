//=============================================================================
// Design Name:		SPI Interface for NCOs
// File Name:		NCO_SPI_interface.v
// Author:			RM Schaub
// Function:		This module implements a SPI interface to control the NCOs
//=============================================================================

module NCO_SPI_interface(
    i_clock,
    i_reset,
    i_SCLK,
    i_CS,
    i_MOSI,
    o_MISO,
    o_parallel_output,
    o_mux_control
);

    // inputs and outputs
    input i_clock;
    input i_SCLK;
    input i_CS;
    input i_MOSI;
    
    inout o_MISO;
    output o_parallel_output;
    output o_mux_control;

    // registers and wires
    reg [2:0] r_SCLK;
    wire w_SCLK_rising_edge;
    wire w_SCLK_falling_edge;

    reg [2:0] r_CS;
    wire w_CS_rising_edge;
    wire w_CS_active;
    wire w_CS_falling_edge;

    reg [1:0] r_MOSI;
    wire w_MOSI_data;

    reg [2:0] r_MOSI_bit_count;
    reg r_byte_received;              //high when a full byte is received
    reg [7:0] r_input_byte;

    reg o_MISO;

    // ========== SYNC THE SPI INPUTS TO THE FPGA ==========
    // sync SPI clock to the FPGA clock
    always @(posedge i_clock) begin
        r_SCLK <= {r_SCLK[1:0], i_SCLK};
    end
    w_SCLK_rising_edge = (r_SCLK[2:1] == 2'b01);
    w_SCLK_falling_edge = (r_SCLK[2:1] == 2'b10);

    // detect the chip select state
    always @(posedge i_clock) begin
        r_CS <= {r_CS[1:0], i_CS};
    end
    w_CS_rising_edge = (r_CS[2:1] == 2'b01);
    w_CS_active = ~r_CS[1];
    w_CS_falling_edge = (r_CS[2:1] == 2'b10);

    // detect the state of the MOSI line
    always @(posedge i_clock) begin
        r_MOSI <= {r_MOSI[1], i_MOSI};
    end
    w_MOSI_data = r_MOSI[1];

    // ========== INPUT ==========
    always @(posedge i_clock) begin
        if (~w_CS_active) begin
            r_MOSI_bit_count <= 0;
        // left-shift the bits in on each positive edge of the SPI clock
        end else if (w_SCLK_rising_edge) begin
            r_MOSI_bit_count <= r_MOSI_bit_count + 1;
            r_input_byte <= {r_input_byte[6:0], w_MOSI_data};
        end
        // byte received flag goes high if we have pulled in a full byte
        r_byte_received <= (w_CS_active && w_CS_rising_edge && (r_MOSI_bit_count == 3'b111));
    end

    // ========== OUTPUT ==========

    // implement a reset
    always @(posedge i_clock) begin
        if (i_reset) begin
            r_SCLK <= 0;
            r_CS <= 0;
            r_MOSI <= 0;
            r_MOSI_bit_count <= 0;
            r_byte_received <= 0;
            r_input_byte <= 0;
        end
    end

endmodule