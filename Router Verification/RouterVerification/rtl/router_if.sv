interface source_if(input bit clock);
	logic [7:0]data_in;
	logic pkt_valid, resetn, error, busy;
	clocking drv_cb@(posedge clock);
		default input #1 output #1;
		output data_in;
		output pkt_valid;
		output resetn;
		input busy, error;
	endclocking : drv_cb
	clocking mon_cb@(posedge clock);
		default input #1 output #1;
		input data_in;
		input pkt_valid;
		input resetn;
		input busy, error;
	endclocking : mon_cb
	
	modport SRC_DRV (clocking drv_cb);
	modport SRC_MON (clocking mon_cb);
	
endinterface : source_if

interface dest_if(input bit clock);
	logic [7:0]data_out;
	logic valid_out, read_en;
	clocking drv_cb@(posedge clock);
		default input #1 output #1;
		input data_out;
		input valid_out;
		output read_en;
	endclocking : drv_cb
	clocking mon_cb@(posedge clock);
		default input #1 output #1;
		input data_out;
		input valid_out;
		input read_en;
	endclocking : mon_cb
	
	modport DES_DRV (clocking drv_cb);
	modport DES_MON (clocking mon_cb);
	
endinterface : dest_if