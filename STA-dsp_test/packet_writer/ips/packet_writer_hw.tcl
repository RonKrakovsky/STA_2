
# 
# packet_writer "packet_writer" v0.1
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
# module packet_writer
# 
set_module_property DESCRIPTION ""
set_module_property NAME packet_writer
set_module_property VERSION 0.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP VincNL
set_module_property AUTHOR "Nitzan Lavi"
set_module_property DISPLAY_NAME packet_writer
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL packet_writer
set_fileset_property quartus_synth ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property quartus_synth ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file packet_writer.vhd VHDL PATH ../source/packet_writer.vhd TOP_LEVEL_FILE


set_module_property ELABORATION_CALLBACK    elaborate_me
set_module_property VALIDATION_CALLBACK     validate_me

# 
# parameters
# 
add_parameter MAX_PACKET_LEN POSITIVE 1024
set_parameter_property MAX_PACKET_LEN DEFAULT_VALUE 1024
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

add_parameter USE_FIX_ADDRESS_WIDTH Integer 0 "Use pre-determined master address width instead of automatically-determined master address width"
set_parameter_property USE_FIX_ADDRESS_WIDTH DISPLAY_NAME "Use pre-determined master address width"
set_parameter_property USE_FIX_ADDRESS_WIDTH DISPLAY_HINT boolean
set_parameter_property USE_FIX_ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property USE_FIX_ADDRESS_WIDTH DERIVED false
set_parameter_property USE_FIX_ADDRESS_WIDTH HDL_PARAMETER false
set_parameter_property USE_FIX_ADDRESS_WIDTH AFFECTS_ELABORATION true
add_display_item "Transfer Options" USE_FIX_ADDRESS_WIDTH parameter

add_parameter FIX_ADDRESS_WIDTH INTEGER 32 "Minimum master address width that is required to address memory slave."
set_parameter_property FIX_ADDRESS_WIDTH DISPLAY_NAME "Pre-determined master address width:"
set_parameter_property FIX_ADDRESS_WIDTH ALLOWED_RANGES 1:64
set_parameter_property FIX_ADDRESS_WIDTH AFFECTS_GENERATION true
set_parameter_property FIX_ADDRESS_WIDTH DERIVED false
set_parameter_property FIX_ADDRESS_WIDTH HDL_PARAMETER false
set_parameter_property FIX_ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property FIX_ADDRESS_WIDTH VISIBLE true
add_display_item "Transfer Options" FIX_ADDRESS_WIDTH parameter

add_parameter AUTO_ADDRESS_WIDTH INTEGER 32
set_parameter_property AUTO_ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property AUTO_ADDRESS_WIDTH DERIVED true
set_parameter_property AUTO_ADDRESS_WIDTH HDL_PARAMETER false
set_parameter_property AUTO_ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property AUTO_ADDRESS_WIDTH VISIBLE false
set_parameter_property AUTO_ADDRESS_WIDTH SYSTEM_INFO {ADDRESS_WIDTH mem}

add_parameter ADDRESS_WIDTH INTEGER 32
set_parameter_property ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDRESS_WIDTH DERIVED true
set_parameter_property ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADDRESS_WIDTH VISIBLE false
#-------------------------------------------------------------------------------
# module GUI
#-------------------------------------------------------------------------------         

# display group
# add_display_item {} {Clock} GROUP
# add_display_item {} {Packet} GROUP
# add_display_item {} {Memory Write Master} GROUP

# # group parameter
# add_display_item {Clock} CLK_FREQ PARAMETER

# add_display_item {Packet} PACKET_LEN PARAMETER
# add_display_item {Packet} PACKET_RATE PARAMETER

# add_display_item {Memory Write Master} DATA_WIDTH PARAMETER
# add_display_item {Memory Write Master} USE_FIX_ADDRESS_WIDTH PARAMETER
# add_display_item {Memory Write Master} FIX_ADDRESS_WIDTH PARAMETER


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
# connection point mem
# 
add_interface mem avalon start
set_interface_property mem addressUnits SYMBOLS
set_interface_property mem associatedClock clock
set_interface_property mem associatedReset reset
set_interface_property mem bitsPerSymbol 8
set_interface_property mem burstOnBurstBoundariesOnly false
set_interface_property mem burstcountUnits WORDS
set_interface_property mem doStreamReads false
set_interface_property mem doStreamWrites false
set_interface_property mem holdTime 0
set_interface_property mem linewrapBursts false
set_interface_property mem maximumPendingReadTransactions 0
set_interface_property mem maximumPendingWriteTransactions 0
set_interface_property mem readLatency 0
set_interface_property mem readWaitTime 1
set_interface_property mem setupTime 0
set_interface_property mem timingUnits Cycles
set_interface_property mem writeWaitTime 0
set_interface_property mem ENABLED true
set_interface_property mem EXPORT_OF ""
set_interface_property mem PORT_NAME_MAP ""
set_interface_property mem CMSIS_SVD_VARIABLES ""
set_interface_property mem SVD_ADDRESS_GROUP ""

add_interface_port mem mem_address address Output -1
add_interface_port mem mem_waitrequest waitrequest Input 1
add_interface_port mem mem_writedata writedata Output data_width
add_interface_port mem mem_write write Output 1


# 
# connection point csr
# 
add_interface csr avalon end
set_interface_property csr addressUnits WORDS
set_interface_property csr associatedClock clock
set_interface_property csr associatedReset reset
set_interface_property csr bitsPerSymbol 8
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr burstcountUnits WORDS
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr maximumPendingWriteTransactions 0
set_interface_property csr readLatency 0
set_interface_property csr readWaitTime 1
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0
set_interface_property csr ENABLED true
set_interface_property csr EXPORT_OF ""
set_interface_property csr PORT_NAME_MAP ""
set_interface_property csr CMSIS_SVD_VARIABLES ""
set_interface_property csr SVD_ADDRESS_GROUP ""

add_interface_port csr avs_csr_address address Input 4
add_interface_port csr avs_csr_writedata writedata Input 32
add_interface_port csr avs_csr_write write Input 1
add_interface_port csr avs_csr_readdata readdata Output 32
add_interface_port csr avs_csr_read read Input 1
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0


proc elaborate_me {}  {   
   set data_width [get_parameter_value DATA_WIDTH]
   set_port_property mem_address WIDTH_EXPR [get_parameter_value ADDRESS_WIDTH]

   set amps_width [get_parameter_value AMPS_WIDTH]
   set filters_width [get_parameter_value FILTERS_WIDTH]
   set attenuator_width [get_parameter_value ATTENUATOR_WIDTH]

   #sink data width = signal + amps + filters + attenuator + protection + error
   set rffe_info_width [expr {$amps_width + $filters_width + $attenuator_width + 1 + 1 }]
   set sink_data_width [expr {$data_width + $rffe_info_width}]
   set sink_data_fragment_list "sink_data $data_width sink_amps $amps_width sink_filters $filters_width"
   append sink_data_fragment_list " sink_attenuator $attenuator_width sink_protection 1 sink_error 1"

   dsp_add_streaming_interface sink sink
   set_interface_property sink associatedClock clock
   set_interface_property sink dataBitsPerSymbol $sink_data_width
   dsp_add_interface_port sink sink_valid valid Input 1
   dsp_add_interface_port sink sink_sop startofpacket Input 1
   dsp_add_interface_port sink sink_eop endofpacket Input 1
   dsp_add_interface_port sink sink_data data Input $sink_data_width $sink_data_fragment_list 
}

proc validate_me {}  {
   if { [get_parameter_value USE_FIX_ADDRESS_WIDTH] == 1 }  {
        set_parameter_property FIX_ADDRESS_WIDTH ENABLED true
        set_parameter_value ADDRESS_WIDTH [get_parameter_value FIX_ADDRESS_WIDTH]
    } else {
        set_parameter_property FIX_ADDRESS_WIDTH ENABLED false
        set_parameter_value ADDRESS_WIDTH [get_parameter_value AUTO_ADDRESS_WIDTH]
    }
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
