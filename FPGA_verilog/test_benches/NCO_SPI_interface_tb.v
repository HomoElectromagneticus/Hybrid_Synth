`include "../NCO_SPI_interface.v"
`timescale 1us/1ns

module NCO_SPI_interface_tb();
    reg r_CLOCK = 1'b0;
    reg r_RESET = 1'b1;
    reg r_SCLK_tb = 1'b0;
    reg r_CS_tb = 1'b1;        // CS is active-low in SPI
    reg r_MOSI_tb = 1'b0;

    wire w_MISO;
    wire [31:0] w_OUTPUT;
    wire [31:0] w_OUTPUT_LATCH;

    NCO_SPI_interface UUT(
        .i_clock(r_CLOCK),
        .i_reset(r_RESET),
        .i_SCLK(r_SCLK_tb),
        .i_CS(r_CS_tb),
        .i_MOSI(r_MOSI_tb),
        .o_MISO(w_MISO),
        .r_parallel_output(w_OUTPUT),
	.r_parallel_output_latch(w_OUTPUT_LATCH)
    );

    always #1 r_CLOCK <= !r_CLOCK;

    initial begin
        #2;
        r_RESET <= 0;
	#2;
	r_CS_tb <= 0;
	#8;

        repeat (16) begin		//need to repeat 16 times to get 8 bits
            r_MOSI_tb <= !r_MOSI_tb;
            #4;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
	 
        end
        #16;

        repeat (16) begin		//need to repeat 16 times to get 8 bits
            r_MOSI_tb <= 1'b0;
            #4;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
        end
        #16;

        repeat (16) begin		//need to repeat 16 times to get 8 bits
            r_MOSI_tb <= 1'b1;
            #4;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
        end
        #16;
        
        repeat (8) begin		//need to repeat 8 times to get 8 bits
            r_MOSI_tb <= !r_MOSI_tb;
            #4;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
	    r_SCLK_tb <= !r_SCLK_tb;
	    #2;
        end
      
    end
endmodule