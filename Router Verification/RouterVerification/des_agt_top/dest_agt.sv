class dest_agt extends uvm_agent;
	`uvm_component_utils(dest_agt)
	//uvm_active_passive_enum is_active = UVM_ACTIVE;
	d_sequencer d_seqr;
	d_driver d_drv;
	d_monitor d_mon;
	dest_cfg d_cfg;
	
	function new(string name = "dest_agt", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(dest_cfg)::get(this,"","d_cfg",d_cfg))
			`uvm_fatal("Dest agent ","getting failed !!");
		super.build_phase(phase);
		d_mon = d_monitor::type_id::create("d_mon", this);
		if(d_cfg.is_active == UVM_ACTIVE)
			begin
				d_drv = d_driver::type_id::create("d_drv", this);
				d_seqr = d_sequencer::type_id::create("d_seq", this);
			end
	endfunction : build_phase
	
	function void connect_phase(uvm_phase phase);
		if(d_cfg.is_active == UVM_ACTIVE)
			begin	
				d_drv.seq_item_port.connect(d_seqr.seq_item_export);
			end
	endfunction: connect_phase

endclass :  dest_agt