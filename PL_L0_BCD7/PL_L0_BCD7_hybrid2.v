/*
PL_L0_BCD7_hybrid2.v - implements a purely async/combinatorial BCD to 7-segment converter.

Alternate implementation of PL_L0_BCD7 using an "if" conditioned on the dec flag to see if I can't simplify the graph we get.

So instead of one 5 bit -> 7 bit logic lump, we get two 4-bit -> 7 bit logic lumps.

Generated logic with truth_2_logic.py, qv, with the data files:
BCD7-hybrid2common.csv
BCD7-hybrid2hex.csv

the segments are numbered thus:
     ___
  0 | 1 | 2
    |___|
  3 | 4 | 5
    |___|
      6

So 1 is the top one there, others should be pretty unambiguous.

Truth table: in all cases lsb to right
      val   seg            seg(hex)
if(~dec):
  0:  0000  1 1 0  1 1 1 1 (6F)
  1:  0001  0 1 0  0 1 0 0 (24)
  2:  0010  1 0 1  1 1 1 0 (5E)
  3:  0011  1 1 1  0 1 1 0 (76)
  4:  0100  0 1 1  0 1 0 1 (35)
  5:  0101  1 1 1  0 0 1 1 (73)
  6:  0110  1 1 1  1 0 1 1 (7B)
  7:  0111  0 1 0  0 1 1 0 (26)
  8:  1000  1 1 1  1 1 1 1 (7F)
  9:  1001  1 1 1  0 1 1 1 (77)
  A:  1010  0 1 1  1 1 1 1 (3F)
  B:  1011  1 1 1  1 0 0 1 (79)
  C:  1100  1 0 0  1 0 1 1 (4B)
  D:  1101  1 1 1  1 1 0 0 (7C)
  E:  1110  1 0 1  1 0 1 1 (5B)
  F:  1111  0 0 1  1 0 1 1 (1B)
else:
  0:  0000  1 1 0  1 1 1 1 (6F)
  1:  0001  0 1 0  0 1 0 0 (24)
  2:  0010  1 0 1  1 1 1 0 (5E)
  3:  0011  1 1 1  0 1 1 0 (76)
  4:  0100  0 1 1  0 1 0 1 (35)
  5:  0101  1 1 1  0 0 1 1 (73)
  6:  0110  1 1 1  1 0 1 1 (7B)
  7:  0111  0 1 0  0 1 1 0 (26)
  8:  1000  1 1 1  1 1 1 1 (7F)
  9:  1001  1 1 1  0 1 1 1 (77)
  X:  XXXX  0 0 1  0 0 0 0 (10)


Let's try a show of it thru yosys like this from https://rhye.org/post/fpgas-for-software-engineers-0-basics/

yosys -q << EOF
read_verilog PL_L0_BCD7_if.v; // Read in our verilog file
hierarchy -check; // Check and expand the design hierarchy
proc; opt; // Convert all processes in the design with logic, then optimize
fsm; opt;  // Extract and optimize the finite state machines in the design
synth_ice40 -top top_test;  //will this work? sean adds
show -stretch PL_L0_BCD7_if; // Generate and display a graphviz output of the BCD to 7seg module (sean adds stretch to put all inputs at left, outs at right)
EOF
*/

`default_nettype none

module PL_L0_BCD7_hybrid2(
    input wire[3:0] val,
    input wire dec,
    output reg[6:0] seg
);
    always @(val,dec) begin
        if(val < 10) begin
            //common
            seg[6] = (val[2] & ~val[1] & val[0]) | (~val[2] & ~val[0]) | (~val[2] & val[1]) | (val[3]) | (val[1] & ~val[0]);
            seg[5] = (val[0]) | (val[2]) | (~val[1]);
            seg[4] = (~val[2] & val[1]) | (val[3]) | (val[1] & ~val[0]) | (val[2] & ~val[1]);
            seg[3] = (~val[2] & ~val[0]) | (val[1] & ~val[0]);
            seg[2] = (~val[2]) | (~val[1] & ~val[0]) | (val[1] & val[0]);
            seg[1] = (val[1]) | (val[2] & val[0]) | (val[3]) | (~val[2] & ~val[0]);
            seg[0] = (~val[1] & ~val[0]) | (val[3]) | (val[2] & ~val[1]) | (val[2] & ~val[0]);
        end else if(~dec) begin
            //hex
            seg[6] = (~val[1]) | (~val[2] & val[0]) | (val[2] & ~val[0]);
            seg[5] = (~val[2]) | (~val[1] & val[0]);
            seg[4] = (val[0]) | (val[1]);
            seg[3] = 1;     //truth_2_logic emitted "();"
            seg[2] = (~val[1] & val[0]) | (~val[2] & ~val[0]);
            seg[1] = (~val[0]) | (val[2] & val[1]);
            seg[0] = (~val[0]) | (val[1]);
        end else begin
            seg = 7'b0010000;            //see if this causes the loop problem; if so, try a bit of logic - looks good!
        end
    end
endmodule
