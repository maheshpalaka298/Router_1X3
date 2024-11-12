
module router_reg(input clk,resetn,packet_valid,
				  input [7:0] datain,
				  input fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
				  output reg err,parity_done,low_packet_valid,
				  output reg [7:0] dout);
				  
reg [7:0] header_byte,fifo_full_state_byte,internal_parity,packet_parity_byte;

//dout logic
always@(posedge clk)
	begin 
		if(!resetn)
			dout<=8'd0;
			
		else if(detect_add && packet_valid && datain[1]!=3)
			dout<=dout;
			
		else if(lfd_state)
			dout<=header_byte;
			
		else if(ld_state && !fifo_full)
			dout<=datain;
			
		else if(ld_state && fifo_full)
			dout<=dout;
			
		else if(laf_state)
			dout=fifo_full_state_byte;
	end


//fifo full state byte
always@(posedge clk)
	begin 
		if(!resetn)
			fifo_full_state_byte<=8'd0;

		else if(ld_state && fifo_full)
			fifo_full_state_byte=datain;
	end

//Header logic
always@(posedge clk)
	begin 
		if(!resetn)
			header_byte<=8'd0;

		else if(detect_add && packet_valid && datain[1]!=3)
			header_byte<=datain;
	end

//	full state logic
always@(posedge clk)
	begin
		if(!resetn || rst_int_reg)
			internal_parity<=8'd0;
			
		else if(detect_add)
			internal_parity<=8'd0;
			
		else if(lfd_state && !full_state)
			internal_parity<=internal_parity^header_byte;
			
		else if(packet_valid && ld_state && !fifo_full)
			internal_parity<=internal_parity^datain;
	end

//packet parity
always@(posedge clk)
	begin
		if(!resetn || detect_add || rst_int_reg)
			packet_parity_byte<=8'b0;
			
		else if (ld_state && !packet_valid)
		packet_parity_byte<=datain;
	end
	
//low packet valid
always@(posedge clk)
	begin
	if(!resetn)
			low_packet_valid=1'b0;
			
		if(ld_state && !packet_valid )
			low_packet_valid=1'b1;
			
		else 
			low_packet_valid=1'b0;
	end
			

//parity done
always@(posedge clk)
	begin
		if(!resetn)
			parity_done=1'b0;
			
		if(ld_state && !packet_valid && !fifo_full)
			parity_done<=1'b1;
			
		else if(low_packet_valid && laf_state && !parity_done)
			parity_done<=1'b1;
			
		else if (detect_add)
			parity_done<=1'b0;
	
	end
				
		

//error
always@(posedge clk)
	begin
		if(!resetn)
			err=1'b0;
			
		if(parity_done)
			begin
				if(internal_parity != packet_parity_byte)
					err=1'b1;
				else 
					err=1'b0;
			end
	end
	
endmodule

	

		

