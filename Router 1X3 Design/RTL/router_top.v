module router_top(input clk, resetn, packet_valid, read_enb_0, read_enb_1, read_enb_2,
				  input [7:0]datain, 
				  output vld_out_0, vld_out_1, vld_out_2, err, busy,
				  output [7:0]data_out_0, data_out_1, data_out_2);



//fifo
wire empty_0,empty_1,empty_2;
wire full_0,full_1,full_2;
wire [7:0]data_out_reg;
wire [2:0]write_enb_sync;
wire soft_reset_0,soft_reset_1,soft_reset_2;
wire lfd_state;




router_fifo f1    (			.clk(clk),
					.resetn(resetn),
					.soft_reset(soft_reset_0),
					.write_enb(write_enb_sync[0]),
					.read_enb(read_enb_0),
					.lfd_state(lfd_state),
					.datain(data_out_reg),
					.full(full_0),
					.empty(empty_0),
					.dataout(data_out_0));

router_fifo f2   (			.clk(clk),
					.resetn(resetn),
					.soft_reset(soft_reset_1),
					.write_enb(write_enb_sync[1]),
					.read_enb(read_enb_1),
					.lfd_state(lfd_state),
					.datain(data_out_reg),
					.full(full_1),
					.empty(empty_1),
					.dataout(data_out_1));


router_fifo f3    (			.clk(clk),
					.resetn(resetn),
					.soft_reset(soft_reset_2),
					.write_enb(write_enb_sync[2]),
					.read_enb(read_enb_2),
					.lfd_state(lfd_state),
					.datain(data_out_reg),
					.full(full_2),
					.empty(empty_2),
					.dataout(data_out_2));



		  
router_reg register( .clk(clk),
				.resetn(resetn),
				.packet_valid(packet_valid),
				.fifo_full(fifo_full),
				.detect_add(detect_add),
				.ld_state(ld_state),
				.laf_state(laf_state),
				.full_state(full_state),
				.lfd_state(lfd_state),
				.rst_int_reg(rst_int_reg),
				.datain(datain),
				.err(err),
				.parity_done(parity_done),
				.low_packet_valid(low_packet_valid),
				.dout(data_out_reg));  


router_sync sync(.clk(clk),
				 .resetn(resetn), 
				 .detect_add(detect_add), 
				 .full_0(full_0), 
				 .full_1(full_1), 
				 .full_2(full_2), 
				 .empty_0(empty_0), 
				 .empty_1(empty_1), 
				 .empty_2(empty_2), 
				 .write_enb_reg(write_enb_reg), 
				 .read_enb_0(read_enb_0), 
				 .read_enb_1(read_enb_1), 
				 .read_enb_2(read_enb_2), 
				 .datain(datain[1:0]), 
				 .write_enb(write_enb_sync),
				 .fifo_full(fifo_full),
				 .soft_reset_0(soft_reset_0),
				 .soft_reset_1(soft_reset_1),
				 .soft_reset_2(soft_reset_2), 
				 .vld_out_1(vld_out_1),
				 .vld_out_2(vld_out_2),
				 .vld_out_0(vld_out_0) ); 


router_fsm fsm( .clk(clk),
				  .resetn(resetn), 
				  .packet_valid(packet_valid), 
				  .datain(datain[1:0]), 
				  .fifo_full(fifo_full), 
				  .fifo_empty_0(empty_0), 
				  .fifo_empty_1(empty_1), 
				  .fifo_empty_2(empty_2), 
				  .soft_reset_0(soft_reset_0), 
				  .soft_reset_1(soft_reset_1), 
				  .soft_reset_2(soft_reset_2), 
				  .parity_done(parity_done), 
				  .low_packet_valid(low_packet_valid), 
				  .write_enb_reg(write_enb_reg), 
				  .detect_add(detect_add), 
				  .ld_state(ld_state), 
				  .laf_state(laf_state), 
				  .lfd_state(lfd_state),
				  .full_state(full_state), 
				  .rst_int_reg(rst_int_reg), 
				  .busy(busy)  );
				  

endmodule
