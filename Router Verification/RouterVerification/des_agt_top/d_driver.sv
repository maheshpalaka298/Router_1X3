class d_driver extends uvm_driver#(dest_xtn);
	`uvm_component_utils(d_driver)
	virtual dest_if.DES_DRV vif;
	dest_cfg d_cfg;
	
	function new(string name = "d_driver", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(dest_cfg)::get(this,"","d_cfg",d_cfg))
			`uvm_fatal("dest_driver","getting failed !")
		super.build_phase(phase);
		uvm_top.print_topology();
	endfunction : build_phase
	
	function void connect_phase(uvm_phase phase);
		vif = d_cfg.vif;
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end 
	endtask
	
	task send_to_dut(dest_xtn req);
		wait(vif.drv_cb.valid_out == 1)
		repeat(req.delay)
			@(vif.drv_cb);
		vif.drv_cb.read_en <= 1'b1;
		wait(vif.drv_cb.valid_out == 0)
		@(vif.drv_cb);
		vif.drv_cb.read_en <= 1'b0;
	endtask: send_to_dut

endclass : d_driver