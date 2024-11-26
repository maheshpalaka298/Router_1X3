class vseq extends uvm_sequence#(uvm_sequence_item);
	`uvm_object_utils(vseq);
	
	small_pkt s_pkt;
	medium_pkt m_pkt;
	big_pkt b_pkt;
	random_pkt rnd_pkth;
	
	bit [1:0]addr;
	
	seq1 s1;
	seq2 s2;
	
	s_sequencer src_seqr[];
	d_sequencer des_seqr[];
	
	vsequencer vsqr;
	env_cfg cfg;
	
	function new(string name="vseq");
		super.new(name);
	endfunction: new
	
	task body();
		if(!uvm_config_db#(env_cfg)::get(null,get_full_name(),"cfg",cfg))
			`uvm_fatal("vseq","getting failed")
		src_seqr = new[cfg.no_of_sagnt];
		des_seqr = new[cfg.no_of_dagnt];
		assert($cast(vsqr,m_sequencer))
		else 
			begin
				`uvm_error("vseq","UVM casting failed")
			end
		foreach(src_seqr[i])
			src_seqr[i] = vsqr.src_seqr[i];
		foreach(des_seqr[i])
			des_seqr[i] = vsqr.des_seqr[i];
	endtask: body

endclass: vseq	

class small_vseq extends vseq;
	`uvm_object_utils(small_vseq)
	
	function new(string name="small_vseq");
		super.new(name);
	endfunction: new
	
	task body();
		super.body();
		s_pkt = small_pkt::type_id::create("s_pkt");
		s1 = seq1::type_id::create("s1");
		if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal("Addr","getting failed in Vseq")
		fork
			begin			
				for(int i=0; i<cfg.no_of_sagnt;i++)
					s_pkt.start(src_seqr[i]);
			end
			begin
				if(addr == 2'b00)
					s1.start(des_seqr[0]);
				if(addr == 2'b01)
					s1.start(des_seqr[1]);
				if(addr == 2'b10)
					s1.start(des_seqr[2]);
			end
		join
	endtask: body
	
endclass: small_vseq

class medium_vseq extends vseq;
	`uvm_object_utils(medium_vseq)
	
	function new(string name="medium_vseq");
		super.new(name);
	endfunction: new
	
	task body();
		super.body();
		m_pkt = medium_pkt::type_id::create("m_pkt");
		s1 = seq1::type_id::create("s1");
		if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal("Addr","getting failed in Vseq")
		fork
			begin			
				for(int i=0; i<cfg.no_of_sagnt;i++)
					m_pkt.start(src_seqr[i]);
			end
			begin
				if(addr == 2'b00)
					s1.start(des_seqr[0]);
				if(addr == 2'b01)
					s1.start(des_seqr[1]);
				if(addr == 2'b10)
					s1.start(des_seqr[2]);
			end
		join
	endtask: body
	
endclass: medium_vseq

class big_vseq extends vseq;
	`uvm_object_utils(big_vseq)
	
	function new(string name="big_vseq");
		super.new(name);
	endfunction: new
	
	task body();
		super.body();
		b_pkt = big_pkt::type_id::create("b_pkt");
		s1 = seq1::type_id::create("s1");
		if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal("Addr","getting failed in Vseq")
		fork
			begin			
				for(int i=0; i<cfg.no_of_sagnt;i++)
					b_pkt.start(src_seqr[i]);
			end
			begin
				if(addr == 2'b00)
					s1.start(des_seqr[0]);
				if(addr == 2'b01)
					s1.start(des_seqr[1]);
				if(addr == 2'b10)
					s1.start(des_seqr[2]);
			end
		join
	endtask: body
	
endclass: big_vseq

class rand_vseq extends vseq;
	`uvm_object_utils(rand_vseq)
	
	function new(string name="rand_vseq");
		super.new(name);
	endfunction: new
	
	task body();
		super.body();
		rnd_pkth = random_pkt::type_id::create("rnd_pkth");
		s1 = seq1::type_id::create("s1");
		if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal("Addr","getting failed in Vseq")
		fork
			begin			
				for(int i=0; i<cfg.no_of_sagnt;i++)
					rnd_pkth.start(src_seqr[i]);
			end
			begin
				if(addr == 2'b00)
					s1.start(des_seqr[0]);
				if(addr == 2'b01)
					s1.start(des_seqr[1]);
				if(addr == 2'b10)
					s1.start(des_seqr[2]);
			end
		join
	endtask: body
endclass: rand_vseq

class rand_timeout_seq extends vseq;
	`uvm_object_utils(rand_timeout_seq)
	
	function new(string name="rand_timeout_seq");
		super.new(name);
	endfunction: new
	
	task body();
		super.body();
		rnd_pkth = random_pkt::type_id::create("rnd_pkth");
		s2 = seq2::type_id::create("s2");
		if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal("Addr","getting failed in Vseq")
		fork
			begin			
				for(int i=0; i<cfg.no_of_sagnt;i++)
					rnd_pkth.start(src_seqr[i]);
			end
			begin
				if(addr == 2'b00)
					s2.start(des_seqr[0]);
				if(addr == 2'b01)
					s2.start(des_seqr[1]);
				if(addr == 2'b10)
					s2.start(des_seqr[2]);
			end
		join
	endtask: body
endclass: rand_timeout_seq



		
		
	
	
	