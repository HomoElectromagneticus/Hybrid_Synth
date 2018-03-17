`include "../NCO_SPI_interface.v"
`timescale 1us/1ns

module NCO_SPI_interface_tb();
    reg r_CLOCK = 1'b0;
    reg r_RESET = 1'b1;
    reg r_SCLK_tb = 1'b0;
    reg r_CS_tb = 1'b1;                 // CS is active-low in SPI
    reg r_MOSI_tb = 1'b0;

    wire w_MISO;
    wire [31:0] w_OUTPUT;

    NCO_SPI_interface UUT(
        .i_clock(r_CLOCK),
        .i_reset(r_RESET),
        .i_SCLK(r_SCLK_tb),
        .i_CS(r_CS_tb),
        .i_MOSI(r_MOSI_tb),
        .o_MISO(w_MISO),
        .r_parallel_output_latch(w_OUTPUT)
    );

    always #1 r_CLOCK <= !r_CLOCK;

    initial begin
        #2;
        r_RESET <= 0;
        #2;
        r_CS_tb <= 0;
        #8;

        // send 8'b10101010
        repeat (4) begin		        //need to repeat 4 times to get 8 bits
            r_MOSI_tb <= 1'b1;		    //send a 1
            #4;
            r_SCLK_tb <= 1'b1;		    //rising edge
            #8;
            r_SCLK_tb <= !r_SCLK_tb;	//falling edge
            #4;
            r_MOSI_tb <= !r_MOSI_tb;	//send a 0
            #4;
            r_SCLK_tb <= !r_SCLK_tb;	//rising edge
            #8;
            r_SCLK_tb <= ~r_SCLK_tb;	//falling edge
            #4;
        end
        #32;
        
        // send 8'b00000000
        repeat (16) begin		        //need to repeat 16 times to get 8 bits
            r_MOSI_tb <= 1'b0;
            #4;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
        end
        #32;

        // send 8'b11111111
        repeat (16) begin		        //need to repeat 16 times to get 8 bits
            r_MOSI_tb <= 1'b1;
            #4;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
        end
        #32;
            
        // send 8'b11001100
        repeat (2) begin		        //need to repeat 2 times to get 8 bits
            r_MOSI_tb <= 1'b1;
            #4;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
            r_SCLK_tb <= !r_SCLK_tb;
            #4;
            r_MOSI_tb <= 1'b0;
            #4;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
            r_SCLK_tb <= !r_SCLK_tb;
            #8;
            r_SCLK_tb <= !r_SCLK_tb;
            #4;
        end
    
    end

endmodule
