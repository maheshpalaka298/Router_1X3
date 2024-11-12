
module router_reg_tb();

reg clk, resetn, packet_valid,fifo_full, detect_add, ld_state, laf_state, full_state, lfd_state, rst_int_reg;
reg [7:0] datain;
wire err, parity_done, low_packet_valid;
wire [7:0]dout;
integer i;
router_reg DUT( .clk(clk),
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
				.dout(dout));   
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
	
	//goodpacket
	task packet1();
	
			reg [7:0]header, payload_data, parity;
			reg [5:0]payloadlen;
			reg [1:0]addr;
			begin
				@(negedge clk);
				payloadlen=6'd4;
				addr=2'b10;
				packet_valid=1'b1;
				detect_add=1'b1;
				header={payloadlen,addr};
				parity=8'h00^header;
				datain=header;

				@(negedge clk);
				detect_add=1'b0;
				lfd_state=1'b1;
				full_state=0;
				fifo_full=0;
				laf_state=0;
		
				for(i=0;i<payloadlen;i=i+1)	
					begin
					@(negedge clk);	
					lfd_state=0;
					ld_state=1;
	
					payload_data={$random}%256;
					datain=payload_data;
					parity=parity^datain;				
					end

				@(negedge clk);	
				packet_valid=0;
				datain=parity;
				
			@(negedge clk);
			ld_state=0;
			end
		
endtask
task packet2();
	
			reg [7:0]header, payload_data, parity;
			reg [5:0]payloadlen;
			reg [1:0]addr;
			begin
				@(negedge clk);
				payloadlen=6'd4;
				addr=2'b10;
				packet_valid=1'b1;
				detect_add=1'b1;
				header={payloadlen,addr};
				parity=8'h00^header;
				datain=header;

				@(negedge clk);
				detect_add=1'b0;
				lfd_state=1'b1;
				full_state=0;
				fifo_full=0;
				laf_state=0;
		
				for(i=0;i<payloadlen;i=i+1)	
					begin
					@(negedge clk);	
					lfd_state=0;
					ld_state=1;
	
					payload_data={$random}%256;
					datain=payload_data;
					parity=parity^datain;				
					end
				

				@(negedge clk);	
				packet_valid=0;
				datain={$random}%256;
				
			@(negedge clk);
			ld_state=0;
			end
		endtask
initial
	begin
		reset;
		packet1();
		#105;
		packet2();
		#50
		$finish;
	end
	
endmodule 
	

