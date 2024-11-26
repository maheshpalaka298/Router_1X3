module router_top(input          clock,
		  input          resetn,
		  input          pkt_valid,
		  input    [7:0] data_in,
		  input          read_enb_0,
		  input          read_enb_1,
		  input          read_enb_2,

		  output   [7:0] data_out_0,
		  output   [7:0] data_out_1,
		  output   [7:0] data_out_2,
	 	  output         vld_out_0,
		  output	 vld_out_1,
		  output	 vld_out_2,
		  output         busy,
		  output         error);            
										
										
   //Internal wires
   wire   [2:0] write_enb;
   wire   [7:0] dout;

   //Module Instances
		
   router_fifo FIFO_0(.clock         (clock),
	              .write_enb     (write_enb[0]),
	              .read_enb      (read_enb_0),
	              .data_in       (dout),
	              .data_out      (data_out_0),
	              .empty         (empty_0),
	              .full          (full_0),
	              .resetn        (resetn),
	              .soft_reset    (soft_reset_0),
	              .lfd_state     (lfd_state)
	             );

   router_fifo FIFO_1(.clock         (clock),
	              .write_enb     (write_enb[1]),
	              .read_enb      (read_enb_1),
	              .data_in       (dout),
	              .data_out      (data_out_1),
	              .empty         (empty_1),
	              .full          (full_1),
	              .resetn        (resetn),
	              .soft_reset    (soft_reset_1),
	              .lfd_state     (lfd_state)
                     );

   router_fifo FIFO_2(.clock         (clock),
	              .write_enb     (write_enb[2]),
	              .read_enb      (read_enb_2),
	              .data_in       (dout),
	              .data_out      (data_out_2),
	              .empty         (empty_2),
	              .full          (full_2),
	              .resetn        (resetn),
	              .soft_reset    (soft_reset_2),
	              .lfd_state     (lfd_state)
                     );
					
   router_fsm  FSM(.clock            (clock),          
	           .busy             (busy),
		   .fifo_empty_0     (empty_0),
	 	   .fifo_empty_1     (empty_1),
		   .fifo_full        (fifo_full),           
		   .fifo_empty_2     (empty_2),
		   .pkt_valid        (pkt_valid),   
		   .data_in          (data_in[1:0]),
	           .parity_done      (parity_done),
		   .low_pkt_valid    (low_pkt_valid),
		   .detect_add       (detect_add),
		   .write_enb_reg    (write_enb_reg),
		   .resetn           (resetn),
		   .ld_state         (ld_state),
		   .laf_state        (laf_state),
		   .lfd_state        (lfd_state),
		   .full_state       (full_state),
		   .rst_int_reg      (rst_int_reg),
		   .soft_reset_0     (soft_reset_0),
		   .soft_reset_1     (soft_reset_1),
		   .soft_reset_2     (soft_reset_2)
		   );  
		 
   router_sync SYNCH (.clock         (clock),
		      .resetn        (resetn),
		      .detect_add    (detect_add),
		      .data_in       (data_in[1:0]),
	              .empty_0       (empty_0),
		      .empty_1       (empty_1),
		      .empty_2       (empty_2),
	              .full_0        (full_0),
	              .full_1        (full_1),
	              .full_2        (full_2),
	              .write_enb_reg (write_enb_reg),
		      .write_enb     (write_enb),
		      .fifo_full     (fifo_full),
		      .vld_out_0     (vld_out_0),
		      .vld_out_1     (vld_out_1),
		      .vld_out_2     (vld_out_2),
		      .soft_reset_0  (soft_reset_0),
		      .soft_reset_1  (soft_reset_1),
	              .soft_reset_2  (soft_reset_2),
		      .read_enb_0    (read_enb_0),
	              .read_enb_1    (read_enb_1),
		      .read_enb_2    (read_enb_2));

   router_reg    REG(.clock          (clock),
	      	     .resetn         (resetn),
	             .pkt_valid      (pkt_valid),
		     .data_in        (data_in),
		     .fifo_full      (fifo_full),
		     .detect_add     (detect_add), 
		     .lfd_state      (lfd_state),
		     .ld_state       (ld_state),
		     .laf_state      (laf_state),
		     .full_state     (full_state),
		     .rst_int_reg    (rst_int_reg),
	             .parity_done    (parity_done),
		     .low_pkt_valid  (low_pkt_valid),
		     .dout           (dout),
		     .err            (error)
	           );
endmodule 
