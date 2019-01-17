# Run with "libero SCRIPT:libero.tcl"

file delete -force proj

new_project \
    -name example \
    -location proj \
    -block_mode 0 \
    -hdl "VERILOG" \
    -family IGLOO2 \
    -die PA4MGL500 \
    -package tq144 \
    -speed -1

import_files -hdl_source {netlist.vm}
import_files -sdc {example.sdc}
import_files -io_pdc {example.io.pdc}
import_files -fp_pdc {example.fp.pdc}
set_option -synth 0

organize_tool_files -tool PLACEROUTE \
    -file {proj/constraint/example.sdc} \
    -file {proj/constraint/io/example.io.pdc} \
    -file {proj/constraint/fp/example.fp.pdc} \
    -input_type constraint

organize_tool_files -tool VERIFYTIMING \
    -file {proj/constraint/example.sdc} \
    -input_type constraint

configure_tool -name PLACEROUTE \
    -params TDPR:true \
    -params PDPR:false \
    -params EFFORT_LEVEL:false \
    -params REPAIR_MIN_DELAY:false

puts "**> COMPILE"
run_tool -name {COMPILE}
puts "<** COMPILE"

puts "**> PLACEROUTE"
run_tool -name {PLACEROUTE}
puts "<** PLACEROUTE"

puts "**> VERIFYTIMING"
run_tool -name {VERIFYTIMING}
puts "<** VERIFYTIMING"

save_project

# puts "**> export_bitstream"
# export_bitstream_file -trusted_facility_file 1 -trusted_facility_file_components {FABRIC}
# puts "<** export_bitstream"

exit 0