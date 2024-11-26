class s_sequencer extends uvm_sequencer #(s_xtn);
	`uvm_component_utils(s_sequencer);
	function new(string name = "s_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction : new
endclass : s_sequencer