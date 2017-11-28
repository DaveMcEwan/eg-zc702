yosys
=====

These are example yosys(+Vivado) projects for generating bitstream files
suitable for congfiguring the Programmable Logic (PL) part of the Zynq FPGA.

*It is not yet possible to avoid Vivado completely.*
Yosys is used to synthesize `pl_m` which should contain all the interesting
logic structures.
Vivado is then used to synthesize the Xilinx IP from their catalog then stitch
together the top level (`top_m`), treating `pl_m` as a black box.


led8
----

This is equivalent in function to vivado/nonproj-led8.

    +-led8
        |
        +-hdl       Verilog, SystemVerilog, VHDL source files.
            |
            top_m.v         Top level module for connecting ps7, rst, and PL.
            pl_m.sv         Programmable Logic module.
            pl_m_stub.v     Programmable Logic stub, for synth only.
            ...             Other source files.
        +-xdc       Constraints.
            |
            clkrst.xdc      Clock and reset constraints.
            ddr.xdc         DDR pins, usually leave alone.
            mio.xdc         Multiplexed IO pin constraints.
            ...             Other constraints.
        +-tcl       TCL scripts to control Vivado.
            |
            cfg.tcl         Config file containing parameters, e.g. part number.
            common.tcl      Config file should be sourced first in TCL scripts.
            local.tcl       Untracked configuration changes go here.
            synth_ip.tcl    Script to synthesize all Xilinx catalog IP.
            synth_ip_*.tcl  Script to synthesize a specific Xilinx catalog IP.
            top.tcl         Main script for compliation to bitstream.
            ...             Other TCL scripts
        +-build     Generated files appear in here.
        +-release   Optional place for pre-built bitstreams etc.
        README.md   Optional, Basic documentation.
        Makefile    Make recipies to control Vivado with scripts under `tcl`.

This file structure is quite flat and because all generated files appear under
build it is easy to ignore them for version control.
Note that Vivado will generate hidden directories too which are dealt with by
`.gitignore` and `make clean`.

To get started run `make all` to generate the bitstream, send it to the zc702
(assuming you have SSH configured), and program the bitstream using the xdevcfg
driver.
