//seeing if this is how to do a testbench for a module

`default_nettype none



//`include "sram.v"

// FOR STARTERS JUST USING CLIFFORD WOLF'S BLINKY
module top_test();
    //and then the clock, simulation style
    reg clk = 1;
    //make easier-to-count gtkwave values by having a system tick be 10 clk ticks
    always #5 clk = (clk === 1'b0);

    wire led_b_outwire;
    reg led_reg = 0;

    //then the sram module proper, currently a blinkois
    //let us have it blink on the blue upduino LED.
    // test using smaller counter so we don't have to run a jillion cycles in gtkwave
    // ....well, this module should always be compiled with TEST defined but... wev
    `ifdef TEST
    parameter cbits = 4;
    `else
    parameter cbits = 22;       //originally 26 but this is better for 6 MHz
    `endif
    blinky #(.CBITS(cbits)) blinkus(.i_clk(clk),.o_led(led_b_outwire));

    reg[4:0] count = 0;
    wire[6:0] segout;
    PL_L0_BCD7 bcd27seg(
        .val(count[3:0]),
        .dec(count[4]),
        .seg(segout)
    );

    //try the version with only case/if
    wire[6:0] segout_if;
    PL_L0_BCD7_if bcd27seg_if(
        .val(count[3:0]),
        .dec(count[4]),
        .seg(segout_if)
    );

    //try the version with unsimplified logic
    wire[6:0] segout_unsimp;
    PL_L0_BCD7_if bcd27seg_us(
        .val(count[3:0]),
        .dec(count[4]),
        .seg(segout_unsimp)
    );

    //try the version with if/opt logic
    wire[6:0] segout_hybrid;
    PL_L0_BCD7_hybrid bcd27seg_hybrid(
        .val(count[3:0]),
        .dec(count[4]),
        .seg(segout_hybrid)
    );

    //try the other version with if/opt logic
    wire[6:0] segout_hybrid2;
    PL_L0_BCD7_hybrid2 bcd27seg_hybrid2(
        .val(count[3:0]),
        .dec(count[4]),
        .seg(segout_hybrid2)
    );

    always @(posedge clk) begin
        //this should drive the blinkingness
        led_reg <= led_b_outwire;

        //and this the bcd output - just cycle the counter and high bit is "dec" and the lower 4 are the 7-seg
        count <= count + 1;
    end

    //bit for creating gtkwave output
    /* dunno if we need this with the makefile version - Maybe, it's hanging - aha, bc I hadn't made clean and had a non-finishing version */
    initial begin
        //uncomment the next two for gtkwave?
        $dumpfile("top_test.vcd");
        $dumpvars(0, top_test);
    end

    initial begin
        $display("and away we go!!!1");
        #325 $finish;           //longer sim, mask clock is now 16 bits. 5 sec run on vm, 30M vcd.
    end

endmodule
