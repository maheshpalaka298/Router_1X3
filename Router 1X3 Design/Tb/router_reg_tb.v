module router_reg_tb();
reg clk,rst,pktvalid,fifofull,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
reg [7:0]din;
wire parity_done,lowpktvalid,err;
wire [7:0] dout;

integer i;

router_reg DUT(clk,rst,pktvalid,fifofull,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,din,parity_done,lowpktvalid,err,dout);

//clk generation
initial
begin
clk=1'b0;
forever #5 clk=~clk;
end

//reset
task reset;
begin
@(negedge clk)
rst=1'b0;
@(negedge clk)
rst=1'b1;
end
endtask

task packet1();
reg [7:0] header,payload_data,parity;
reg [5:0] payload_len;
begin
	@(negedge clk)
	payload_len=14;
	parity=0;
	detect_add=1;
	pktvalid=1;
	header={payload_len,2'b10};
	din=header;
	parity=parity^din;
	
	@(negedge clk)
	detect_add=0;
	lfd_state=1;
	
	for (i=0;i<payload_len;i=i+1)
	begin
		@(negedge clk)
		lfd_state=0;
		ld_state=1;
		payload_data={$random}%256;
		din=payload_data;
		parity=parity^din;
	end
	
	@(negedge clk)
	pktvalid=0;
	din=parity;
	
	@(negedge clk)
	ld_state=0;
	
end
endtask

initial
begin
reset;
fifofull=1'b0;
laf_state=0;
full_state=0;
rst_int_reg=0;

#20;
packet1();
#20;
rst_int_reg=1;
#20;
rst_int_reg=0;
#10 $finish;
end

initial
$monitor ("clock = %b, reset = %b, data_in =%d, dout=%d,parity_done=%b,low_pkt_valid=%b,error=%b,detect_add=%b, LFD=%b, LD =%b, LAF =%b, FFS = %b, rst_int_reg=%b",clk,rst,din,dout,parity_done,lowpktvalid,err,detect_add,lfd_state,ld_state,laf_state,full_state,rst_int_reg);


endmodule