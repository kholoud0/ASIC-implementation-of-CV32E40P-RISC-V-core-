set_host_options -max_cores 1
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


 open_block /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core5:riscv_core_3_after_pns.design

 link_block

####################################################################################
###################################  PLACEMENT  ###################################
####################################################################################

############################################################
#source /home/islam/ICpedia_Tasks/GPCore-aes_ip/core_updated/syn/cons/dont_use_generic.tcl
#set_target_library_subset -dont_use [get_lib_cells */*0P5*]
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_INV_4.frame
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_EO2_V1_0P75.frame
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_OA221_U_0P5.frame
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_CAPTTAPP6.frame
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_OA21_1.frame
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_OAI21_0P5.frame
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_MUX2_MM_0P5.frame
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_MUX2_MM_0P5.frame
#set_target_library_subset -dont_use saed14rvt_ss0p6vm40c:SAEDRVT14_OA221_U_0P5.frame
#set_app_options \
#-name opt.common.enable_target_library_subset_opt -value 1


check_design -checks pre_placement_stage
analyze_lib_cell_placement -lib_cells *

#set_app_options -name place.coarse.max_density -value 0.

#saed14rvt_ss0p6vm40c:SAEDRVT14_FDPS_V3_2.frame
#set_app_options -name place.coarse.congestion_driven_max_util -value 0.5

set_app_options -name time.disable_recovery_removal_checks -value false
set_app_options -name time.disable_case_analysis -value false
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name opt.common.user_instance_name_prefix -value place

#set_app_options -name place.coarse.congestion_layer_aware  -value true
#set_app_options -name place.coarse.increased_cell_expansion  -value true
#set_app_options -name place.coarse.congestion_expansion_direction  -value horizontal.

#remove_corners estimated_corner
create_placement -congestion
legalize_placement
check_pg_drc
analyze_design_violations


place_opt
legalize_placement
check_legality -verbos
report_timing


set NDM_POWER_NET                "VDD" ;#
set NDM_POWER_PORT               "VDD" ;#
set NDM_GROUND_NET               "VSS" ;#
set NDM_GROUND_PORT              "VSS" ;#



connect_pg_net -net $NDM_POWER_NET [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $NDM_GROUND_NET [get_pins -hierarchical "*/VSS"]
#######



save_block -as ${DESIGN}_4_placed_2

print_res {placement}
report_qor > $dir/placement/qor.rpt



close_blocks -force -purge
 close_lib


