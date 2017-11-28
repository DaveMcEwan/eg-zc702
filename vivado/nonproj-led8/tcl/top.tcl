
set REPORT 1
set CHECKPOINT 1
set NETLIST 1

source tcl/common.tcl
if [ file exists tcl/local.tcl ] {
    source tcl/local.tcl
}

set_part ${part}

# Build IP from catalog.
if [ file exists ${dir_bld}/synth_ip.DONE ] {
    read_checkpoint ${dir_bld}/ip/ps7_m/ps7_m.dcp
    read_checkpoint ${dir_bld}/ip/rst_m/rst_m.dcp
} else {
    source tcl/synth_ip.tcl
    exec touch ${dir_bld}/synth_ip.DONE
}

# Read in all source files.
read_verilog [ glob ${dir_hdl}/*.v ]
read_verilog [ glob ${dir_hdl}/*.sv ]

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
if $NETLIST {
    write_verilog -force ${dir_bld}/netlist.v
    write_xdc -no_fixed_only -force ${dir_bld}/impl.v
}

# Write out a bitstream.
write_bitstream -force ${dir_bld}/${projname}.bit

