class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	
	uvm_tlm_analysis_fifo #(dest_xtn) fifo_rdh[];
	uvm_tlm_analysis_fifo #(s_xtn) fifo_wrh;
	
	dest_xtn rd_data;
	s_xtn wr_data;
	
	dest_xtn read_cov_data;
	s_xtn write_cov_data;
	env_cfg cfg;
	
	int data_verified_count;
	
	covergroup router_fcov1;
		option.per_instance = 1;
		ADD: coverpoint write_cov_data.header[1:0]
								{
									bins low  = {2'b00};
									bins mid1 = {2'b01};
									bins mid2 = {2'b10};
								}
									
		PAYLOAD_DATA: coverpoint write_cov_data.header[7:2]
								{
									bins small_pkt  = {[0:16]};
									bins medium_pkt = {[17:40]};
									bins big_pkt    = {[41:63]};
								}
		
		BAD_PKT: coverpoint write_cov_data.error
								{
									bins bad_pkt = {1};
								}
								
		CROSS1: cross ADD,PAYLOAD_DATA;
		
		CROSS2: cross ADD,PAYLOAD_DATA,BAD_PKT;
	endgroup
	
	covergroup router_fcov2;
		option.per_instance = 1;
		ADD: coverpoint read_cov_data.header[1:0]
								{
									bins low  = {2'b00};
									bins mid1 = {2'b01};
									bins mid2 = {2'b10};
								}
									
		PAYLOAD_DATA: coverpoint read_cov_data.header[7:2]
								{
									bins small_pkt  = {[0:16]};
									bins medium_pkt = {[17:40]};
									bins big_pkt    = {[41:63]};
								}
								
		CROSS1: cross ADD,PAYLOAD_DATA;
	endgroup
		
	function new(string name = "scoreboard",uvm_component parent);
		super.new(name,parent);
		router_fcov1 = new();
		router_fcov2 = new();
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_cfg)::get(this,"","cfg",cfg))
			`uvm_fatal("Config","in SB getting failed")
		fifo_wrh = new("fifo_wrh",this);
		fifo_rdh = new[cfg.no_of_dagnt];
		foreach(fifo_rdh[i]) begin
			fifo_rdh[i] = new($sformatf("fifo_rdh[%0d]",i),this);
		end
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		fork
			begin	
				forever begin
					fifo_wrh.get(wr_data);
						`uvm_info("SB","Write_data",UVM_LOW)
					wr_data.print;
					write_cov_data = wr_data;
					router_fcov1.sample();
				end
			end
			begin	
				forever begin
					fork
						begin
							fifo_rdh[0].get(rd_data);
								`uvm_info("SB","Read[0]_Data",UVM_LOW)
							rd_data.print;
							check_data(rd_data);
							read_cov_data = rd_data;
							router_fcov2.sample();
						end
						begin
							fifo_rdh[1].get(rd_data);
								`uvm_info("SB","Read[1]_Data",UVM_LOW)
							rd_data.print;
							check_data(rd_data);
							read_cov_data = rd_data;
							router_fcov2.sample();
						end
						begin
							fifo_rdh[2].get(rd_data);
								`uvm_info("SB","Read[2]_Data",UVM_LOW)
							rd_data.print;
							check_data(rd_data);
							read_cov_data = rd_data;
							router_fcov2.sample();
						end						
					join_any
					disable fork;
				end
			end
		join
	endtask: run_phase
	
	task check_data(dest_xtn rd);
		if(wr_data.header == rd.header)
			`uvm_info("SB","Read Header data matched Successfully",UVM_MEDIUM)
		else
			`uvm_error("SB","Failed header Reading")
		if(wr_data.payload == rd.payload)
			`uvm_info("SB","Read payload data matched Successfully",UVM_MEDIUM)
		else
			`uvm_error("SB","Failed payload data Reading")
		if(wr_data.parity == rd.parity)
			`uvm_info("SB","Read parity data matched Successfully",UVM_MEDIUM)
		else
			`uvm_error("SB","Failed  parity Reading")
		
		data_verified_count++;
		
	endtask: check_data
	
endclass: scoreboard
	
	
	