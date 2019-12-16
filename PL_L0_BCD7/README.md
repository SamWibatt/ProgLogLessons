# VerilogSkeleton

Skeleton project for Verilog / IceStorm.

The idea is to make top.v the main module for the .bin file, and top_test.v is the testbench top module. You can have any number of submodules - see Makefile for how to organize this.

# Usage

`make all` is intended to build the .bin output file to send to the target hardware

toolchain is yosys / nextpnr / icepack

`make test` is intended to build a simulation

toolchain is iverilog / vvp / vcd2fst, yielding a .fst file that can be viewed in gtkwave

`make clean` does the usual cleanup of all the non-source files.

stdout and stderr are redirected during the compile, to build_top_out.txt and build_top_err.txt for the "all" target, to sim_top_tb_out.txt and sim_top_tb_err.txt in the "test" target.

*need to test `make flash` and `make gui` and `make pll`*

Makefile, Makefile.icestorm, and upduino_v2.pcf are copied and modified from osresearch's code at https://github.com/osresearch/up5k licensed under GPL3

# test to see if markdown on github can syntax highlight verilog

Oh wow it looks like the Atom previewer, anyway

And indeed github does too!

```verilog
//Based on Dan Gisselquist's blinky at https://zipcpu.com/blog/2017/05/19/blinky.html
`default_nettype none

module blinky(
    input wire i_clk,
    output wire o_led
);

    parameter CBITS = 26;

    reg	[CBITS-1:0]	counter = 0;
    always @(posedge i_clk)
    counter <= counter + 1'b1;
    assign o_led = counter[CBITS-1];
endmodule
```
