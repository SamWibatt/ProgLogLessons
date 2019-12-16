/*
PL_L0_BCD7.v - implements a purely async/combinatorial BCD to 7-segment converter.

val is a 4-bit input of the value we want to display
hex is 0 if we only want to display 0-9, 1 if we want 0-F. Values A-F when hex is 0 will just show "-"
- maybe blank later but for now do a - so we know something is being driven.
seg represents the 7 segments on the display, active high. Will probably invert to drive LEDs.

Where the segments are numbered thus:
     ___
  0 | 1 | 2
    |___|
  3 | 4 | 5
    |___|
      6

So 1 is the top one there, others should be pretty unambiguous.

Truth table: in all cases lsb to right
    hex  val   seg            seg(hex)
  0:  0  0000  1 1 0  1 1 1 1 (6F)
  1:  0  0001  0 1 0  0 1 0 0 (24)
  2:  0  0010  1 0 1  0 1 1 0 (56)
  3:  0  0011  1 1 1  0 1 1 0 (76)
  4:  0  0100  0 1 1  0 1 0 1 (35)
  5:  0  0101  1 1 1  0 0 1 1 (73)
  6:  0  0110  1 1 1  1 0 1 1 (7B)
  7:  0  0111  0 1 0  0 1 1 0 (26)
  8:  0  1000  1 1 1  1 1 1 1 (7F)
  9:  0  1001  1 1 1  0 1 1 1 (77)
  A:  0  1010  0 1 1  1 1 1 1 (3F)
  B:  0  1011  1 1 1  1 0 0 1 (79)
  C:  0  1100  1 0 0  1 0 1 1 (4B)
  D:  0  1101  1 1 1  1 1 0 0 (7C)
  E:  0  1110  1 0 1  1 0 1 1 (5B)
  F:  0  1111  0 0 1  1 0 1 1 (1B)

  0:  1  0000  1 1 0  1 1 1 1 (6F)
  1:  1  0001  0 1 0  0 1 0 0 (24)
  2:  1  0010  1 0 1  0 1 1 0 (56)
  3:  1  0011  1 1 1  0 1 1 0 (76)
  4:  1  0100  0 1 1  0 1 0 1 (35)
  5:  1  0101  1 1 1  0 0 1 1 (73)
  6:  1  0110  1 1 1  1 0 1 1 (7B)
  7:  1  0111  0 1 0  0 1 1 0 (26)
  8:  1  1000  1 1 1  1 1 1 1 (7F)
  9:  1  1001  1 1 1  0 1 1 1 (77)
  A:  1  1010  0 0 0  1 0 0 0 (08)
  B:  1  1011  0 0 0  1 0 0 0 (08)
  C:  1  1100  0 0 0  1 0 0 0 (08)
  D:  1  1101  0 0 0  1 0 0 0 (08)
  E:  1  1110  0 0 0  1 0 0 0 (08)
  F:  1  1111  0 0 0  1 0 0 0 (08)

  So how do I turn that into logic? Should I just do it the stupid way and let the tool chain optimize?
  That could be an interesting exercise OR since it's no longer 1988 and I don't have to do everything by hand
  maybe a tool like this could help: http://www.32x8.com/index.html

  per which
  seg 0 = y = A'D'E' + B'D'E' + B'CD' + B'CE' + BC'D' + A'BD
  seg 1 = y = B'D + B'C'E' + B'CE + A'CD + BC'D' + A'BE'
  seg 2 = y = B'C' + C'D' + A'C'E' + B'D'E' + B'DE + A'BD'E
  seg 3 = y = BD + BC + C'D'E' + CDE'
  seg 4 = y = B'C'D + A'DE' + B'DE' + B'CD' + BC'D' + A'BE
  seg 5 = y = C'D' + B'E + B'C + A'D'E + A'BC'
  seg 6 = y = B'C'E' + B'C'D + B'DE' + A'BD' + BC'D' + A'C'DE + B'CD'E + A'CDE'

  where A = hex, B = val[3], ... E = val[0]
*/


`default_nettype none

module PL_L0_BCD7(
    input wire[3:0] val,
    input wire hex,
    output reg[6:0] seg
);

    //Here is the combinatorial logic for the BCD to 7 seg converter.
    //should trigger whenever the
    always @(val, hex) begin
        seg[0] = (~hex & ~val[1] & ~val[0]) | (~val[3] & ~val[1] & ~val[0]) | (~val[3] & val[2] & ~val[1]) | (~val[3] & val[2] & ~val[0]) | (val[3] & ~val[2] & ~val[1]) | (~hex & val[3] & val[1]);
        seg[1] = (~val[3] & val[1]) | (~val[3] & ~val[2] & ~val[0]) | (~val[3] & val[2] & val[0]) | (~hex & val[2] & val[1]) | (val[3] & ~val[2] & ~val[1]) | (~hex & val[3] & ~val[0]);
        seg[2] = (~val[3] & ~val[2]) | (~val[2] & ~val[1]) | (~hex & ~val[2] & ~val[0]) | (~val[3] & ~val[1] & ~val[0]) | (~val[3] & val[1] & val[0]) | (~hex & val[3] & ~val[1] & val[0]);
        seg[3] = (val[3] & val[1]) | (val[3] & val[2]) | (~val[2] & ~val[1] & ~val[0]) | (val[2] & val[1] & ~val[0]);
        //seg[4] = (~hex & ~val[2] & val[1]) | (~hex & val[1] & ~val[0]) | (~val[3] & val[2] & ~val[1]) | (val[3] & ~val[2] & ~val[1]) | (~hex & val[3] & val[0]) | (hex & ~val[3] & val[1]);
        //seg[4] = (~val[3] & ~val[2] & val[1]) + (~hex & val[1] & ~val[0]) + (~val[3] & val[1] & ~val[0]) + (~val[3] & val[2] & ~val[1]) + (val[3] & ~val[2] & ~val[1]) + (~hex & val[3] & val[0]);
        seg[4] =   (~val[3] & ~val[2] & val[1]) | (~hex & val[1] & ~val[0]) | (~val[3] & val[1] & ~val[0]) | (~val[3] & val[2] & ~val[1]) | (val[3] & ~val[2] & ~val[1]) | (~hex & val[3] & val[0]);
        seg[5] = (~val[2] & ~val[1]) | (~val[3] & val[0]) | (~val[3] & val[2]) | (~hex & ~val[1] & val[0]) | (~hex & val[3] & ~val[2]);
        seg[6] = (~val[3] & ~val[2] & ~val[0]) | (~val[3] & ~val[2] & val[1]) | (~val[3] & val[1] & ~val[0]) | (~hex & val[3] & ~val[1]) | (val[3] & ~val[2] & ~val[1]) | (~hex & ~val[2] & val[1] & val[0]) | (~val[3] & val[2] & ~val[1] & val[0]) | (~hex & val[2] & val[1] & ~val[0]);
    end
endmodule
