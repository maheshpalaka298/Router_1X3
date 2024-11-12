class dest_agt_top extends uvm_env;
	`uvm_component_utils(dest_agt_top)
	dest_agt dagt[];
	env_cfg cfg;
	
	function new(string name = "dest_agt_top", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg))
			`uvm_fatal("dest_agt_top","getting is failed");
		super.build_phase(phase);
		dagt = new[cfg.no_of_dagnt];
		foreach(dagt[i])
			begin
				dagt[i] = dest_agt::type_id::create($sformatf("dest_agt[%0d]", i), this);
				uvm_config_db#(dest_cfg)::set(this, $sformatf("dest_agt[%0d]*", i), "d_cfg", cfg.d_cfg[i]);
			end
	endfunction : build_phase
endclass : dest_agt_top