class source_agt extends uvm_agent;
	`uvm_component_utils(source_agt)
	//uvm_active_passive_enum is_active = UVM_ACTIVE;
	s_sequencer seqr;
	s_driver drv;
	s_monitor mon;
	source_cfg s_cfg;
	
	function new(string name = "source_agt", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(source_cfg)::get(this,"","s_cfg",s_cfg))
			`uvm_fatal("Source agent ","getting failed !!");
		super.build_phase(phase);
		mon = s_monitor::type_id::create("mon", this);
		if(s_cfg.is_active == UVM_ACTIVE)
			begin
				drv = s_driver::type_id::create("drv", this);
				seqr = s_sequencer::type_id::create("seq", this);
			end
	endfunction : build_phase
	
	function void connect_phase(uvm_phase phase);
		if(s_cfg.is_active == UVM_ACTIVE)
			begin	
				drv.seq_item_port.connect(seqr.seq_item_export);
			end
	endfunction: connect_phase

endclass :  source_agt