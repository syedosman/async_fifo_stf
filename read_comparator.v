module comparator_rd
	#(parameter ADDR = 5)
	(input [ADDR:0] rptr, wptr;
	output wire empty);

	assign empty = (wptr[ADDR:0] == rptr[ADDR:0])
endmodule