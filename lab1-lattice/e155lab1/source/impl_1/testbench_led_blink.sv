
module testbench_led_blink();
	
/*
Name: Emily Kendrick
Email: ekendrick@hmc.edu
Date created: 8/31/25
Testbench for the top module 
*/
	logic clk, reset;
	logic led2;
	
	// generate clock
	logic int_osc;
	HSOSC #(.CLKHF_DIV(2'b01)) 
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

	
led_blink dut(int_osc, reset, led2);

endmodule