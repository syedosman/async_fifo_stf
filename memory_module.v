module memory

#(parameter WIDTH = 8, DEPTH = 32, ADDR = 5)
	input wire [ADDR - 1:0] waddr, raddr,
	input wire clk, reset_b,
	input wire write, wfull,
	input wire [WIDTH-1:0] rdata,
	output wire [ADDR-1:0] wdata);


	integer i;
	reg [WIDTH-1:0] memory [DEPTH-1:0];

	always @ (posedge clk, negedge reset_b)
		if (~reset_b)
		for (i=0, i < DEPTH, i=i+1)
			memory[i] = `d0;
		else 
			if (write = !wfull)
				memory [waddr] <= wdata;


		// Data is always available from memory
		assign rdata = memory [raddr]

endmodule