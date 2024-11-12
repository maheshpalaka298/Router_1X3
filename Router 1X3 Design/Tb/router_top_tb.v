
module router_top_tb();

reg clk, resetn, read_enb_0, read_enb_1, read_enb_2, packet_valid;
reg [7:0]datain;
wire [7:0]data_out_0, data_out_1, data_out_2;
wire vld_out_0, vld_out_1, vld_out_2, err, busy;
integer i;
integer k;

router_top DUT(.clk(clk),
			   .resetn(resetn),
			   .read_enb_0(read_enb_0),
			   .read_enb_1(read_enb_1),
			   .read_enb_2(read_enb_2),
			   .packet_valid(packet_valid),
			   .datain(datain),
			   .data_out_0(data_out_0),
			   .data_out_1(data_out_1),
			   .data_out_2(data_out_2),
			   .vld_out_0(vld_out_0),
			   .vld_out_1(vld_out_1),
			   .vld_out_2(vld_out_2),
			   .err(err),
			   .busy(busy) );			   
			   
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
			{read_enb_0, read_enb_1, read_enb_2, packet_valid, datain}=0;
			#10;
			resetn=1'b1;
		end
	endtask
	
	task pkt_gen_8;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [8:0]payloadlen;
			
			begin
				parity=0;
				@(negedge clk);
				wait(~busy)
				
				@(negedge clk);
				payloadlen=8'd8;
				header={payloadlen,2'b10};
				parity=0;
				datain=header;
				packet_valid=1'b1;
				parity=parity^header;
			
				@(negedge clk);
				wait(~busy)			
				for(i=0;i<payloadlen;i=i+1)
					begin
					@(negedge clk);
					wait(~busy)
					//payload_data={$random}%256;
					payload_data=i;
					datain=payload_data;
					parity=parity^payload_data;		
					end					
								
								
					@(negedge clk);
					wait(~busy)
					packet_valid=0;				
					datain=parity;
			end
		endtask
	
	task pkt_gen_14;	// packet generation payload 14
			reg [7:0]header, payload_data, parity;
			reg [8:0]payloadlen;
			
			begin
				parity=0;
				@(negedge clk);
				wait(~busy)
				
				@(negedge clk);
				payloadlen=8'd14;
				header={payloadlen,2'b10};
				parity=0;
				datain=header;
				packet_valid=1'b1;
				parity=parity^header;
			
				@(negedge clk);
				wait(~busy)			
				for(i=0;i<payloadlen;i=i+1)
					begin
					@(negedge clk);
					wait(~busy)
					//payload_data={$random}%256;
					payload_data=i;
					datain=payload_data;
					parity=parity^payload_data;		
					end					
								
								
					@(negedge clk);
					wait(~busy)
					packet_valid=0;				
					datain=parity;
			end
		endtask




task pkt_gen_16;	// packet generation payload 16
			reg [7:0]header, payload_data, parity;
			reg [8:0]payloadlen;
			
			begin
				parity=0;
				@(negedge clk);
				wait(~busy)
				
				@(negedge clk);
				payloadlen=8'd18;
				header={payloadlen,2'b10};
				parity=0;
				datain=header;
				packet_valid=1'b1;
				parity=parity^header;
			
				@(negedge clk);
				wait(~busy)			
				for(i=0;i<payloadlen;i=i+1)
					begin
					@(negedge clk);
					wait(~busy)
					payload_data={$random}%256;
					datain=payload_data;
					parity=parity^payload_data;
					wait(busy)
					read_enb_2=1;
					end	
						
					@(negedge clk);
					wait(~busy)
					packet_valid=0;				
					datain=parity;
			end
		endtask
	initial
		begin
			reset;
			#10;
			@(negedge clk);
			pkt_gen_8;
			@(negedge clk);
			read_enb_2=1;
			wait(~vld_out_2);
			@(negedge clk);
			read_enb_2=0;

			reset;
			#10;
			
			@(negedge clk);
			pkt_gen_14;
			wait(~busy);
			@(negedge clk);
			@(negedge clk);
			read_enb_2=1;
			wait(~vld_out_2);
			@(negedge clk);
			read_enb_2=0;
			
			reset;
			#10;

		   @(negedge clk);
			pkt_gen_16;
			@(negedge clk);
			read_enb_2=1;
			wait(~vld_out_2);
			@(negedge clk);
			read_enb_2=0;
			
         reset;
			#10;


			$finish;
		end
		
		
endmodule
