## Generated SDC file "fft_test.out.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.0 Build 711 06/05/2020 SJ Standard Edition"

## DATE    "Thu Nov  3 14:13:07 2022"

##
## DEVICE  "5CSXFC6D6F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 33.333 -waveform { 0.000 16.666 } [get_ports {altera_reserved_tck}]
create_clock -name {clk_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pll_150} -source [get_pins {inst7|pll_0|altera_pll_i|outclk_wire[0]~CLKENA0|inclk}] -multiply_by 3 -master_clock {clk_50} [get_pins {inst7|pll_0|altera_pll_i|outclk_wire[0]~CLKENA0|outclk}] 
#create_generated_clock -name {pll_150} -source [get_pins {inst7|pll_0|altera_pll_i|outclk_wire[0]~CLKENA0|inclk}] -multiply_by 3 [get_pins {inst7|pll_0|altera_pll_i|outclk_wire[0]~CLKENA0|outclk}]

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {pll_150}] -rise_to [get_clocks {pll_150}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {pll_150}] -rise_to [get_clocks {pll_150}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {pll_150}] -fall_to [get_clocks {pll_150}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {pll_150}] -fall_to [get_clocks {pll_150}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {pll_150}] -rise_to [get_clocks {pll_150}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {pll_150}] -rise_to [get_clocks {pll_150}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {pll_150}] -fall_to [get_clocks {pll_150}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {pll_150}] -fall_to [get_clocks {pll_150}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

