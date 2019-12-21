//top.v - "main" or "controller" for sram project
`default_nettype none

//`include "sram.v"

module top(
    output wire led_g,              //alive-blinky, use rgb green ... from controller
    output wire led_b,                  //blue led bc rgb driver needs it
    output wire led_r,                   //red led
    output wire[6:0] segout         // 7 segment display segments, active low. See below for how to use w/active high.
    );

    wire clk;
    wire reset = 0;

    //let's do a 6MHz clock for now, speed up later if I feel like it; for now it's all about getting stuff to work and not nec. be fast
    //The SB_HFOSC primitive contains the following parameter and their default values:
    //Parameter CLKHF_DIV = 2’b00 : 00 = div1, 01 = div2, 10 = div4, 11 = div8 ; Default = “00”
    //div8 = 6MHz
    SB_HFOSC #(.CLKHF_DIV("0b11")) u_hfosc (
		.CLKHFPU(1'b1),
		.CLKHFEN(1'b1),
		.CLKHF(clk)
	);

    //looks like the pwm parameters like registers - not quite sure how they work, but let's
    //just create some registers and treat them as active-high ... Well, we'll see what we get.
    //these work basically like an "on" bit, just write a 1 to turn LED on. PWM comes from you
    //switching it on and off and stuff.
    reg led_r_pwm_reg = 0;
    reg led_g_pwm_reg = 0;
    reg led_b_pwm_reg = 0;

    SB_RGBA_DRV rgb (
      .RGBLEDEN (1'b1),         // enable LED
      .RGB0PWM  (led_g_pwm_reg),    //these appear to be single-bit parameters. ordering determined by experimentation and may be wrong
      .RGB1PWM  (led_b_pwm_reg),    //driven from registers within counter arrays in every example I've seen
      .RGB2PWM  (led_r_pwm_reg),    //so I will do similar
      .CURREN   (1'b1),         // supply current; 0 shuts off the driver (verify)
      .RGB0     (led_g),    //Actual Hardware connection - output wires. looks like it goes 0=green
      .RGB1     (led_b),        //1 = blue
      .RGB2     (led_r)         //2 = red - but verify
    );
    defparam rgb.CURRENT_MODE = "0b1";          //half current mode
    defparam rgb.RGB0_CURRENT = "0b000001";     //4mA for Full Mode; 2mA for Half Mode
    defparam rgb.RGB1_CURRENT = "0b000001";     //see SiliconBlue ICE Technology doc
    defparam rgb.RGB2_CURRENT = "0b000001";

    // alive-blinky wires:
    //wire led_g_outwire;
    wire led_b_outwire; // = greenblinkct[GREENBLINKBITS-1];
    //wire led_r_outwire;

    //then the blinky module proper
    //let us have it blink on the blue upduino LED.
    blinky blinkus(.i_clk(clk),.o_led(led_b_outwire));

    //pure-comblogic version: Info: Max frequency for clock 'clk': 68.96 MHz (PASS at 12.00 MHz)
    reg[4:0] count = 0;         //input value to bcd, s.t. count[4] is dec bit, count[3:0] the 4-bit input
    wire[6:0] segraw;           //output from bcd to 7-segment module
    PL_L0_BCD7 bcd27seg(
        .val(count[3:0]),
        .dec(count[4]),
        .seg(segraw)            // segraw is active high, which you may not want
    );

    /*
    //try the version with only case/if - hm Info: Max frequency for clock 'clk': 61.20 MHz (PASS at 12.00 MHz)
    //wire[6:0] segout_if;
    PL_L0_BCD7_if bcd27seg_if(
        .val(count[3:0]),
        .dec(count[4]),
        .seg(segraw)
    );
    */

    //here converting to what we want for output from segraw. Active low means they need inverting.
    //active high, you could probably comment this and segraw declaration out and use segout in the .seg() line
    //of the instantiation of bcd27seg above.
    assign segout[0] = ~segraw[0];
    assign segout[1] = ~segraw[1];
    assign segout[2] = ~segraw[2];
    assign segout[3] = ~segraw[3];
    assign segout[4] = ~segraw[4];
    assign segout[5] = ~segraw[5];
    assign segout[6] = ~segraw[6];



    parameter PWMbits = 3;              // for dimming have LED on only 1/2^PWMbits of the time
    reg[PWMbits-1:0] pwmctr = 0;
    parameter countbits = 22;           //23 too slow
    reg[countbits-1:0] counttimer;      // for timing the advance of the display
    always @(posedge clk) begin
        //this should drive the blinkingness
        led_b_pwm_reg <= (&pwmctr) & led_b_outwire;
        pwmctr <= pwmctr + 1;
        //and this the bcd output - just cycle the counter and high bit is "dec" and the lower 4 are the 7-seg
        //do this when counttimer is all 1s, say
        if(&counttimer) begin
            count <= count + 1;
        end
        counttimer <= counttimer + 1;
    end


endmodule
