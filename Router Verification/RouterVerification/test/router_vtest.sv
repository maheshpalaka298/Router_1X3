class vtest extends router_base_test;
	`uvm_component_utils(vtest)
	
	small_vseq s_vseq1;
	
	function new(string name = "vtest", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);	
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		repeat(10)
			begin
				addr = {$urandom}%3;
				uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
				s_vseq1 = small_vseq::type_id::create("s_vseq1");
				s_vseq1.start(envh.vsqr);
				//#10; 
			end
		phase.drop_objection(this);
	endtask: run_phase
endclass : vtest

class medium_vtest extends router_base_test;
	`uvm_component_utils(medium_vtest)
	
	medium_vseq m_vseq1;
	
	function new(string name = "medium_vtest", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);	
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		repeat(10)
			begin
				addr = {$urandom}%3;
				uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
				m_vseq1 = medium_vseq::type_id::create("m_vseq1");
				m_vseq1.start(envh.vsqr);
				//#10;
			end
		phase.drop_objection(this);
	endtask: run_phase
endclass : medium_vtest

class big_vtest extends router_base_test;
	`uvm_component_utils(big_vtest)
	
	big_vseq b_vseq1;
	
	function new(string name = "big_vtest", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);	
		super.build_phase(phase);
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		repeat(10)
			begin
				addr = {$urandom}%3;
				uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
				b_vseq1 = big_vseq::type_id::create("b_vseq1");
				b_vseq1.start(envh.vsqr);
				//#10; 
			end
		phase.drop_objection(this);
	endtask: run_phase
endclass : big_vtest

// class bad_pkt_test extends router_base_test;

	// `uvm_component_utils(bad_pkt_test)

	// rand_vseq randseqh;

	// function new(string name = "bad_pkt_test" , uvm_component parent);
		 // super.new(name,parent);
	// endfunction
		
	// function void build_phase(uvm_phase phase);
	   // set_type_override_by_type(s_xtn::get_type(),bad_xtn::get_type());
	   // super.build_phase(phase);
	// endfunction
		
	// task run_phase(uvm_phase phase);
		// phase.raise_objection(this);
		// repeat(10)
			// begin
				// addr = {$urandom}%3;
				// uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
				// randseqh = rand_vseq::type_id::create("randseqh");
				// randseqh.start(envh.vsqr);
				//#10;
			// end	
		// phase.drop_objection(this);
	// endtask
// endclass: bad_pkt_test

// class timeout_test extends router_base_test;
	// `uvm_component_utils(timeout_test)
	
	// rand_timeout_seq timeout_seqh;
	
	// function new(string name = "timeout_test", uvm_component parent);
		// super.new(name, parent);
	// endfunction : new
	
	// function void build_phase(uvm_phase phase);	
		// super.build_phase(phase);
	// endfunction: build_phase
	
	// task run_phase(uvm_phase phase);
		// repeat(10)
			// begin
				// addr = {$urandom}%3;
				// uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
				// timeout_seqh = rand_timeout_seq::type_id::create("timeout_seqh");
				// phase.raise_objection(this);
				// timeout_seqh.start(envh.vsqr);
				// #10;
				// phase.drop_objection(this);
			// end
	// endtask: run_phase
// endclass : timeout_test

class small_vtest_bad extends router_base_test;
	`uvm_component_utils(small_vtest_bad)
	small_vseq vseq; 
	function new(string name = "small_vtest_bad", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	function void build_phase(uvm_phase phase);	
		set_type_override_by_type(s_xtn::get_type(),bad_xtn::get_type());
		super.build_phase(phase);
	endfunction : build_phase
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		repeat(10)
			begin
				addr = $urandom%3;
				uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
				vseq = small_vseq::type_id::create("vseq");
				vseq.start(envh.vsqr);
			end
		phase.drop_objection(this);
	endtask : run_phase
endclass : small_vtest_bad

// class medium_vtest_bad extends router_base_test;
	// `uvm_component_utils(medium_vtest_bad)
	// medium_vseq vseq; 
	// function new(string name = "medium_vtest_bad", uvm_component parent);
		// super.new(name, parent);
	// endfunction : new
	// function void build_phase(uvm_phase phase);	
		// set_type_override_by_type(s_xtn::get_type(),bad_xtn::get_type());
		// super.build_phase(phase);
	// endfunction : build_phase
	// task run_phase(uvm_phase phase);
		// phase.raise_objection(this);
		// repeat(10)
			// begin
				// addr = $urandom%3;
				// uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
				// vseq = medium_vseq::type_id::create("vseq");
				// vseq.start(envh.vsqr);
			// end
		// phase.drop_objection(this);
	// endtask : run_phase
// endclass : medium_vtest_bad

// class big_vtest_bad extends router_base_test;
	// `uvm_component_utils(medium_vtest_bad)
	// big_vseq vseq; 
	// function new(string name = "big_vtest_bad", uvm_component parent);
		// super.new(name, parent);
	// endfunction : new
	// function void build_phase(uvm_phase phase);	
		// set_type_override_by_type(s_xtn::get_type(),bad_xtn::get_type());
		// super.build_phase(phase);
	// endfunction : build_phase
	// task run_phase(uvm_phase phase);
		// phase.raise_objection(this);
		// repeat(10)
			// begin
				// addr = $urandom%3;
				// uvm_config_db#(bit [1:0])::set(this,"*","bit",addr);
				// vseq = big_vseq::type_id::create("vseq");
				// vseq.start(envh.vsqr);
			// end
		// phase.drop_objection(this);
	// endtask : run_phase
// endclass : big_vtest_bad