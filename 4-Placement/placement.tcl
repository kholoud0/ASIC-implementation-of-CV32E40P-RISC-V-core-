set_host_options -max_cores 8
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"



open_block /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core:riscv_core_3_after_pns.design
 link_block

####################################################################################
###################################  PLACEMENT  ###################################
####################################################################################

############################################################
#source /home/islam/ICpedia_Tasks/GPCore-aes_ip/core_updated/syn/cons/dont_use_generic.tcl


check_design -checks pre_placement_stage
analyze_lib_cell_placement -lib_cells *

set_app_options -name place.coarse.max_density -value 0.6


set_app_options -name place.coarse.congestion_driven_max_util -value 0.6

set_app_options -name time.disable_recovery_removal_checks -value false
set_app_options -name time.disable_case_analysis -value false
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name opt.common.user_instance_name_prefix -value place
#set_app_options -name place.coarse.congestion_layer_aware  -value true
#set_app_options -name place.coarse.increased_cell_expansion  -value true
#set_app_options -name place.coarse.congestion_expansion_direction  -value horizontal.

remove_corners estimated_corner
create_placement -congestion
legalize_placement
check_pg_drc
analyze_design_violations


place_opt
legalize_placement
check_legality -verbos



set NDM_POWER_NET                "VDD" ;#
set NDM_POWER_PORT               "VDD" ;#
set NDM_GROUND_NET               "VSS" ;#
set NDM_GROUND_PORT              "VSS" ;#



#############
create_net -power $NDM_POWER_NET
create_net -ground $NDM_GROUND_NET 

connect_pg_net -net $NDM_POWER_NET [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $NDM_GROUND_NET [get_pins -hierarchical "*/VSS"]
#######



save_block -as ${DESIGN}_4_placed

print_res {placement}
report_qor > $dir/placement/qor.rpt
report_utilization -config config_sr -verbose > $dir/placement/utilization_sire_row.rpt


close_blocks -force -purge
 close_lib


