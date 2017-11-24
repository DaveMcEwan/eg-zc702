
source tcl/common.tcl

set REPORT 1
set CHECKPOINT 1

set_part ${part}

# Build IP from catalog.
source tcl/synth_ip.tcl
# TODO: Not sure why this isn't working.
#if [ file exists ${dir_bld}/ip.dcp ] {
#    read_checkpoint ${dir_bld}/ip.dcp
#} else {
#    source tcl/synth_ip.tcl
#    write_checkpoint ${dir_bld}/ip.dcp
#}

# Read in all source files.
read_verilog [ glob ${dir_hdl}/*.v ]

# Read in constraints.
read_xdc ${dir_xdc}/clkrst.xdc
read_xdc ${dir_xdc}/ddr.xdc
read_xdc ${dir_xdc}/mio.xdc
read_xdc ${dir_xdc}/o_led.xdc

# Synthesize design.
synth_design -part ${part} -top top_m
if $CHECKPOINT {
    write_checkpoint -force ${dir_bld}/synth.dcp
}
if $REPORT {
    report_timing_summary   -file ${rpt_post_synth}timing_summary.rpt
    report_power            -file ${rpt_post_synth}power.rpt
}

# Optimize, place design.
opt_design
place_design
phys_opt_design
if $CHECKPOINT {
    write_checkpoint -force ${dir_bld}/place.dcp
}

# Route design.
route_design
if $CHECKPOINT {
    write_checkpoint -force ${dir_bld}/route.dcp
}
if $REPORT {
    report_timing_summary       -file ${rpt_post_route}timing_summary.rpt
    report_timing -sort_by group -max_paths 100 -path_type summary \
                                -file ${rpt_post_route}timing.rpt
    report_clock_utilization    -file ${rpt_post_route}clock_utilization.rpt
    report_utilization          -file ${rpt_post_route}utilization.rpt
    report_power                -file ${rpt_post_route}power.rpt
    report_drc                  -file ${rpt_post_route}drc.rpt
}

# Write out netlist and constraints.
write_verilog -force ${dir_bld}/netlist.v
write_xdc -no_fixed_only -force ${dir_bld}/impl.v

# Write out a bitstream.
write_bitstream -force ${dir_bld}/${projname}.bit













# https://www.xilinx.com/support/documentation/sw_manuals/xilinx2015_3/ug835-vivado-tcl-commands.pdf
# Page 284
# -in_memory is not part of the standard non-project design flow.
#create_project -part ${part} -in_memory ${projname}

# This requires an open project.
#create_bd_design -dir build ${projname}
