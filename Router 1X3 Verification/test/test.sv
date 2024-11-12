class test extends uvm_test;
	`uvm_component_utils(test)
	env envh;
	function new(string name = "test", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = env::type_id::create("envh", this);
	endfunction : build_phase
endclass