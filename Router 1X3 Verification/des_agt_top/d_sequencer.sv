class d_sequencer extends uvm_sequencer#(dest_xtn);
	`uvm_component_utils(d_sequencer)
	function new(string name = "d_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction : new
endclass : d_sequencer