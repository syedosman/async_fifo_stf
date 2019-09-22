module comparator_wr
	#(paramter ADDR = 5)
	(input [ADDR:0] rptr, wptr;
	output wire full);

	assign full = (wptr = [ADDR] != rptr[ADDR]) & (wptr[ADDR-1:0] == rptr[ADDR-1:0]);
endmodule
