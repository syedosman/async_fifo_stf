module pointer (

	#(parameter ADDR = 5)
	input wire clk, reset_b, op,fifo_status,
	output [ADDR:0] binary, gray);


	wire reg [ADDR:0] binary_next, 
	wire reg [Addr:0] gray_next;

	assign binary_next = binary + (!fifo_status & op);
	assign gray_next = (binary_next>>1) ^ binary_next;

always @ (posedge clk, negedge reset_b)
	if (~reset_b) 		binary <= `h0;
	else 				binary <= binary_next;

always @ (posedge clk, negedge reset_b)
	if (~reset_b) 		gray <= `h0;
	else 				gray <= gray_next;

endmodule