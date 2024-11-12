
module router_fifo(clk,resetn,soft_reset,write_enb,read_enb,lfd_state,datain,full,empty,dataout);

input clk,resetn,soft_reset,write_enb,read_enb,lfd_state;
input [7:0]datain;
output reg full,empty;
output reg [7:0]dataout;

reg [3:0]read_ptr,write_ptr;
reg [5:0]count;
reg [8:0]fifo[15:0];
integer i;
reg temp;
reg [4:0] incrementer;


//lfd_state
always@(posedge clk)
	begin
		if(!resetn)
			temp<=1'b0;
			
		else 
			temp<=lfd_state;
	end 



//Incrementer

always @(posedge clk )
begin
   if( !resetn )
       incrementer <= 0;

   else if( (!full && write_enb) && ( !empty && read_enb ) )
          incrementer<= incrementer;

   else if( !full && write_enb )
          incrementer <= incrementer + 1;					

   else if( !empty && read_enb )									
          incrementer <= incrementer - 1;
   else
         incrementer <= incrementer;
end

//full and empty logic
always @(incrementer)
begin
	if(incrementer==0)   
		empty = 1 ;
	else
		empty = 0;

  if(incrementer==5'b10000)  
		full = 1;
   else
		full = 0;
end 

//Fifo write logic
always@(posedge clk)
	begin
		if(!resetn || soft_reset)
			begin
				for(i=0;i<16;i=i+1)
					fifo[i]<=0; 
			end
		
		else if(write_enb && !full)
				{fifo[write_ptr[3:0]][8],fifo[write_ptr[3:0]][7:0]}<={temp,datain}; 
	end

//

//READ logic
always@(posedge clk)
	begin
		if(!resetn)
			dataout<=8'd0;

		else if(soft_reset)
			dataout<=8'bzz;
		
		else
			begin 
				if(read_enb && !empty)
					dataout<=fifo[read_ptr[3:0]];
				if(count==0) 
					dataout<=8'dz;
			end
	end

//counter logic
always@(posedge clk)
	begin
		
		 if(read_enb && !empty)
			begin
				if(fifo[read_ptr[3:0]][8])      
                               						 
					count<=(fifo[read_ptr[3:0]][7:2])+1'b1;
					
				else if(count!=6'd0)
					count<=count-1'b1;           
				
			end
	
	end

//pointer logic
always@(posedge clk)
	begin
		if(!resetn || soft_reset)
			begin
				read_ptr<=5'd0;
				write_ptr<=5'd0;
			end

		else 
			begin
				if(write_enb && !full)
					write_ptr<=write_ptr+1'b1;

				if(read_enb && !empty)
					read_ptr<=read_ptr+1'b1;
			end
	end

endmodule

