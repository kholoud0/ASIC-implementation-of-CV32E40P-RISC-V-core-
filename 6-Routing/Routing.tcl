set_host_options -max_cores 8
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


####################################################################################
###################################  ROUTING  ###################################
####################################################################################


############################################################
remove_ignored_layers -all
set_ignored_layers \
    -min_routing_layer  $MIN_ROUTING_LAYER \
    -max_routing_layer  $MAX_ROUTING_LAYER
    
route_opt



save_block -as ${DESIGN}_6_routed

print_res {routing}
report_qor > $dir/routing/qor.rpt
check_lvs -max 5000 > $dir/routing/lvs.rpt
report_utilization -config config_sr -verbose > $dir/routing/utilization.rpt
