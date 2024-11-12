
module router_reg(input       clock,
		  input       resetn,
		  input       pkt_valid,
		  input  [7:0]data_in,
		  input       fifo_full,
		  input       rst_int_reg,
		  input       detect_add,
		  input       ld_state,
                  input       lfd_state,
		  input       laf_state,
		  input       full_state,									 
	          output  reg  parity_done,
		  output  reg  low_pkt_valid,
		  output  reg  [7:0] dout,
		  output  reg  err);										
		

   //Internal registers
   reg [7:0] full_state_byte;
   reg [7:0] pkt_parity;
   reg [7:0] first_byte;
   reg [7:0] internal_parity;
   

   //Parity_done logic
   always@(posedge clock)
      begin
         if(~resetn)
            parity_done <= 1'b0;
         else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && !parity_done && low_pkt_valid))
            parity_done <= 1'b1;
         else if (detect_add)
            parity_done <= 1'b0;
      end

   //Low_packet_valid logic
   always@(posedge clock)
      begin
         if(~resetn)
	    low_pkt_valid <= 1'b0;
         else if(ld_state == 1 && pkt_valid == 0)
	    low_pkt_valid <= 1'b1;
         else if(rst_int_reg)
            low_pkt_valid <= 1'b0;
      end

   //Register dout logic
   always@(posedge clock)
      begin
         if(~resetn)
            begin
 	       dout <= 8'h00;
 	       first_byte <= 8'h00;
               full_state_byte <= 8'h00;														
            end   
         else
            begin
               if(detect_add && pkt_valid==1 && data_in[1:0] != 2'b11)
		  first_byte <= data_in;
	       else if(lfd_state)
		  dout<= first_byte;
	       else if(ld_state && !fifo_full)
		  begin
		     dout <= data_in;
		  end
               else if(ld_state && fifo_full)
                  full_state_byte <= data_in;
               else if(laf_state)
                  dout <= full_state_byte;
            end
      end

   //Internal parity logic
   always@(posedge clock)
      begin
	 if(~resetn)
	    internal_parity  <=8'h00;
         else
            begin
	       if(detect_add)
	          internal_parity <= 8'h00;
               else if(lfd_state)
		  begin
		     internal_parity  <= internal_parity ^ first_byte;
                  end
               else if(ld_state && !full_state && pkt_valid) 
		  internal_parity <= internal_parity^data_in;
            end
      end

   //Packet_parity logic
   always@(posedge clock)
      begin
         if(~resetn)
	    begin
	       pkt_parity <= 8'h00;												
	    end
         else if(detect_add)
            begin
	       pkt_parity <= 8'h00;		
            end
	 else if((ld_state && !pkt_valid && ~fifo_full)||(laf_state & low_pkt_valid & ~parity_done))			
            begin
	       pkt_parity <= data_in; 
            end
					
      end

   //Error logic
   always@(posedge clock)
      begin
         if(~resetn)
            err <=1'b0;
         else if(!parity_done)
            err <= 1'b0;
         else if(pkt_parity != internal_parity)
            err <= 1'b1;
         else
            err <= 1'b0;
      end

endmodule 


