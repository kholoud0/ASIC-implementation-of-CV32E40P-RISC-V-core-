set_host_options -max_cores 8
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


open_block /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core:riscv_core_2_floorplan.design

link_block

####################################################################################
###################################  POWER PLAN  ###################################
####################################################################################

############################
########  PG RINGS  ########
############################

remove_pg_via_master_rules -all
remove_pg_patterns -all
remove_pg_strategies -all
remove_pg_strategy_via_rules -all





create_pg_ring_pattern ring1 \
	    -nets VDD \
            -horizontal_layer {M9} -vertical_layer {M8 } \
            -horizontal_width 5 -vertical_width 5 \
            -horizontal_spacing 0.8 -vertical_spacing 0.8 \
            -via_rule {{intersection: all}}



set_pg_strategy ring1_s -core -pattern {{name: ring1} {nets: VDD VSS}} -extension {{stop: design_boundary}}



compile_pg -strategies ring1_s



create_pg_ring_pattern ring2 \
	    -nets VSS \
            -horizontal_layer {M7} -vertical_layer {M6} \
            -horizontal_width 5 -vertical_width 5 \
            -horizontal_spacing 0.8 -vertical_spacing 0.8 \
            -via_rule {{intersection: all}}

set_pg_strategy ring2_s -core -pattern {{name: ring2} {nets: VDD VSS}} -extension {{stop: design_boundary}}
compile_pg -strategies ring2_s


create_pg_mesh_pattern m9_mesh -layers {{{horizontal_layer: M9} {width: 2.5} {spacing: 4} {pitch: 13} {offset: 8}}}
set_pg_strategy m9_mesh -core -extension {{direction: T B L R} {stop: outermost_ring}} -pattern {{name: m9_mesh} {nets: VDD VSS}} 
compile_pg -strategies m9_mesh



create_pg_mesh_pattern m8_mesh -layers {{{vertical_layer: M8} {width: 2.5} {spacing: 4} {pitch: 13} {offset: 8}}}
set_pg_strategy m8_mesh -core -extension {{direction: T B L R} {stop: outermost_ring}} -pattern {{name: m8_mesh} {nets: VDD VSS}} 
compile_pg -strategies m8_mesh


create_pg_mesh_pattern m7_mesh -layers {{{horizontal_layer: M7} {width: 2.5} {spacing: 4} {pitch: 13} {offset: 8}}}
set_pg_strategy m7_s -core -extension {{direction: T B L R} {stop: outermost_ring}} -pattern {{name: m7_mesh} {nets: VDD VSS}} 
compile_pg -strategies m7_s

create_pg_mesh_pattern m6_mesh -layers {{{vertical_layer: M6} {width: 2.5} {spacing: 4} {pitch: 13} {offset: 8}}}
set_pg_strategy m6_s -core -extension {{direction: T B L R} {stop: outermost_ring}} -pattern {{name: m6_mesh} {nets: VDD VSS}} 
compile_pg -strategies m6_s

create_pg_mesh_pattern m5_mesh -layers {{{horizontal_layer: M5} {width: 2.5} {spacing: 4} {pitch: 13} {offset: 8}}}
set_pg_strategy m5_s -core -extension {{direction: T B L R} {stop: core_boundary}} -pattern {{name: m5_mesh} {nets: VDD VSS}} 
compile_pg -strategies m5_s




create_pg_std_cell_conn_pattern rail_pattern  -rail_width 0.094 -layers {M1}
######### Create rail strategy #########################
set_pg_strategy rail_strat -pattern {{pattern: rail_pattern} {nets: VDD VSS}} -core
######### compile rail #################################
compile_pg -strategies rail_strat 

#############  fixing floating vias ###################
remove_via  [get_vias -of_objects [get_nets -all "VSS VDD"]]
create_pg_vias -nets "VSS VDD"

################# design checks ######################
check_pg_connectivity
 check_pg_drc 
check_pg_missing_vias 

######################### saving Design & printing reports #####################

save_block -as ${DESIGN}_3_after_pns

print_res {pns}
report_qor > $dir/pns/qor.rpt
create_utilization_configuration config_sr \
            -capacity site_row -exclude {hard_macros macro_keepouts}
report_utilization -config config_sr -verbose > $dir/pns/utilization_sire_row.rpt



close_blocks -force -purge

 close_lib






