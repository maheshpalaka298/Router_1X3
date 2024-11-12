class source_agt_top extends uvm_env;
	`uvm_component_utils(source_agt_top)
	source_agt sagt[];
	env_cfg cfg;
	function new(string name = "source_agt_top", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg))
			`uvm_fatal("source_agt_top","getting is failed");
		super.build_phase(phase);
		sagt = new[cfg.no_of_sagnt];
		foreach(sagt[i])
			begin
				sagt[i] = source_agt::type_id::create($sformatf("source_agt[%0d]", i), this);
				uvm_config_db#(source_cfg)::set(this, $sformatf("source_agt[%0d]*", i), "s_cfg", cfg.s_cfg[i]);
			end
	endfunction : build_phase
endclass : source_agt_top