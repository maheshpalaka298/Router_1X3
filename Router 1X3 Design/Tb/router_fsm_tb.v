
module router_fsm_tb();

reg clk,resetn, packet_valid;
reg [1:0]datain;
reg fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2, soft_reset_0, soft_reset_1, soft_reset_2, parity_done, low_packet_valid;
wire write_enb_reg, detect_add, ld_state, laf_state, lfd_state, full_state, rst_int_reg, busy;

router_fsm DUT  ( .clk(clk),
				  .resetn(resetn), 
				  .packet_valid(packet_valid), 
				  .datain(datain), 
				  .fifo_full(fifo_full), 
				  .fifo_empty_0(fifo_empty_0), 
				  .fifo_empty_1(fifo_empty_1), 
				  .fifo_empty_2(fifo_empty_2), 
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
				  .busy(busy));
				  
				  
	//clock generation
	initial 
	begin
	clk = 1;
	forever 
	#5 clk=~clk;
	end
	
	
	task reset;
		begin
			resetn=1'b0;
			#10;
			resetn=1'b1;
		end
	endtask
	
	task task1;
		begin
			@(negedge clk)
			packet_valid=1'b1; 
			datain=2'b00;
			fifo_empty_0=1'b1;
			@(negedge clk)
			@(negedge clk)
			fifo_full=1'b0; 
			packet_valid=1'b0; 
			@(negedge clk)
		   @(negedge clk)
			fifo_full=1'b0; 
			@(negedge clk)
			soft_reset_0=1'b1;
		end
	endtask
	
	
	task task2;
		begin
		   soft_reset_0=1'b0;
			@(negedge clk)
			packet_valid=1'b1; 
			datain=2'b00;
			fifo_empty_0=1'b1;
			@(negedge clk)
			@(negedge clk)
			fifo_full=1'b1; 
			@(negedge clk)
			fifo_full=1'b0; 
			@(negedge clk)
			parity_done =1'b0;
			low_packet_valid=1'b1;
			@(negedge clk)
			@(negedge clk)
		   fifo_full=1'b0; 
			@(negedge clk)
			soft_reset_0=1'b1;
		end
	endtask
	
	task task3;
		begin
			soft_reset_0=1'b0;
			@(negedge clk)
			packet_valid=1'b1; 
			datain=2'b00;
			fifo_empty_0=1'b1;
			@(negedge clk)
			@(negedge clk)
			fifo_full=1'b1; 
			@(negedge clk)
			fifo_full=1'b0; 
			@(negedge clk)
			parity_done =1'b0;
			low_packet_valid=1'b0;
			@(negedge clk)
			fifo_full=1'b0; 
			packet_valid=1'b0; 
			@(negedge clk)
		   @(negedge clk)
			fifo_full=1'b0; 
			@(negedge clk)
			soft_reset_0=1'b1;
		end
	endtask
	
	task task4;
		begin
			soft_reset_0=1'b0;
			@(negedge clk)
			packet_valid=1'b1; 
			datain=2'b00;
			fifo_empty_0=1'b1;
			@(negedge clk)
			@(negedge clk)
			fifo_full=1'b0; 
			packet_valid=1'b0; 
			@(negedge clk)
			@(negedge clk)
			fifo_full=1'b1; 
			@(negedge clk)
			fifo_full=1'b0; 
			@(negedge clk)
			parity_done =1'b0;
			@(negedge clk)
			soft_reset_0=1'b1;

		end
	endtask
			
	initial 
		begin
			reset;
			#20;
			task1;
			reset;
			#20;
			task2;
			reset;
			#20;
			task3;
			reset;
			#20;
			task4;
			reset;
			#100;
			$finish;
		end
		
		endmodule 	
			
	
	
	

