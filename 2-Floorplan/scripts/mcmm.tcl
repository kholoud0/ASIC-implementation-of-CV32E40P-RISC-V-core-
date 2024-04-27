set Constraints_file "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/cons/func_mode.tcl"
set fast_corner "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/cons/saed14rvt_ff0p88v25c.tcl"
set slow_corner "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/cons/saed14rvt_ss0p6vm40c.tcl"

remove_corners -all
remove_modes -all
remove_scenarios -all

create_corner slow
create_corner fast

read_parasitic_tech \
	-tlup $TLUPLUS_MAX_FILE \
	-layermap $MAP_FILE \
	-name tlup_max

read_parasitic_tech \
	-tlup $TLUPLUS_MIN_FILE \
	-layermap $MAP_FILE \
	-name tlup_min

set_parasitics_parameters \
	-early_spec tlup_min \
	-late_spec tlup_min \
	-corners {fast}

set_parasitics_parameters \
	-early_spec tlup_max \
	-late_spec tlup_max \
	-corners {slow}

create_mode func
current_mode func


### FUNC_FAST
current_corner fast
source $fast_corner


create_scenario -mode func -corner fast -name func_fast
source $Constraints_file


### FUNC_SLOW
current_corner slow
puts "current_corner slow"
source $slow_corner


create_scenario -mode func -corner slow -name func_slow
source $Constraints_file

################### TEST MODE ##########################
create_mode test
### TEST_FAST
current_corner fast
source $fast_corner
create_scenario -mode test -corner fast -name test_fast
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/cons/test_mode.tcl

### TEST_SLOW
current_corner slow
puts "current_corner slow"
source $slow_corner
create_scenario -mode test -corner slow -name test_slow


current_scenario func_slow

