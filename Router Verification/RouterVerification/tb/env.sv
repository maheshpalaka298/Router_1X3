class env extends uvm_env;
	`uvm_component_utils(env)
	source_agt_top sagnt;
	dest_agt_top dagnt;
	scoreboard sbh;
	vsequencer vsqr;
	env_cfg cfg;
	
	function new(string name = "env", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_cfg)::get(this,"","cfg",cfg))
			`uvm_fatal(" env cfg","getting failed in env")
		super.build_phase(phase);
		sagnt = source_agt_top::type_id::create("sagnt", this);
		dagnt = dest_agt_top::type_id::create("dagnt", this);
		vsqr = vsequencer::type_id::create("vsqr",this);
		sbh = scoreboard::type_id::create("sbh",this);
			
	endfunction : build_phase
	
	function void connect_phase(uvm_phase phase);
		for(int i=0;i<cfg.no_of_sagnt;i++)
			vsqr.src_seqr[i] = sagnt.sagt[i].seqr;
		for(int i=0;i<cfg.no_of_dagnt;i++)
			vsqr.des_seqr[i] = dagnt.dagt[i].d_seqr;
		for(int i=0;i<cfg.no_of_sagnt;i++) 
			begin
     		    sagnt.sagt[i].mon.ap.connect(sbh.fifo_wrh.analysis_export);
   			end
		for(int i=0;i<cfg.no_of_dagnt;i++)
			begin
      			dagnt.dagt[i].d_mon.ap.connect(sbh.fifo_rdh[i].analysis_export);
			end
	endfunction: connect_phase
endclass : env