#### Variables
set CONSTRAINTS   	"/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/1-Synthesis/cons/explor_cons.tcl"
set DB_PATH 		"/mnt/hgfs/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/db_nldm"
set ELABORATION 	"/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/1-Synthesis/scripts/elaborate_riscy.tcl"

#set TTLIB 	"$DB_PATH/saed14rvt_tt0p8v125c.db"
set FFLIB 	"$DB_PATH/saed14rvt_ff0p88v25c.db"
set SSLIB 	"$DB_PATH/saed14rvt_ss0p6vm40c.db"                                        

################## Design Compiler Library Files #setup ######################

puts "###########################################"
puts "#      #setting Design Libraries          #"
puts "###########################################"


## Standard Cell libraries 

set link_library 	 [list * $SSLIB $FFLIB]
set target_library 	 [list $SSLIB $FFLIB]

######################## Elaboration #################################
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/1-Synthesis/cons/dont_use_generic.tcl


source $ELABORATION


#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## checking design consistency ##########"
puts "###############################################"

check_design > design_checks.log

#################### Define Design Constraints #########################
puts "###############################################"
puts "############ Design Constraints #### ##########"
puts "###############################################"

source -verbose $CONSTRAINTS

check_timing


################ creating DFT Ports and Clock ######################
puts "###############################################"
puts "####### creating DFT Signals and Clock #########"
puts "###############################################"
create_port scan_clk -direction in
create_port scan_rst -direction in
create_port scan_mode -direction in

create_port scan_in -direction in
create_port scan_out -direction out

create_clock -name s_clk -period 100 -waveform {0 50} [get_ports scan_clk]

#set_dont_touch_network [get_clocks s_clk]
###################### Mapping and optimization ########################
puts "###############################################"
puts "########## Mapping & Optimization #############"
puts "###############################################"


compile_ultra -scan


###################### set DFT Configrations ##########################
puts "###############################################"
puts "########## set DFT Configrations #############"
puts "###############################################"


set_app_var test_default_delay 0
set_app_var test_default_bidir_delay 0
set_app_var test_default_strobe 40
set_app_var test_default_period 100
#et_scan_configuration -style multiplexed_flip_flop

############################################################################
# DFT Preparation Section
############################################################################

set flops_per_chain 100

set num_flops [sizeof_collection [all_registers -edge_triggered]]

set num_chains [expr $num_flops / $flops_per_chain + 1 ]
set_scan_configuration -chain_count $num_chains

###################### set DFT Signals and Type #####################
puts "###############################################"
puts "########## set DFT Signals and Type #############"
puts "###############################################"


set_dft_signal  -type ScanClock   -port [get_ports scan_clk]   -view existing_dft -timing [list 45 55]   

set_dft_signal  -type ScanEnable  -port [get_ports test_en_i]  -view existing_dft 
set_dft_signal  -type Reset       -port [get_ports scan_rst]   -view spec         -active_state 0
set_dft_signal  -type TestMode    -port [get_ports scan_mode]  -view spec         -active_state 1
set_dft_signal  -type Constant    -port [get_ports scan_mode]  -view existing_df  -active_state 1

set_dft_signal  -type ScanDataIn  -port [get_ports scan_in]    -view spec
set_dft_signal  -type ScanDataOut -port [get_ports scan_out]   -view spec


###################### Creating Test Protocol #####################
puts "###############################################"
puts "########## Creating Test Protocol #############"
puts "###############################################"

create_test_protocol -infer_clock -infer_asynch

###################### DFT insertion and Checks #####################
puts "###############################################"
puts "########## DFT insertion and Checks #############"
puts "###############################################"

dft_drc
insert_dft
dft_drc -coverage_estimate 

######################  second optimization #####################
puts "###############################################"
puts "##########  second optimization #############"
puts "###############################################"


compile_ultra -incremental -scan


############################# Formality Setup File ##########################
                                                   
set_svf $top.svf 

#############################################################################
# Write out files
#############################################################################
group_path -name input -from [all_inputs]
group_path -name outputs -to [all_outputs]
group_path -name comb -from [all_inputs] -to [all_outputs]
report_timing



define_name_rules  no_case -case_insensitive
change_names -rule no_case -hierarchy
change_names -rule sverilog -hierarchy
set verilogout_no_tri	 true
set verilogout_equation  false


write_file -format verilog -hierarchy -output ../netlists/$top.ddc
write_file -format verilog -hierarchy -output ../netlists/$top.v
write_sdf  ../sdf/$top.sdf
write_sdc  -nosplit ../sdc/$top.sdc
write_scan_def -output ../netlists/$top.scandef

####################### reporting ##########################################

report_area -hierarchy > ../reports/area.rpt
report_power -hierarchy > ../reports/power.rpt
report_timing -delay_type max -max_paths 20 > ../reports/setup.rpt
report_clock -attributes > ../reports/clocks.rpt
report_constraint -all_violators -nosplit > ../reports/constraints.rpt
dft_drc -verbose -coverage_estimate >> ../reports/dft.rpt

################# starting graphical user interface #######################

#gui_start

#exit

sh cp $top.svf ../svf/ 
