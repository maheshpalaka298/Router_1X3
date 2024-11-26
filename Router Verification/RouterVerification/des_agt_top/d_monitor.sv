class d_monitor extends uvm_monitor;
	`uvm_component_utils(d_monitor)
	
	virtual dest_if.DES_MON vif;
	dest_cfg d_cfg;
	uvm_analysis_port#(dest_xtn) ap;
	dest_xtn d1 ;
	
	function new(string name = "d_monitor", uvm_component parent);
		super.new(name, parent);
		ap = new("ap",this);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(dest_cfg)::get(this,"","d_cfg",d_cfg))
			`uvm_fatal("dest_driver","getting failed !")
		super.build_phase(phase);
	endfunction: build_phase
	
	function void connect_phase(uvm_phase phase);
		vif = d_cfg.vif;
	endfunction: connect_phase
	
	task run_phase(uvm_phase phase);
		forever 
			collect_data();
	endtask: run_phase
	
	task collect_data();
		d1 = dest_xtn::type_id::create("d1");
		@(vif.mon_cb); //Change
		wait(vif.mon_cb.read_en == 1)
		@(vif.mon_cb);
		d1.header = vif.mon_cb.data_out;
		d1.payload = new[d1.header[7:2]];
		@(vif.mon_cb);
		foreach(d1.payload[i])
			begin 
				d1.payload[i] = vif.mon_cb.data_out;
				@(vif.mon_cb);
			end
		d1.parity = vif.mon_cb.data_out;
		@(vif.mon_cb);
		`uvm_info("d_monitor", $sformatf("printing from monitor \n %s", d1.sprint()), UVM_LOW)
		ap.write(d1);
	endtask: collect_data
	
	// function void report_phase(uvm_phase phase);
		// `uvm_info("d_monitor", $sformatf("printing from monitor \n %s", d1.sprint()), UVM_LOW)
	// endfunction : report_phase
			
		
endclass : d_monitor