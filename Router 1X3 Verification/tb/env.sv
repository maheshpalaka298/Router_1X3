class env extends uvm_env;
	`uvm_component_utils(env)
	source_agt_top sagnt;
	dest_agt_top dagnt;
	function new(string name = "env", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sagnt = source_agt_top::type_id::create("sagnt", this);
		dagnt = dest_agt_top::type_id::create("dagnt", this);
	endfunction : build_phase
endclass : env