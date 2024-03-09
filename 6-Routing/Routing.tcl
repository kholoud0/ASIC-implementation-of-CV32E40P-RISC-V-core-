set_host_options -max_cores 8
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


####################################################################################
###################################  ROUTING  ###################################
####################################################################################
open_block /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core2:riscv_core_5_cts.design
 link_block


############################################################
remove_ignored_layers -all


set MIN_ROUTING_LAYER            "M2"   ;# Min routing layer
set MAX_ROUTING_LAYER            "M9"   ;# Max routing layer


set_ignored_layers \
    -min_routing_layer  $MIN_ROUTING_LAYER \
    -max_routing_layer  $MAX_ROUTING_LAYER
    


check_routability

check_routability > /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/6-Routing/check_routability.rpt

set_lib_cell_purpose -include all  [get_lib_cells -of [get_cells *]]


set_app_option -name route.common.global_min_layer_mode -value allow_pin_connection
set_app_option -name route.common.global_max_layer_mode -value soft
set_app_option -name time.si_enable_analysis -value true
set_app_option -name time.enable_si_timing_windows -value true


route_global
route_track
route_detail

route_opt



save_block -as ${DESIGN}_6_routed

print_res {routing}
report_qor > $dir/routing/qor.rpt
check_lvs -max 5000 > $dir/routing/lvs.rpt
report_utilization -config config_sr -verbose > $dir/routing/utilization.rpt
