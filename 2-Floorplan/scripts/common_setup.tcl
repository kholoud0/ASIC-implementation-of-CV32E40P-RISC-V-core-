puts "RM-Info: Running script [info script]\n"

##########################################################################################
# Variables common to all RM scripts
# Script: common_setup.tcl
# Version: F-2011.09-SP4 (April 2, 2012)
# Copyright (C) 2007-2012 Synopsys, Inc. All rights reserved.
##########################################################################################

set DESIGN_NAME                   "riscv_core"  ;#  The name of the top-level design

## Point to the new 14nm SAED libs
#set DESIGN_REF_PATH "/remote/exchange/synopsys/SAED14_EDK"
set DESIGN_REF_PATH		  "/mnt/hgfs/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/db_nldm"

set DESIGN_REF_TECH_PATH          "/mnt/hgfs/SAED14nm_PDK_06052019/SAED14nm_PDK_12232018/techfiles"

#set DESIGN_REF_DATA_PATH          ""  ;#  Absolute path prefix variable for library/design data.
                                       #  Use this variable to prefix the common absolute path to 
                                       #  the common variables defined below.
                                       #  Absolute paths are mandatory for hierarchical RM flow.

##########################################################################################
# Hierarchical Flow Design Variables
##########################################################################################

#set HIERARCHICAL_DESIGNS           "" ;# List of hierarchical block design names "DesignA DesignB" ...
#set HIERARCHICAL_CELLS             "" ;# List of hierarchical block cell instance names "u_DesignA u_DesignB" ...

##########################################################################################
# Library Setup Variables
##########################################################################################

# For the following variables, use a blank space to separate multiple entries
# Example: set TARGET_LIBRARY_FILES "lib1.db lib2.db lib3.db"

set ADDITIONAL_SEARCH_PATH     "/mnt/hgfs/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/db_nldm \
				/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/1-Synthesis/runs "



set GATE_NET_PATH       "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/1-Synthesis/runs"

set DB_PATH 	"/mnt/hgfs/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/db_nldm"
set FFLIB 		"$DB_PATH/saed14rvt_ff0p88v125c.db"
set SSLIB 		"$DB_PATH/saed14rvt_ss0p6vm40c.db"


set TARGET_LIBRARY_FILES [list $SSLIB $FFLIB]
set LINK_LIBRARY_FILES [list * $SSLIB $FFLIB]  

set NDM_REFERENCE_LIB_DIRS  " \
       /mnt/hgfs/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/db_nldm \
       /mnt/hgfs/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/ndm/saed14rvt_frame_only.ndm \
       
"

set MW_REFERENCE_CONTROL_FILE     "saed14nm_1p9m_mw.tf"  ;#  Reference Control file to define the MW ref libs

set TECH_FILE                     "${DESIGN_REF_TECH_PATH}/saed14nm_1p9m_mw.tf"  ;#  Milkyway technology file
#set TECH_FILE                     "/SCRATCH/labs/Low_Power_Methodology_Manual_for_3228nm/saed14rvt_1p9m.tf"
set MAP_FILE                      "/mnt/hgfs/SAED14nm_PDK_06052019/SAED14nm_PDK_12232018/starrc/saed14nm_tf_itf_tluplus.map"  ;#  Mapping file for TLUplus
set TLUPLUS_MAX_FILE              "/mnt/hgfs/SAED14nm_PDK_06052019/SAED14nm_PDK_12232018/starrc/max/saed14nm_1p9m_Cmax.tluplus"  ;#  Max TLUplus file
set TLUPLUS_MIN_FILE              "/mnt/hgfs/SAED14nm_PDK_06052019/SAED14nm_PDK_12232018/starrc/min/saed14nm_1p9m_Cmin.tluplus"  ;#  Min TLUplus file
set GDS_MAP_FILE          	  "/mnt/hgfs/SAED14nm_PDK_06052019/SAED14nm_PDK_12232018/techfiles/saed14nm_1p9m_gdsout_mw_icc2.map"
set STD_CELL_GDS		  "/mnt/hgfs/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/gds/saed14rvt.gds"
#set SRAMLP_SINGLELP_GDS		  "${DESIGN_REF_PATH}/lib/sram_lp/gds/singlelp.gds"

set NDM_POWER_NET                "VDD" ;#
set NDM_POWER_PORT               "VDD" ;#
set NDM_GROUND_NET               "VSS" ;#
set NDM_GROUND_PORT              "VSS" ;#

set MIN_ROUTING_LAYER            "M2"   ;# Min routing layer
set MAX_ROUTING_LAYER            "M9"   ;# Max routing layer

##RH variable for ICC SAED library and design input data
#set ICC_INPUT_DATA "/global/scratch/mculver/PD_fest_2012/initial_design/dhm"

#???set LIBRARY_DONT_USE_FILE        "source /home/islam/ICpedia_Tasks/GPCore-aes_ip/core_updated/syn/cons/dont_use_generic.tcl"   ;# Tcl file with library modifications for dont_use

##########################################################################################
# Multi-Voltage Common Variables
#
# Define the following MV common variables for the RM scripts for multi-voltage flows.
# Use as few or as many of the following definitions as needed by your design.
##########################################################################################

#set PD1                          ""           ;# Name of power domain/voltage area  1
#set PD1_CELLS                    ""           ;# Instances to include in power domain/voltage area 1
#set VA1_COORDINATES              {}           ;# Coordinates for voltage area 1
#set NDM_POWER_NET1                "VDD1"       ;# Power net for voltage area 1
#set NDM_POWER_PORT1               "VDD"        ;# Power port for voltage area 1

#set PD2                          ""           ;# Name of power domain/voltage area  2
#set PD2_CELLS                    ""           ;# Instances to include in power domain/voltage area 2
#set VA2_COORDINATES              {}           ;# Coordinates for voltage area 2
#set NDM_POWER_NET2                "VDD2"       ;# Power net for voltage area 2
#set NDM_POWER_PORT2               "VDD"        ;# Power port for voltage area 2

#set PD3                          ""           ;# Name of power domain/voltage area  3
#set PD3_CELLS                    ""           ;# Instances to include in power domain/voltage area 3
#set VA3_COORDINATES              {}           ;# Coordinates for voltage area 3
#set NDM_POWER_NET3                "VDD3"       ;# Power net for voltage area 3
#set NDM_POWER_PORT3               "VDD"        ;# Power port for voltage area 3

#set PD4                          ""           ;# Name of power domain/voltage area  4
#set PD4_CELLS                    ""           ;# Instances to include in power domain/voltage area 4
#set VA4_COORDINATES              {}           ;# Coordinates for voltage area 4
#set NDM_POWER_NET4                "VDD4"       ;# Power net for voltage area 4
#set NDM_POWER_PORT4               "VDD"        ;# Power port for voltage area 4

puts "RM-Info: Completed script [info script]\n"

###################################################################################
###################################   INITLIB   ###################################
###################################################################################

set_host_options -max_cores 8
set DESIGN riscv_core
set_app_var search_path "$DESIGN_REF_TECH_PATH $DESIGN_REF_PATH $DB_PATH $GATE_NET_PATH"


#close_lib

#file delete -force ${DESIGN}

create_lib -technology  $TECH_FILE -ref_libs " /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/CLIB_created/CLIBs/saed14rvt_c.ndm \
                                              /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/CLIB_created/CLIBs/saed14rvt_c_physical_only.ndm" ${DESIGN}

read_parasitic_tech -tlup $TLUPLUS_MAX_FILE  -layermap  $MAP_FILE 
read_parasitic_tech -tlup $TLUPLUS_MIN_FILE  -layermap  $MAP_FILE 


 
