module testbench_sevseg();
	logic clk, reset;
	logic [3:0] s;
	logic [6:0] seg, seg_exp;
	logic [31:0] vectornum, errors;
	logic [12:0] testvectors[10000:0];
	
sevseg dut(s, seg);

// generate clock
always
	begin
		// create clock -- period = 10 ticks
		clk = 1; #5; clk = 0; #5;
	end

initial
	begin
		// read test vectors
		$readmemb("sevseg_tv.tv", testvectors);
		// number of vectors, number of errors
		vectornum = 0;
		errors = 0;
		reset = 0; #22; reset = 1;
	end
	
always @(posedge clk)
	begin
		#1;
		{s, seg_exp} = testvectors[vectornum];
	end
	
always @(negedge clk)
	if(~reset) begin
		// check if outputs from DUT match expected values
		if(seg != seg_exp) begin
			$display("Error: inputs = %b", s);
			$display(" outputs = %b (%b expected)", seg, seg_exp);
			errors = errors + 1;
		end
		
		vectornum = vectornum + 1;
		
		if(testvectors[vectornum] === 13'bx) begin
			$display("%d tests completed with %d errors", vectornum, errors);
			$stop;
		end
		
	end

endmodule