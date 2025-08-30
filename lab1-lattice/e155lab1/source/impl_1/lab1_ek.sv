module lab1_ek(
	input logic clk,
	input logic [3:0] s,
	output logic [2:0] led,
	output logic [6:0] seg
);

	logic int_osc;
	logic [24:0] counter;
	
	// Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01)) 
          hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
  
    // Counter
    always_ff @(posedge int_osc) begin
      if(reset == 0)  counter <= 0;
      else            counter <= counter + 1;
    end
  
    // Assign LED output
    assign led = counter[24];
	
endmodule

module sevseg(
	input logic [3:0] s,
	output logic [6:0] seg
);

	always_comb
		case (s):
			4'b0000:	seg = 7'b0111111 // 0
			4'b0001:	seg = 7'b0000110 // 1
			4'b0010:	seg = 7'b1011011 // 2
			4'b0011:	seg = 7'b1001111 // 3
			4'b0100:	seg = 7'b1100110 // 4
			4'b0101:	seg = 7'b1101101 // 5
			4'b0110: 	seg = 7'b1111101 // 6
			4'b0111: 	seg = 7'b0000111 // 7
			4'b1000:	seg = 7'b1111111 // 8
			4'b1001:	seg = 7'b1100111 // 9
			4'b1010:	seg = 7'b1110111 // A
			4'b1011:	seg = 7'b1111100 // b
			4'b1100:	seg = 7'b0111001 // C
			4'b1101:	seg = 7'b1011110 // d
			4'b1110:	seg = 7'b1111001 // E
			4'b1111:	seg = 7'b1110001 // F
			default: 		seg = 7'b0111111 // display 0 by default
		endcase
		
endmodule