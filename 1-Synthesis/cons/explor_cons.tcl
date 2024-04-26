#create_clock -name CLK_I -period 2.2 -waveform {0 1.1} [get_ports clk_i]
#create_generated_clock -source CLK_I -name  CLK_GN -divide_by 1 [get_ports core_clock_gate_i/clk_o]

#set_input_delay -max 0 -clock [get_clocks CLK_I] [remove_from_collection [all_inputs] [get_ports clk_i]]
#set_output_delay -max 0 -clock [get_clocks CLK_I] [all_outputs]
#set_clock_uncertainty 0 [get_clocks]
#set_false_path -hold -from [remove_from_collection [all_inputs] [get_ports clk_i]]
#set_false_path -hold -to [all_outputs]
#set_dont_touch [get_ports clk_i] true
#set_dont_touch [get_ports core_clock_gate_i/clk_o] true
####################################################################################
# Constraints
# ----------------------------------------------------------------------------
#
# 0. Design Compiler variables
#
# 1. Master Clock Definitions
#
# 2. Generated Clock Definitions
#
# 3. Clock Uncertainties
#
# 4. Clock Latencies 
#
# 5. Clock Relationships
#
# 6. set input/output delay on ports
#
# 7. Driving cells
#
# 8. Output load

####################################################################################
           #########################################################
                  #### Section 0 : DC Variables ####
           #########################################################
#################################################################################### 

# Prevent assign statements in the generated netlist (must be applied before compile command)
#set_fix_multiple_port_nets -all -buffer_constants -feedthroughs

####################################################################################
           #########################################################
                  #### Section 1 : Clock Definition ####
           #########################################################
#################################################################################### 
# 1. Master Clock Definitions 
create_clock -name CLK_I -period 4 -waveform {0 2} [get_ports clk_i]
#set_dont_touch_network [get_clocks CLK_I]



# 2. Generated Clock Definitions
#create_generated_clock -master_clock "CLK_I" -source [get_ports clk_i] -name  CLK_GATED -divide_by 1 [get_ports core_clock_gate_i/clk_o]



#create_generated_clock -master_clock CLK_I -source [get_ports clk_i] -name CLK_GATED \
 #  -divide_by 1 [get_ports core_clock_gate_i/clk_o]


#set_dont_touch_network [get_clocks CLK_GATED]


# 3. Clock Latencies
# 4. Clock Uncertainties
set_clock_uncertainty 0.1 [get_clocks CLK_I]
# 4. Clock Transitions

puts "\t\t\t\t ###################reporting clocks#####################"
report_clocks 
####################################################################################

 

#set_false_path -hold -from [remove_from_collection [all_inputs] [get_ports clk_i]]
#set_false_path -hold -to [all_outputs]



####################################################################################
           #########################################################
             #### Section 2 : Clocks Relationship ####
           #########################################################
####################################################################################


####################################################################################
           #########################################################
             #### Section 3 : set input/output delay on ports ####
           #########################################################
####################################################################################
set_input_delay -max 0 -clock [get_clocks CLK_I] [remove_from_collection [all_inputs] [get_ports clk_i]]
set_output_delay -max 0 -clock [get_clocks CLK_I] [all_outputs]


####################################################################################
           #########################################################
                  #### Section 4 : Driving cells ####
           #########################################################
####################################################################################



####################################################################################
           #########################################################
                  #### Section 5 : Output load ####
           #########################################################
####################################################################################
#set_load  25000000   [all_outputs]

set_max_fanout	20 $top
####################################################################################
           #########################################################
                 #### Section 6 : Operating Condition ####
           #########################################################
####################################################################################

# Define the Worst Library for Max(#setup) analysis
# Define the Best Library for Min(hold) analysis
set_operating_conditions  -min_library "saed14rvt_ff0p88v25c" -min "ff0p88v25c" -max_library "saed14rvt_ss0p6vm40c" -max "ss0p6vm40c"
####################################################################################



