
module router_fifo_tb();
reg clk, resetn, write_enb, read_enb, lfd_state, soft_reset;
reg [7:0]data_in;
wire full, empty;	
wire [7:0]data_out;
integer k;

router_fifo DUT    (.clk(clk),
					.resetn(resetn),
					.soft_reset(soft_reset),
					.write_enb(write_enb),
					.read_enb(read_enb),
					.lfd_state(lfd_state),
					.datain(data_in),
					.full(full),
					.empty(empty),
					.dataout(data_out));

	//clock generation
	initial begin
	clk = 1;
	forever 
	#5 clk=~clk;
	end
	
	//Reset task
  task rst_dut();
      begin
         @(negedge clk);
            resetn=1'b0;
         @(negedge clk);
            resetn=1'b1;
      end
      endtask
		
		
		 task soft_reset_t();
      begin
         @(negedge clk);
            soft_reset=1'b1;
         @(negedge clk);
            soft_reset=1'b0;
      end
      endtask
      

task write();
	reg[7:0]payload_data, parity, header;
	reg[5:0]payload_len;
	reg[1:0]addr;
	begin
	lfd_state=1'b1;
	@(negedge clk);
	payload_len=6'd18;
	addr=2'b01;
	header={payload_len, addr};
	data_in= header;
	write_enb=1;
	read_enb=0;

	for(k=0;k<payload_len;k=k+1)
		begin
		@(negedge clk);
		lfd_state=0;
		//payload_data={$random}%256;
		payload_data=k;
		data_in= payload_data;
	end	
	@(negedge clk);
	parity={$random}%256;
	data_in=parity;
		write_enb=1'b0;
	 read_enb=1'b1;
end
endtask


		 task read();
      begin
         @(negedge clk);
			write_enb=1'b0;
          read_enb=1'b1;
      end
      endtask

initial 
begin

	//begin

	rst_dut;
	soft_reset_t;
	#20
   write;

	
   //end
end
endmodule

