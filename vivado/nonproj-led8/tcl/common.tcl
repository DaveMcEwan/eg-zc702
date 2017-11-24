
source tcl/cfg.tcl

set projname [ file tail [ pwd ] ]
set dir_xdc "xdc"
set dir_hdl "hdl"
set dir_bld "build"
set dir_rpt "${dir_bld}/report"
set dir_ip  "${dir_bld}/ip"


# Create build directories.
file mkdir ${dir_bld}
file mkdir ${dir_rpt}
file mkdir ${dir_ip}

set rpt_post_synth "${dir_rpt}/synth_"
set rpt_post_route "${dir_rpt}/route_"

