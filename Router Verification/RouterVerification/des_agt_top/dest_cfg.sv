class dest_cfg extends uvm_object;
	`uvm_object_utils(dest_cfg)
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	virtual dest_if vif;
	
	function new(string name = "dest_cfg");
		super.new(name);
	endfunction : new
endclass : dest_cfg