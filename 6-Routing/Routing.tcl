set_host_options -max_cores 2
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


####################################################################################
###################################  ROUTING  ###################################
####################################################################################
open_block /mntset_host_options -max_cores 2
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


####################################################################################
###############/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core4:riscv_core_5_cts.design
 link_block


############################################################
remove_ignored_layers -all


##############app option to access pins############
#set_app_option -name route.common.connect_within_pins_by_layer_name  -value {{M1 via_standard_cell_pins} {M2 via_standard_cell_pins}}

#set_app_options -list {route.detail.generate_extra_off_grid_pin_tracks {true}}

#set_app_options \
   -name route.common.wire_on_grid_by_layer_name \
   -value {{M1 false}{M2 false}{M3 false} {M4 false}{M5 false}{M6 false}{M7 false}{M8 false}{M9 false}}

#set_app_options \
   -name route.common.via_on_grid_by_layer_name \
   -value {{VIA1 false} {VIA2 false} {VIA3 false} {VIA4 false} {VIA5 false} {VIA6 false} {VIA7 false} {VIA8 false} {VIA9 false}}
}


#set_app_options -list {route.detail.var_spacing_to_same_net {true}}


set MIN_ROUTING_LAYER            "M1"   ;# Min routing layer
set MAX_ROUTING_LAYER            "M8"   ;# Max routing layer


set_ignored_layers \
    -min_routing_layer  $MIN_ROUTING_LAYER \
    -max_routing_layer  $MAX_ROUTING_LAYER
    


check_routability

check_routability > /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/6-Routing/check_routability.rpt
check_design -checks pre_route_stage > /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/6-Routing/check_pre_route.rpt

set_lib_cell_purpose -include all  [get_lib_cells ]


#set_app_option -name route.common.global_min_layer_mode -value allow_pin_connection
#set_app_option -name route.common.global_max_layer_mode -value soft
#set_app_option -name time.si_enable_analysis -value true
#set_app_option -name time.enable_si_timing_windows -value true


route_global
route_track
route_detail

route_opt



save_block -as ${DESIGN}_6_routed_finished_2

print_res {routing}
report_qor > $dir/routing/qor.rpt
check_lvs -max 5000 > $dir/routing/lvs.rpt
report_utilization  -verbose > $dir/routing/utilization.rpt
