remove_design -all
set search_path {../lib}
set target_library {lsi_10k.db}
set link_library "* lsi_10k.db"

analyze -format verilog {../rtl/router_top.v ../rtl/router_fifo.v ../rtl/router_sync.v ../rtl/router_fsm.v ../rtl/router_reg.v}


elaborate router_top

link
#source router.com
check_design

current_design router_top

compile_ultra 
#compile_ultra -no_autoungroup      //for group structure as 5 blocks


#report_timing -path full > timing_report_top.txt

write_file -f verilog -hier -output router_netlist.v


 

