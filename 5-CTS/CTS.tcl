set_host_options -max_cores 4
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


open_block /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core6:riscv_core_4_placed.design
link_block
####################################################################################
###################################  CTS  ###################################
####################################################################################

##############app option to access pins############
#set_app_option -name route.common.connect_within_pins_by_layer_name  -value {{M1 via_standard_cell_pins } {M2 via_standard_cell_pins }}



set_dont_touch_network -clear [get_clocks CLK_I]

set_dont_use [get_lib_cells */*_INV_S_10*]

set_dont_use [get_lib_cells */*_INV_S_12*]

set_dont_use [get_lib_cells */*_INV_S_14*]

set_dont_use [get_lib_cells */*_INV_S_16*]

set_dont_use [get_lib_cells */*_INV_S_20*]


set_dont_use [get_lib_cells */*_BUF*]
############################################################


#create_routing_rule ROUTE_RULES_1 
\
  -widths {M1 0.034 M2 0.034 M3 0.034  } \
  -spacings {M1 0.41 M2 0.041 M3 0.041 }
#########################  include inverters only to cts  ########################
set_lib_cell_purpose -exclude cts [get_lib_cells -of [get_cells *]]
#set_lib_cell_purpose -include cts */*AOBUF_IW*
#set_lib_cell_purpose -include cts */*BUF*
set_lib_cell_purpose -include cts */*_INV_S_2*
set_lib_cell_purpose -include cts */*_INV_S_3*
set_lib_cell_purpose -include cts */*_INV_S_4*
set_lib_cell_purpose -include cts */*_INV_S_6*
set_lib_cell_purpose -include cts */*_INV_S_8*
check_design -checks pre_clock_tree_stage

set_lib_cell_purpose -exclude cts */*_INV_S_20*


#set_wire_track_pattern -site_def unit -layer M1  -mode uniform -mask_constraint {mask_two mask_one} -coord 0.037 -space 0.0074 -direction horizontal

#set_wire_track_pattern -site_def unit -layer M2  -mode uniform -mask_constraint {mask_two mask_one} -coord 0.0037 -space 0.00074 -direction vertical

set_app_options \-name cts.common.user_instance_name_prefix -value "CTS_"


create_routing_rule ROUTE_RULES -multiplier_spacing 1 -multiplier_width 1
set_clock_routing_rules -rules ROUTE_RULES -min_routing_layer M2  -max_routing_layer M9
set_clock_tree_options -target_latency 0.000 -target_skew 0.000 
set cts_enable_drc_fixing_on_data true




clock_opt





set NDM_POWER_NET                "VDD" ;#
set NDM_POWER_PORT               "VDD" ;#
set NDM_GROUND_NET               "VSS" ;#
set NDM_GROUND_PORT              "VSS" ;#



connect_pg_net -net $NDM_POWER_NET [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $NDM_GROUND_NET [get_pins -hierarchical "*/VSS"]
#######



# clock_opt -from final_opto               #optimization
check_pg_drc
write_verilog /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/results/${DESIGN}.cts.gate.v

#set_propagated_clock [get_clocks CLK_I]

save_block -as ${DESIGN}_5_cts

print_res {cts}
report_qor > $dir/cts/qor.rpt

report_clock_timing  -type skew >  $dir/cts/clock_skew.rpt
report_clock_qor -type area >  $dir/cts/clock_qor_area.rpt


 close_blocks -force -purge
close_lib

