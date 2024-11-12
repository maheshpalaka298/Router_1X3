class router_base_test extends uvm_test;
	`uvm_component_utils(router_base_test)
	env envh;
	source_cfg s_cfg[];
	dest_cfg d_cfg[];
	env_cfg cfg;
	bit [1:0]addr;
	int no_of_sagnt = 1;
	int no_of_dagnt = 3;
	function new(string name = "router_base_test", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	function void build_phase(uvm_phase phase);
		s_cfg = new[no_of_sagnt];
		d_cfg = new[no_of_dagnt];
		foreach(s_cfg[i])
			begin
				s_cfg[i] = source_cfg::type_id::create($sformatf("s_cfg[%0d]", i));
				if(!uvm_config_db#(virtual source_if)::get(this, "", "s_vif", s_cfg[i].vif))
					`uvm_fatal("router_base_test", "getting is failed")
				s_cfg[i].is_active = UVM_ACTIVE;
			end
		foreach(d_cfg[i])
			begin
				d_cfg[i] = dest_cfg::type_id::create($sformatf("d_cfg[%0d]", i));
				if(!uvm_config_db#(virtual dest_if)::get(this, "", $sformatf("d_vif[%0d]", i), d_cfg[i].vif))
					`uvm_fatal("router_base_test", "getting is failed")
				d_cfg[i].is_active = UVM_ACTIVE;
			end
		cfg = env_cfg::type_id::create("cfg");
		cfg.s_cfg = s_cfg;
		cfg.d_cfg = d_cfg;
		cfg.no_of_dagnt = no_of_dagnt;
		cfg.no_of_sagnt = no_of_sagnt;
		uvm_config_db#(env_cfg)::set(this, "*", "cfg", cfg);
		super.build_phase(phase);
		envh = env::type_id::create("envh", this);
	endfunction : build_phase

endclass : router_base_test

class small_pkt_test extends router_base_test;
	`uvm_component_utils(small_pkt_test)
	
	small_pkt seq;
	
	function new(string name = "small_pkt_test", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		addr = $urandom%3;
		uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
		super.build_phase(phase);
		
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq = small_pkt::type_id::create("seq");
		
		for(int i = 0; i < no_of_sagnt; i++)
			begin
				seq.start(envh.sagnt.sagt[i].seqr);
				//seq.print();
			end
		phase.drop_objection(this);
	endtask : run_phase

endclass:small_pkt_test



class small_pkt_seq1 extends small_pkt_test;
	`uvm_component_utils(small_pkt_seq1)
	
	seq1 s1;
	
	function new(string name = "small_pkt_seq1", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		s1 = seq1::type_id::create("s1");
		if(addr == 2'b00)
			s1.start(envh.dagnt.dagt[0].d_seqr);
		if(addr == 2'b01)
			s1.start(envh.dagnt.dagt[1].d_seqr);
		if(addr == 2'b10)
			s1.start(envh.dagnt.dagt[2].d_seqr);
		phase.drop_objection(this);
		
	endtask: run_phase
endclass: small_pkt_seq1		
	
class small_pkt_seq2 extends small_pkt_test;
	`uvm_component_utils(small_pkt_seq2)
	
	seq2 s2;
	
	function new(string name = "small_pkt_seq2", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		s2 = seq2::type_id::create("s2");
		if(addr == 2'b00)
			s2.start(envh.dagnt.dagt[0].d_seqr);
		if(addr == 2'b01)
			s2.start(envh.dagnt.dagt[1].d_seqr);
		if(addr == 2'b10)
			s2.start(envh.dagnt.dagt[2].d_seqr);
		phase.drop_objection(this);
		
	endtask: run_phase
endclass: small_pkt_seq2

class medium_pkt_test extends router_base_test;
	`uvm_component_utils(medium_pkt_test)
	
	medium_pkt seq;
	
	function new(string name = "medium_pkt_test", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		addr = $urandom%3;
		uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq = medium_pkt::type_id::create("seq");
		for(int i = 0; i < no_of_sagnt; i++)
			begin
				seq.start(envh.sagnt.sagt[i].seqr);
				//seq.print();
			end
		phase.drop_objection(this);
	endtask : run_phase

endclass:medium_pkt_test

class medium_pkt_seq1 extends medium_pkt_test;
	`uvm_component_utils(medium_pkt_seq1)
	
	seq1 s1;
	
	function new(string name = "medium_pkt_seq1", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		s1 = seq1::type_id::create("s1");
		if(addr == 2'b00)
			s1.start(envh.dagnt.dagt[0].d_seqr);
		if(addr == 2'b01)
			s1.start(envh.dagnt.dagt[1].d_seqr);
		if(addr == 2'b10)
			s1.start(envh.dagnt.dagt[2].d_seqr);
		phase.drop_objection(this);
		
	endtask: run_phase
endclass: medium_pkt_seq1

class big_pkt_test extends router_base_test;
	`uvm_component_utils(big_pkt_test)
	
	big_pkt seq;
	
	function new(string name = "big_pkt_test", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		addr = $urandom%3;
		uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq = big_pkt::type_id::create("seq");
		for(int i = 0; i < no_of_sagnt; i++)
			begin
				seq.start(envh.sagnt.sagt[i].seqr);
				//seq.print();
			end
		phase.drop_objection(this);
	endtask : run_phase

endclass:big_pkt_test

class big_pkt_seq1 extends big_pkt_test;
	`uvm_component_utils(big_pkt_seq1)
	
	seq1 s1;
	
	function new(string name = "big_pkt_seq1", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		s1 = seq1::type_id::create("s1");
		if(addr == 2'b00)
			s1.start(envh.dagnt.dagt[0].d_seqr);
		if(addr == 2'b01)
			s1.start(envh.dagnt.dagt[1].d_seqr);
		if(addr == 2'b10)
			s1.start(envh.dagnt.dagt[2].d_seqr);
		phase.drop_objection(this);
		
	endtask: run_phase
endclass: big_pkt_seq1