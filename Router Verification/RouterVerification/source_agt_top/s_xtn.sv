class s_xtn extends uvm_sequence_item;
	`uvm_object_utils(s_xtn)
	
	rand bit [7:0]header;
	rand bit [7:0]payload[];
	bit [7:0]parity;
	
	bit error;
	
	constraint VALID_ADDR{ header[1:0] inside {[0:2]};}
	constraint VALID_LENGTH{ header[7:2] != 0;}
	constraint VALID_SIZE {payload.size == header[7:2];}
	
	function new(string name="s_xtn");
		super.new(name);
	endfunction:new
	
	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field( "header", 	this.header,  8, UVM_HEX );
		foreach(payload[i])
			printer.print_field( $sformatf(" payload_data[%0d]",i),	this.payload[i], 8,	 UVM_HEX );
		printer.print_field( "parity",	parity,	 8,  UVM_HEX );
		printer.print_field( "error",	error,	 1,  UVM_HEX );
		
	endfunction: do_print
	
	function void post_randomize();
		parity = header^0;
		foreach(payload[i])
			begin
				parity = parity^payload[i];
			end
	endfunction: post_randomize
	
endclass: s_xtn

class bad_xtn extends s_xtn;
	`uvm_object_utils(bad_xtn)
	
	rand xtn_type trans_type;
	constraint a{ trans_type dist {BAD_XTN := 2, GOOD_XTN := 8}; }
	
	function new(string name="bad_xtn");
		super.new(name);
	endfunction:new
	
	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_generic("trans_type", "xtns_type", $bits(trans_type), trans_type.name);
		
	endfunction: do_print
	
	function void post_randomize();
		parity = $random;
	endfunction:post_randomize

endclass: bad_xtn
		
		
	
	