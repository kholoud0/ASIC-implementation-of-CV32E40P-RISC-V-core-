set_host_options -max_cores 8
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


open_block /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core:riscv_core_4_placed.design
link_block
####################################################################################
###################################  CTS  ###################################
####################################################################################
set_lib_cell_purpose -include cts \
{HVT_lib/buf1 HVT_lib/buf2 LVT_lib/buf1 LVT_lib/buf2}

############################################################
#source /home/islam/ICpedia_Tasks/GPCore-aes_ip/core_updated/syn/cons/dont_use_generic.tcl

#create_routing_rule ROUTE_RULES_1 \
 # -widths {M3 0.2 M4 0.2 } \
  #-spacings {M3 0.42 M4 0.63 }

#set_clock_routing_rules -rules ROUTE_RULES_1 -min_routing_layer M2 -max_routing_layer M4


create_routing_rule ROUTE_RULES_1 -multiplier_spacing 2 -multiplier_width 2
set_clock_routing_rules -rules ROUTE_RULES_1 -min_routing_layer metal2  -max_routing_layer metal5
set_clock_tree_options -target_latency 0.000 -target_skew 0.000 
set cts_enable_drc_fixing_on_data true

clock_opt

# clock_opt -from final_opto               #optimization

write_verilog /home/ICer/cv32e40p_updated/results/${DESIGN}.cts.gate.v

#report_qor > ../results/${DESIGN}.clock_qor.rpt

#report_clock_timing  -type skew > ../results/${DESIGN}.clock_skew.rpt

set_propagated_clock [get_clocks CLK_GATED]


#create_tap_cells -lib_cell saed14rvt_frame_timing_ccs/SAEDRVT14_TAPDS -pattern stagger -distance 15

save_block -as ${DESIGN}_5_cts

print_res {cts}
report_qor > $dir/cts/qor.rpt

create_utilization_configuration config_sr \
            -capacity site_row -exclude {hard_macros macro_keepouts}
report_utilization -config config_sr -verbose > $dir/cts/utilization.rpt
