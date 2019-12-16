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
