class s_monitor extends uvm_monitor;

	`uvm_component_utils(s_monitor)
	
	virtual source_if.SRC_MON vif;
	
	source_cfg s_cfg;
	
	uvm_analysis_port#(s_xtn) ap;
	
	s_xtn xtn;

	function new(string name = "s_monitor", uvm_component parent);
		super.new(name, parent);
		ap = new("ap", this);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(source_cfg)::get(this,"","s_cfg",s_cfg))
			`uvm_fatal("s_monitor","getting failed");
		super.build_phase(phase);
	endfunction: build_phase
	
	function void connect_phase(uvm_phase phase);
		vif = s_cfg.vif;
	endfunction: connect_phase
	
	task run_phase(uvm_phase phase);
		forever
			collect_data();
	endtask: run_phase
	
	task collect_data();
		xtn = s_xtn::type_id::create("xtn");
		wait(vif.mon_cb.busy == 0)
		wait(vif.mon_cb.pkt_valid == 1)
		xtn.header = vif.mon_cb.data_in;
		xtn.payload = new[xtn.header[7:2]];
		@(vif.mon_cb);
		foreach(xtn.payload[i])
			begin
				wait(vif.mon_cb.busy == 0)
				xtn.payload[i] = vif.mon_cb.data_in;
				@(vif.mon_cb);
			end
		xtn.parity = vif.mon_cb.data_in;
		repeat(2)
			@(vif.mon_cb);
		xtn.error = vif.mon_cb.error;
		//xtn.print();
		`uvm_info("s_monitor", $sformatf("printing from monitor \n %s", xtn.sprint()), UVM_LOW)
		ap.write(xtn);
	endtask: collect_data
	
	// function void report_phase(uvm_phase phase);
		
	// endfunction : report_phase
endclass : s_monitor
