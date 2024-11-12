class source_cfg extends uvm_object;
	`uvm_object_utils(source_cfg)
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	virtual source_if vif;
	function new(string name = "source_cfg");
		super.new(name);
	endfunction : new
endclass : source_cfg