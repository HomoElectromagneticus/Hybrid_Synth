`include "../mixer.v"
`timescale 1us/1ns

module mixer_tb();
    reg r_CLOCK = 1'b0;
    reg r_RESET = 1'b1;
    reg [7:0] r_SAMPLE = 8'h00;
    reg r_SAMPLE_1_LOAD = 1'b0;
    reg r_SAMPLE_2_LOAD = 1'b0;
    reg [2:0] r_SAMPLE_1_LEVEL = 3'b000;
    reg [2:0] r_SAMPLE_2_LEVEL = 3'b000;
    reg r_EXECUTE = 1'b0;

    wire [11:0] w_OUTPUT;

    //instantiate the unit under test
    mixer UUT(
        .i_clock(r_CLOCK),
        .i_reset(r_RESET),
        .i_sample(r_SAMPLE),
        .i_sample_1_load(r_SAMPLE_1_LOAD),
        .i_sample_2_load(r_SAMPLE_2_LOAD),
        .i_sample_1_level(r_SAMPLE_1_LEVEL),
        .i_sample_2_level(r_SAMPLE_2_LEVEL),
        .i_execute(r_EXECUTE),
        .o_output(w_OUTPUT)
    );

    always #1 r_CLOCK = !r_CLOCK;

    initial begin
        #2
        r_RESET <= 0;
        #5
        r_SAMPLE <= 60;
        #1
        r_SAMPLE_1_LOAD <= 1;
        #2
        r_SAMPLE_1_LOAD <= 0;
        #1
        r_SAMPLE <= 80;
        #1
        r_SAMPLE_2_LOAD <= 1;
        #2
        r_SAMPLE_2_LOAD <= 0;
        #2
        r_EXECUTE <= 1;
        #2
        r_EXECUTE <= 0;
        #2
        r_SAMPLE_1_LEVEL <= 3'b111;       //turn wave 1 off
        #2
        r_EXECUTE <= 1;
        #2
        r_EXECUTE <= 0;
        #2
        r_SAMPLE_1_LEVEL <= 3'b000;       //turn wave 1 on
        r_SAMPLE_2_LEVEL <= 3'b111;       //turn wave 2 off
        #2
        r_EXECUTE <= 1;
        #2
        r_EXECUTE <= 0;
        #2
        r_SAMPLE_1_LEVEL <= 3'b001;       //turn wave 1 on, but divide by 2
        r_SAMPLE_2_LEVEL <= 3'b001;       //turn wave 2 on, but divide by 2
        #2
        r_EXECUTE <= 1;
        #2
        r_EXECUTE <= 0;
    end

endmodule