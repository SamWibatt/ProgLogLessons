# PL_L0_BCD7

Platform: Upduino v2 / v2.1

Simple test of writing a non-clocked "always" block that does blocking combinatorial logic. Just because I hadn't done that before. See [the ProgLogLessons wiki under Lesson 0](https://github.com/SamWibatt/ProgLogLessons/wiki/Lesson-00---Combinatorial-logic) for details.

Based on [my VerilogSkeleton project](https://github.com/SamWibatt/VerilogSkeleton) which supplies a blinky.

# Usage

`make all` is intended to build the .bin output file to send to the target hardware. You still need to run iceprog to actually send it.

toolchain is yosys / nextpnr / icepack

`make test` is intended to build a simulation

toolchain is iverilog / vvp / vcd2fst, yielding a .fst file that can be viewed in gtkwave

`make clean` does the usual cleanup of all the non-source files.

Makefile, Makefile.icestorm, and upduino_v2.pcf are copied and modified from osresearch's code at https://github.com/osresearch/up5k licensed under GPL3
