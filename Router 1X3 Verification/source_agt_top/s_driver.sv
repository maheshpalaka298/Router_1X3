class s_driver extends uvm_driver #(s_xtn);

	`uvm_component_utils(s_driver)
	
	virtual source_if.SRC_DRV vif;
	
	source_cfg s_cfg;
	
	function new(string name = "s_driver", uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(source_cfg)::get(this,"","s_cfg",s_cfg))
			`uvm_fatal("s_driver","getting failed !!");
		super.build_phase(phase);
		uvm_top.print_topology();
	endfunction : build_phase
	
	function void connect_phase(uvm_phase phase);
		vif = s_cfg.vif;
	endfunction: connect_phase
	
	task run_phase(uvm_phase phase);
		@(vif.drv_cb);
			vif.drv_cb.resetn <=1'b0;
		@(vif.drv_cb);
			vif.drv_cb.resetn <=1'b1;
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask: run_phase
	
	task send_to_dut(s_xtn req);
		`uvm_info("s_driver", $sformatf("printing from driver \n %s", req.sprint()), UVM_LOW)
		wait(vif.drv_cb.busy == 0)
		//while(vif.drv_cb.busy == 1)
		//	@(vif.drv_cb)
		vif.drv_cb.pkt_valid <= 1'b1;
		vif.drv_cb.data_in <= req.header;
			@(vif.drv_cb);
		foreach(req.payload[i])
			begin
				wait(vif.drv_cb.busy == 0)
				vif.drv_cb.data_in <= req.payload[i];
				@(vif.drv_cb);
			end
		wait(vif.drv_cb.busy == 0)
		vif.drv_cb.pkt_valid <= 1'b0;
		vif.drv_cb.data_in <= req.parity;
		@(vif.drv_cb);
		
	endtask: send_to_dut
		

endclass : s_driver