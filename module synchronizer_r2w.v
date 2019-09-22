module synchronizer_r2w
#(parameter ADDR = 5)
	(input wire [ADDR:0] rptr,
 	input wire wclk,
 	input wire reset_b,
 	output reg [ADDR:0] rptr_wr);
 	reg  [ADDR:0] rptr_wr_tmp;
 	always @ (posedge wclk, negedge reset_b)
 	if (~reset_b)	begin
 		rpt_wr <= `h0;
 		rpt_wr_tmp <= `h0;
 	end else begin 
 		rpt_wr_tmp <= rptr;
 		rptr_wr <= rpt_wr_tmp;
 	end
 endmodule
 


