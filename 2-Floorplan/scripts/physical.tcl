source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/common_setup.tcl	

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


####################################################################################
###################################   FLOORPLAN   ##################################
####################################################################################

set gate_verilog "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/1-Synthesis/runs/run_18/netlists/riscv_core.v" 

read_verilog -top $DESIGN $gate_verilog

current_design $DESIGN

#read_sdc /home/ICer/cv32e40p_updated/output/${DESIGN}.sdc
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/1-Synthesis/cons/dont_use_generic.tcl
#load_upf ../../dc/output/compile.upf

#commit_upf
#source /home/ICer/cv32e40p_updated/scripts/Synthesis/cons/cons.tcl

source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/mcmm.tcl
#source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/cons/dont_use_generic.tcl
save_block -as ${DESIGN}_1_imported

############################################################
set_attribute [get_layers M1] routing_direction horizontal
set_attribute [get_layers M2] routing_direction vertical
set_attribute [get_layers M3] routing_direction horizontal
set_attribute [get_layers M4] routing_direction vertical
set_attribute [get_layers M5] routing_direction horizontal
set_attribute [get_layers M6] routing_direction vertical
set_attribute [get_layers M7] routing_direction horizontal
set_attribute [get_layers M8] routing_direction vertical
set_attribute [get_layers M9] routing_direction horizontal
set_attribute [get_layers MRDL] routing_direction vertical

#set_wire_track_pattern -site_def unit -layer M1  -mode uniform -mask_constraint {mask_two mask_one} \
#-coord 0.037 -space 0.074 -direction vertical


#./output/ChipTop_pads.v
initialize_floorplan \
  -core_utilization 0.25 \
  -flip_first_row true \
  -core_offset {11.25 11.25 11.25 11.25}
   # -boundary {{0 0} {700 700}} \
########################        place pins with constraints          ######################
set_block_pin_constraints -self -allowed_layers {M6 M7} -sides {1 2 3 4}
place_pins -ports [get_ports *]

#fix the ports 
set_attribute [get_ports *] physical_status fixed
get_attribute [get_ports *] is_fixed

#######################         inserting eell tap cells   #####################################
create_tap_cells -lib_cell  [get_lib_cell saed14rvt_ss0p6vm40c/SAEDRVT14_TAPDS] -pattern stagger -distance 30

#save_block -as ${DESIGN}_2_floorplan
#SAED14_CAPTTAPP6

#get_lib_cells *BOUND*
#create_boundary_cells -tap_distance 20 -left_boun
#set non_physical_cells [get_cells -filter {is_physical == false}]dary_cell <cell name> -right_boundary_cell <cell names>
#set non_physical_cells [get_cells -filter {is_physical == false}]
#create_keepout_margin -type soft -outer {3 0 3 0} [get_cells *]

set_placement_spacing_label -name x  -side both -lib_cells [get_lib_cells -of [get_cells *]]

set_placement_spacing_rule -labels {x x} {0 1}

report_placement_spacing_rules


#############
create_net -power $NDM_POWER_NET
create_net -ground $NDM_GROUND_NET 

connect_pg_net -net $NDM_POWER_NET [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $NDM_GROUND_NET [get_pins -hierarchical "*/VSS"]
#######


##############################  floorplanning placement ####################

create_placement -floorplan -timing_driven
legalize_placement
###############################  saving Floorplan Block  #######################
save_block -as ${DESIGN}_2_floorplan

##############################  printing Reports  #############################
print_res {fp}
report_qor > $dir/fp/qor.rpt
create_utilization_configuration config_sr \
            -capacity site_row -exclude {hard_macros macro_keepouts}
report_utilization -config config_sr -verbose > $dir/fp/utilization_site_row.rpt



close_blocks -force -purge
close_lib

