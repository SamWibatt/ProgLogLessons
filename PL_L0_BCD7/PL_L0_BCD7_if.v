/*
PL_L0_BCD7_if.v - implements a purely async/combinatorial BCD to 7-segment converter.

Alternate implementation of PL_L0_BCD7 using an "if" conditioned on the dec flag to see if I can't simplify the graph we get.

So instead of one 5 bit -> 7 bit logic lump, we get two 4-bit -> 7 bit logic lumps.
...and possibly not even that. They're the same up to 9. Can we also do an if val < 10?
Let's first try the two lumps way - nah, let's do it the awesome way with two ifs and see what if val < 10 does, if it's even legal

Would it be better just to do a damn case statement? LET'S TRY THAT!

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

if val < 9:
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

if dec == 0:
  A:  1010  0 1 1  1 1 1 1 (3F)
  B:  1011  1 1 1  1 0 0 1 (79)
  C:  1100  1 0 0  1 0 1 1 (4B)
  D:  1101  1 1 1  1 1 0 0 (7C)
  E:  1110  1 0 1  1 0 1 1 (5B)
  F:  1111  0 0 1  1 0 1 1 (1B)
else:
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

// *****************************************************************************************************************************************************************
// *****************************************************************************************************************************************************************
// *****************************************************************************************************************************************************************
// CURRENTLY UNCHANGED FROM ORIGINAL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// *****************************************************************************************************************************************************************
// *****************************************************************************************************************************************************************
// *****************************************************************************************************************************************************************

`default_nettype none

module PL_L0_BCD7_if(
    input wire[3:0] val,
    input wire dec,
    output reg[6:0] seg
);
    always @(val,dec) begin
        if(val < 10) begin
            case (val)
                4'b0000: seg = 7'b1101111; // (6F)
                4'b0001: seg = 7'b0100100; // (24)
                4'b0010: seg = 7'b1011110; // (5E)
                4'b0011: seg = 7'b1110110; // (76)
                4'b0100: seg = 7'b0110101; // (35)
                4'b0101: seg = 7'b1110011; // (73)
                4'b0110: seg = 7'b1111011; // (7B)
                4'b0111: seg = 7'b0100110; // (26)
                4'b1000: seg = 7'b1111111; // (7F)
                4'b1001: seg = 7'b1110111; // (77)
            endcase
        end else if(~dec) begin
            case (val)
                4'b1010: seg = 7'b0111111; // (3F)
                4'b1011: seg = 7'b1111001; // (79)
                4'b1100: seg = 7'b1001011; // (4B)
                4'b1101: seg = 7'b1111100; // (7C)
                4'b1110: seg = 7'b1011011; // (5B)
                4'b1111: seg = 7'b0011011; // (1B)
            endcase
        end else begin
            seg = 7'b0010000;           //the actual logic for this case!
        end
    end
endmodule
