set_host_options -max_cores 8
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


open_block /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core6:riscv_core_4_placed.design
link_block
####################################################################################
###################################  CTS  ###################################
####################################################################################

set_dont_touch_network -clear [get_clocks CLK_I]

set_dont_use [get_lib_cells */*_INV_S_10*]

set_dont_use [get_lib_cells */*_INV_S_12*]

set_dont_use [get_lib_cells */*_INV_S_14*]

set_dont_use [get_lib_cells */*_INV_S_16*]

set_dont_use [get_lib_cells */*_INV_S_20*]

set_dont_use [get_lib_cells */*_INV_S_18*]
set_dont_use [get_lib_cells */*_BUF*]
############################################################
#source /home/islam/ICpedia_Tasks/GPCore-aes_ip/core_updated/syn/cons/dont_use_generic.tcl

#create_routing_rule ROUTE_RULES_1 \
 # -widths {M3 0.2 M4 0.2 } \
  #-spacings {M3 0.42 M4 0.63 }
#########################  include buffers to cts  ########################
set_lib_cell_purpose -exclude cts [get_lib_cells -of [get_cells *]]
#set_lib_cell_purpose -include cts */*AOBUF_IW*
#set_lib_cell_purpose -include cts */*BUF*
set_lib_cell_purpose -include cts */*_INV_S_2*
set_lib_cell_purpose -include cts */*_INV_S_3*
set_lib_cell_purpose -include cts */*_INV_S_4*
set_lib_cell_purpose -include cts */*_INV_S_6*
set_lib_cell_purpose -include cts */*_INV_S_8*
check_design -checks pre_clock_tree_stage

#set_wire_track_pattern -site_def unit -layer M1  -mode uniform -mask_constraint {mask_two mask_one} -coord 0.037 -space 0.0074 -direction horizontal

#set_wire_track_pattern -site_def unit -layer M2  -mode uniform -mask_constraint {mask_two mask_one} -coord 0.0037 -space 0.00074 -direction vertical

set_lib_cell_purpose -exclude cts */*_INV_S_20*


set_app_options \-name cts.common.user_instance_name_prefix -value "CTS_"

set_placement_spacing_label -name a \
            -side both -lib_cells */*_INV_S_8*


set_placement_spacing_label -name a \
            -side both -lib_cells */*_INV_S_6*


set_placement_spacing_label -name a \
            -side both -lib_cells */*_INV_S_4*



set_placement_spacing_label -name a \
            -side both -lib_cells */*_INV_S_3*



set_placement_spacing_label -name a \
            -side both -lib_cells */*_INV_S_2*



set_placement_spacing_rule -labels {a a} {0 3}


set_placement_spacing_label -name b \
            -side both -lib_cells */*_FDPRB_V3_2*

set_placement_spacing_label -name x  -side both -lib_cells [get_lib_cells -of [get_cells *]]

set_placement_spacing_rule -labels {a b} {0 10}

set_placement_spacing_rule -labels {b b} {0 10}

set_placement_spacing_rule -labels {x b} {0 10}

#saed14rvt_ss0p6vm40c:SAEDRVT14_FDPRB_V3_2.frame


create_routing_rule ROUTE_RULES -multiplier_spacing 0.0001 -multiplier_width 0.1
set_clock_routing_rules -rules ROUTE_RULES -min_routing_layer M2  -max_routing_layer M6
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

set_propagated_clock [get_clocks CLK_I]


#create_tap_cells -lib_cell saed14rvt_frame_timing_ccs/SAEDRVT14_TAPDS -pattern stagger -distance 15

save_block -as ${DESIGN}_5_cts

print_res {cts}
report_qor > $dir/cts/qor.rpt

create_utilization_configuration config_sr \
            -capacity site_row -exclude {hard_macros macro_keepouts}
report_utilization -config config_sr -verbose > $dir/cts/utilization_site_row.rpt
report_clock_timing  -type skew >  $dir/cts/clock_skew.rpt
report_clock_qor -type area >  $dir/cts/clock_qor_area.rpt


 close_blocks -force -purge
close_lib

