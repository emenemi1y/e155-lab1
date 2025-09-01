module top(
	input logic [3:0] s,
	input logic reset,
	output logic [2:0] led,
	output logic [6:0] seg
);

	logic int_osc;
	HSOSC #(.CLKHF_DIV(2'b01)) 
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	led_blink blink_led_logic(int_osc, reset, led);
	leds led_logic(s, led);
	sevseg sevseg_logic(s, seg);

	
endmodule

module led_blink(
	input logic int_osc,
	input logic reset,
	output logic [2:0] led
);
	
	logic [24:0] counter;
	logic [24:0] NUM_CYCLES;
	
	assign NUM_CYCLES = 24'd9_999_999;
	
    // Counter
    always_ff @(posedge int_osc) begin
	  if (reset == 0) begin
		  counter <= 0;
		  led[2] <= 0;
	  end
      if(counter == NUM_CYCLES) begin
		  counter <= 0;
		  led[2] <= ~led[2];
      end
      else counter <= counter + 1;
    end

endmodule    
	

module leds(
	input logic [3:0] s,
	output logic [2:0] led
);

	always_comb begin
		led[0] = s[0] ^ s[1];
		led[1] = s[2] && s[3];
	end
		
endmodule



module sevseg(
	input logic [3:0] s,
	output logic [6:0] seg
);

	always_comb begin
		case (s)
			4'b0000:	seg = 7'b1000000; // 0
			4'b0001:	seg = 7'b1111001; // 1
			4'b0010:	seg = 7'b0100100; // 2
			4'b0011:	seg = 7'b0110000; // 3
			4'b0100:	seg = 7'b0011001; // 4
			4'b0101:	seg = 7'b0010010; // 5
			4'b0110: 	seg = 7'b0000010; // 6
			4'b0111: 	seg = 7'b1111000; // 7
			4'b1000:	seg = 7'b0000000; // 8
			4'b1001:	seg = 7'b0011000; // 9
			4'b1010:	seg = 7'b0001000; // A
			4'b1011:	seg = 7'b0000011; // b
			4'b1100:	seg = 7'b1000110; // C
			4'b1101:	seg = 7'b0100001; // d
			4'b1110:	seg = 7'b0000110; // E
			4'b1111:	seg = 7'b0001110; // F
			default: 	seg = 7'b1000000; // display 0 by default
		endcase		
	end
endmodule