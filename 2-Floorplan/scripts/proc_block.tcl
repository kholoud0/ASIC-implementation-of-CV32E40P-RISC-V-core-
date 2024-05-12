proc print_res {"stage"} {

set dir /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report-hier
sh rm -rf $dir/$stage
sh mkdir -p $dir/$stage


report_power > $dir/$stage/power.rpt
report_port -verbose > $dir/$stage/port_info.rpt
report_clock -attributes > $dir/$stage/clock_info.rpt
report_constraint -all_violators -nosplit > $dir/$stage/constraints.rpt
report_timing -max_paths 20 -delay_type max -nosplit -capacitance -transition_time -nets -input_pins  > $dir/$stage/timing_max_long.rpt
report_timing -max_paths 20 -delay_type min -nosplit -capacitance -transition_time -nets -input_pins  > $dir/$stage/timing_min_long.rpt
report_timing -max_paths 20 -delay_type min -nosplit -path_type short > $dir/$stage/timing_min.rpt
report_timing -max_paths 50 -delay_type max -nosplit -path_type short > $dir/$stage/timing_max.rpt
report_hierarchy   > $dir/$stage/hierarchy.rpt
#report_area > $dir/$stage/area.rpt
report_qor  > $dir/$stage/qor.rpt
report_utilization > $dir/$stage/utilization.rpt
check_legality > $dir/$stage/legilality.rpt
report_design  > $dir/$stage/design_phyiscal.rpt

}


# you can call it any where in the script but you must run it at the begining of the script
#print_res {fp}
#print_res {pns}
#print_res {placement}
#print_res {cts}
#print_res {routing}
#and so on
#you just pass the name of file will be crated to save these repports on.
#the file is created at previos dir 
