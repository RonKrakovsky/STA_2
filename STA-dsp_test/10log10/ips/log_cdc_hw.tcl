
# 
# log_cdc "log_cdc" v0.1
# Nitzan Lavi 
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
# module log_cdc
# 
set_module_property DESCRIPTION ""
set_module_property NAME log_cdc
set_module_property VERSION 0.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP VincNL
set_module_property AUTHOR "Nitzan Lavi"
set_module_property DISPLAY_NAME log_cdc
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL log_cdc
set_fileset_property quartus_synth ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property quartus_synth ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file log_cdc.vhd VHDL PATH ../source/log_cdc.vhd TOP_LEVEL_FILE


set_module_property ELABORATION_CALLBACK    elaborate_me
set_module_property VALIDATION_CALLBACK     validate_me

# 
# parameters
# 
add_parameter MAX_PACKET_LEN POSITIVE 16384
set_parameter_property MAX_PACKET_LEN DEFAULT_VALUE 16384
set_parameter_property MAX_PACKET_LEN DISPLAY_NAME {Length}
set_parameter_property MAX_PACKET_LEN TYPE INTEGER
set_parameter_property MAX_PACKET_LEN UNITS None
set_parameter_property MAX_PACKET_LEN ALLOWED_RANGES \
{8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144}
set_parameter_property MAX_PACKET_LEN DESCRIPTION {Packet length}
set_parameter_property MAX_PACKET_LEN AFFECTS_GENERATION true 
set_parameter_property MAX_PACKET_LEN HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME {Data Width}
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS bits
set_parameter_property DATA_WIDTH ALLOWED_RANGES 2:64
set_parameter_property DATA_WIDTH DESCRIPTION {Data width}
set_parameter_property DATA_WIDTH AFFECTS_GENERATION {1}
set_parameter_property DATA_WIDTH HDL_PARAMETER true

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
# connection point in clock
# 
add_interface in_clock clock end
set_interface_property in_clock clockRate 0
set_interface_property in_clock ENABLED true
add_interface_port in_clock in_clk clk Input 1

# 
# connection point out clock
# 
add_interface out_clock clock end
set_interface_property out_clock clockRate 0
set_interface_property out_clock ENABLED true
add_interface_port out_clock out_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock in_clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
add_interface_port reset reset_n reset_n Input 1

# 
# connection point fifo_source
# 
add_interface fifo_source avalon_streaming start
set_interface_property fifo_source associatedClock in_clock
set_interface_property fifo_source associatedReset reset
set_interface_property fifo_source firstSymbolInHighOrderBits true
set_interface_property fifo_source maxChannel 0
set_interface_property fifo_source readyLatency 0
set_interface_property fifo_source ENABLED true

add_interface_port fifo_source fifo_source_data  data  Output data_width
add_interface_port fifo_source fifo_source_valid valid Output 1
add_interface_port fifo_source fifo_source_ready ready Input 1

add_interface fifo_sink avalon_streaming end
set_interface_property fifo_sink associatedClock out_clock
set_interface_property fifo_sink associatedReset reset
set_interface_property fifo_sink firstSymbolInHighOrderBits true
set_interface_property fifo_sink maxChannel 0
set_interface_property fifo_sink readyLatency 0
set_interface_property fifo_sink ENABLED true

add_interface_port fifo_sink fifo_sink_data  data  Input data_width
add_interface_port fifo_sink fifo_sink_valid valid Input 1
add_interface_port fifo_sink fifo_sink_ready ready Output 1

proc elaborate_me {}  {   
   set data_width [get_parameter_value DATA_WIDTH]

   set_interface_property fifo_source dataBitsPerSymbol $data_width
   set_interface_property fifo_sink dataBitsPerSymbol $data_width

   set amps_width [get_parameter_value AMPS_WIDTH]
   set filters_width [get_parameter_value FILTERS_WIDTH]
   set attenuator_width [get_parameter_value ATTENUATOR_WIDTH]

   #sink data width = signal + amps + filters + attenuator + protection + error
   set rffe_info_width [expr {$amps_width + $filters_width + $attenuator_width + 1 + 1 }]
   set all_data_width [expr {$data_width + $rffe_info_width}]
   set sink_data_fragment_list "sink_signal $data_width sink_amps $amps_width sink_filters $filters_width"
   append sink_data_fragment_list " sink_attenuator $attenuator_width sink_protection 1 sink_error 1"

   dsp_add_streaming_interface sink sink
   set_interface_property sink associatedClock in_clock
   set_interface_property sink associatedReset reset
   set_interface_property sink dataBitsPerSymbol $all_data_width
   dsp_add_interface_port sink sink_valid valid Input 1
   dsp_add_interface_port sink sink_sop startofpacket Input 1
   dsp_add_interface_port sink sink_eop endofpacket Input 1
   dsp_add_interface_port sink sink_data data Input $all_data_width $sink_data_fragment_list 

   #source data width = signal + amps + filters + attenuator + protection + error
   set source_fragment_list "source_signal $data_width source_amps $amps_width source_filters $filters_width"
   append source_fragment_list " source_attenuator $attenuator_width source_protection 1 source_error 1"

   dsp_add_streaming_interface source source
   set_interface_property source associatedClock out_clock
   set_interface_property source associatedReset reset
   set_interface_property source dataBitsPerSymbol $all_data_width
   dsp_add_interface_port source source_valid valid Output 1
   dsp_add_interface_port source source_sop startofpacket Output 1
   dsp_add_interface_port source source_eop endofpacket Output 1
   dsp_add_interface_port source source_data data Output $all_data_width $source_fragment_list


   set rffe_fifo_sink_data_fragment_list "rffe_fifo_sink_amps $amps_width rffe_fifo_sink_filters $filters_width"
   append rffe_fifo_sink_data_fragment_list " rffe_fifo_sink_attenuator $attenuator_width rffe_fifo_sink_protection 1 rffe_fifo_sink_error 1"

   dsp_add_streaming_interface rffe_fifo_sink sink
   set_interface_property rffe_fifo_sink associatedClock out_clock
   set_interface_property rffe_fifo_sink associatedReset reset
   set_interface_property rffe_fifo_sink dataBitsPerSymbol $rffe_info_width
   dsp_add_interface_port rffe_fifo_sink rffe_fifo_sink_valid valid Input 1
   dsp_add_interface_port rffe_fifo_sink rffe_fifo_sink_ready ready Output 1
   # dsp_add_interface_port rffe_fifo_sink rffe_fifo_sink_sop startofpacket Input 1
   # dsp_add_interface_port rffe_fifo_sink rffe_fifo_sink_eop endofpacket Input 1
   dsp_add_interface_port rffe_fifo_sink rffe_fifo_sink data Input $rffe_info_width $rffe_fifo_sink_data_fragment_list 

   
   set rffe_fifo_source_fragment_list "rffe_fifo_source_amps $amps_width rffe_fifo_source_filters $filters_width"
   append rffe_fifo_source_fragment_list " rffe_fifo_source_attenuator $attenuator_width rffe_fifo_source_protection 1 rffe_fifo_source_error 1"

   dsp_add_streaming_interface rffe_fifo_source source
   set_interface_property rffe_fifo_source associatedClock in_clock
   set_interface_property rffe_fifo_source associatedReset reset
   set_interface_property rffe_fifo_source dataBitsPerSymbol $rffe_info_width
   dsp_add_interface_port rffe_fifo_source rffe_fifo_source_valid valid Output 1
   dsp_add_interface_port rffe_fifo_source rffe_fifo_source_ready ready Input 1
   # dsp_add_interface_port rffe_fifo_source rffe_fifo_source_sop startofpacket Output 1
   # dsp_add_interface_port rffe_fifo_source rffe_fifo_source_eop endofpacket Output 1
   dsp_add_interface_port rffe_fifo_source rffe_fifo_source data Output $rffe_info_width $rffe_fifo_source_fragment_list

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
