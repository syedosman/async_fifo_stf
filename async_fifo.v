module async_fifo #(parameter DEPTH = 32, WIDTH = 8, ADDR = 5)
	(input wire  write, read,
	 input wire rclk, wclk,
	 input wire rreset_b, wreset_b,
	 input wire [ADDR:0] wdata,

	 output wire [WIDTH-1:0] rdata,
	 output wire 		wfull, empty);

	//Binary Pointer for WR => waddr and RD => raddr of FIFO
	wire [ADDR:0] fifo_wptr, fifo_rptr;
       //   Gray Pointers for WR and RD
	wire [ADDR:0] wptr_gray, rptr_gray;
       //   Synchronized Gray WR/RD Pointers
     wire [ADDR:0] wptr_rd, rptr_wr;
       //   After Gray -> Binary Conversion
	wire [ADDR:0] rptr_bin_wr, wptr_bin_rd; wire wfull_tmp, rempty_tmp;

	function [ADDR:0] gray2binary;
      input [ADDR:0] gray;
      integer i;
      begin
		for (i = 0; i < ADDR; i = i+1) gray2binary[i] = ^(gray>>i);
	  end
      	gray2binary[i] = gray[i];
	endfunction
	assign rptr_bin_wr = gray2binary (rptr_wr); assign wptr_bin_rd = gray2binary (wptr_rd);

	//Instantiation of the modules

	pointer ptr_wr ( 					.op(write)
										.clk(wclk)
										.fifo_status(wfull)
										.reset_b(wreset_b)
										.binary(fifo_wptr)
										.gray(wptr_gray));
	

	pointer ptr_rd (					.op(read)
										.clk(rclk)
										.fifo_status(empty)
										.reset_b(rreset_b)
										.binary(fifo_rptr)
										.gray(rptr_gray));


	synchronizer_w2r sync_0 (			.wptr(wptr_gray)
										.rclk(rclk)
										.reset_b(rreset_b)
										.wptr_rd(wptr_rd));


	synchronizer_r2w  sync_1 (			.rptr(rptr_gray)
										.rclk(wclk)
										.reset_b(wreset_b)
										.rptr_wr(rptr_rd));

	comparator_rd comp_0 ( 				.rptr(fifo_rptr)
										.wptr(wptr_bin_rd)
										.empty(rempty));


	comparator_wr comp_1 (				.wptr(fifo_wptr)
										.rptr(rptr_bin_wr)
										.full(wfull));


	memory m1 ( 						.clk(wclk)
										.reset_b(wreset_b)
										.write(write)
										.wfull(wfull)
										.rdata(rdata)
										.wdata(wdata)
										.waddr(fifo_wptr)
										.raddr(fifo_rptr));

endmodule


function [ADDR:0] gray2binary;
	 input [ADDR:0] gray;
	 integer i;
	 begin
	 	for (i=0; i<ADDR; i=i+1)
	 		gray2binary[i] = ^(gray>>i);
	 end
	 gray2binary[i] = gray[i];
endfuntion

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

module comparator_rd
	#(parameter ADDR = 5)
	(input [ADDR:0] rptr, wptr;
	output wire empty);

	assign empty = (wptr[ADDR:0] == rptr[ADDR:0])
endmodule


module comparator_wr
	#(parameter ADDR = 5)
	(input [ADDR:0] rptr, wptr;
	output wire full);

	assign full = (wptr = [ADDR] != rptr[ADDR]) & (wptr[ADDR-1:0] == rptr[ADDR-1:0]);
endmodule

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

			
module synchronizer_r2w		#(parameter ADDR = 5)
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
 



