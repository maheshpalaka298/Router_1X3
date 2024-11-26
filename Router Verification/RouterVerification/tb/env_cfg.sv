class env_cfg extends uvm_object;
	`uvm_object_utils(env_cfg)
	source_cfg s_cfg[];
	dest_cfg d_cfg[];
	
	int no_of_sagnt;
	int no_of_dagnt;
	
	function new(string name = "env_cfg");
		super.new(name);
	endfunction : new
endclass : env_cfg