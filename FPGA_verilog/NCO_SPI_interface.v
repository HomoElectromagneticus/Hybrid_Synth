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
    r_parallel_output_latch
);

    // inputs and outputs
    input i_clock;
    input i_reset;
    input i_SCLK;
    input i_CS;
    input i_MOSI;
    
    inout o_MISO;
    output r_parallel_output_latch;

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

    reg [3:0] r_MOSI_bit_count;
    reg r_byte_received;                //high when a full byte is received
    reg [7:0] r_SPI_SR;		            //8-bit shift register for SPI xfer

    reg o_MISO;

    reg [2:0] r_byte_received_count;
    reg [32:0] r_parallel_output;
    reg [32:0] r_parallel_output_latch;

    // ========== SYNC THE SPI INPUTS TO THE FPGA ==========
    // sync SPI clock to the FPGA clock
    always @(posedge i_clock) begin
        r_SCLK <= {r_SCLK[1:0], i_SCLK};
    end
    assign w_SCLK_rising_edge = (r_SCLK[2:1] == 2'b01);
    assign w_SCLK_falling_edge = (r_SCLK[2:1] == 2'b10);

    // detect the chip select state
    always @(posedge i_clock) begin
        r_CS <= {r_CS[1:0], i_CS};
    end
    assign w_CS_rising_edge = (r_CS[2:1] == 2'b01);
    assign w_CS_active = ~r_CS[1];      //CS is active low for SPI
    assign w_CS_falling_edge = (r_CS[2:1] == 2'b10);

    // detect the state of the MOSI line
    always @(posedge i_clock) begin
        r_MOSI <= {r_MOSI[0], i_MOSI};
    end
    assign w_MOSI_data = r_MOSI[1];

    // ========== INPUT ==========
    always @(posedge i_clock) begin
        // reset the bit and byte counts if the chip isn't selected
        if (~w_CS_active) begin
            r_MOSI_bit_count <= 0;
            r_byte_received_count <= 0;
        // left-shift the bits in on each positive edge of the SPI clock
        end else if (w_SCLK_rising_edge) begin
            r_MOSI_bit_count <= r_MOSI_bit_count + 1;
            r_SPI_SR <= {r_SPI_SR[6:0], w_MOSI_data};
        end
        // byte received flag goes high if we have pulled in a full byte
        r_byte_received <= (w_CS_active && (r_MOSI_bit_count == 4'b1000));
    end

    // ========== HANDLE INPUT BYTES ===========
    always @(negedge i_clock) begin
        if (r_byte_received == 1) begin
            // load each input byte into the parallel output register
            case(r_byte_received_count)
                0: r_parallel_output[7:0] <= r_SPI_SR; 
                1: r_parallel_output[15:8] <= r_SPI_SR;
                2: r_parallel_output[23:16] <= r_SPI_SR;
                3: r_parallel_output[31:24] <= r_SPI_SR;
            endcase
            r_byte_received_count <= r_byte_received_count + 1;
            r_MOSI_bit_count <= 0;
            // r_byte_received will be reset at the next positive clock edge
        end
    end

    // ========== OUTPUT ==========
    // o_MISO is in high-impedance mode if the chip is not selected, but driven
    // to the last input byte otherwise. this implements the SPI "ring buffer"
    assign o_MISO = w_CS_active ? r_SPI_SR[7] : 1'bz;

    always @(posedge i_clock) begin
        // enable 32-bit parallel output if it's ready
        if (r_byte_received_count == 4) begin
            r_parallel_output_latch <= r_parallel_output;
        end
    end

    // implement a reset
    always @(posedge i_clock) begin
        if (i_reset) begin
            r_SCLK <= 0;
            r_CS <= 0;
            r_MOSI <= 0;
            r_MOSI_bit_count <= 0;
            r_byte_received_count <= 0;
            r_byte_received <= 0;
            r_SPI_SR <= 0;
            r_parallel_output <= 0;
            r_parallel_output_latch <= 0;
        end
    end

endmodule
