set_host_options -max_cores 4
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


####################################################################################
###################################  FINISHING  ###################################
####################################################################################

############################################################

## std filler
set pnr_std_fillers " saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_ECO_18   saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_ECO_15 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_ECO_12 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_ECO_9   saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_ECO_2 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_ECO_1    saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_NNWIV1Y2_2 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_NNWIV1Y2_3 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_NNWIY2_2 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_NNWIY2_3 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_NNWSPACERY2_7 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_NNWVDDBRKY2_3 saed14rvt_ss0p6vm40c/SAEDRVT14_FILLP2 saed14rvt_ss0p6vm40c/SAEDRVT14_FILLP3 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_SPACER_7 saed14rvt_ss0p6vm40c/SAEDRVT14_FILL_Y2_3 "


set std_fillers "  saed14rvt_ss0p6vm40c/SAEDRVT14_DCAP_PV1ECO_18   "
#foreach filler $pnr_std_fillers { lappend std_fillers "*/${filler}" }
create_stdcell_filler -lib_cell $std_fillers


set NDM_POWER_NET                "VDD" ;#
set NDM_POWER_PORT               "VDD" ;#
set NDM_GROUND_NET               "VSS" ;#
set NDM_GROUND_PORT              "VSS" ;#



connect_pg_net -automatic

remove_stdcell_fillers_with_violation
#######
create_stdcell_filler -lib_cell $pnr_std_fillers

connect_pg_net -automatic

check_legality
check_routes
#############

set_app_options -name plan.pgcheck.treat_terminal_as_voltage_source -value true
set vss_terminals [get_terminals -of_objects [get_ports VSS]]
set_attribute $vss_terminals must_join_group vss_group
check_pg_connectivity -nets VSS
set vdd_terminals [get_terminals -of_objects [get_ports VDD]]
set_attribute $vdd_terminals must_join_group vdd_group
check_pg_connectivity -nets VDD
check_pg_connectivity
#######\
############################################################

write_verilog /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/results/riscv_core.icc2.gate.v
print_res {finishing}
report_qor > $dir/finishing/qor.rpt
-config config_sr -verbose > $dir/finishing/utilization.rpt

############################################################
##NAR STREAMOUT-I U VERILOG OUT-I PAHY SCRIPTUM CHKA, BAITS AVELATSNENQ CHE EREVI?
if { 1 } {
#report_area
report_timing
report_power 

save_block -as ${DESIGN}_4_finished


change_names -rules verilog -verbose
write_verilog \
	-include {pg_netlist unconnected_ports} \
	/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/output/${DESIGN}_pg.v


set GDS_MAP_FILE          	  "/mnt/hgfs/Gp_CV32e40p/tech/milkyway/saed14nm_1p9m_gdsout_mw.map"

write_gds -design ${DESIGN}_4_finished \
	  -layer_map $GDS_MAP_FILE \
	  -keep_data_type \
	  -fill include \
	  -output_pin all \
	  -lib_cell_view frame \
	  -long_names \
	  /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/output/${DESIGN}.gds

write_parasitics -output    {/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/output/core_final.spf}

close_block
close_lib

exit

}
