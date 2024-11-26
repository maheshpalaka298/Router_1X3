class dest_seq extends uvm_sequence #(dest_xtn); 

	`uvm_object_utils(dest_seq);
	
	function new(string name="dest_seq");
		super.new(name);
	endfunction: new

endclass: dest_seq

class seq1 extends dest_seq;
	`uvm_object_utils(seq1)
	
	function new(string name="seq1");
		super.new(name);
	endfunction: new
	
	task body();
		req = dest_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {delay inside {[1:29]};})
		finish_item(req);
	endtask: body
endclass: seq1	
	
class seq2 extends dest_seq;
	`uvm_object_utils(seq2)
	
	function new(string name="seq2");
		super.new(name);
	endfunction: new
	
	task body();
		req = dest_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {delay >29;})
		finish_item(req);
	endtask: body
endclass: seq2
	