
# 
# packetizer "packetizer" v0.1
# Nitzan Lavi 2022.08.16.10:05:05
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1

add_parameter design_env STRING "SYSTEM"
set_parameter_property design_env VISIBLE false
set_parameter_property design_env system_info DESIGN_ENVIRONMENT
# 
# module packetizer
# 
set_module_property DESCRIPTION "Communicates with cpld controller and sends adc data in Avalon Streaming interface with packets flags"
set_module_property NAME packetizer
set_module_property VERSION 0.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP VincNL
set_module_property AUTHOR "Nitzan Lavi"
set_module_property DISPLAY_NAME packetizer
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL packetizer
set_fileset_property quartus_synth ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property quartus_synth ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file packetizer.vhd VHDL PATH ../source/packetizer.vhd TOP_LEVEL_FILE

add_fileset sim_vhdl SIM_VHDL "" ""
set_fileset_property sim_vhdl TOP_LEVEL packetizer
set_fileset_property sim_vhdl ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property sim_vhdl ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file packetizer_tb.vhd VHDL PATH ../tb/packetizer_tb.vhd
add_fileset_file packetizer.vhd VHDL PATH ../source/packetizer.vhd

set_module_property ELABORATION_CALLBACK    elaborate_me
set_module_property VALIDATION_CALLBACK     validate_me

# 
# parameters
# 
add_parameter PACKET_LEN POSITIVE 1024
set_parameter_property PACKET_LEN DEFAULT_VALUE 8192
set_parameter_property PACKET_LEN DISPLAY_NAME {Length}
set_parameter_property PACKET_LEN TYPE INTEGER
set_parameter_property PACKET_LEN UNITS None
set_parameter_property PACKET_LEN ALLOWED_RANGES \
{8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144}
set_parameter_property PACKET_LEN DESCRIPTION {Packet length}
set_parameter_property PACKET_LEN AFFECTS_GENERATION true 
set_parameter_property PACKET_LEN HDL_PARAMETER true

add_parameter ADC_WIDTH INTEGER 8
set_parameter_property ADC_WIDTH DEFAULT_VALUE 8
set_parameter_property ADC_WIDTH DISPLAY_NAME {Data Width}
set_parameter_property ADC_WIDTH TYPE INTEGER
set_parameter_property ADC_WIDTH UNITS bits
set_parameter_property ADC_WIDTH ALLOWED_RANGES 2:64
set_parameter_property ADC_WIDTH DESCRIPTION {Data width}
set_parameter_property ADC_WIDTH AFFECTS_GENERATION {1}
set_parameter_property ADC_WIDTH HDL_PARAMETER true

add_parameter AMPS_WIDTH INTEGER 3
set_parameter_property AMPS_WIDTH DEFAULT_VALUE 3
set_parameter_property AMPS_WIDTH DISPLAY_NAME {Amps Width}
set_parameter_property AMPS_WIDTH TYPE INTEGER
set_parameter_property AMPS_WIDTH UNITS bits
set_parameter_property AMPS_WIDTH ALLOWED_RANGES 0:64
set_parameter_property AMPS_WIDTH DESCRIPTION {Amps width}
set_parameter_property AMPS_WIDTH AFFECTS_GENERATION {1}
set_parameter_property AMPS_WIDTH HDL_PARAMETER true
 
add_parameter FILTERS_WIDTH INTEGER 2
set_parameter_property FILTERS_WIDTH DEFAULT_VALUE 2
set_parameter_property FILTERS_WIDTH DISPLAY_NAME {Filters Width}
set_parameter_property FILTERS_WIDTH TYPE INTEGER
set_parameter_property FILTERS_WIDTH UNITS bits
set_parameter_property FILTERS_WIDTH ALLOWED_RANGES 0:64
set_parameter_property FILTERS_WIDTH DESCRIPTION {Filters width}
set_parameter_property FILTERS_WIDTH AFFECTS_GENERATION {1}
set_parameter_property FILTERS_WIDTH HDL_PARAMETER true

add_parameter ATTENUATOR_WIDTH INTEGER 6
set_parameter_property ATTENUATOR_WIDTH DEFAULT_VALUE 6
set_parameter_property ATTENUATOR_WIDTH DISPLAY_NAME {Attenuator Width}
set_parameter_property ATTENUATOR_WIDTH TYPE INTEGER
set_parameter_property ATTENUATOR_WIDTH UNITS bits
set_parameter_property ATTENUATOR_WIDTH ALLOWED_RANGES 0:64
set_parameter_property ATTENUATOR_WIDTH DESCRIPTION {Attenuator width}
set_parameter_property ATTENUATOR_WIDTH AFFECTS_GENERATION {1}
set_parameter_property ATTENUATOR_WIDTH HDL_PARAMETER true


#-------------------------------------------------------------------------------
# module GUI
#-------------------------------------------------------------------------------         

# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point adc
# 
add_interface adc avalon_streaming end
set_interface_property adc associatedClock clock
set_interface_property adc associatedReset reset
set_interface_property adc errorDescriptor ""
set_interface_property adc firstSymbolInHighOrderBits true
set_interface_property adc maxChannel 0
set_interface_property adc readyLatency 1
set_interface_property adc ENABLED true
set_interface_property adc EXPORT_OF ""
set_interface_property adc PORT_NAME_MAP ""
set_interface_property adc CMSIS_SVD_VARIABLES ""
set_interface_property adc SVD_ADDRESS_GROUP ""

add_interface_port adc adc_i data Input adc_width

proc elaborate_me {}  {   
   set adc_width [get_parameter_value ADC_WIDTH]
   set_interface_property adc dataBitsPerSymbol $adc_width

   set amps_width [get_parameter_value AMPS_WIDTH]
   set filters_width [get_parameter_value FILTERS_WIDTH]
   set attenuator_width [get_parameter_value ATTENUATOR_WIDTH]

   #sink data width = amps + filters + attenuator + protection + new message
   set cpld_sink_data_width [expr {$amps_width + $filters_width + $attenuator_width + 1 + 1 }] 
   set cpld_sink_data_fragment_list "cpld_amps_i $amps_width cpld_filters_i $filters_width"
   append cpld_sink_data_fragment_list " cpld_attenuator_i $attenuator_width cpld_protection_i 1 cpld_new_msg_i 1"

   # set source_data_fragment_list "source_real $out_width source_imag $out_width"
   set cpld_source_data_width [expr {$filters_width}] 
   set cpld_source_data_fragment_list "cpld_filters_o $filters_width"

   dsp_add_streaming_interface cpld_sink sink
   set_interface_property cpld_sink associatedClock clock
   set_interface_property cpld_sink dataBitsPerSymbol $cpld_sink_data_width
   dsp_add_interface_port cpld_sink cpld_valid_i valid Input 1
   dsp_add_interface_port cpld_sink cpld_data_i data Input $cpld_sink_data_width $cpld_sink_data_fragment_list 

   dsp_add_streaming_interface cpld_source source
   set_interface_property cpld_source associatedClock clock
   set_interface_property cpld_source dataBitsPerSymbol $cpld_source_data_width
   dsp_add_interface_port cpld_source cpld_valid_o valid Output 1
   dsp_add_interface_port cpld_source cpld_ready_i ready Input 1
   dsp_add_interface_port cpld_source cpld_data_o data Output $cpld_source_data_width $cpld_source_data_fragment_list

   #source data width = adc + amps + filters + attenuator + protection
   set data_source_data_width [expr {$adc_width + $amps_width + $filters_width + $attenuator_width + 1}] 
   set data_source_fragment_list "out_adc $adc_width out_amps $amps_width out_filters $filters_width"
   append data_source_fragment_list " out_attenuator $attenuator_width out_protection 1"

   dsp_add_streaming_interface data_source source
   set_interface_property data_source associatedClock clock
   set_interface_property data_source dataBitsPerSymbol $data_source_data_width
   dsp_add_interface_port data_source out_valid valid Output 1
   dsp_add_interface_port data_source out_sop startofpacket Output 1
   dsp_add_interface_port data_source out_eop endofpacket Output 1
   dsp_add_interface_port data_source out_data data Output $data_source_data_width $data_source_fragment_list

      # dsp_add_interface_port cpld sink_ready ready Output 1
   # dsp_add_interface_port cpld sink_error error Input 2
   # dsp_add_interface_port cpld sink_sop startofpacket Input 1
   # dsp_add_interface_port cpld sink_eop endofpacket Input 1

}

proc validate_me {}  {
}

#
# The method signature is identical to  that of add_interface_port except that a fragment list
# must be specified for data signal_type.
#
# frag_list should be a list of name value pairs where the name is the name of the port
# and value is the width of the port. For example, "imag 16 real 16" 
#
proc dsp_add_interface_port { interface port signal_type direction width_expression {frag_list ""} } {
   if { [get_parameter_value design_env] eq {QSYS} } {
      add_interface_port $interface $port $signal_type $direction $width_expression
      if { $signal_type eq {data} } { 
         set_port_property $port fragment_list [build_fragment_list $frag_list] 
 
      }
   } else {
      if { $signal_type eq {data} } { 
         set len [llength $frag_list]
         if { $len % 2 } {
            send_message ERROR "List must have an even number of items: $frag_list"
         }
         for {set i 0} {$i < $len} {incr i; incr i} {
            set port  [lindex $frag_list $i]
            set width [lindex $frag_list [expr {$i+1}]]
            add_interface_port $interface $port $port $direction $width
            # fragment lists do not generate STD_LOGIC ports,
            # we could have hidden this from the user by selecting 
            # just normal wire or [0 : 0] in top.sv.terp depending on standalone or qsys respectively. 
            # But our example design always uses qsys mode and the component interface
            # should match up for usability and consistency.
            set_port_property $port VHDL_TYPE STD_LOGIC_VECTOR
         }
      } else {
         add_interface_port $interface $port $port $direction $width_expression 
      }
      
   }
}

#
# direction is one of sink or source
# name is the name of the interface
#
proc dsp_add_streaming_interface { name direction } {
    if { [get_parameter_value design_env] eq {QSYS} } {
         add_interface $name avalon_streaming $direction
    } else { 
        if { $direction eq {sink} } {
           add_interface $name conduit end
        } else {
           add_interface $name conduit start
           set_interface_assignment $name "ui.blockdiagram.direction" OUTPUT
        }
        set_interface_property $name allowMultipleExportRoles 1	
    }
}

proc build_fragment_list { frag_list } {
   set x ""
   for {set i 0} {$i < [llength $frag_list]} {incr i; incr i} {
      set port  [lindex $frag_list $i]
      set width [lindex $frag_list [expr {$i+1}]]
      if { $width eq 1 } {
         append x "$port "
      } else {
         append x "$port\([expr $width-1]:0\) "
      }
   }
   return $x
}
