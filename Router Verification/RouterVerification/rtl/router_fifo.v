module router_fifo #(parameter WIDTH = 8,DEPTH = 16)
                    (input clock,
	             input resetn,  
	             input soft_reset,
	             input write_enb,
	             input read_enb,
	             input lfd_state,
	             input [(WIDTH-1):0]data_in,  
	             output reg [(WIDTH-1):0]data_out, 
	             output empty,    
	             output full);

    
   //Internal variables
   reg [8:0] memory [(DEPTH-1):0]; 
   reg [4:0] write_ptr; 
   reg [4:0] read_ptr; 
   reg [6:0] count;
   integer i;
   reg lfd_state_d1;

   always@(posedge clock)
      lfd_state_d1 <= lfd_state;

   //FIFO full and empty logic
   assign empty = (write_ptr == read_ptr) ? 1'b1 : 1'b0;
   assign full  = (write_ptr == {~read_ptr[4],read_ptr[3:0]}) ? 1'b1 : 1'b0; 

   

   //FIFO write operation
   always@(posedge clock) 
      begin 
         if(~resetn) 
	    begin
	       write_ptr <= 0;
	       for(i = 0;i < 16;i=i+1)
	          begin
		     memory[i] <= 0;
		  end
	    end 
	 else if(soft_reset)
	    begin
	       write_ptr <= 0;
	       for(i = 0;i < 16 ; i=i+1)
	          begin
	             memory[i] <= 0;
		  end
	    end 
	 else 
	    begin
	       if(write_enb &&  ~full) 
	          begin
		     write_ptr <= write_ptr + 1;
		     memory[write_ptr[3:0]] <= {lfd_state_d1,data_in};							
		  end 

            end

      end 

   //FIFO read operation
   always@(posedge clock) 
      begin 
         if(~resetn) 
	    begin
	       read_ptr  <= 0;
	       data_out  <= 8'h00;
	    end 
	 else if(soft_reset)
	    begin
	       read_ptr  <= 0;
	       data_out  <= 8'hzz;
	    end 
	 else 
	    begin
	       if(read_enb && ~empty)
	          read_ptr <= read_ptr + 1;
						
	       if((count == 0) && (data_out != 0))
	          data_out <= 8'dz;
	       else if(read_enb && ~empty) 
	          begin
		     data_out <= memory[read_ptr[3:0]];
		  end
	    end
      end 


   //FIFO down-counter logic
   always@(posedge clock)
      begin
	 if(~resetn)
	    begin
	       count <= 0;
	    end
	 else if(soft_reset)
	    begin
	       count <= 0;
	    end
	 else if(read_enb & ~empty)
	    begin
	       if(memory[read_ptr[3:0]][8] == 1'b1 )
		  count <= memory[read_ptr[3:0]][7:2] + 1'b1;					
	       else if(count != 0)
	    	  count <= count - 1'b1;
      	    end
      end


endmodule 
