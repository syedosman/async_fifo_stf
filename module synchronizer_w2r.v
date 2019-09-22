module synchronizer_w2r
	#(parameter ADDR = 5)
		(input wire [ADDR:0] wptr,
		 input wire rclk,
		 input wire reset_b
		 output reg [ADDR:0] wptr_rd);
		reg [ADDR:0] wptr_rd_tmp;
	always @ (posedge wclk, negedge reset_b)
		if (~reset_b) 		begin
			wptr_tmp <= `h0;
			wptr_rd <= `h0;
		end else begin
			wptr_rd_tmp <= wptr;
			wptr_rd <= wptr_rd_tmp;
		end
endmodule

			

