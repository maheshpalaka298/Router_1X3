class s_base_sequence extends uvm_sequence #(s_xtn); 

	`uvm_object_utils(s_base_sequence);
	bit [1:0]addr;
	
	function new(string name="s_base_sequence");
		super.new(name);
	endfunction: new

endclass: s_base_sequence

class small_pkt extends s_base_sequence;
	
	`uvm_object_utils(small_pkt)
	
	function new(string name= "small_pkt");
		super.new(name);
	endfunction: new
	
	task body();
		if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal("small_pkt","addr getting failed !!")
		req = s_xtn::type_id::create("req");
		start_item(req);
		req.randomize() with { header[7:2] inside {[0:16]} && header[1:0] == addr;};
		finish_item(req);
	endtask
endclass: small_pkt

class medium_pkt extends s_base_sequence;

	`uvm_object_utils(medium_pkt)
	
	function new(string name="medium_pkt");
		super.new(name);
	endfunction:new
	
	task body();
		if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal("medium_pkt","addr getting failed !!")
		req = s_xtn::type_id::create("req");
		start_item(req);
		req.randomize() with { header[7:2] inside {[17:40]} &&
							   header[1:0] == addr; 
							};
		finish_item(req);
	endtask
endclass: medium_pkt
	
class big_pkt extends s_base_sequence;
	
	`uvm_object_utils(big_pkt)
	
	function new(string name = "big_pkt");
		super.new(name);
	endfunction:new
	
	task body();
		if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal("big_pkt","addr getting failed !!")
		req = s_xtn::type_id::create("req");
		start_item(req);
		req.randomize() with { header[7:2] inside {[41:63]} &&
							   header[1:0] == addr; 
							};
		finish_item(req);
	endtask
endclass: big_pkt
	
class random_pkt extends s_base_sequence;	

	`uvm_object_utils(random_pkt)
	bit[1:0]addr;
	function new(string name = "random_pkt");
		super.new(name);
	endfunction
			
	task body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal(get_type_name(),"getting the configuration faile, check if it set properly")
		req = s_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[1:0]==addr;});
		`uvm_info("random_pkt",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
		finish_item(req); 
	endtask
 
endclass: random_pkt

